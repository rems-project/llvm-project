// REQUIRES: aarch64
// RUN: llvm-mc --triple=aarch64-none-elf -mattr=+c64 -target-abi purecap -filetype=obj %s -o %t.o
// RUN: ld.lld -m aarch64elf --morello-c64-plt %t.o -o %t
// RUN: llvm-readelf -h %t | FileCheck %s

/// Check that the output file has the correct eflags
.text
.globl _start
.type _start, %function
.size _start, 4
_start:
	nop
// CHECK: Flags: 0x10000
