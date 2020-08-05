// REQUIRES: aarch64

/// Test that going over Immediate(IMM) range throws out-of-range error
///   -2^20 (-1048576) <= IMM <= 2^20 - 16 (1048560)
/// FIXME: The diagnostic maximum range (1048575) is 15-bytes too large.

// RUN: llvm-mc -filetype=obj --triple=arm64 -mattr=+morello %s -o %t.o

// RUN: echo "SECTIONS { \
// RUN:       .data 0x102000: { *(.data) } \
// RUN:       .text 0x002000: { *(.text) } \
// RUN: }" > %t.script
// RUN: not ld.lld --script=%t.script %t.o -o /dev/null 2>&1 | FileCheck %s --check-prefix=OVER_MAX

// RUN: echo "SECTIONS { \
// RUN:       .data 0x001FF0: { *(.data) } \
// RUN:       .text 0x102000: { *(.text) } \
// RUN: }" > %t.script
// RUN: not ld.lld --script=%t.script %t.o -o /dev/null 2>&1 | FileCheck %s --check-prefix=UNDER_MIN

// OVER_MAX: relocation R_MORELLO_LD_PREL_LO17 out of range: 1048576 is not in [-1048576, 1048575]
// UNDER_MIN: relocation R_MORELLO_LD_PREL_LO17 out of range: -1048577 is not in [-1048576, 1048575]

  .text
  .global _start
  .type _start, %function
_start:
  ldr c8,  sym_1
  ldr c9,  sym_2

  .data
sym_1:
.zero 15
sym_2:
