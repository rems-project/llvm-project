// REQUIRES: aarch64
// RUN: llvm-mc -filetype=obj -triple=arm64 -mattr=+morello,+c64 %s -o %t.o
// RUN: not ld.lld %t.o -o /dev/null 2>&1 | FileCheck %s

// CHECK: relocation R_MORELLO_ADR_PREL_PG_HI20 out of range: 2147483648 is not in [-2147483648, 2147483647]
// CHECK: relocation R_MORELLO_ADR_PREL_PG_HI20 out of range: -2147487744 is not in [-2147483648, 2147483647]

  .text
  .global _start
  .type _start, %function
_start:
foo = .
adrp c25, foo + 0x80000000
adrp c26, foo - (0x80000000+0x1000)
