// RUN: llvm-mc -triple aarch64-none-linux-gnu -show-encoding -mattr=+c64,+rcpc < %s 2>&1 | FileCheck %s

  ldaprb w0, [c0, #0]
  ldaprh w0, [c7, #0]
  ldapr w0, [c1, #0]
  ldapr x0, [c0, #0]
  ldapr w18, [c0]
  ldapr x15, [c0]

// CHECK: ldaprb w0, [c0]    // encoding: [0x00,0xc0,0xbf,0x38]
// CHECK: ldaprh w0, [c7]    // encoding: [0xe0,0xc0,0xbf,0x78]
// CHECK: ldapr w0, [c1]     // encoding: [0x20,0xc0,0xbf,0xb8]
// CHECK: ldapr x0, [c0]     // encoding: [0x00,0xc0,0xbf,0xf8]
// CHECK: ldapr w18, [c0]    // encoding: [0x12,0xc0,0xbf,0xb8]
// CHECK: ldapr x15, [c0]    // encoding: [0x0f,0xc0,0xbf,0xf8]
