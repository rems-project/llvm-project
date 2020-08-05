// REQUIRES: aarch64

/// Test Immediate(IMM) alignment check
/// e.g.
/// for the ldr c12, sym_5 instruction below
///   P = 0x210141
///   S = 0x220181
///   IMM = S + A - (P & ~0xF)
///       = 0x220181 - (0x210141 & ~0xF)
///       = 0x10021

// RUN: llvm-mc -filetype=obj --triple=arm64 -mattr=+morello %s -o %t.o
// RUN: not ld.lld %t.o -o /dev/null 2>&1 | FileCheck %s

// CHECK: improper alignment for relocation R_MORELLO_LD_PREL_LO17: 0x10041 is not aligned to 16 bytes
// CHECK: improper alignment for relocation R_MORELLO_LD_PREL_LO17: 0x10042 is not aligned to 16 bytes
// CHECK: improper alignment for relocation R_MORELLO_LD_PREL_LO17: 0x10043 is not aligned to 16 bytes
// CHECK: improper alignment for relocation R_MORELLO_LD_PREL_LO17: 0x10044 is not aligned to 16 bytes
// CHECK: improper alignment for relocation R_MORELLO_LD_PREL_LO17: 0x10035 is not aligned to 16 bytes
// CHECK: improper alignment for relocation R_MORELLO_LD_PREL_LO17: 0x10036 is not aligned to 16 bytes
// CHECK: improper alignment for relocation R_MORELLO_LD_PREL_LO17: 0x10037 is not aligned to 16 bytes
// CHECK: improper alignment for relocation R_MORELLO_LD_PREL_LO17: 0x10038 is not aligned to 16 bytes
// CHECK: improper alignment for relocation R_MORELLO_LD_PREL_LO17: 0x10029 is not aligned to 16 bytes
// CHECK: improper alignment for relocation R_MORELLO_LD_PREL_LO17: 0x1002A is not aligned to 16 bytes
// CHECK: improper alignment for relocation R_MORELLO_LD_PREL_LO17: 0x1002B is not aligned to 16 bytes
// CHECK: improper alignment for relocation R_MORELLO_LD_PREL_LO17: 0x1002C is not aligned to 16 bytes
// CHECK: improper alignment for relocation R_MORELLO_LD_PREL_LO17: 0x1001D is not aligned to 16 bytes
// CHECK: improper alignment for relocation R_MORELLO_LD_PREL_LO17: 0x1001E is not aligned to 16 bytes
// CHECK: improper alignment for relocation R_MORELLO_LD_PREL_LO17: 0x1001F is not aligned to 16 bytes
// CHECK-NOT: improper alignment for relocation R_MORELLO_LD_PREL_LO17:

  .balign 16
  .text
  .global _start
  .type _start, %function
_start:
  ldr c8,  sym_1
  ldr c9,  sym_2
  ldr c10, sym_3
  ldr c11, sym_4
  ldr c12, sym_5
  ldr c13, sym_6
  ldr c14, sym_7
  ldr c15, sym_8
  ldr c16, sym_9
  ldr c17, sym_A
  ldr c18, sym_B
  ldr c19, sym_C
  ldr c20, sym_D
  ldr c21, sym_E
  ldr c22, sym_F
  ldr c23, sym_0

  .balign 16
  .data
  .zero 1
sym_1:
  .zero 1
sym_2:
  .zero 1
sym_3:
  .zero 1
sym_4:
  .zero 1
sym_5:
  .zero 1
sym_6:
  .zero 1
sym_7:
  .zero 1
sym_8:
  .zero 1
sym_9:
  .zero 1
sym_A:
  .zero 1
sym_B:
  .zero 1
sym_C:
  .zero 1
sym_D:
  .zero 1
sym_E:
  .zero 1
sym_F:
  .zero 1
sym_0:
