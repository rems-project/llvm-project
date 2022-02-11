// RUN: llvm-mc -triple=aarch64-none-elf -mattr=+morello %s -filetype=obj -morello-integer-branches -o %t.o
// RUN: llvm-readelf -r --syms %t.o | FileCheck %s

.arch armv8-a+c64
.globl bar
.type bar, @function

.globl bat
.type bat, @function

bar:
  b foo
  b baz
  b.ls sym
  tbz x6, #45, sym
  b.ls bat
  tbz x6, #45, bat

bat:
  bl buf
  bl baz


// CHECK: Relocation section '.rela.text' at offset 0x120 contains 8 entries:
// CHECK-NEXT:    Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
// CHECK-NEXT: 0000000000000000  000000040000011a R_AARCH64_JUMP26       0000000000000000 foo + 0
// CHECK-NEXT: 0000000000000004  000000050000011a R_AARCH64_JUMP26       0000000000000000 baz + 0
// CHECK-NEXT: 0000000000000008  0000000600000118 R_AARCH64_CONDBR19     0000000000000000 sym + 0
// CHECK-NEXT: 000000000000000c  0000000600000117 R_AARCH64_TSTBR14      0000000000000000 sym + 0
// CHECK-NEXT: 0000000000000010  0000000300000118 R_AARCH64_CONDBR19     0000000000000018 bat + 0
// CHECK-NEXT: 0000000000000014  0000000300000117 R_AARCH64_TSTBR14      0000000000000018 bat + 0
// CHECK-NEXT: 0000000000000018  000000070000011b R_AARCH64_CALL26       0000000000000000 buf + 0
// CHECK-NEXT: 000000000000001c  000000050000011b R_AARCH64_CALL26       0000000000000000 baz + 0

// CHECK: Symbol table '.symtab' contains 8 entries:
// CHECK-NEXT:   Num:    Value          Size Type    Bind   Vis       Ndx Name
// CHECK-NEXT:     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   UND
// CHECK-NEXT:     1: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT     2 $c.0
// CHECK-NEXT:     2: 0000000000000000     0 FUNC    GLOBAL DEFAULT     2 bar
// CHECK-NEXT:     3: 0000000000000018     0 FUNC    GLOBAL DEFAULT     2 bat
// CHECK-NEXT:     4: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   UND foo
// CHECK-NEXT:     5: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   UND baz
// CHECK-NEXT:     6: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   UND sym
// CHECK-NEXT:     7: 0000000000000000     0 NOTYPE  GLOBAL DEFAULT   UND buf
