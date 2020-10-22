//=== AArch64CallingConvention.cpp - AArch64 CC impl ------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains the table-generated and custom routines for the AArch64
// Calling Convention.
//
//===----------------------------------------------------------------------===//

#include "AArch64CallingConvention.h"
#include "AArch64.h"
#include "AArch64InstrInfo.h"
#include "AArch64Subtarget.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/TargetInstrInfo.h"
#include "llvm/IR/CallingConv.h"
using namespace llvm;

static const MCPhysReg XRegList[] = {AArch64::X0, AArch64::X1, AArch64::X2,
                                     AArch64::X3, AArch64::X4, AArch64::X5,
                                     AArch64::X6, AArch64::X7};
static const MCPhysReg CRegList[] = {AArch64::C0, AArch64::C1, AArch64::C2,
                                     AArch64::C3, AArch64::C4, AArch64::C5,
                                     AArch64::C6, AArch64::C7};
static const MCPhysReg XPureCapRegList[] =
                                    {AArch64::X0, AArch64::X1, AArch64::X2,
                                     AArch64::X3, AArch64::X4, AArch64::X5};
static const MCPhysReg CPureCapRegList[] =
                                    {AArch64::C0, AArch64::C1, AArch64::C2,
                                     AArch64::C3, AArch64::C4, AArch64::C5};
static const MCPhysReg CCCallRegList[] =
                                    {AArch64::C9, AArch64::C10, AArch64::C0,
                                     AArch64::C1, AArch64::C2, AArch64::C3,
                                     AArch64::C4, AArch64::C5, AArch64::C6,
                                     AArch64::C7};
static const MCPhysReg XCCallRegList[] =
                                    {AArch64::X11, AArch64::X0, AArch64::X1,
                                     AArch64::X2, AArch64::X3, AArch64::X4,
                                     AArch64::X5, AArch64::X6, AArch64::X7};
static const MCPhysReg HRegList[] = {AArch64::H0, AArch64::H1, AArch64::H2,
                                     AArch64::H3, AArch64::H4, AArch64::H5,
                                     AArch64::H6, AArch64::H7};
static const MCPhysReg SRegList[] = {AArch64::S0, AArch64::S1, AArch64::S2,
                                     AArch64::S3, AArch64::S4, AArch64::S5,
                                     AArch64::S6, AArch64::S7};
static const MCPhysReg DRegList[] = {AArch64::D0, AArch64::D1, AArch64::D2,
                                     AArch64::D3, AArch64::D4, AArch64::D5,
                                     AArch64::D6, AArch64::D7};
static const MCPhysReg QRegList[] = {AArch64::Q0, AArch64::Q1, AArch64::Q2,
                                     AArch64::Q3, AArch64::Q4, AArch64::Q5,
                                     AArch64::Q6, AArch64::Q7};
static const MCPhysReg ZRegList[] = {AArch64::Z0, AArch64::Z1, AArch64::Z2,
                                     AArch64::Z3, AArch64::Z4, AArch64::Z5,
                                     AArch64::Z6, AArch64::Z7};

static bool finishStackBlock(SmallVectorImpl<CCValAssign> &PendingMembers,
                             MVT LocVT, ISD::ArgFlagsTy &ArgFlags,
                             CCState &State, Align SlotAlign) {
  if (LocVT.isScalableVector()) {
    const AArch64Subtarget &Subtarget = static_cast<const AArch64Subtarget &>(
        State.getMachineFunction().getSubtarget());
    const AArch64TargetLowering *TLI = Subtarget.getTargetLowering();

    // We are about to reinvoke the CCAssignFn auto-generated handler. If we
    // don't unset these flags we will get stuck in an infinite loop forever
    // invoking the custom handler.
    ArgFlags.setInConsecutiveRegs(false);
    ArgFlags.setInConsecutiveRegsLast(false);

    // The calling convention for passing SVE tuples states that in the event
    // we cannot allocate enough registers for the tuple we should still leave
    // any remaining registers unallocated. However, when we call the
    // CCAssignFn again we want it to behave as if all remaining registers are
    // allocated. This will force the code to pass the tuple indirectly in
    // accordance with the PCS.
    bool RegsAllocated[8];
    for (int I = 0; I < 8; I++) {
      RegsAllocated[I] = State.isAllocated(ZRegList[I]);
      State.AllocateReg(ZRegList[I]);
    }

    auto &It = PendingMembers[0];
    CCAssignFn *AssignFn =
        TLI->CCAssignFnForCall(State.getCallingConv(), /*IsVarArg=*/false);
    if (AssignFn(It.getValNo(), It.getValVT(), It.getValVT(), CCValAssign::Full,
                 ArgFlags, State))
      llvm_unreachable("Call operand has unhandled type");

    // Return the flags to how they were before.
    ArgFlags.setInConsecutiveRegs(true);
    ArgFlags.setInConsecutiveRegsLast(true);

    // Return the register state back to how it was before, leaving any
    // unallocated registers available for other smaller types.
    for (int I = 0; I < 8; I++)
      if (!RegsAllocated[I])
        State.DeallocateReg(ZRegList[I]);

    // All pending members have now been allocated
    PendingMembers.clear();
    return true;
  }

  const Align StackAlign =
      State.getMachineFunction().getDataLayout().getStackAlignment();
  const Align OrigAlign = ArgFlags.getNonZeroOrigAlign();
  const Align Alignment = std::min(OrigAlign, StackAlign);

  for (auto &It : PendingMembers) {
    unsigned Size = It.getLocVT().getSizeInBits() / 8;
    Align RegAlign = std::max(Alignment, SlotAlign);
    if (It.getLocVT() == MVT::iFATPTR128)
      RegAlign = std::max(RegAlign, Align(16u));
    It.convertToMem(State.AllocateStack(Size, RegAlign));
    State.addLoc(It);
    SlotAlign = Align(1);
  }

  // All pending members have now been allocated
  PendingMembers.clear();
  return true;
}

/// The Darwin variadic PCS places anonymous arguments in 8-byte stack slots. An
/// [N x Ty] type must still be contiguous in memory though.
static bool CC_AArch64_Custom_Stack_Block(
      unsigned &ValNo, MVT &ValVT, MVT &LocVT, CCValAssign::LocInfo &LocInfo,
      ISD::ArgFlagsTy &ArgFlags, CCState &State) {
  SmallVectorImpl<CCValAssign> &PendingMembers = State.getPendingLocs();

  // Add the argument to the list to be allocated once we know the size of the
  // block.
  PendingMembers.push_back(
      CCValAssign::getPending(ValNo, ValVT, LocVT, LocInfo));

  if (!ArgFlags.isInConsecutiveRegsLast())
    return true;

  const AArch64Subtarget &Subtarget = static_cast<const AArch64Subtarget &>(
      State.getMachineFunction().getSubtarget());
  Align StackAlign(Subtarget.hasPureCap() ? 16 : 8);
  return finishStackBlock(PendingMembers, LocVT, ArgFlags, State, StackAlign);
}

unsigned getRegisterForPending(const AArch64RegisterInfo *RegInfo,
                               MVT LocVT, MVT PendingLocVT,
                               unsigned RegResult) {
  if (PendingLocVT == LocVT)
    return RegResult;

  // Allow a mix of i64/iFATPTR128 in the register block.
  if (PendingLocVT == MVT::iFATPTR128) {
    assert(LocVT == MVT::i64);
    for (MCSuperRegIterator AI(RegResult, RegInfo, false); AI.isValid();
         ++AI)
      if (AArch64::CapRegClass.contains(*AI))
        return *AI;
  }

  if (LocVT == MVT::iFATPTR128) {
    assert(PendingLocVT == MVT::i64);
    return RegInfo->getSubReg(RegResult, AArch64::sub_64);
  }

  return RegResult;
}

/// Given an [N x Ty] block, it should be passed in a consecutive sequence of
/// registers. If no such sequence is available, mark the rest of the registers
/// of that type as used and place the argument on the stack.
static bool CC_AArch64_Custom_Block(unsigned &ValNo, MVT &ValVT, MVT &LocVT,
                                    CCValAssign::LocInfo &LocInfo,
                                    ISD::ArgFlagsTy &ArgFlags, CCState &State) {
  const AArch64Subtarget &Subtarget = static_cast<const AArch64Subtarget &>(
      State.getMachineFunction().getSubtarget());
  const AArch64RegisterInfo *RegInfo = Subtarget.getRegisterInfo();
  bool IsDarwinILP32 = Subtarget.isTargetILP32() && Subtarget.isTargetMachO();
  bool HasPureCap = Subtarget.hasPureCap();
  bool Use16CapRegs = Subtarget.use16CapRegs();
  // Try to allocate a contiguous block of registers, each of the correct
  // size to hold one member.
  ArrayRef<MCPhysReg> RegList;
  ArrayRef<MCPhysReg> ReducedList;
  bool UseReduced = false;
  if (LocVT.SimpleTy == MVT::i64 || (IsDarwinILP32 && LocVT.SimpleTy == MVT::i32)) {
    RegList = XRegList;
    ReducedList = XPureCapRegList;
    UseReduced = (HasPureCap && Use16CapRegs);
  } else if (LocVT.SimpleTy == MVT::iFATPTR128) {
    RegList = CRegList;
    ReducedList = CPureCapRegList;
    UseReduced = HasPureCap && Use16CapRegs;
  } else if (LocVT.SimpleTy == MVT::f16)
    RegList = HRegList;
  else if (LocVT.SimpleTy == MVT::f32 || LocVT.is32BitVector())
    RegList = SRegList;
  else if (LocVT.SimpleTy == MVT::f64 || LocVT.is64BitVector())
    RegList = DRegList;
  else if (LocVT.SimpleTy == MVT::f128 || LocVT.is128BitVector())
    RegList = QRegList;
  else if (LocVT.isScalableVector())
    RegList = ZRegList;
  else {
    // Not an array we want to split up after all.
    return false;
  }

  SmallVectorImpl<CCValAssign> &PendingMembers = State.getPendingLocs();

  // Add the argument to the list to be allocated once we know the size of the
  // block.
  PendingMembers.push_back(
      CCValAssign::getPending(ValNo, ValVT, LocVT, LocInfo));

  if (!ArgFlags.isInConsecutiveRegsLast())
    return true;

  // [N x i32] arguments get packed into x-registers on Darwin's arm64_32
  // because that's how the armv7k Clang front-end emits small structs.
  unsigned EltsPerReg = (IsDarwinILP32 && LocVT.SimpleTy == MVT::i32) ? 2 : 1;
  unsigned RegResult = State.AllocateRegBlock(
      UseReduced ? ReducedList : RegList,
      alignTo(PendingMembers.size(), EltsPerReg) / EltsPerReg);
  if (RegResult && EltsPerReg == 1) {
    for (auto &It : PendingMembers) {
      It.convertToReg(getRegisterForPending(RegInfo, LocVT, It.getLocVT(),
                                            RegResult));
      State.addLoc(It);
      ++RegResult;
    }
    PendingMembers.clear();
    return true;
  } else if (RegResult) {
    assert(EltsPerReg == 2 && "unexpected ABI");
    bool UseHigh = false;
    CCValAssign::LocInfo Info;
    for (auto &It : PendingMembers) {
      Info = UseHigh ? CCValAssign::AExtUpper : CCValAssign::ZExt;
      State.addLoc(CCValAssign::getReg(It.getValNo(), MVT::i32, RegResult,
                                       MVT::i64, Info));
      UseHigh = !UseHigh;
      if (!UseHigh)
        ++RegResult;
    }
    PendingMembers.clear();
    return true;
  }

  if (!LocVT.isScalableVector()) {
    // Mark all regs in the class as unavailable
    for (auto Reg : RegList)
      State.AllocateReg(Reg);
  }

  const Align SlotAlign = Subtarget.isTargetDarwin()
                              ? Align(1)
                              : Align(Subtarget.hasPureCap() ? 16 : 8);

  return finishStackBlock(PendingMembers, LocVT, ArgFlags, State, SlotAlign);
}

// CCall takes the first two capability arguments in C9 and C10 and the first
// integer argument in X11.
static bool CC_AArch64_Custom_CCall_Block(unsigned &ValNo, MVT &ValVT, MVT &LocVT,
                                    CCValAssign::LocInfo &LocInfo,
                                    ISD::ArgFlagsTy &ArgFlags, CCState &State) {
  const AArch64Subtarget &Subtarget = static_cast<const AArch64Subtarget &>(
      State.getMachineFunction().getSubtarget());
  const AArch64RegisterInfo *RegInfo = Subtarget.getRegisterInfo();
  // Try to allocate a contiguous block of registers, each of the correct
  // size to hold one member.
  ArrayRef<MCPhysReg> RegList;
  if (LocVT.SimpleTy == MVT::i64) {
    RegList = XCCallRegList;
  } else if (LocVT.SimpleTy == MVT::MVT::iFATPTR128) {
    RegList = CCCallRegList;
  } else if (LocVT.SimpleTy == MVT::f16)
    RegList = HRegList;
  else if (LocVT.SimpleTy == MVT::f32 || LocVT.is32BitVector())
    RegList = SRegList;
  else if (LocVT.SimpleTy == MVT::f64 || LocVT.is64BitVector())
    RegList = DRegList;
  else if (LocVT.SimpleTy == MVT::f128 || LocVT.is128BitVector())
    RegList = QRegList;
  else {
    // Not an array we want to split up after all.
    return false;
  }

  SmallVectorImpl<CCValAssign> &PendingMembers = State.getPendingLocs();

  // Add the argument to the list to be allocated once we know the size of the
  // block.
  PendingMembers.push_back(
      CCValAssign::getPending(ValNo, ValVT, LocVT, LocInfo));

  if (!ArgFlags.isInConsecutiveRegsLast())
    return true;

  unsigned RegResult = State.AllocateRegBlock(RegList, PendingMembers.size());
  if (RegResult) {
    for (auto &It : PendingMembers) {
      It.convertToReg(getRegisterForPending(RegInfo, LocVT, It.getLocVT(),
                                            RegResult));
      State.addLoc(It);
      ++RegResult;
    }
    PendingMembers.clear();
    return true;
  }

  // Mark all regs in the class as unavailable
  for (auto Reg : RegList)
    State.AllocateReg(Reg);

  return finishStackBlock(PendingMembers, LocVT, ArgFlags, State, Align(16));
}

// TableGen provides definitions of the calling convention analysis entry
// points.
#include "AArch64GenCallingConv.inc"
