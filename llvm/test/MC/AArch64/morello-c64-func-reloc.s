// RUN: llvm-mc -triple=aarch64-none-elf -mattr=+morello %s -filetype=obj -o - | llvm-objdump --mattr=+morello -d - -r | FileCheck %s

.arch armv8a+c64

// Verify that we force relocation on C64 symbols.

.text
.align 4
.globl foo
.type foo, @function
foo:
  nop

.align 4
.globl bar
.type bar, @function
bar:
// CHECK: R_AARCH64_MOVW_UABS_G0_NC foo
// CHECK: R_AARCH64_MOVW_UABS_G0 foo
  movk x0, #:abs_g0_nc:foo
  movz x0, #:abs_g0:foo
