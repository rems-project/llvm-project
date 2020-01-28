//===- AArch64SandboxGlobalsOpt.cpp - AArch64 Sandbox Globals Optimization ===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/Pass.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/CallSite.h"
#include "llvm/IR/PatternMatch.h"
#include "llvm/IR/InstVisitor.h"
#include "llvm/ADT/SmallSet.h"
#include "llvm/ADT/APSInt.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "AArch64TargetMachine.h"

using namespace llvm;
using namespace PatternMatch;

#define DEBUG_TYPE "aarch64-sandbox-globals-opt"

static cl::opt<bool>
OptShareGlobalCaps("aarch64-sandbox-share-global-capabilities",
         cl::desc("Allow sharing capabilities to globals between functions"),
         cl::init(true));

namespace {

class AArch64SandboxGlobalsOpt : public ModulePass {
  llvm::StringRef getPassName() const override {
    return "AArch64 sandbox global address optimization pass";
  }

public:
  static char ID;
  TargetMachine *TM;
  AArch64SandboxGlobalsOpt(TargetMachine *TM) : ModulePass(ID), TM(TM) {}

  bool doInitialization(Module &Mod) override {
    return true;
  }

  static bool isUsedGlobal(GlobalVariable &GV) {
    for (User *U : GV.users()) {
      if (isa<Instruction>(U))
        return true;
      if (GEPOperator *GEP = dyn_cast<GEPOperator>(U)) {
        for (User *GEPU : U->users()) {
          if (isa<Instruction>(GEPU))
            return true;
        }
      }
    }
    return false;
  }

  static GlobalValue::LinkageTypes getCapLinkage(GlobalValue *GV) {
    if (GV->hasComdat())
      return GlobalValue::WeakODRLinkage;
    return GlobalValue::PrivateLinkage;
  }

  static GlobalValue::VisibilityTypes getCapVisibility(GlobalValue *GV) {
    if (GV->hasComdat())
      return GlobalValue::HiddenVisibility;
    return GlobalValue::DefaultVisibility;
  }

  static Comdat *getCapComdat(GlobalValue *GV) {
    Module &M = *GV->getParent();
    std::string CName = "__cap_";
    CName = CName.append(GV->getComdat()->getName().str());
    Comdat *C = M.getOrInsertComdat(CName);
    C->setSelectionKind(GV->getComdat()->getSelectionKind());
    return C;
  }

  // Create a constant global containing the GV address and add
  // metadata to the original global pointing to the address.
  // The code generation will then try to use this global
  // instead of creating constant pool entries.
  bool enableCapabilityToGlobalSharing(GlobalObject &GV) {
    // FIXME: look for an already existing constant global.
    // FIXME: this has to be factored out so that we can do this for
    // functions as well (look for the intrinsic call).
    if (!OptShareGlobalCaps)
      return false;

    auto Linkage = getCapLinkage(&GV);
    GlobalVariable *NGV = new GlobalVariable(*GV.getParent(), GV.getType(),
        true, Linkage, &GV, Twine("__cap_") + GV.getName(), nullptr,
        GlobalValue::NotThreadLocal, 0);
    if (GV.hasComdat())
      NGV->setComdat(getCapComdat(&GV));
    NGV->setVisibility(getCapVisibility(&GV));

    NGV->setAlignment(MaybeAlign(16));
    LLVMContext &C = GV.getContext();
    auto *VAM = ValueAsMetadata::get(NGV);
    SmallVector<Metadata*, 1> Elements;
    Elements.push_back(VAM);
    GV.setMetadata(LLVMContext::MD_cap_addr, MDTuple::get(C, Elements));
    return true;
  }

  bool runOnGlobal(GlobalVariable &GV, Module &M) {
    if (M.begin() == M.end())
      return false;
    const Function &Fun = *M.begin();
    const AArch64Subtarget *ST =
      static_cast<const AArch64Subtarget *>(TM->getSubtargetImpl(Fun));
    if ((ST->ClassifyGlobalReference(&GV, *TM) & AArch64II::MO_GOT) != 0)
      return false;

    if (GV.getThreadLocalMode() != GlobalValue::NotThreadLocal)
      return false;

    const DataLayout &DL = M.getDataLayout();
    if (!DL.isFatPointer(GV.getType()))
      return false;

    if (!GV.getValueType()->isSized())
      return false;

    if (!isUsedGlobal(GV))
      return false;

    return enableCapabilityToGlobalSharing(GV);
  }

  bool runOnFunction(Function *F) {
    // Only perform this optimization if we're not using the GOT.
    const AArch64Subtarget *ST =
        static_cast<const AArch64Subtarget *>(TM->getSubtargetImpl(*F));
    if ((ST->ClassifyGlobalReference(F, *TM) & AArch64II::MO_GOT) != 0)
      return false;
    return enableCapabilityToGlobalSharing(*F);
  }

  bool runOnModule(Module &M) override {
    // Nothing to do if we are not in sandbox mode.
    const DataLayout &DL = M.getDataLayout();
    if (DL.getAllocaAddrSpace() != 200)
      return false;

    bool Modified = false;
    for (GlobalValue &GV: M.globals()) {
      if (GlobalVariable *GVar = dyn_cast<GlobalVariable>(&GV)) {
        Modified |= runOnGlobal(*GVar, M);
        continue;
      }
    }
    // Gather functions with their addresses taken.
    for (Function &Fun : M.functions()) {
      LLVM_DEBUG(dbgs() << "[SGO] Gathering function addresses from  "
                        << Fun.getName() << "\n");
      if (Fun.hasAddressTaken())
        Modified |= runOnFunction(&Fun);
    }
    return Modified;
  }

};

} // anonymous namespace

char AArch64SandboxGlobalsOpt::ID;

namespace llvm {
ModulePass *createAArch64SandboxGlobalsOpt(TargetMachine *TM) {
  return new AArch64SandboxGlobalsOpt(TM);
}
}
