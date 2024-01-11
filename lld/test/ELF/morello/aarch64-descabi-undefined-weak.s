// REQUIRES: aarch64
// RUN: llvm-mc -filetype=obj -triple=aarch64-none-linux -mattr=+c64 -target-abi purecap -cheri-cap-table-abi=fn-desc %s -o %t.o
// RUN: ld.lld %t.o -o %t
// RUN: llvm-objdump -d --no-show-raw-insn --mattr=+morello %t | FileCheck %s

/// Check that the ARM 64-bit ABI rules for undefined weak symbols are applied.
/// Branch instructions are resolved to the next instruction.

 .weak target

 .text
 .global _start
_start:
 mov c28, c29
/// R_MORELLO_DESC_GLOBAL_JUMP26
 b target
/// R_MORELLO_DESC_GLOBAL_CALL26
 bl target

// CHECK: Disassembly of section .text:
// CHECK-EMPTY:
// CHECK:         210190:       mov     c28, c29
// CHECK:         210194:       b       0x210198 <_start+0x8>
// CHECK-NEXT:    210198:       bl      0x21019c <_start+0xc>
