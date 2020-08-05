// RUN: llvm-mc -triple aarch64-none-linux-gnu -show-encoding -mattr=+morello,+c64 < %s | FileCheck %s

        adrp c29, loc
// CHECK: adrp    c29, loc                // encoding: [0x1d'A',A,0x80'A',0x90'A']
// CHECK:                                 //   fixup A - offset: 0, value: loc, kind: fixup_aarch64_pcrel_adrp_imm20

        adrp c29, :got:loc
// CHECK: adrp    c29, :got:loc           // encoding: [0x1d'A',A,0x80'A',0x90'A']
// CHECK:                                 //   fixup A - offset: 0, value: :got:loc, kind: fixup_aarch64_pcrel_adrp_imm20

        adrp c29, :pg_hi21_nc:loc
// CHECK: adrp    c29, :pg_hi21_nc:loc    // encoding: [0x1d'A',A,0x80'A',0x90'A']
// CHECK:                                 //   fixup A - offset: 0, value: :pg_hi21_nc:loc, kind: fixup_aarch64_pcrel_adrp_imm20

        adrp c30, #-4096
        adrp c2, #0
// CHECK: adrp    c30, #-4096             // encoding: [0xfe,0xff,0xff,0xf0]
// CHECK: adrp    c2, #0                  // encoding: [0x02,0x00,0x80,0x90]

        adrp c5, #2147479552
        adrp c24, #-2147483648
// CHECK: adrp    c5, #2147479552         // encoding: [0xe5,0xff,0xbf,0xf0]
// CHECK: adrp    c24, #-2147483648       // encoding: [0x18,0x00,0xc0,0x90]

        adrp c24, #102400
        adrp c24, #106496
// CHECK: adrp    c24, #102400            // encoding: [0xd8,0x00,0x80,0xb0]
// CHECK: adrp    c24, #106496            // encoding: [0xd8,0x00,0x80,0xd0]

        adrdp c30, #4294963200
        adrdp c2, #0
// CHECK: adrdp    c30, #4294963200        // encoding: [0xfe,0xff,0x7f,0xf0]
// CHECK: adrdp    c2, #0                  // encoding: [0x02,0x00,0x00,0x90]

        adrdp c5, #2147479552
// CHECK: adrdp    c5, #2147479552         // encoding: [0xe5,0xff,0x3f,0xf0]

        adrdp c24, #102400
        adrdp c24, #106496
// CHECK: adrdp    c24, #102400            // encoding: [0xd8,0x00,0x00,0xb0]
// CHECK: adrdp    c24, #106496            // encoding: [0xd8,0x00,0x00,0xd0]

       adr c5, #12
// CHECK: adr      c5, #12                 // encoding: [0x65,0x00,0x00,0x10]
