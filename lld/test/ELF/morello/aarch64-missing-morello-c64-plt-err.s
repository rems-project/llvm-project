// REQUIRES: aarch64
// RUN: llvm-mc --triple=aarch64-none-elf -mattr=+c64,+morello -filetype=obj %s -o %t.o
// RUN: not ld.lld --shared %t.o -o /dev/null 2>&1 | FileCheck %s
/// Check that we error somewhat gracefully when --morello-c64-plt is missed out.

// CHECK: error: Morello PLT/GOT generating relocation R_MORELLO_CALL26 requires --morello-c64-plt
// CHECK-NEXT: error: Morello PLT/GOT generating relocation R_MORELLO_JUMP26 requires --morello-c64-plt
// CHECK-NEXT: error: Morello PLT/GOT generating relocation R_MORELLO_LD128_GOT_LO12_NC requires --morello-c64-plt

 .text
 bl imported
 b  imported
 adrp c0, :got: val
 ldr c0, [c0, :got_lo12: val]

 .data
 .global val
 .size val, 4
 .type val, %object
val:
 .word 0
