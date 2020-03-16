// REQUIRES: aarch64
// RUN: llvm-mc --triple=aarch64-none-elf -mattr=+c64 -filetype=obj %s -o %t.o
// RUN: ld.lld %t.o -o %t
// RUN: llvm-objdump --no-show-raw-insn -d %t --triple=aarch64-none-elf --mattr=+morello | FileCheck %s

/// Strictly speaking the definition of R_AARCH64_ABS64 to a C64 symbol is:
/// ((S & ~1) + A) | C
/// If we are not careful and clear the bottom bit before adding the addend
/// we can get an even answer for R_AARCH64_ABS64.
 .text
 .globl _start
 .type _start, %function
_start:
 ret
 .xword _start + 1

// CHECK:  210124: 21 01 21 00 .word 0x00210121
