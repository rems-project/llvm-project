//===- lib/MC/AArch64ELFStreamer.cpp - ELF Object Output for AArch64 ------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file assembles .s files and emits AArch64 ELF .o object files. Different
// from generic ELF streamer in emitting mapping symbols ($x and $d) to delimit
// regions of data and code.
//
//===----------------------------------------------------------------------===//

#include "AArch64ELFStreamer.h"
#include "AArch64MCAsmInfo.h"
#include "AArch64MCTargetDesc.h"
#include "AArch64TargetStreamer.h"
#include "AArch64MCExpr.h"
#include "AArch64MCTargetDesc.h"
#include "llvm/ADT/SmallPtrSet.h"
#include "llvm/ADT/StringExtras.h"
#include "AArch64WinCOFFStreamer.h"
#include "llvm/ADT/DenseMap.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Triple.h"
#include "llvm/ADT/Twine.h"
#include "llvm/BinaryFormat/ELF.h"
#include "llvm/MC/MCAsmBackend.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCCodeEmitter.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCELFStreamer.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/MC/MCSection.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/MCSymbolELF.h"
#include "llvm/MC/MCWinCOFFStreamer.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/FormattedStream.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

class AArch64ELFStreamer;

class AArch64TargetAsmStreamer : public AArch64TargetStreamer {
  formatted_raw_ostream &OS;

  void emitInst(uint32_t Inst, const MCSubtargetInfo &STI) override;

  void emitDirectiveVariantPCS(MCSymbol *Symbol) override {
    OS << "\t.variant_pcs\t" << Symbol->getName() << "\n";
  }

  void emitARM64WinCFIAllocStack(unsigned Size) override {
    OS << "\t.seh_stackalloc\t" << Size << "\n";
  }
  void emitARM64WinCFISaveR19R20X(int Offset) override {
    OS << "\t.seh_save_r19r20_x\t" << Offset << "\n";
  }
  void emitARM64WinCFISaveFPLR(int Offset) override {
    OS << "\t.seh_save_fplr\t" << Offset << "\n";
  }
  void emitARM64WinCFISaveFPLRX(int Offset) override {
    OS << "\t.seh_save_fplr_x\t" << Offset << "\n";
  }
  void emitARM64WinCFISaveReg(unsigned Reg, int Offset) override {
    OS << "\t.seh_save_reg\tx" << Reg << ", " << Offset << "\n";
  }
  void emitARM64WinCFISaveRegX(unsigned Reg, int Offset) override {
    OS << "\t.seh_save_reg_x\tx" << Reg << ", " << Offset << "\n";
  }
  void emitARM64WinCFISaveRegP(unsigned Reg, int Offset) override {
    OS << "\t.seh_save_regp\tx" << Reg << ", " << Offset << "\n";
  }
  void emitARM64WinCFISaveRegPX(unsigned Reg, int Offset) override {
    OS << "\t.seh_save_regp_x\tx" << Reg << ", " << Offset << "\n";
  }
  void emitARM64WinCFISaveLRPair(unsigned Reg, int Offset) override {
    OS << "\t.seh_save_lrpair\tx" << Reg << ", " << Offset << "\n";
  }
  void emitARM64WinCFISaveFReg(unsigned Reg, int Offset) override {
    OS << "\t.seh_save_freg\td" << Reg << ", " << Offset << "\n";
  }
  void emitARM64WinCFISaveFRegX(unsigned Reg, int Offset) override {
    OS << "\t.seh_save_freg_x\td" << Reg << ", " << Offset << "\n";
  }
  void emitARM64WinCFISaveFRegP(unsigned Reg, int Offset) override {
    OS << "\t.seh_save_fregp\td" << Reg << ", " << Offset << "\n";
  }
  void emitARM64WinCFISaveFRegPX(unsigned Reg, int Offset) override {
    OS << "\t.seh_save_fregp_x\td" << Reg << ", " << Offset << "\n";
  }
  void emitARM64WinCFISetFP() override { OS << "\t.seh_set_fp\n"; }
  void emitARM64WinCFIAddFP(unsigned Size) override {
    OS << "\t.seh_add_fp\t" << Size << "\n";
  }
  void emitARM64WinCFINop() override { OS << "\t.seh_nop\n"; }
  void emitARM64WinCFISaveNext() override { OS << "\t.seh_save_next\n"; }
  void emitARM64WinCFIPrologEnd() override { OS << "\t.seh_endprologue\n"; }
  void emitARM64WinCFIEpilogStart() override { OS << "\t.seh_startepilogue\n"; }
  void emitARM64WinCFIEpilogEnd() override { OS << "\t.seh_endepilogue\n"; }
  void emitARM64WinCFITrapFrame() override { OS << "\t.seh_trap_frame\n"; }
  void emitARM64WinCFIMachineFrame() override { OS << "\t.seh_pushframe\n"; }
  void emitARM64WinCFIContext() override { OS << "\t.seh_context\n"; }
  void emitARM64WinCFIClearUnwoundToCall() override {
    OS << "\t.seh_clear_unwound_to_call\n";
  }

public:
  AArch64TargetAsmStreamer(MCStreamer &S, formatted_raw_ostream &OS);
};

AArch64TargetAsmStreamer::AArch64TargetAsmStreamer(MCStreamer &S,
                                                   formatted_raw_ostream &OS)
  : AArch64TargetStreamer(S), OS(OS) {}

void AArch64TargetAsmStreamer::emitInst(uint32_t Inst,
                                        const MCSubtargetInfo &STI) {
  OS << "\t.inst\t0x" << Twine::utohexstr(Inst) << "\n";
}

/// Extend the generic ELFStreamer class so that it can emit mapping symbols at
/// the appropriate points in the object files. These symbols are defined in the
/// AArch64 ELF ABI:
///    infocenter.arm.com/help/topic/com.arm.doc.ihi0056a/IHI0056A_aaelf64.pdf
///
/// In brief: $x or $d should be emitted at the start of each contiguous region
/// of A64 code or data in a section. In practice, this emission does not rely
/// on explicit assembler directives but on inherent properties of the
/// directives doing the emission (e.g. ".byte" is data, "add x0, x0, x0" an
/// instruction).
///
/// As a result this system is orthogonal to the DataRegion infrastructure used
/// by MachO. Beware!
class AArch64ELFStreamer : public MCELFStreamer {
public:
  AArch64ELFStreamer(MCContext &Context, std::unique_ptr<MCAsmBackend> TAB,
                     std::unique_ptr<MCObjectWriter> OW,
                     std::unique_ptr<MCCodeEmitter> Emitter)
      : MCELFStreamer(Context, std::move(TAB), std::move(OW),
                      std::move(Emitter)),
        MappingSymbolCounter(0), LastEMS(EMS_None) {}

  void changeSection(MCSection *Section, const MCExpr *Subsection) override {
    // We have to keep track of the mapping symbol state of any sections we
    // use. Each one should start off as EMS_None, which is provided as the
    // default constructor by DenseMap::lookup.
    LastMappingSymbols[getPreviousSection().first] = LastEMS;
    LastEMS = LastMappingSymbols.lookup(Section);

    LastLabels[getPreviousSection().first] = std::move(CurrentLabels);
    CurrentLabels = std::move(LastLabels[Section]);

    MCELFStreamer::changeSection(Section, Subsection);
  }

  // Reset state between object emissions
  void reset() override {
    MappingSymbolCounter = 0;
    MCELFStreamer::reset();
    LastMappingSymbols.clear();
    LastEMS = EMS_None;
  }

  /// This function is the one used to emit instruction data into the ELF
  /// streamer. We override it to add the appropriate mapping symbol if
  /// necessary.
  void emitInstruction(const MCInst &Inst,
                       const MCSubtargetInfo &STI) override {
    emitCodeMappingSymbol(STI);
    checkDescABIFuncStart(Inst);
    adjustCurrentLabels(STI);
    MCELFStreamer::emitInstruction(Inst, STI);
  }

  /// Emit a 32-bit value as an instruction. This is only used for the .inst
  /// directive, EmitInstruction should be used in other cases.
  void emitInst(uint32_t Inst, const MCSubtargetInfo &STI) {
    char Buffer[4];

    // We can't just use EmitIntValue here, as that will emit a data mapping
    // symbol, and swap the endianness on big-endian systems (instructions are
    // always little-endian).
    for (char &C : Buffer) {
      C = uint8_t(Inst);
      Inst >>= 8;
    }

    emitCodeMappingSymbol(STI);
    adjustCurrentLabels(STI);
    MCELFStreamer::emitBytes(StringRef(Buffer, 4));
  }

  /// This is one of the functions used to emit data into an ELF section, so the
  /// AArch64 streamer overrides it to add the appropriate mapping symbol ($d)
  /// if necessary.
  void emitBytes(StringRef Data) override {
    CurrentLabels.clear();
    emitDataMappingSymbol();
    MCELFStreamer::emitBytes(Data);
  }

  /// This is one of the functions used to emit data into an ELF section, so the
  /// AArch64 streamer overrides it to add the appropriate mapping symbol ($d)
  /// if necessary.
  void emitValueImpl(const MCExpr *Value, unsigned Size, SMLoc Loc) override {
    CurrentLabels.clear();
    emitDataMappingSymbol();
    MCELFStreamer::emitValueImpl(Value, Size, Loc);
  }

  void SetCurrentLabel(MCSymbol *Label) {
    CurrentLabels.push_back(Label);
  }

  void emitFill(const MCExpr &NumBytes, uint64_t FillValue,
                                  SMLoc Loc) override {
    emitDataMappingSymbol();
    MCObjectStreamer::emitFill(NumBytes, FillValue, Loc);
  }

protected:
  void EmitCheriCapabilityImpl(const MCSymbol *Symbol, const MCExpr *Addend,
                               unsigned CapSize, SMLoc Loc) override;
  void emitCheriIntcap(const MCExpr *Expr, unsigned CapSize,
                       SMLoc Loc) override;

private:
  enum ElfMappingSymbol {
    EMS_None,
    EMS_A64,
    EMS_C64,
    EMS_Data
  };

  void emitDataMappingSymbol() {
    if (LastEMS == EMS_Data)
      return;
    emitMappingSymbol("$d");
    LastEMS = EMS_Data;
  }

  void emitA64MappingSymbol() {
    if (LastEMS == EMS_A64)
      return;
    emitMappingSymbol("$x");
    LastEMS = EMS_A64;
  }

  void emitC64MappingSymbol() {
    if (LastEMS == EMS_C64)
      return;
    emitMappingSymbol("$c");
    LastEMS = EMS_C64;
  }

  void checkDescABIFuncStart(const MCInst &Inst) {
    if (MCTargetOptions::cheriCapabilityTableABI() !=
        CheriCapabilityTableABI::FunctionDescriptor)
      return;

    if (Inst.getOpcode() == AArch64::CapCopy &&
        Inst.getOperand(0).getReg() == AArch64::C28 &&
        Inst.getOperand(1).getReg() == AArch64::CFP)
      return;

    if (llvm::any_of(CurrentLabels, [](MCSymbol *Symb) {
            return cast<MCSymbolELF>(Symb)->getType() == ELF::STT_FUNC; }))
      getContext().reportWarning(Inst.getLoc(),
          "Function should start with mov c28, c29");
  }

  void emitThumbFunc(MCSymbol *Func) override {
    getAssembler().setIsThumbFunc(Func);
  }

  void adjustCurrentLabels(const MCSubtargetInfo &STI) {
    const AArch64MCAsmInfoELF *MAI =
        static_cast<const AArch64MCAsmInfoELF *>(getContext().getAsmInfo());
    if (!STI.getFeatureBits()[AArch64::FeatureC64] ||
        MAI->isPurecapBenchmarkABI()) {
      CurrentLabels.clear();
      return;
    }
    for (MCSymbol *Symb : CurrentLabels) {
      emitThumbFunc(Symb);
    }
    CurrentLabels.clear();
  }

  void emitCodeMappingSymbol(const MCSubtargetInfo &STI) {
    if (STI.getFeatureBits()[AArch64::FeatureC64])
      emitC64MappingSymbol();
    else
      emitA64MappingSymbol();
  }

  void emitMappingSymbol(StringRef Name) {
    auto *Symbol = cast<MCSymbolELF>(getContext().getOrCreateSymbol(
        Name + "." + Twine(MappingSymbolCounter++)));
    emitLabel(Symbol);
    Symbol->setType(ELF::STT_NOTYPE);
    Symbol->setBinding(ELF::STB_LOCAL);
    Symbol->setExternal(false);
  }

  int64_t MappingSymbolCounter;

  DenseMap<const MCSection *, ElfMappingSymbol> LastMappingSymbols;
  DenseMap<const MCSection *, SmallVector<MCSymbol *, 3> > LastLabels;
  ElfMappingSymbol LastEMS;
  SmallVector<MCSymbol *, 3> CurrentLabels;

  void emitCHERINotes() override {
    MCELFStreamer::emitCHERINotes();
    const AArch64MCAsmInfoELF *MAI =
        static_cast<const AArch64MCAsmInfoELF *>(getContext().getAsmInfo());
    if (MAI->isCheriPurecapABI())
      emitCHERINote(ELF::NT_CHERI_MORELLO_PURECAP_BENCHMARK_ABI,
                    MAI->isPurecapBenchmarkABI());
  }
};

void AArch64ELFStreamer::EmitCheriCapabilityImpl(const MCSymbol *Symbol,
    const MCExpr *Addend,
    unsigned CapSize, SMLoc Loc) {
  assert(Addend && "Should have received a MCConstExpr(0) instead of nullptr");
  assert(CapSize == 16 && "Unexpected capability size");
  visitUsedSymbol(*Symbol);
  MCContext &Context = getContext();
  const MCSymbolRefExpr *SRE =
      MCSymbolRefExpr::create(Symbol, MCSymbolRefExpr::VK_None, Context, Loc);
  const MCBinaryExpr *CapExpr = MCBinaryExpr::createAdd(SRE, Addend, Context);

  // Pad to ensure that the capability is aligned
  // TODO: in the future we should check alignment when emitting relocations
  //  instead of adding alignment for all capabilities.
  emitValueToAlignment(CapSize, 0, 1, 0);
  emitCapInit(AArch64MCExpr::create(CapExpr, AArch64MCExpr::VK_CAPINIT, Context));
  emitIntValue(0, 8);
  emitIntValue(0, 8);
}

void AArch64ELFStreamer::emitCheriIntcap(const MCExpr *Expr, unsigned CapSize,
    SMLoc Loc) {
  assert(CapSize == 16 && "Unexpected capability size");
  emitCheriIntcapGeneric(Expr, CapSize, Loc);
}

} // end anonymous namespace

llvm::AArch64TargetELFStreamer::AArch64TargetELFStreamer(
    MCStreamer &S, const MCSubtargetInfo &STI)
    : AArch64TargetStreamer(S) {
  MCAssembler &MCA = getStreamer().getAssembler();
  unsigned EFlags = MCA.getELFHeaderEFlags();
  if (S.getContext().getAsmInfo()->isCheriPurecapABI()) {
    EFlags |= ELF::EF_AARCH64_CHERI_PURECAP;
  }
  MCA.setELFHeaderEFlags(EFlags);
}

AArch64ELFStreamer &AArch64TargetELFStreamer::getStreamer() {
  return static_cast<AArch64ELFStreamer &>(Streamer);
}

void AArch64TargetELFStreamer::emitInst(uint32_t Inst,
                                        const MCSubtargetInfo &STI) {
  getStreamer().emitInst(Inst, STI);
}

void AArch64TargetELFStreamer::emitLabel(MCSymbol *Symbol) {
  AArch64ELFStreamer &Streamer = getStreamer();

  unsigned Type = cast<MCSymbolELF>(Symbol)->getType();
  if (Type == ELF::STT_FUNC || Type == ELF::STT_GNU_IFUNC)
    Streamer.SetCurrentLabel(Symbol);
}

void AArch64TargetELFStreamer::emitDirectiveVariantPCS(MCSymbol *Symbol) {
  cast<MCSymbolELF>(Symbol)->setOther(ELF::STO_AARCH64_VARIANT_PCS);
}

MCTargetStreamer *
llvm::createAArch64AsmTargetStreamer(MCStreamer &S, formatted_raw_ostream &OS,
                                     MCInstPrinter *InstPrint,
                                     bool isVerboseAsm) {
  return new AArch64TargetAsmStreamer(S, OS);
}

MCELFStreamer *llvm::createAArch64ELFStreamer(
    MCContext &Context, std::unique_ptr<MCAsmBackend> TAB,
    std::unique_ptr<MCObjectWriter> OW, std::unique_ptr<MCCodeEmitter> Emitter,
    bool RelaxAll) {
  AArch64ELFStreamer *S = new AArch64ELFStreamer(
      Context, std::move(TAB), std::move(OW), std::move(Emitter));
  if (RelaxAll)
    S->getAssembler().setRelaxAll(true);
  return S;
}
