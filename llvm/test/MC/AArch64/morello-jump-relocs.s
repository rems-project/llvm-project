// RUN: llvm-mc -triple=aarch64-none-elf -mattr=+morello %s -filetype=obj -o - | llvm-objdump --mattr=+morello -d - -r | FileCheck %s

.arch armv8-a+a64c
.text
.align 4
.globl foo
.type foo, @function
foo:
// CHECK: b #0
// CHECK-NEXT: R_AARCH64_JUMP26 bar
  b bar

.arch armv8-a+c64
.globl bar
.type bar, @function
bar:
// CHECK: b #0
// CHECK-NEXT: R_MORELLO_JUMP26 foo
  b foo
// CHECK: b #0
// CHECK-NEXT: R_MORELLO_JUMP26 baz
  b baz

.arch armv8-a+a64c
.text
.globl baz
.type baz, @function
baz:
// CHECK: bl #0
// CHECK-NEXT: R_AARCH64_CALL26 bar
  bl bar
// CHECK: bl #0
// CHECK-NEXT: R_AARCH64_CALL26 bat
  bl bat

.arch armv8-a+c64
.globl bat
.type bat, @function
bat:
// CHECK: bl #0
// CHECK-NEXT: R_MORELLO_CALL26 buf
  bl buf
// CHECK: bl #0
// CHECK-NEXT: R_MORELLO_CALL26 baz
  bl baz

.arch armv8-a+a64c
.globl buf
.type buf, @function
buf:
// CHECK: b #0
// CHECK-NEXT: R_AARCH64_JUMP26 bat
  b bat
  ret
