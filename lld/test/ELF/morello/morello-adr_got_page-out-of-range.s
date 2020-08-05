// REQUIRES: aarch64
// RUN: llvm-mc -filetype=obj -triple=arm64 -mattr=+c64,+morello %s -o %t.o
// RUN: not ld.lld %t.o --morello-c64-plt -o /dev/null 2>&1 | FileCheck %s
// RUN: llvm-readobj -r %t.o  | FileCheck %s --check-prefix=RELOCS

// CHECK: relocation R_MORELLO_ADR_GOT_PAGE out of range: 2147483648 is not in [-2147483648, 2147483647]
// CHECK: relocation R_MORELLO_ADR_GOT_PAGE out of range: -2147487744 is not in [-2147483648, 2147483647]

// RELOCS: Relocations [
// RELOCS-NEXT: Section
// RELOCS-NEXT:   0x0 R_MORELLO_ADR_GOT_PAGE foo 0x7FFF0000
// RELOCS-NEXT:   0x4 R_MORELLO_ADR_GOT_PAGE foo 0xFFFFFFFF7FFEF000

  .text
  .global _start
  .type _start, %function
_start:
adrp c25, :got:foo + (0x7ffef000+0x1000)
adrp c26, :got:foo - (0x80010000+0x1000)

  .data
  .global foo
 .size foo, 8
foo:
 .xword 10
