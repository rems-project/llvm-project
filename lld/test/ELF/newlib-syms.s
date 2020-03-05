# REQUIRES: x86
# RUN: llvm-mc -filetype=obj -triple=x86_64-pc-linux %s -o %t.o
# RUN: ld.lld %t.o -o %t
# RUN: llvm-objdump -t -section-headers %t | FileCheck %s

## Check the linker defined symbols added for newlib.
## __bss_start__ is the start of the .bss section
## __bss_end__ is the end of the .bss section
## __end__ is the same as __end, the highest allocatable address

# CHECK: Sections:
# CHECK-NEXT: Idx Name          Size     VMA          Type
# CHECK-NEXT:   0               00000000 0000000000000000
# CHECK-NEXT:   1 .text         00000001 0000000000201158 TEXT
# CHECK-NEXT:   2 .data         00000002 0000000000202159 DATA
# CHECK-NEXT:   3 .bss          00000006 000000000020215c BSS
# CHECK: SYMBOL TABLE:
# CHECK-NEXT: 0000000000202162 g       .bss     0000000000000000 __bss_end__
# CHECK-NEXT: 000000000020215c g       .bss     0000000000000000 __bss_start__
# CHECK-NEXT: 0000000000202162 g       .bss     0000000000000000 __end__
# CHECK-NEXT: 0000000000201158 g       .text    0000000000000000 _start

# RUN: ld.lld -r %t.o -o %t2
# RUN: llvm-objdump -t %t2 | FileCheck --check-prefix=RELOCATABLE %s
# RELOCATABLE:      0000000000000000         *UND*      0000000000000000 __bss_end__
# RELOCATABLE-NEXT: 0000000000000000         *UND*      0000000000000000 __bss_start__
# RELOCATABLE-NEXT: 0000000000000000         *UND*      0000000000000000 __end__

.global __bss_start__,__bss_end__,__end__,_start
.text
_start:
 nop
.data
 .word 1
.bss
 .align 4
 .space 6
