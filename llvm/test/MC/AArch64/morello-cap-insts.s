// RUN: llvm-mc -triple=arm64 -mattr=+morello,+v8.2a -show-encoding < %s | FileCheck %s
// RUN: llvm-mc -triple=arm64 -mattr=+morello,+use-16-cap-regs,+v8.2a -show-encoding < %s | FileCheck %s

  cbz x0, #0
  cbnz x0, #0
// CHECK: cbz x0, #0                    // encoding: [0x00,0x00,0x00,0xb4]
// CHECK: cbnz x0, #0                   // encoding: [0x00,0x00,0x00,0xb5]

  cbz x17, #0
  cbnz x17, #0
// CHECK: cbz x17, #0                   // encoding: [0x11,0x00,0x00,0xb4]
// CHECK: cbnz x17, #0                  // encoding: [0x11,0x00,0x00,0xb5]

  adr x0, #0
// CHECK: adr x0, #0                    // encoding: [0x00,0x00,0x00,0x10]

  adr x17, #0
// CHECK: adr x17, #0                   // encoding: [0x11,0x00,0x00,0x10]

  dc zva, x17
  dc ivac, x17
  dc cvau, x17
  dc civac, x17
  dc cvap, x17
  ic ivau, x17
// CHECK:  dc zva, x17                  // encoding: [0x31,0x74,0x0b,0xd5]
// CHECK:  dc ivac, x17                 // encoding: [0x31,0x76,0x08,0xd5]
// CHECK:  dc cvau, x17                 // encoding: [0x31,0x7b,0x0b,0xd5]
// CHECK:  dc civac, x17                // encoding: [0x31,0x7e,0x0b,0xd5]
// CHECK:  dc cvap, x17                 // encoding: [0x31,0x7c,0x0b,0xd5]
// CHECK:  ic ivau, x17                 // encoding: [0x31,0x75,0x0b,0xd5]
