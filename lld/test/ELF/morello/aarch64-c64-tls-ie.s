// REQUIRES: aarch64
// This needs additional relocations.
// XFAIL: *
// RUN: llvm-mc -filetype=obj -triple=aarch64-none-elf -mattr=+c64,+morello %s -o %t.o
// RUN: ld.lld --morello-c64-plt %t.o -o %t
// RUN: llvm-objdump -triple=aarch64-none-elf -mattr=+morello -d --no-show-raw-insn %t | FileCheck %s --check-prefix=RELAX
// RUN: ld.lld --morello-c64-plt --shared %t.o -o %t
// RUN: llvm-objdump -triple=aarch64-none-elf -mattr=+morello -d --no-show-raw-insn %t | FileCheck %s --check-prefix=NORELAX
// RUN: llvm-readobj --relocs %t | FileCheck %s

/// An attempt to handle IE TLS. This should not require a capability as it is
/// just an offset from TP.
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
 ldr c0, [c0, #:gottprel_lo12:foo]

 adrp c0, :gottprel:bar
 ldr c0, [c0, #:gottprel_lo12:bar]

// RELAX: 00000000002101c8 _start:
// RELAX-NEXT:   2101c8:        movz    x0, #0, lsl #16
// RELAX-NEXT:   2101cc:        movk    x0, #16
// RELAX-NEXT:   2101d0:        movz    x0, #0, lsl #16
// RELAX-NEXT:   2101d4:        movk    x0, #20

// NORELAX: 00000000000102f0 _start:
// NORELAX-NEXT:    102f0:              adrp    c0, #65536
// NORELAX-NEXT:    102f4:              ldr     c0, [c0, #944]
// NORELAX-NEXT:    102f8:              adrp    c0, #65536
// NORELAX-NEXT:    102fc:              ldr     c0, [c0, #960]

// CHECK: Relocations [
// CHECK-NEXT:   Section (5) .rela.dyn {
// CHECK-NEXT:     0x203C0 R_AARCH64_TLS_TPREL64 bar 0x0
// CHECK-NEXT:     0x203B0 R_AARCH64_TLS_TPREL64 foo 0x0
