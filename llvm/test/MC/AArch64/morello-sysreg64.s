// RUN: llvm-mc -triple=arm64 -mattr=+morello -show-encoding < %s | FileCheck %s
// RUN: llvm-mc -triple=arm64 -mattr=+morello,+c64 -show-encoding < %s | FileCheck %s

        mrs     x0, CCTLR_EL0
        mrs     x0, CCTLR_EL1
        mrs     x0, CCTLR_EL12
        mrs     x0, CCTLR_EL2
        mrs     x0, CCTLR_EL3
        mrs     x0, CHCR_EL2
        mrs     x0, CSCR_EL3
        mrs     x0, RSP_EL0
        mrs     x0, RTPIDR_EL0
// CHECK:       mrs     x0, CCTLR_EL0           // encoding: [0x40,0x12,0x3b,0xd5]
// CHECK:       mrs     x0, CCTLR_EL1           // encoding: [0x40,0x12,0x38,0xd5]
// CHECK:       mrs     x0, CCTLR_EL12          // encoding: [0x40,0x12,0x3d,0xd5]
// CHECK:       mrs     x0, CCTLR_EL2           // encoding: [0x40,0x12,0x3c,0xd5]
// CHECK:       mrs     x0, CCTLR_EL3           // encoding: [0x40,0x12,0x3e,0xd5]
// CHECK:       mrs     x0, CHCR_EL2            // encoding: [0x60,0x12,0x3c,0xd5]
// CHECK:       mrs     x0, CSCR_EL3            // encoding: [0x60,0x12,0x3e,0xd5]
// CHECK:       mrs     x0, RSP_EL0             // encoding: [0x60,0x41,0x3f,0xd5]
// CHECK:       mrs     x0, RTPIDR_EL0          // encoding: [0x80,0xd0,0x3b,0xd5]

        msr     CCTLR_EL0, x8
        msr     CCTLR_EL1, x8
        msr     CCTLR_EL12, x8
        msr     CCTLR_EL2, x8
        msr     CCTLR_EL3, x8
        msr     CHCR_EL2, x8
        msr     CSCR_EL3, x8
        msr     RSP_EL0, x8
        msr     RTPIDR_EL0, x8
// CHECK:       msr     CCTLR_EL0, x8           // encoding: [0x48,0x12,0x1b,0xd5]
// CHECK:       msr     CCTLR_EL1, x8           // encoding: [0x48,0x12,0x18,0xd5]
// CHECK:       msr     CCTLR_EL12, x8          // encoding: [0x48,0x12,0x1d,0xd5]
// CHECK:       msr     CCTLR_EL2, x8           // encoding: [0x48,0x12,0x1c,0xd5]
// CHECK:       msr     CCTLR_EL3, x8           // encoding: [0x48,0x12,0x1e,0xd5]
// CHECK:       msr     CHCR_EL2, x8            // encoding: [0x68,0x12,0x1c,0xd5]
// CHECK:       msr     CSCR_EL3, x8            // encoding: [0x68,0x12,0x1e,0xd5]
// CHECK:       msr     RSP_EL0, x8             // encoding: [0x68,0x41,0x1f,0xd5]
// CHECK:       msr     RTPIDR_EL0, x8          // encoding: [0x88,0xd0,0x1b,0xd5]
