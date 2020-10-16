// REQUIRES: aarch64
// RUN: llvm-mc -filetype=obj -triple=aarch64-none-elf -mattr=+c64,+morello %s -o %t.o
// RUN: ld.lld --morello-c64-plt -static %t.o -o %tout
// RUN: llvm-objdump -s -d --print-imm-hex --no-show-raw-insn -triple=aarch64-none-elf -mattr=+morello %tout | FileCheck %s
// RUN: llvm-readobj -r --symbols %tout | FileCheck %s --check-prefix=RELANDSYM
.text
.type foo STT_GNU_IFUNC
.globl foo
.size foo, 4
foo:
 ret

.type bar STT_GNU_IFUNC
.globl bar
.size bar, 4
bar:
 ret

.globl _start
_start:
 bl foo
 bl bar
 add x2, x2, :lo12:__rela_iplt_start
 add x2, x2, :lo12:__rela_iplt_end

// Contents of section .got.plt:
// CHECK:      220270 31022100 00000000 04000000 00000004
// CHECK-NEXT: 220280 35022100 00000000 04000000 00000004

// CHECK: 0000000000210231 foo:
// CHECK-NEXT:   210231:        <unknown>

// CHECK: 0000000000210235 bar:
// CHECK-NEXT:   210235:        <unknown>

// CHECK: 0000000000210238 _start:
// CHECK-NEXT:   210238:        bl      #0x18
// CHECK-NEXT:   21023c:        bl      #0x24
// CHECK-NEXT:   210240:        add     x2, x2, #0x200
// CHECK-NEXT:   210244:        add     x2, x2, #0x230

// CHECK: 0000000000210250 .iplt:
// CHECK-NEXT:   210250:        adrp    c16, #0x10000
// CHECK-NEXT:   210254:        add     c16, c16, #0x270
// CHECK-NEXT:   210258:        ldr     c17, [c16, #0x0]
// CHECK-NEXT:   21025c:        br      c17
// CHECK-NEXT:   210260:        adrp    c16, #0x10000
// CHECK-NEXT:   210264:        add     c16, c16, #0x280
// CHECK-NEXT:   210268:        ldr     c17, [c16, #0x0]
// CHECK-NEXT:   21026c:        br      c17

// RELANDSYM: Relocations [
// RELANDSYM-NEXT:   Section (1) .rela.dyn {
// RELANDSYM-NEXT:     0x220270 R_MORELLO_IRELATIVE - 0x210231
// RELANDSYM-NEXT:     0x220280 R_MORELLO_IRELATIVE - 0x210235

// RELANDSYM:          Name: __rela_iplt_end
// RELANDSYM-NEXT:     Value: 0x200230
// RELANDSYM-NEXT:     Size: 0
// RELANDSYM-NEXT:     Binding: Local (0x0)
// RELANDSYM-NEXT:     Type: None (0x0)
// RELANDSYM-NEXT:     Other [ (0x2)
// RELANDSYM-NEXT:       STV_HIDDEN (0x2)
// RELANDSYM-NEXT:     ]
// RELANDSYM-NEXT:     Section: .rela.dyn (0x1)
// RELANDSYM-NEXT:   }
// RELANDSYM-NEXT:   Symbol {
// RELANDSYM-NEXT:     Name: __rela_iplt_start
// RELANDSYM-NEXT:     Value: 0x200200
// RELANDSYM-NEXT:     Size: 0
// RELANDSYM-NEXT:     Binding: Local (0x0)
// RELANDSYM-NEXT:     Type: None (0x0)
// RELANDSYM-NEXT:     Other [ (0x2)
// RELANDSYM-NEXT:       STV_HIDDEN (0x2)
// RELANDSYM-NEXT:     ]
// RELANDSYM-NEXT:     Section: .rela.dyn (0x1)
