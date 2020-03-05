// RUN: echo "SECTIONS { \
// RUN:    . = SIZEOF_HEADERS; \
// RUN:    .text_low : { *(.text.1) *(.text.2) } \
// RUN:    .text_high 0xf000000 : { *(.text.3) } \
// RUN: } " > %t.script
// RUN: llvm-mc --triple=aarch64-none-elf %s -mattr=+c64,+morello --filetype=obj -o %t1.o
// RUN: llvm-mc --triple=aarch64-none-elf %S/Inputs/aarch64-faraway-func.s --filetype=obj -o %t2.o
// RUN: ld.lld %t1.o %t2.o --script=%t.script -o %t
// RUN: llvm-objdump -d --no-show-raw-insn --triple=aarch64-none-elf -mattr=+morello %t | FileCheck %s --check-prefix=CHECK --check-prefix=A64_LAST

// RUN: llvm-mc --triple=aarch64-none-elf %s --filetype=obj -o %t1.o
// RUN: llvm-mc --triple=aarch64-none-elf %S/Inputs/aarch64-faraway-func.s -mattr=+c64,+morello --filetype=obj -o %t2.o
// RUN: ld.lld %t1.o %t2.o --script=%t.script -o %t
// RUN: llvm-objdump -d --no-show-raw-insn --triple=aarch64-none-elf -mattr=+morello %t | FileCheck %s --check-prefix=CHECK --check-prefix=C64_LAST


  .section .text.1, "ax", %progbits
  .balign 4
  .global _start
  .type _start, %function
  .size _start, 4
_start:
  b  far_away
  bl far_away

/// The A64 Long Thunk is created last, and does not share the C64 Thunk
// A64_LAST: 00000000000000e8 <_start>:
// A64_LAST-NEXT:  e8: b  #8 <__C64ADRPThunk_far_away>
// A64_LAST-NEXT:  ec: bl #4 <__C64ADRPThunk_far_away>

// A64_LAST: 00000000000000f0 <__C64ADRPThunk_far_away>:
// A64_LAST-NEXT: f0: adrp c16, #251658240
// A64_LAST-NEXT: f4: add  c16, c16, #0
// A64_LAST-NEXT: f8: br   c16

// A64_LAST: 00000000000000fc <func>:
// A64_LAST-NEXT:  fc: b  #8 <__AArch64AbsLongThunk_far_away>
// A64_LAST-NEXT: 100: bl #4 <__AArch64AbsLongThunk_far_away>

// A64_LAST: 0000000000000104 <__AArch64AbsLongThunk_far_away>:
// A64_LAST-NEXT: 104: ldr x16, #8
// A64_LAST-NEXT: 108: br  x16


/// The C64 Long Thunk is created last, and does not share the A64 Thunk
// C64_LAST: 00000000000000e8 <_start>:
// C64_LAST-NEXT:  e8: b  #8 <__A64ToC64Thunk_far_away>
// C64_LAST-NEXT:  ec: bl #4 <__A64ToC64Thunk_far_away>

// C64_LAST: 00000000000000f0 <__A64ToC64Thunk_far_away>:
// C64_LAST-NEXT: f0: bx   #4
// C64_LAST-EMPTY:
// C64_LAST-NEXT: 00000000000000f4 <$c>:
// C64_LAST-NEXT: f4: adrp c16, #251658240
// C64_LAST-NEXT: f8: add  c16, c16, #1
// C64_LAST-NEXT: fc: br   c16

// C64_LAST: 0000000000000100 <func>:
// C64_LAST-NEXT: 100: b  #8 <__C64ADRPThunk_far_away>
// C64_LAST-NEXT: 104: bl #4 <__C64ADRPThunk_far_away>

// C64_LAST: 0000000000000108 <__C64ADRPThunk_far_away>:
// C64_LAST-NEXT: 108: adrp c16, #251658240
// C64_LAST-NEXT: 10c: add  c16, c16, #1
// C64_LAST-NEXT: 110: br   c16

// CHECK: 000000000f000000 <far_away>:
