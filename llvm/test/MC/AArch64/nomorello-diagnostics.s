// RUN: not llvm-mc  -triple aarch64-none-linux-gnu -mattr=-morello < %s 2> %t
// RUN: FileCheck --check-prefix=CHECK-ERROR < %t %s

        mov c0, c1
// CHECK-ERROR: error: instruction requires: morello
// CHECK-ERROR-NEXT:    mov c0, c1
// CHECK-ERROR-NEXT:    ^
