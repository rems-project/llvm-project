//===-- AArch64TargetObjectFile.h - AArch64 Object Info -*- C++ ---------*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_LIB_TARGET_AARCH64_AARCH64TARGETOBJECTFILE_H
#define LLVM_LIB_TARGET_AARCH64_AARCH64TARGETOBJECTFILE_H

#include "llvm/CodeGen/TargetLoweringObjectFileImpl.h"
#include "llvm/Target/TargetLoweringObjectFile.h"

namespace llvm {

/// This implementation is used for AArch64 ELF targets (Linux in particular).
class AArch64_ELFTargetObjectFile : public TargetLoweringObjectFileELF {
  void Initialize(MCContext &Ctx, const TargetMachine &TM) override;
public:
  TailPaddingAmount
  getTailPaddingForPreciseBounds(uint64_t Size,
                                 const TargetMachine &TM) const override;
  Align getAlignmentForPreciseBounds(uint64_t Size,
                                     const TargetMachine &TM) const override;
  int getCheriCapabilitySize(const TargetMachine &TM) const override { return 16; }

  AArch64_ELFTargetObjectFile() {
    PLTRelativeVariantKind = MCSymbolRefExpr::VK_PLT;
  }
  MCSection *SelectSectionForGlobal(const GlobalObject *GO, SectionKind Kind,
                                    const TargetMachine &TM) const override;

  MCSection *getSectionForConstant(const DataLayout &DL, SectionKind Kind,
                                   const Constant *C,
                                   Align &Align) const override;
};

/// AArch64_MachoTargetObjectFile - This TLOF implementation is used for Darwin.
class AArch64_MachoTargetObjectFile : public TargetLoweringObjectFileMachO {
public:
  AArch64_MachoTargetObjectFile();

  const MCExpr *getTTypeGlobalReference(const GlobalValue *GV,
                                        unsigned Encoding,
                                        const TargetMachine &TM,
                                        MachineModuleInfo *MMI,
                                        MCStreamer &Streamer) const override;

  MCSymbol *getCFIPersonalitySymbol(const GlobalValue *GV,
                                    const TargetMachine &TM,
                                    MachineModuleInfo *MMI) const override;

  const MCExpr *getIndirectSymViaGOTPCRel(const GlobalValue *GV,
                                          const MCSymbol *Sym,
                                          const MCValue &MV, int64_t Offset,
                                          MachineModuleInfo *MMI,
                                          MCStreamer &Streamer) const override;

  void getNameWithPrefix(SmallVectorImpl<char> &OutName, const GlobalValue *GV,
                         const TargetMachine &TM) const override;
};

/// This implementation is used for AArch64 COFF targets.
class AArch64_COFFTargetObjectFile : public TargetLoweringObjectFileCOFF {};

} // end namespace llvm

#endif
