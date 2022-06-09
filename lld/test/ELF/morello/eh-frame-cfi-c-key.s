// REQUIRES: aarch64
// RUN: llvm-mc --triple=aarch64-none-elf -target-abi purecap -mattr=+c64 -filetype=obj %s -o %t.o
// RUN: ld.lld %t.o -o %t --icf=all --eh-frame-hdr

.globl _start
_start:
.cfi_startproc purecap
.cfi_endproc
