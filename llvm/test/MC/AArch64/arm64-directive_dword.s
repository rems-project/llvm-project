// RUN: llvm-mc -filetype=obj -triple aarch64_be %s | llvm-readobj -section-data -sections | FileCheck --check-prefix=CHECK-BE %s
// RUN: llvm-mc -filetype=obj -triple aarch64 %s | llvm-readobj -section-data -sections | FileCheck --check-prefix=CHECK-LE %s

// CHECK-BE: 0000: 00123456 789ABCDE
// CHECK-LE: 0000: DEBC9A78 56341200
foo:    .dword 0x123456789abcde
