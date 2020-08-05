// RUN: not llvm-mc -triple aarch64-none-linux-gnu -show-encoding -mattr=+v8.1a,+c64 < %s 2>%t | FileCheck %s
// RUN: FileCheck --check-prefix=CHECK-ERROR %s <%t
// RUN: not llvm-mc -triple aarch64-none-linux-gnu -show-encoding -mattr=+v8.1a,+c64,+morello < %s 2>%t | FileCheck %s
// RUN: FileCheck --check-prefix=CHECK-ERROR %s <%t

//------------------------------------------------------------------------------
// Load acquire / store release
//------------------------------------------------------------------------------
        ldlarb w0,[c1]
        ldlarh w0,[c1]
        ldlar  w0,[c1]
        ldlar  x0,[c1]
// CHECK:   ldlarb w0, [c1]   // encoding: [0x20,0x7c,0xdf,0x08]
// CHECK:   ldlarh w0, [c1]   // encoding: [0x20,0x7c,0xdf,0x48]
// CHECK:   ldlar  w0, [c1]   // encoding: [0x20,0x7c,0xdf,0x88]
// CHECK:   ldlar  x0, [c1]   // encoding: [0x20,0x7c,0xdf,0xc8]
        stllrb w0,[c1]
        stllrh w0,[c1]
        stllr  w0,[c1]
        stllr  x0,[c1]
// CHECK:   stllrb w0, [c1]   // encoding: [0x20,0x7c,0x9f,0x08]
// CHECK:   stllrh w0, [c1]   // encoding: [0x20,0x7c,0x9f,0x48]
// CHECK:   stllr  w0, [c1]   // encoding: [0x20,0x7c,0x9f,0x88]
// CHECK:   stllr  x0, [c1]   // encoding: [0x20,0x7c,0x9f,0xc8]

        ldlarb w0,[w1]
        ldlarh x0,[x1]
        stllrb w0,[w1]
        stllrh x0,[x1]
        stllr  w0,[w1]
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         ldlarb w0,[w1]
// CHECK-ERROR:                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         ldlarh x0,[x1]
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         stllrb w0,[w1]
// CHECK-ERROR:                    ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         stllrh x0,[x1]
// CHECK-ERROR:                ^
// CHECK-ERROR: error: invalid operand for instruction
// CHECK-ERROR:         stllr  w0,[w1]
