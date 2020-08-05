# REQUIRES: aarch64
# RUN: llvm-mc -filetype=obj -triple=aarch64-none-elf %s -o %t.o

## Check that undefined start symbols are created for static output,
## and has hidden visibility.
# RUN: ld.lld --morello-c64-plt -static %t.o -o %t
# RUN: llvm-readobj --sections --symbols %t | FileCheck %s

# CHECK:      Symbols [
# CHECK:        Symbol {
# CHECK:          Name: _DYNAMIC
# CHECK-NEXT:     Value: 0x0
# CHECK-NEXT:     Size: 0
# CHECK-NEXT:     Binding: Local
# CHECK-NEXT:     Type: None
# CHECK-NEXT:     Other [ (0x2)
# CHECK-NEXT:       STV_HIDDEN
# CHECK-NEXT:     ]
# CHECK-NEXT:     Section: Undefined
# CHECK-NEXT:   }
# CHECK:        Symbol {
# CHECK:          Name: __start_section
# CHECK-NEXT:     Value: 0x0
# CHECK-NEXT:     Size: 0
# CHECK-NEXT:     Binding: Local
# CHECK-NEXT:     Type: None
# CHECK-NEXT:     Other [ (0x2)
# CHECK-NEXT:       STV_HIDDEN
# CHECK-NEXT:     ]
# CHECK-NEXT:     Section: Undefined
# CHECK-NEXT:   }

.weak	__start_section
.hidden	__start_section
.weak	_DYNAMIC
.hidden	_DYNAMIC

.text

.globl _start
_start:
  adrp	x8, :got:__start_section
  ldr	x8, [x8, :got_lo12:__start_section]
  adrp	x8, :got:_DYNAMIC
  ldr	x8, [x8, :got_lo12:_DYNAMIC]
