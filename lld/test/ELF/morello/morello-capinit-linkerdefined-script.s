// REQUIRES: aarch64
// RUN: llvm-mc --triple=aarch64-none-elf -mattr=+c64 -filetype=obj %s -o %t.o
// RUN: echo "SECTIONS { \
// RUN:       .text 0x210000: { *(.text) } \
// RUN:       mysection : { \
// RUN:          PROVIDE_HIDDEN(__start_mysection = .); \
// RUN:          *(mysection); \
// RUN:          PROVIDE_HIDDEN(__stop_mysection = .); \
// RUN:       } \
// RUN:       .preinit_array : { \
// RUN:          PROVIDE_HIDDEN(__preinit_array_start = .); \
// RUN:          *(.preinit_array); \
// RUN:          PROVIDE_HIDDEN(__preinit_array_end = .); \
// RUN:       } \
// RUN:       .init_array : { \
// RUN:          PROVIDE_HIDDEN(__init_array_start = .); \
// RUN:          *(.init_array); \
// RUN:          PROVIDE_HIDDEN(__init_array_end = .); \
// RUN:       } \
// RUN:       .fini_array : { \
// RUN:          PROVIDE_HIDDEN(__fini_array_start = .); \
// RUN:          *(.fini_array); \
// RUN:          PROVIDE_HIDDEN(__fini_array_end = .); \
// RUN:       } \
// RUN:       .data.rel.ro : { \
// RUN:          *(.data.rel.ro); \
// RUN:       } \
// RUN:       __cap_relocs : { \
// RUN:          *(__cap_relocs); \
// RUN:       } \
// RUN:       } " > %t.script

// RUN: ld.lld -v %t.o -o %t --script %t.script
// RUN: llvm-readobj --cap-relocs --expand-relocs %t | FileCheck %s

/// Using a linker script. Check that linker defined section start symbols
/// get the size of the output section, and stop/end symbols get a size of 0.

 .section .preinit_array, "a", %preinit_array
 .balign 1024
 .xword 0

 .section .init_array, "a", %init_array
 .balign 1024
 .xword 0

 .section .fini_array, "a", %fini_array
 .balign 1024
 .xword 0

 .section mysection, "a", %progbits
 .balign 1024
 .xword 0

 .text
 .balign 1024

 .globl _start
 .type _start, %function
_start: ret

 .data.rel.ro

 .capinit __preinit_array_start
 .xword 0
 .xword 0
 .capinit __preinit_array_end
 .xword 0
 .xword 0

 .capinit __init_array_start
 .xword 0
 .xword 0
 .capinit __init_array_end
 .xword 0
 .xword 0

 .capinit __fini_array_start
 .xword 0
 .xword 0
 .capinit __fini_array_end
 .xword 0
 .xword 0

 .capinit __start_mysection
 .xword 0
 .xword 0

 .capinit __stop_mysection
 .xword 0
 .xword 0

// CHECK: CHERI __cap_relocs [
// CHECK-NEXT:   Relocation {
// CHECK-NEXT:     Location: 0x211008
// CHECK-NEXT:     Base: __preinit_array_start (0x210800)
// CHECK-NEXT:     Offset: 0
// CHECK-NEXT:     Length: 8
// CHECK-NEXT:     Permissions: (RODATA) (0x1BFBE)
// CHECK-NEXT:   }
// CHECK-NEXT:   Relocation {
// CHECK-NEXT:     Location: 0x211018
// CHECK-NEXT:     Base: __preinit_array_end (0x210808)
// CHECK-NEXT:     Offset: 0
// CHECK-NEXT:     Length: 0
// CHECK-NEXT:     Permissions: (RODATA) (0x1BFBE)
// CHECK-NEXT:   }
// CHECK-NEXT:   Relocation {
// CHECK-NEXT:     Location: 0x211028
// CHECK-NEXT:     Base: __init_array_start (0x210C00)
// CHECK-NEXT:     Offset: 0
// CHECK-NEXT:     Length: 8
// CHECK-NEXT:     Permissions: (RODATA) (0x1BFBE)
// CHECK-NEXT:   }
// CHECK-NEXT:   Relocation {
// CHECK-NEXT:     Location: 0x211038
// CHECK-NEXT:     Base: __init_array_end (0x210C08)
// CHECK-NEXT:     Offset: 0
// CHECK-NEXT:     Length: 0
// CHECK-NEXT:     Permissions: (RODATA) (0x1BFBE)
// CHECK-NEXT:   }
// CHECK-NEXT:   Relocation {
// CHECK-NEXT:     Location: 0x211048
// CHECK-NEXT:     Base: __fini_array_start (0x211000)
// CHECK-NEXT:     Offset: 0
// CHECK-NEXT:     Length: 8
// CHECK-NEXT:     Permissions: (RODATA) (0x1BFBE)
// CHECK-NEXT:   }
// CHECK-NEXT:   Relocation {
// CHECK-NEXT:     Location: 0x211058
// CHECK-NEXT:     Base: __fini_array_end (0x211008)
// CHECK-NEXT:     Offset: 0
// CHECK-NEXT:     Length: 0
// CHECK-NEXT:     Permissions: (RODATA) (0x1BFBE)
// CHECK-NEXT:   }
// CHECK-NEXT:   Relocation {
// CHECK-NEXT:     Location: 0x211068
// CHECK-NEXT:     Base: __start_mysection (0x210400)
// CHECK-NEXT:     Offset: 0
// CHECK-NEXT:     Length: 8
// CHECK-NEXT:     Permissions: (RODATA) (0x1BFBE)
// CHECK-NEXT:   }
// CHECK-NEXT:   Relocation {
// CHECK-NEXT:     Location: 0x211078
// CHECK-NEXT:     Base: __stop_mysection (0x210408)
// CHECK-NEXT:     Offset: 0
// CHECK-NEXT:     Length: 0
// CHECK-NEXT:     Permissions: (RODATA) (0x1BFBE)
