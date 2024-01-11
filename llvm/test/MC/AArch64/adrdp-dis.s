// RUN: llvm-mc -arch=aarch64 -filetype=obj -mattr=+morello,+c64 -target-abi purecap %s -o - | llvm-objdump -d - | FileCheck %s

// CHECK: 0000000000001000 <foo>:
// CHECK-NEXT:    1000: 06 00 00 d0  	adrdp	c6, 0x2000
// CHECK-NEXT:    1004: c6 30 40 c2  	ldr	c6, [c6, #192]

.globl bar
 nop
 ret

.align 12
.globl foo
foo:
 adrdp c6, #0x2000
 ldr  c6, [c6, #0xc0]
