// RUN: llvm-mc --triple=aarch64-none-elf -mattr=+c64,+morello -filetype=obj %S/Inputs/shared-datalib.s -o %t.o
// RUN: ld.lld --shared --soname=t.so %t.o -o %t.so
// RUN: llvm-mc --triple=aarch64-none-elf -mattr=+c64,+morello -filetype=obj %s -o %t.o

// RUN: ld.lld %t.so %t.o -o %t
// RUN: llvm-objdump --print-imm-hex --no-show-raw-insn -s -d --triple=aarch64-none-elf --mattr=+morello %t | FileCheck %s
// RUN: llvm-readobj --dynamic --relocations %t | FileCheck %s --check-prefix=RELS

// RUN: ld.lld --pie %t.so %t.o -o %tpie
// RUN: llvm-objdump --print-imm-hex --no-show-raw-insn -s -d --triple=aarch64-none-elf --mattr=+morello %tpie | FileCheck %s --check-prefix=CHECK-PIE
// RUN: llvm-readobj --dynamic --relocations %tpie | FileCheck %s --check-prefix=RELS-PIE

/// Application using a shared data only library. Expect to see dynamic
/// relocations and not a __cap_relocs section. The link is repeated for -fpie

 .text
 .global _start
 .type _start, %function
 .size _start, 8
_start:
 ret

 .global from_app
 .type from_app, %function
 .size from_app, 4
from_app:
 ret

 .data.rel.ro
 .capinit rodata
 .xword 0
 .xword 0
 .capinit data
 .xword 0
 .xword 0
 .capinit appdata
 .xword 0
 .xword 0
 .capinit from_app
 .xword 0
 .xword 0

// CHECK: Contents of section .data.rel.ro:
/// rodata (shlib.so) rw (default) size 8
// CHECK-NEXT:  220330 00000000 00000000 08000000 00000002
/// data (shlib.so) rw (default) size 8
// CHECK-NEXT:  220340 00000000 00000000 08000000 00000002
/// appdata 0x230440 rw size 8
// CHECK-NEXT:  220350 40042300 00000000 08000000 00000002
/// from_app 21032c exec size 4
// CHECK-NEXT:  220360 2d032100 00000000 04000000 00000004

// CHECK-PIE: Contents of section .data.rel.ro:
/// rodata (shlib.so) rw (default) size 8
// CHECK-PIE-NEXT:  20330 00000000 00000000 08000000 00000002
/// data (shlib.so) rw (default) size 8
// CHECK-PIE-NEXT:  20340 00000000 00000000 08000000 00000002
/// appdata 0x30450 rw size 8
// CHECK-PIE-NEXT:  20350 50040300 00000000 08000000 00000002
/// from_app 1032c exec size 4
// CHECK-PIE-NEXT:  20360 2d030100 00000000 04000000 00000004

 .data
 .global appdata
 .type appdata, %object
 .size appdata, 8
appdata: .xword 8

// CHECK: Contents of section .data:
// CHECK-NEXT:  230440 08000000 00000000

// CHECK-PIE: Contents of section .data:
// CHECK-PIE-NEXT:  30450 08000000 00000000

// CHECK: 0000000000210328 <_start>:
// CHECK-NEXT:   210328:        ret

// CHECK: 000000000021032c <from_app>:
// CHECK-NEXT:   21032c:        ret

// CHECK-PIE: 0000000000010328 <_start>:
// CHECK-PIE-NEXT:    10328:            ret

// CHECK-PIE: 000000000001032c <from_app>:
// CHECK-PIE-NEXT:    1032c:            ret

/// Check that the dynamic table holds the correct number of RELATIVE relocs
// RELS: DynamicSection [
// RELS: 0x000000006FFFFFF9 RELACOUNT 2

// RELS: Relocations [
// RELS-NEXT:   Section (5) .rela.dyn {
/// .capinit appdata
// RELS-NEXT:     0x220350 R_MORELLO_RELATIVE - 0x0
/// .capinit data
// RELS-NEXT:     0x220340 R_MORELLO_CAPINIT data 0x0
/// .capinit rodata
// RELS-NEXT:     0x220330 R_MORELLO_CAPINIT rodata 0x0
/// .capinit from_app (strictly speaking don't need symbol here)
// RELS-NEXT:     0x220360 R_MORELLO_RELATIVE from_app 0x0
// RELS-NEXT:   }

/// Check that the dynamic table holds the correct number of RELATIVE relocs
// RELS-PIE: DynamicSection [
// RELS-PIE: 0x000000006FFFFFF9 RELACOUNT 2

// RELS-PIE: Relocations [
// RELS-PIE-NEXT:   Section (5) .rela.dyn {
/// .capinit appdata
// RELS-PIE-NEXT:     0x20350 R_MORELLO_RELATIVE - 0x0
/// .capinit data
// RELS-PIE-NEXT:     0x20340 R_MORELLO_CAPINIT data 0x0
/// .capinit rodata
// RELS-PIE-NEXT:     0x20330 R_MORELLO_CAPINIT rodata 0x0
/// .capinit from_app (strictly speaking don't need symbol here)
// RELS-PIE-NEXT:     0x20360 R_MORELLO_RELATIVE from_app 0x0
// RELS-PIE-NEXT:   }
