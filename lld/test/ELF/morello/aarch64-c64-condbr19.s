// REQUIRES: aarch64
// RUN: llvm-mc --triple=aarch64-none-elf -mattr=+c64 -filetype=obj %s -o %t.o
// RUN: ld.lld %t.o -o %t
// RUN: llvm-objdump --no-show-raw-insn -d %t --triple=aarch64-none-elf --mattr=+c64

/// Test that we can handle the R_AARCH64_CONDBR19 reloc when the target is a
/// capability.
/// FIXME: This relocation is likely to become R_MORELLO_CONDBR19.
 .section .text.1, "ax", %progbits
 .globl _start
 .type _start, %function
_start:
 b.eq high

 .section .text.2, "ax", %progbits
 .globl high
 .type high, %function
high:
 b.ne _start

// CHECK: 0000000000210000 _start:
// CHECK-NEXT:      210000:        b.eq    #4 <high>

// CHECK:0000000000210004 high:
// CHECK-NEXT:     210004:        b.ne    #-4 <_start>
