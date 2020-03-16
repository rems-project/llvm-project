// REQUIRES: aarch64
// RUN: llvm-mc -filetype=obj -triple=arm64 -mattr=+morello,+c64 %s -o %t.o
// RUN: ld.lld %t.o -o %t
// RUN: llvm-objdump --mattr=+morello -d %t | FileCheck %s

// CHECK: adrp c25, #-2147483648
// CHECK: adrp c26, #2147479552

  .text
  .global _start
  .type _start, %function
_start:
  foo = .
  adrp c25, :pg_hi21_nc:foo+0x80000000
  adrp c26, :pg_hi21_nc:foo-(0x80000000+0x1000)
