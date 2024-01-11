//====-- AArch64DescSetup.cpp -- Global entry point prologue insertion ----===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//====---------------------------------------------------------------------===//

#include "AArch64Subtarget.h"
#include "llvm/CodeGen/MachineFunctionPass.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineJumpTableInfo.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/Support/Debug.h"

using namespace llvm;

#define DEBUG_TYPE "aarch64-desc-setup"
#define AARCH64_DESC_SETUP_NAME "AArch64 Descriptor ABI Global Cap Setup"

namespace {
class AArch64DescSetup : public MachineFunctionPass {
public:
  static char ID;
  AArch64DescSetup() : MachineFunctionPass(ID) {}
  void getAnalysisUsage(AnalysisUsage &AU) const override;
  bool runOnMachineFunction(MachineFunction &MF) override;
  StringRef getPassName() const override { return AARCH64_DESC_SETUP_NAME; }
};
} // end anonymous namespace

char AArch64DescSetup::ID = 0;

INITIALIZE_PASS(AArch64DescSetup, "aarch64-desc-setup",
                AARCH64_DESC_SETUP_NAME, false, false)

void AArch64DescSetup::getAnalysisUsage(AnalysisUsage &AU) const {
  AU.setPreservesCFG();
  MachineFunctionPass::getAnalysisUsage(AU);
}

FunctionPass *llvm::createAArch64DescSetupPass() {
  return new AArch64DescSetup();
}

bool AArch64DescSetup::runOnMachineFunction(MachineFunction &MF) {
  MachineBasicBlock &Entry = *MF.begin();

  const AArch64InstrInfo *TII = static_cast<const AArch64InstrInfo *>(
      MF.getSubtarget().getInstrInfo());

  // Insert mov c28, cfp
  BuildMI(Entry, Entry.begin(), Entry.findDebugLoc(Entry.begin()),
          TII->get(AArch64::CapCopy))
      .addReg(AArch64::C28)
      .addReg(AArch64::CFP);

  // Additionally insert copies in landing pads.
  for (MachineBasicBlock &MBB : MF) {
    if (MBB.isEHPad()) {
      auto MI = MBB.SkipPHIsAndLabels(MBB.begin());
      BuildMI(MBB, MI, MBB.findDebugLoc(MI), TII->get(AArch64::BaseRegRestore));
    }
  }

  return true;
}
