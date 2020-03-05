// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+c64 < %s | \
// RUN:   llvm-objdump -t - | FileCheck --check-prefix=CHECK-C64 %s
// RUN: llvm-mc -triple=aarch64 -filetype=obj < %s | \
// RUN:   llvm-objdump -t - | FileCheck --check-prefix=CHECK-A64 %s
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+morello < %s | \
// RUN:   llvm-objdump -t - | FileCheck --check-prefix=CHECK-A64 %s
// RUN: llvm-mc -triple=aarch64 -filetype=obj -mattr=+c64,+morello < %s | \
// RUN:   llvm-objdump -t - | FileCheck --check-prefix=CHECK-C64 %s


// Check that mapping symbol "$c" is used for the C64 code and "$x" for A64(C).

	mov x0, #3
	.word 5
	.inst 0xd28000e0 // mov x0, #7

// CHECK-C64: 0000000000000000 l        .text           0000000000000000 $c.0
// CHECK-C64: 0000000000000008 l        .text           0000000000000000 $c.2
// CHECK-C64: 0000000000000004 l        .text           0000000000000000 $d.1

// CHECK-A64: 0000000000000004 l        .text           0000000000000000 $d.1
// CHECK-A64: 0000000000000000 l        .text           0000000000000000 $x.0
// CHECK-A64: 0000000000000008 l        .text           0000000000000000 $x.2
