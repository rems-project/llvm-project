# REQUIRES: aarch64
# RUN: llvm-mc -filetype=obj -triple=aarch64-unknown-freebsd %s -o %t
# RUN: echo '.globl sym1; .size sym1, 0xC; .section .data; sym1:; .xword 0' | llvm-mc -filetype=obj -triple=aarch64-unknown-freebsd -o %t2.o
# RUN: echo '.globl sym2; .size sym2, 0xF000E000D000C; .section .data; sym2:; .xword 0' | llvm-mc -filetype=obj -triple=aarch64-unknown-freebsd -o %t3.o
# RUN: echo '.globl sym3; .size sym3, 0xD000C; .section .data; sym3:; .xword 0' | llvm-mc -filetype=obj -triple=aarch64-unknown-freebsd -o %t4.o
# RUN: echo '.globl sym4; .size sym4, 0xE000D000C; .section .data; sym4:; .xword 0' | llvm-mc -filetype=obj -triple=aarch64-unknown-freebsd -o %t5.o
# RUN: ld.lld %t %t2.o %t3.o %t4.o %t5.o -o %t2
# RUN: llvm-objdump -d %t2 | FileCheck %s

.section .R_MORELLO_MOVW_SIZE,"ax",@progbits
movz1:
   movk x12, #:size_g0:sym1
   movk x12, #:size_g0_nc:sym2
   movk x13, #:size_g1:sym3
   movk x13, #:size_g1_nc:sym2
   movk x14, #:size_g2:sym4
   movk x14, #:size_g2_nc:sym2
   movz x15, #:size_g3:sym2
   movk x16, #:size_g3:sym2

## 4222124650659840 == (0xF << 48)
# CHECK: Disassembly of section .R_MORELLO_MOVW_SIZE:
# CHECK-EMPTY:
# CHECK-NEXT: <movz1>:
# CHECK-NEXT: 8c 01 80 f2   movk  x12, #12
# CHECK-NEXT: 8c 01 80 f2   movk  x12, #12
# CHECK-NEXT: ad 01 a0 f2   movk  x13, #13, lsl #16
# CHECK-NEXT: ad 01 a0 f2   movk  x13, #13, lsl #16
# CHECK-NEXT: ce 01 c0 f2   movk  x14, #14, lsl #32
# CHECK-NEXT: ce 01 c0 f2   movk  x14, #14, lsl #32
# CHECK-NEXT: ef 01 e0 d2   mov x15, #4222124650659840
# CHECK-NEXT: f0 01 e0 f2   movk  x16, #15, lsl #48
