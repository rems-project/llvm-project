// REQUIRES: aarch64
// RUN: llvm-mc --triple=aarch64-none-elf %s -mattr=+c64,+morello --filetype=obj -o %t.o
// RUN: echo "SECTIONS { \
// RUN:       . = SIZEOF_HEADERS; \
// RUN:       .text_low : { *(.text.1) } \
// RUN:       .text_high 0xf000000 : { *(.text.2) *(.text.3) } \
// RUN:       } " > %t.script
// RUN: ld.lld %t.o -o %t --script=%t.script
// RUN: llvm-objdump -d --no-show-raw-insn --triple=aarch64-none-elf -mattr=+morello %t | FileCheck %s

        .section .text.1, "ax", %progbits
        .balign 4
        .global _start
        .type _start, %function
        .size _start, 4
_start:
        bl target
        b target2

        .section .text.2, "ax", %progbits
        .global target
        .type target, %function
        .size target, 4
target: ret

        .section .text.3, "ax", %progbits
        .global target2
        .type target2, %function
        .size target2, 4
target2: ret

// CHECK: 00000000000000e8 <_start>:
// CHECK-NEXT:       e8:        bl      #8 <__C64ADRPThunk_target>
// CHECK-NEXT:       ec:        b       #16 <__C64ADRPThunk_target2>

// CHECK: 00000000000000f0 <__C64ADRPThunk_target>:
// CHECK-NEXT:       f0:        adrp    c16, #251658240
// CHECK-NEXT:       f4:        add     c16, c16, #1
// CHECK-NEXT:       f8:        br      c16

// CHECK: 00000000000000fc <__C64ADRPThunk_target2>:
// CHECK-NEXT:       fc:        adrp    c16, #251658240
// CHECK-NEXT:      100:        add     c16, c16, #5
// CHECK-NEXT:      104:        br      c16

// CHECK: 000000000f000000 <target>:
// CHECK-NEXT:  f000000:        ret

// CHECK: 000000000f000004 <target2>:
// CHECK-NEXT:  f000004:        ret
