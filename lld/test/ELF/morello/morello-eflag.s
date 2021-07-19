// REQUIRES: aarch64
// RUN: llvm-mc --triple=aarch64-none-elf -mattr=+morello,+c64 -target-abi purecap -filetype=obj %s -o %t.o
// RUN: ld.lld -m aarch64elf --morello-c64-plt %t.o -o %t
// RUN: llvm-readelf -h %t | FileCheck %s

// XXX should use split-file %s %t
// RUN: llvm-mc --triple=aarch64-none-elf -mattr=+morello,+c64 -target-abi purecap -filetype=obj %s -o %t_purecap.o
// RUN: llvm-mc --triple=aarch64-none-elf -mattr=+morello -filetype=obj %S/Inputs/morello-eflags-hybrid.s -o %t_hybrid.o
// RUN: ld.lld -m aarch64elf --morello-c64-plt %t_purecap.o %t_hybrid.o -o %t_mixed 2>&1 | FileCheck %s --check-prefix WARNING-MSG

/// Check that the output file has the correct eflags

.text
.globl _start
.type _start, %function
.size _start, 4
_start:
	nop

// CHECK: Flags: 0x10000
// WARNING-MSG: warning: {{.+}}: linking object files with different EF_AARCH64_CHERI_PURECAP. This will be deprecated and produce an error.
