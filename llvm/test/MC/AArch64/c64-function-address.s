# RUN: llvm-mc -triple=aarch64-none-elf -filetype=obj %s -o %t
# RUN: llvm-readelf -s %t | FileCheck %s

.arch morello
.text
.code c64
func_label:
.type func_label, %function

.type foo_impl, %function
foo_impl:
  adr c0, #0
.type foo_resolver, %function
foo_resolver:
  b foo_impl
.type foo, %gnu_indirect_function
.set foo, foo_resolver

.code c64
label:
  adr c0, #0
.code a64
  adr x0, #0
.type label, %function

# CHECK:   Num:    Value          Size Type    Bind   Vis       Ndx Name
# CHECK-NEXT: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT   UND
# CHECK-NEXT: 0000000000000001     0 FUNC    LOCAL  DEFAULT     2 func_label
# CHECK-NEXT: 0000000000000001     0 FUNC    LOCAL  DEFAULT     2 foo_impl
# CHECK-NEXT: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT     2 $c.0
# CHECK-NEXT: 0000000000000005     0 FUNC    LOCAL  DEFAULT     2 foo_resolver
# CHECK-NEXT: 0000000000000005     0 IFUNC   LOCAL  DEFAULT     2 foo
# CHECK-NEXT: 0000000000000008     0 FUNC    LOCAL  DEFAULT     2 label
# CHECK-NEXT: 000000000000000c     0 NOTYPE  LOCAL  DEFAULT     2 $x.1
