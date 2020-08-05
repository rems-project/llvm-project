// REQUIRES: x86
// RUN: llvm-mc --triple=x86_64-none-elf %s -filetype=obj -o %t.o
// RUN: not ld.lld --morello-c64-plt %t.o -o /dev/null 2>&1 | FileCheck %s

/// Check that --morello-c64-plt is not supported on non-aarch64 targets
// CHECK: error: --morello-c64-plt only supported on AArch64
 .data
 .word 0
