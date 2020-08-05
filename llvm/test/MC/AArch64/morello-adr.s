// RUN: llvm-mc -triple aarch64-none-linux-gnu -show-encoding -mattr=+morello < %s | FileCheck %s

        adr x2, loc
        adr xzr, loc
// CHECK: adr    x2, loc                 // encoding: [0x02'A',A,A,0x10'A']
// CHECK:                                 //   fixup A - offset: 0, value: loc, kind: fixup_aarch64_pcrel_adr_imm21
// CHECK: adr    xzr, loc                // encoding: [0x1f'A',A,A,0x10'A']
// CHECK:                                 //   fixup A - offset: 0, value: loc, kind: fixup_aarch64_pcrel_adr_imm21

        adrp x29, loc
// CHECK: adrp    x29, loc                // encoding: [0x1d'A',A,A,0x90'A']
// CHECK:                                 //   fixup A - offset: 0, value: loc, kind: fixup_aarch64_pcrel_adrp_imm21

        adrp x30, #4096
        adr x20, #0
        adr x9, #-1
        adr x5, #1048575
// CHECK: adrp    x30, #4096              // encoding: [0x1e,0x00,0x00,0xb0]
// CHECK: adr     x20, #0                 // encoding: [0x14,0x00,0x00,0x10]
// CHECK: adr     x9, #-1                 // encoding: [0xe9,0xff,0xff,0x70]
// CHECK: adr     x5, #1048575            // encoding: [0xe5,0xff,0x7f,0x70]

        adr x9, #1048575
        adr x2, #-1048576
        adrp x9, #4294963200
        adrp x20, #-4294967296
// CHECK: adr     x9, #1048575            // encoding: [0xe9,0xff,0x7f,0x70]
// CHECK: adr     x2, #-1048576           // encoding: [0x02,0x00,0x80,0x10]
// CHECK: adrp    x9, #4294963200         // encoding: [0xe9,0xff,0x7f,0xf0]
// CHECK: adrp    x20, #-4294967296       // encoding: [0x14,0x00,0x80,0x90]
