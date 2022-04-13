// REQUIRES: aarch64
// RUN: llvm-mc -filetype=obj -triple=aarch64-none-elf -target-abi purecap -mattr=+c64,+morello %s -o %t.o
// RUN: ld.lld %t.o -o %t
// RUN: llvm-objdump --mattr=+morello -d --no-show-raw-insn %t | FileCheck %s --check-prefix=RELAX
// RUN: ld.lld --shared %t.o -o %t
// RUN: llvm-objdump --mattr=+morello -d --no-show-raw-insn %t | FileCheck %s --check-prefix=NORELAX
// RUN: llvm-readobj --relocs %t | FileCheck %s

 .text
 .global foo
 .section .tdata,"awT",%progbits
 .align 2
 .type foo, %object
 .size foo, 4
foo:
 .word 5
 .text

.text
 .global bar
 .section .tdata,"awT",%progbits
 .align 2
 .type bar, %object
 .size bar, 4
bar:
 .word 5
 .text

 .globl _start
 .type _start, %function
 .size _start, 16
_start:
 adrp c0, :gottprel:foo
 add c0, c0, #:gottprel_lo12:foo
 ldp x0, x1, [c0]

 adrp c0, :gottprel:bar
 add c0, c0, #:gottprel_lo12:bar
 ldp x0, x1, [c0]

// RELAX: 0000000000210200 <_start>:
// RELAX-NEXT:  210200:      	adrp	c0, 0x200000
// RELAX-NEXT:  210204:      	add	c0, c0, #480
// RELAX-NEXT:  210208:      	ldp	x0, x1, [c0]
// RELAX-NEXT:  21020c:      	adrp	c0, 0x200000
// RELAX-NEXT:  210210:      	add	c0, c0, #496
// RELAX-NEXT:  210214:      	ldp	x0, x1, [c0]

// NORELAX: 00000000000102f0 <_start>:
// NORELAX-NEXT:   102f0:      	adrp	c0, 0x20000 <_start+0x40>
// NORELAX-NEXT:   102f4:      	add	c0, c0, #944
// NORELAX-NEXT:   102f8:      	ldp	x0, x1, [c0]
// NORELAX-NEXT:   102fc:      	adrp	c0, 0x20000 <_start+0x4c>
// NORELAX-NEXT:   10300:      	add	c0, c0, #960
// NORELAX-NEXT:   10304:      	ldp	x0, x1, [c0]

// CHECK: Relocations [
// CHECK-NEXT:   Section (5) .rela.dyn {
// CHECK-NEXT:     0x203B0 R_MORELLO_TLS_TPREL128 foo 0x0
// CHECK-NEXT:     0x203C0 R_MORELLO_TLS_TPREL128 bar 0x0
