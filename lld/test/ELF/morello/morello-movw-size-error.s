# REQUIRES: aarch64
# RUN: llvm-mc -filetype=obj -triple=aarch64-unknown-freebsd %s -o %t
# RUN: echo '.globl sym1; .size sym1, 0x10000; .section .data; sym1:; .xword 0' | llvm-mc -filetype=obj -triple=aarch64-unknown-freebsd -o %t2.o
# RUN: echo '.globl sym2; .size sym2, 0x100000000; .section .data; sym2:; .xword 0' | llvm-mc -filetype=obj -triple=aarch64-unknown-freebsd -o %t3.o
# RUN: echo '.globl sym3; .size sym3, 0x1000000000000; .section .data; sym3:; .xword 0' | llvm-mc -filetype=obj -triple=aarch64-unknown-freebsd -o %t4.o
# RUN: not ld.lld %t %t2.o %t3.o %t4.o -o /dev/null 2>&1 | FileCheck %s

# CHECK: relocation R_MORELLO_MOVW_SIZE_G0 out of range: 65536 is not in [0, 65535]
movn x0, #:size_g0:sym1
# CHECK: relocation R_MORELLO_MOVW_SIZE_G1 out of range: 4294967296 is not in [0, 4294967295]
movn x0, #:size_g1:sym2
# CHECK: relocation R_MORELLO_MOVW_SIZE_G2 out of range: 281474976710656 is not in [0, 281474976710655]
movn x0, #:size_g2:sym3
