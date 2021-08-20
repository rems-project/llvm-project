// REQUIRES: aarch64
// RUN: llvm-mc --triple=aarch64-none-elf -mattr=+morello,+c64 -target-abi purecap -filetype=obj %s -o %t.o
// RUN: ld.lld -m aarch64elf %t.o -o %t
// RUN: llvm-readelf -h %t | FileCheck %s

// XXX should use split-file %s %t
// RUN: llvm-mc --triple=aarch64-none-elf -target-abi purecap -mattr=+morello,+c64 -filetype=obj %s -o %t_purecap.o
// RUN: llvm-mc --triple=aarch64-none-elf -mattr=+morello -filetype=obj %S/Inputs/morello-eflags-hybrid.s -o %t_hybrid.o
// RUN: ld.lld -m aarch64elf %t_purecap.o %t_hybrid.o -o %t_mixed 2>&1 | FileCheck %s --check-prefix=WARNING-MSG
// RUN: ld.lld -m aarch64elf %t_purecap.o %t_hybrid.o -o %t_mixed --morello-c64-plt 2>&1 | \
// RUN:     FileCheck %s --check-prefix=WARNING-MSG --check-prefix=C64PLTWARN
// RUN: ld.lld -m aarch64elf %t_purecap.o %t_hybrid.o -o %t_mixed -disable-warn-morello-abi-mismatch 2>&1 | \
// RUN:     FileCheck %s --check-prefix=NOWARNING-MSG --check-prefix=NOC64PLTWARN --allow-empty

/// Check that the output file has the correct eflags

.text
.globl _start
.type _start, %function
.size _start, 4
_start:
	nop

// CHECK: Flags: 0x10000
// C64PLTWARN: warning: {{.+}}: Forcing purecap ABI because --morello-c64-plt was passed. This option is deprecated and should be removed. The purecap ABI should be infered through e_flags. Use a recent toolchain to rebuild this object and build it with the purecap ABI
// NOC64PLTWARN-NOT: warning: {{.+}}: Forcing purecap ABI because --morello-c64-plt was passed. This option is deprecated and should be removed. The purecap ABI should be infered through e_flags. Use a recent toolchain to rebuild this object and build it with the purecap ABI
// WARNING-MSG: warning: {{.+}}: linking object files with different EF_AARCH64_CHERI_PURECAP. This will be deprecated and produce an error.
// NOWARNING-MSG-NOT: warning: {{.+}}: linking object files with different EF_AARCH64_CHERI_PURECAP. This will be deprecated and produce an error.
