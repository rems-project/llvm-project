# REQUIRES: aarch64
# RUN: llvm-mc -filetype=obj -triple=aarch64-unknown-freebsd -mattr=+morello,+c64 -target-abi purecap %p/Inputs/aarch64-tstbr14-reloc.s -o %t1
# RUN: llvm-mc -filetype=obj -triple=aarch64-unknown-freebsd -mattr=+morello,+c64 -target-abi purecap %s -o %t2
# RUN: ld.lld %t1 %t2 -o %t
# RUN: llvm-objdump --mattr=+morello -d --no-show-raw-insn --print-imm-hex %t | FileCheck %s
# RUN: ld.lld -shared %t1 %t2 -o %t3
# RUN: llvm-objdump --mattr=+morello -d --no-show-raw-insn --print-imm-hex %t3 | FileCheck --check-prefix=DSO %s
# RUN: llvm-readobj -S -r %t3 | FileCheck -check-prefix=DSOREL %s

# CHECK-LABEL: <_foo>:
# CHECK-NEXT:  210190: nop
# CHECK-NEXT:          nop
# CHECK-NEXT:          nop
# CHECK-NEXT:          nop
# CHECK-LABEL: <_bar>:
# CHECK-NEXT:  2101a0: nop
# CHECK-NEXT:          nop
# CHECK-NEXT:          nop
# CHECK:      <_start>:
# CHECK-NEXT:  2101ac: tbnz w3, #0xf, 0x210190 <_foo>
# CHECK-NEXT:          tbnz w3, #0xf, 0x2101a0 <_bar>
# CHECK-NEXT:          tbz x6, #0x2d, 0x210190 <_foo>
# CHECK-NEXT:          tbz x6, #0x2d, 0x2101a0 <_bar>

#DSOREL:      Section {
#DSOREL:        Index:
#DSOREL:        Name: .got.plt
#DSOREL-NEXT:   Type: SHT_PROGBITS
#DSOREL-NEXT:   Flags [
#DSOREL-NEXT:     SHF_ALLOC
#DSOREL-NEXT:     SHF_WRITE
#DSOREL-NEXT:   ]
#DSOREL-NEXT:   Address: 0x30490
#DSOREL-NEXT:   Offset:
#DSOREL-NEXT:   Size:
#DSOREL-NEXT:   Link: 0
#DSOREL-NEXT:   Info: 0
#DSOREL-NEXT:   AddressAlignment: 16
#DSOREL-NEXT:   EntrySize: 0
#DSOREL-NEXT:  }
#DSOREL:      Relocations [
#DSOREL-NEXT:  Section ({{.*}}) .rela.plt {
#DSOREL-NEXT:    0x304C0 R_MORELLO_JUMP_SLOT _foo 0x0
#DSOREL-NEXT:    0x304D0 R_MORELLO_JUMP_SLOT _bar 0x0
#DSOREL-NEXT:  }
#DSOREL-NEXT:]

#DSO:      Disassembly of section .text:
#DSO-EMPTY:
#DSO-LABEL: <_foo>:
#DSO-NEXT:  10368: nop
#DSO-NEXT:         nop
#DSO-NEXT:         nop
#DSO-NEXT:         nop
#DSO-LABEL: <_bar>:
#DSO-NEXT:  10378: nop
#DSO-NEXT:         nop
#DSO-NEXT:         nop
#DSO-LABEL: <_start>:
#DSO-NEXT:  10384: tbnz w3, #0xf, 0x103c0
#DSO-NEXT:         tbnz w3, #0xf, 0x103d0
#DSO-NEXT:         tbz x6, #0x2d, 0x103c0
#DSO-NEXT:         tbz x6, #0x2d, 0x103d0
#DSO-EMPTY:
#DSO-NEXT: Disassembly of section .plt:
#DSO-EMPTY:
#DSO-LABEL: <.plt>:
#DSO-NEXT:  103a0: stp  c16, c30, [csp, #-0x20]!
#DSO-NEXT:         adrp c16, 0x30000
#DSO-NEXT:         ldr  c17, [c16, #0x4b0]
#DSO-NEXT:         add  c16, c16, #0x4b0
#DSO-NEXT:         br   c17
#DSO-NEXT:         nop
#DSO-NEXT:         nop
#DSO-NEXT:         nop
#DSO-NEXT:  103c0: adrp c16, 0x30000
#DSO-NEXT:         add  c16, c16, #0x4c0
#DSO-NEXT:         ldr  c17, [c16, #0x0]
#DSO-NEXT:         br   c17
#DSO-NEXT:  103d0: adrp c16, 0x30000
#DSO-NEXT:         add  c16, c16, #0x4d0
#DSO-NEXT:         ldr  c17, [c16, #0x0]
#DSO-NEXT:         br   c17

.globl _start
_start:
 tbnz w3, #0xf, _foo
 tbnz w3, #0xf, _bar
 tbz x6, #0x2d, _foo
 tbz x6, #0x2d, _bar
