// REQUIRES: aarch64
// RUN: llvm-mc --triple=aarch64-none-elf -mattr=+c64,+morello -filetype=obj %s -o %t.o
// RUN: echo "SECTIONS { \
// RUN:         other : { \
// RUN:           *(.data); \
// RUN:           *(__cap_relocs); \
// RUN:         } \
// RUN:       } " > %t.script
// RUN: ld.lld %t.o -o %t --script %t.script
// RUN: llvm-readobj --cap-relocs --symbols --expand-relocs %t | FileCheck %s

 .data
 .balign 16
hello:
 .string "Hello World"

 .type ptr1, %object
 .size ptr1, 16
ptr1:
 .capinit hello + 8
 .8byte 0
 .8byte 12

 .type ptr2, %object
 .size ptr2, 16
ptr2:
 .capinit bye
 .8byte 0
 .8byte 10

bye:
 .string "Bye World"

 .globl __cap_relocs_start
 .globl __cap_relocs_end
 .xword __cap_relocs_start
 .xword __cap_relocs_end

// CHECK:          Name: __cap_relocs_end
// CHECK-NEXT:     Value: 0x98
// CHECK-NEXT:     Size: 0
// CHECK-NEXT:     Binding: Local (0x0)
// CHECK-NEXT:     Type: None (0x0)
// CHECK-NEXT:     Other [ (0x2)
// CHECK-NEXT:       STV_HIDDEN (0x2)
// CHECK-NEXT:     ]
// CHECK-NEXT:     Section: other
// CHECK-NEXT:   }
// CHECK-NEXT:   Symbol {
// CHECK-NEXT:     Name: __cap_relocs_start
// CHECK-NEXT:     Value: 0x48
// CHECK-NEXT:     Size: 0
// CHECK-NEXT:     Binding: Local (0x0)
// CHECK-NEXT:     Type: None (0x0)
// CHECK-NEXT:     Other [ (0x2)
// CHECK-NEXT:       STV_HIDDEN (0x2)
// CHECK-NEXT:     ]
// CHECK-NEXT:     Section: other

// CHECK: There is no __cap_relocs section in the file
