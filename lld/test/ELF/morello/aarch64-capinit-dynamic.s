// REQUIRES: aarch64
// RUN: llvm-mc --triple=aarch64-none-elf -mattr=+c64,+morello -filetype=obj %s -o %t.o
// RUN: ld.lld --shared --morello-c64-plt %t.o -o %t
// RUN: llvm-objdump -s %t | FileCheck %s --check-prefix=DATA
// RUN: llvm-readobj --expand-relocs --relocations --cap-relocs %t | FileCheck %s

/// Basics of the .capinit relocation using dynamic linking.
/// We create two capabilites via .capinit. These will produce R_MORELLO_CAPINIT
/// Relocations that the linker will use to create dynamic relocations for
/// the dynamic loader to create the capabilities

 .text
 .type _start, %function
 .globl _start
 .balign 4
_start:
 ret

 .data
 .balign 16
 .type ptr1, %object
 .size ptr1, 16
ptr1:
 .capinit str + 8
 .8byte 0
 .8byte 12

 .type ptr2, %object
 .size ptr2, 16
ptr2:
 .capinit str
 .8byte 0
 .8byte 12

 .type ptr3, %object
 .size ptr3, 16
ptr3:
 .capinit foo + 0x10
 .8byte 0
 .8byte 0

 .local str
 .type str, %object
 .size str, 12
str:
 .string "Hello World"

 .globl foo
 .type foo, %object
 .size foo, 8
foo:
 .balign 8
 .8byte 0

/// Check that we write the size, permissions and address if relevant to the
/// Fragment.
// DATA: Contents of section .data:
// DATA:       303b0 e0030300 00000000 0c000000 00000002
// DATA-NEXT:  303c0 e0030300 00000000 0c000000 00000002
// DATA-NEXT:  303d0 ec030300 00000000 08000000 00000002
// DATA-NEXT:  303e0 48656c6c 6f20576f 726c6400 00000000  Hello World
// DATA-NEXT:  303f0 00000000 00000000

/// Dynamic relocations
// CHECK: Relocations [
// CHECK-NEXT:   Section (5) .rela.dyn {
// CHECK-NEXT:     Relocation {
// CHECK-NEXT:       Offset: 0x303B0
// CHECK-NEXT:       Type: R_MORELLO_RELATIVE
// CHECK-NEXT:       Symbol: - (0)
// CHECK-NEXT:       Addend: 0x8
// CHECK-NEXT:     }
// CHECK-NEXT:     Relocation {
// CHECK-NEXT:       Offset: 0x303C0
// CHECK-NEXT:       Type: R_MORELLO_RELATIVE
// CHECK-NEXT:       Symbol: - (0)
// CHECK-NEXT:       Addend: 0x0
// CHECK-NEXT:     }
// CHECK-NEXT:     Relocation {
// CHECK-NEXT:       Offset: 0x303D0
// CHECK-NEXT:       Type: R_MORELLO_CAPINIT
// CHECK-NEXT:       Symbol: foo (2)
// CHECK-NEXT:       Addend: 0x10
// CHECK-NEXT:     }
// CHECK-NEXT:   }
// CHECK-NEXT: ]
// CHECK-NEXT: There is no __cap_relocs section in the file.
