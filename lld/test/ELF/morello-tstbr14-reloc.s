# REQUIRES: aarch64
# RUN: llvm-mc -filetype=obj -triple=aarch64-unknown-freebsd -mattr=+morello,+c64 -target-abi purecap %p/Inputs/aarch64-tstbr14-reloc.s -o %t1
# RUN: llvm-mc -filetype=obj -triple=aarch64-unknown-freebsd -mattr=+morello,+c64 -target-abi purecap %s -o %t2
# RUN: ld.lld %t1 %t2 -o %t
# RUN: llvm-objdump --mattr=+morello -d --no-show-raw-insn %t | FileCheck %s
# RUN: ld.lld -shared %t1 %t2 -o %t3
# RUN: llvm-objdump --mattr=+morello -d --no-show-raw-insn %t3 | FileCheck --check-prefix=DSO %s
# RUN: llvm-readobj -S -r %t3 | FileCheck -check-prefix=DSOREL %s

# CHECK:      <_foo>:
# CHECK-NEXT:  210120: nop
# CHECK-NEXT:  210124: nop
# CHECK-NEXT:  210128: nop
# CHECK-NEXT:  21012c: nop
# CHECK:      <_bar>:
# CHECK-NEXT:  210130: nop
# CHECK-NEXT:  210134: nop
# CHECK-NEXT:  210138: nop
# CHECK:      <_start>:
# CHECK-NEXT:  21013c: tbnz w3, #15, 0x210120 <_foo>
# CHECK-NEXT:  210140: tbnz w3, #15, 0x210130 <_bar>
# CHECK-NEXT:  210144: tbz x6, #45, 0x210120 <_foo>
# CHECK-NEXT:  210148: tbz x6, #45, 0x210130 <_bar>

#DSOREL:      Section {
#DSOREL:        Index:
#DSOREL:        Name: .got.plt
#DSOREL-NEXT:   Type: SHT_PROGBITS
#DSOREL-NEXT:   Flags [
#DSOREL-NEXT:     SHF_ALLOC
#DSOREL-NEXT:     SHF_WRITE
#DSOREL-NEXT:   ]
#DSOREL-NEXT:   Address: 0x30420
#DSOREL-NEXT:   Offset: 0x420
#DSOREL-NEXT:   Size: 96
#DSOREL-NEXT:   Link: 0
#DSOREL-NEXT:   Info: 0
#DSOREL-NEXT:   AddressAlignment: 16
#DSOREL-NEXT:   EntrySize: 0
#DSOREL-NEXT:  }
#DSOREL:      Relocations [
#DSOREL-NEXT:  Section ({{.*}}) .rela.plt {
#DSOREL-NEXT:    0x30450 R_MORELLO_JUMP_SLOT _foo 0x0
#DSOREL-NEXT:    0x30460 R_MORELLO_JUMP_SLOT _bar 0x0
#DSOREL-NEXT:  }
#DSOREL-NEXT:]

#DSO:      Disassembly of section .text:
#DSO-EMPTY:
#DSO-NEXT: <_foo>:
#DSO-NEXT:  102f8: nop
#DSO-NEXT:  102fc: nop
#DSO-NEXT:  10300: nop
#DSO-NEXT:  10304: nop
#DSO:      <_bar>:
#DSO-NEXT:  10308: nop
#DSO-NEXT:  1030c: nop
#DSO-NEXT:  10310: nop
#DSO:      <_start>:
#DSO-NEXT:  10314: tbnz w3, #15, 0x10350
#DSO-NEXT:  10318: tbnz w3, #15, 0x10360
#DSO-NEXT:  1031c: tbz x6, #45, 0x10350
#DSO-NEXT:  10320: tbz x6, #45, 0x10360
#DSO-EMPTY:
#DSO-NEXT: Disassembly of section .plt:
#DSO-EMPTY:
#DSO-NEXT: <.plt>:
#DSO-NEXT:  10330: stp c16, c30, [csp, #-32]!
#DSO-NEXT:  10334: adrp c16, 0x30000 <.plt+0x84>
#DSO-NEXT:  10338: ldr c17, [c16, #1088]
#DSO-NEXT:  1033c: add c16, c16, #1088
#DSO-NEXT:  10340: br c17
#DSO-NEXT:  10344: nop
#DSO-NEXT:  10348: nop
#DSO-NEXT:  1034c: nop
#DSO-NEXT:  10350: adrp c16, 0x30000 <.plt+0xa0>
#DSO-NEXT:  10354: add c16, c16, #1104
#DSO-NEXT:  10358: ldr c17, [c16, #0]
#DSO-NEXT:  1035c: br c17
#DSO-NEXT:  10360: adrp c16, 0x30000 <.plt+0xb0>
#DSO-NEXT:  10364: add c16, c16, #1120
#DSO-NEXT:  10368: ldr c17, [c16, #0]
#DSO-NEXT:  1036c: br c17

.globl _start
_start:
 tbnz w3, #15, _foo
 tbnz w3, #15, _bar
 tbz x6, #45, _foo
 tbz x6, #45, _bar
