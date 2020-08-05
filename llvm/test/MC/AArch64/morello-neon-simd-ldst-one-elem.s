// RUN: llvm-mc -triple=arm64 -mattr=+c64,+neon -show-encoding < %s | FileCheck %s
// RUN: llvm-mc -triple=arm64 -mattr=+c64,+morello,+neon -show-encoding < %s | FileCheck %s

// Check that the assembler can handle the documented syntax for AArch64

//------------------------------------------------------------------------------
// Load single 1-element structure to all lanes of 1 register
//------------------------------------------------------------------------------
         ld1r { v0.16b }, [c0]
         ld1r { v15.8h }, [c25]
         ld1r { v31.4s }, [csp]
         ld1r { v0.2d }, [c0]
         ld1r { v0.8b }, [c0]
         ld1r { v15.4h }, [c25]
         ld1r { v31.2s }, [csp]
         ld1r { v0.1d }, [c0]
// CHECK: ld1r { v0.16b }, [c0]          // encoding: [0x00,0xc0,0x40,0x4d]
// CHECK: ld1r { v15.8h }, [c25]         // encoding: [0x2f,0xc7,0x40,0x4d]
// CHECK: ld1r { v31.4s }, [csp]          // encoding: [0xff,0xcb,0x40,0x4d]
// CHECK: ld1r { v0.2d }, [c0]           // encoding: [0x00,0xcc,0x40,0x4d]
// CHECK: ld1r { v0.8b }, [c0]           // encoding: [0x00,0xc0,0x40,0x0d]
// CHECK: ld1r { v15.4h }, [c25]         // encoding: [0x2f,0xc7,0x40,0x0d]
// CHECK: ld1r { v31.2s }, [csp]          // encoding: [0xff,0xcb,0x40,0x0d]
// CHECK: ld1r { v0.1d }, [c0]           // encoding: [0x00,0xcc,0x40,0x0d]

//------------------------------------------------------------------------------
// Load single N-element structure to all lanes of N consecutive
// registers (N = 2,3,4)
//------------------------------------------------------------------------------
         ld2r { v0.16b, v1.16b }, [c0]
         ld2r { v15.8h, v16.8h }, [c25]
         ld2r { v31.4s, v0.4s }, [csp]
         ld2r { v0.2d, v1.2d }, [c0]
         ld2r { v0.8b, v1.8b }, [c0]
         ld2r { v15.4h, v16.4h }, [c25]
         ld2r { v31.2s, v0.2s }, [csp]
         ld2r { v31.1d, v0.1d }, [csp]
// CHECK: ld2r { v0.16b, v1.16b }, [c0]  // encoding: [0x00,0xc0,0x60,0x4d]
// CHECK: ld2r { v15.8h, v16.8h }, [c25] // encoding: [0x2f,0xc7,0x60,0x4d]
// CHECK: ld2r { v31.4s, v0.4s }, [csp]   // encoding: [0xff,0xcb,0x60,0x4d]
// CHECK: ld2r { v0.2d, v1.2d }, [c0]    // encoding: [0x00,0xcc,0x60,0x4d]
// CHECK: ld2r { v0.8b, v1.8b }, [c0]    // encoding: [0x00,0xc0,0x60,0x0d]
// CHECK: ld2r { v15.4h, v16.4h }, [c25] // encoding: [0x2f,0xc7,0x60,0x0d]
// CHECK: ld2r { v31.2s, v0.2s }, [csp]   // encoding: [0xff,0xcb,0x60,0x0d]
// CHECK: ld2r { v31.1d, v0.1d }, [csp]   // encoding: [0xff,0xcf,0x60,0x0d]

         ld3r { v0.16b, v1.16b, v2.16b }, [c0]
         ld3r { v15.8h, v16.8h, v17.8h }, [c25]
         ld3r { v31.4s, v0.4s, v1.4s }, [csp]
         ld3r { v0.2d, v1.2d, v2.2d }, [c0]
         ld3r { v0.8b, v1.8b, v2.8b }, [c0]
         ld3r { v15.4h, v16.4h, v17.4h }, [c25]
         ld3r { v31.2s, v0.2s, v1.2s }, [csp]
         ld3r { v31.1d, v0.1d, v1.1d }, [csp]
// CHECK: ld3r { v0.16b, v1.16b, v2.16b }, [c0] // encoding: [0x00,0xe0,0x40,0x4d]
// CHECK: ld3r { v15.8h, v16.8h, v17.8h }, [c25] // encoding: [0x2f,0xe7,0x40,0x4d]
// CHECK: ld3r { v31.4s, v0.4s, v1.4s }, [csp] // encoding: [0xff,0xeb,0x40,0x4d]
// CHECK: ld3r { v0.2d, v1.2d, v2.2d }, [c0] // encoding: [0x00,0xec,0x40,0x4d]
// CHECK: ld3r { v0.8b, v1.8b, v2.8b }, [c0] // encoding: [0x00,0xe0,0x40,0x0d]
// CHECK: ld3r { v15.4h, v16.4h, v17.4h }, [c25] // encoding: [0x2f,0xe7,0x40,0x0d]
// CHECK: ld3r { v31.2s, v0.2s, v1.2s }, [csp] // encoding: [0xff,0xeb,0x40,0x0d]
// CHECK: ld3r { v31.1d, v0.1d, v1.1d }, [csp] // encoding: [0xff,0xef,0x40,0x0d]

         ld4r { v0.16b, v1.16b, v2.16b, v3.16b }, [c0]
         ld4r { v15.8h, v16.8h, v17.8h, v18.8h }, [c25]
         ld4r { v31.4s, v0.4s, v1.4s, v2.4s }, [csp]
         ld4r { v0.2d, v1.2d, v2.2d, v3.2d }, [c0]
         ld4r { v0.8b, v1.8b, v2.8b, v3.8b }, [c0]
         ld4r { v15.4h, v16.4h, v17.4h, v18.4h }, [c25]
         ld4r { v31.2s, v0.2s, v1.2s, v2.2s }, [csp]
         ld4r { v31.1d, v0.1d, v1.1d, v2.1d }, [csp]
// CHECK: ld4r { v0.16b, v1.16b, v2.16b, v3.16b }, [c0] // encoding: [0x00,0xe0,0x60,0x4d]
// CHECK: ld4r { v15.8h, v16.8h, v17.8h, v18.8h }, [c25] // encoding: [0x2f,0xe7,0x60,0x4d]
// CHECK: ld4r { v31.4s, v0.4s, v1.4s, v2.4s }, [csp] // encoding: [0xff,0xeb,0x60,0x4d]
// CHECK: ld4r { v0.2d, v1.2d, v2.2d, v3.2d }, [c0] // encoding: [0x00,0xec,0x60,0x4d]
// CHECK: ld4r { v0.8b, v1.8b, v2.8b, v3.8b }, [c0] // encoding: [0x00,0xe0,0x60,0x0d]
// CHECK: ld4r { v15.4h, v16.4h, v17.4h, v18.4h }, [c25] // encoding: [0x2f,0xe7,0x60,0x0d]
// CHECK: ld4r { v31.2s, v0.2s, v1.2s, v2.2s }, [csp] // encoding: [0xff,0xeb,0x60,0x0d]
// CHECK: ld4r { v31.1d, v0.1d, v1.1d, v2.1d }, [csp] // encoding: [0xff,0xef,0x60,0x0d]

//------------------------------------------------------------------------------
// Load single 1-element structure to one lane of 1 register.
//------------------------------------------------------------------------------
         ld1 { v0.b }[9], [c0]
         ld1 { v15.h }[7], [c25]
         ld1 { v31.s }[3], [csp]
         ld1 { v0.d }[1], [c0]
// CHECK: ld1 { v0.b }[9], [c0]         // encoding: [0x00,0x04,0x40,0x4d]
// CHECK: ld1 { v15.h }[7], [c25]       // encoding: [0x2f,0x5b,0x40,0x4d]
// CHECK: ld1 { v31.s }[3], [csp]        // encoding: [0xff,0x93,0x40,0x4d]
// CHECK: ld1 { v0.d }[1], [c0]         // encoding: [0x00,0x84,0x40,0x4d]

//------------------------------------------------------------------------------
// Load single N-element structure to one lane of N consecutive registers
// (N = 2,3,4)
//------------------------------------------------------------------------------
         ld2 { v0.b, v1.b }[9], [c0]
         ld2 { v15.h, v16.h }[7], [c25]
         ld2 { v31.s, v0.s }[3], [csp]
         ld2 { v0.d, v1.d }[1], [c0]
// CHECK: ld2 { v0.b, v1.b }[9], [c0]   // encoding: [0x00,0x04,0x60,0x4d]
// CHECK: ld2 { v15.h, v16.h }[7], [c25] // encoding: [0x2f,0x5b,0x60,0x4d]
// CHECK: ld2 { v31.s, v0.s }[3], [csp]  // encoding: [0xff,0x93,0x60,0x4d]
// CHECK: ld2 { v0.d, v1.d }[1], [c0]   // encoding: [0x00,0x84,0x60,0x4d]

         ld3 { v0.b, v1.b, v2.b }[9], [c0]
         ld3 { v15.h, v16.h, v17.h }[7], [c25]
         ld3 { v31.s, v0.s, v1.s }[3], [csp]
         ld3 { v0.d, v1.d, v2.d }[1], [c0]
// CHECK: ld3 { v0.b, v1.b, v2.b }[9], [c0] // encoding: [0x00,0x24,0x40,0x4d]
// CHECK: ld3 { v15.h, v16.h, v17.h }[7], [c25] // encoding: [0x2f,0x7b,0x40,0x4d]
// CHECK: ld3 { v31.s, v0.s, v1.s }[3], [csp] // encoding: [0xff,0xb3,0x40,0x4d]
// CHECK: ld3 { v0.d, v1.d, v2.d }[1], [c0] // encoding: [0x00,0xa4,0x40,0x4d]

         ld4 { v0.b, v1.b, v2.b, v3.b }[9], [c0]
         ld4 { v15.h, v16.h, v17.h, v18.h }[7], [c25]
         ld4 { v31.s, v0.s, v1.s, v2.s }[3], [csp]
         ld4 { v0.d, v1.d, v2.d, v3.d }[1], [c0]
// CHECK: ld4 { v0.b, v1.b, v2.b, v3.b }[9], [c0] // encoding: [0x00,0x24,0x60,0x4d]
// CHECK: ld4 { v15.h, v16.h, v17.h, v18.h }[7], [c25] // encoding: [0x2f,0x7b,0x60,0x4d]
// CHECK: ld4 { v31.s, v0.s, v1.s, v2.s }[3], [csp] // encoding: [0xff,0xb3,0x60,0x4d]
// CHECK: ld4 { v0.d, v1.d, v2.d, v3.d }[1], [c0] // encoding: [0x00,0xa4,0x60,0x4d]

//------------------------------------------------------------------------------
// Store single 1-element structure from one lane of 1 register.
//------------------------------------------------------------------------------
         st1 { v0.b }[9], [c0]
         st1 { v15.h }[7], [c25]
         st1 { v31.s }[3], [csp]
         st1 { v0.d }[1], [c0]
// CHECK: st1 { v0.b }[9], [c0]         // encoding: [0x00,0x04,0x00,0x4d]
// CHECK: st1 { v15.h }[7], [c25]       // encoding: [0x2f,0x5b,0x00,0x4d]
// CHECK: st1 { v31.s }[3], [csp]        // encoding: [0xff,0x93,0x00,0x4d]
// CHECK: st1 { v0.d }[1], [c0]         // encoding: [0x00,0x84,0x00,0x4d]

//------------------------------------------------------------------------------
// Store single N-element structure from one lane of N consecutive registers
// (N = 2,3,4)
//------------------------------------------------------------------------------
         st2 { v0.b, v1.b }[9], [c0]
         st2 { v15.h, v16.h }[7], [c25]
         st2 { v31.s, v0.s }[3], [csp]
         st2 { v0.d, v1.d }[1], [c0]
// CHECK: st2 { v0.b, v1.b }[9], [c0]   // encoding: [0x00,0x04,0x20,0x4d]
// CHECK: st2 { v15.h, v16.h }[7], [c25] // encoding: [0x2f,0x5b,0x20,0x4d]
// CHECK: st2 { v31.s, v0.s }[3], [csp]  // encoding: [0xff,0x93,0x20,0x4d]
// CHECK: st2 { v0.d, v1.d }[1], [c0]   // encoding: [0x00,0x84,0x20,0x4d]

         st3 { v0.b, v1.b, v2.b }[9], [c0]
         st3 { v15.h, v16.h, v17.h }[7], [c25]
         st3 { v31.s, v0.s, v1.s }[3], [csp]
         st3 { v0.d, v1.d, v2.d }[1], [c0]
// CHECK: st3 { v0.b, v1.b, v2.b }[9], [c0] // encoding: [0x00,0x24,0x00,0x4d]
// CHECK: st3 { v15.h, v16.h, v17.h }[7], [c25] // encoding: [0x2f,0x7b,0x00,0x4d]
// CHECK: st3 { v31.s, v0.s, v1.s }[3], [csp] // encoding: [0xff,0xb3,0x00,0x4d]
// CHECK: st3 { v0.d, v1.d, v2.d }[1], [c0] // encoding: [0x00,0xa4,0x00,0x4d]

         st4 { v0.b, v1.b, v2.b, v3.b }[9], [c0]
         st4 { v15.h, v16.h, v17.h, v18.h }[7], [c25]
         st4 { v31.s, v0.s, v1.s, v2.s }[3], [csp]
         st4 { v0.d, v1.d, v2.d, v3.d }[1], [c0]
// CHECK: st4 { v0.b, v1.b, v2.b, v3.b }[9], [c0] // encoding: [0x00,0x24,0x20,0x4d]
// CHECK: st4 { v15.h, v16.h, v17.h, v18.h }[7], [c25] // encoding: [0x2f,0x7b,0x20,0x4d]
// CHECK: st4 { v31.s, v0.s, v1.s, v2.s }[3], [csp] // encoding: [0xff,0xb3,0x20,0x4d]
// CHECK: st4 { v0.d, v1.d, v2.d, v3.d }[1], [c0] // encoding: [0x00,0xa4,0x20,0x4d]

//------------------------------------------------------------------------------
// Post-index oad single 1-element structure to all lanes of 1 register
//------------------------------------------------------------------------------
         ld1r { v0.16b }, [c0], #1
         ld1r { v15.8h }, [c25], #2
         ld1r { v31.4s }, [csp], #4
         ld1r { v0.2d }, [c0], #8
         ld1r { v0.8b }, [c0], x0
         ld1r { v15.4h }, [c25], x1
         ld1r { v31.2s }, [csp], x2
         ld1r { v0.1d }, [c0], x3
// CHECK: ld1r { v0.16b }, [c0], #1      // encoding: [0x00,0xc0,0xdf,0x4d]
// CHECK: ld1r { v15.8h }, [c25], #2     // encoding: [0x2f,0xc7,0xdf,0x4d]
// CHECK: ld1r { v31.4s }, [csp], #4      // encoding: [0xff,0xcb,0xdf,0x4d]
// CHECK: ld1r { v0.2d }, [c0], #8       // encoding: [0x00,0xcc,0xdf,0x4d]
// CHECK: ld1r { v0.8b }, [c0], x0       // encoding: [0x00,0xc0,0xc0,0x0d]
// CHECK: ld1r { v15.4h }, [c25], x1     // encoding: [0x2f,0xc7,0xc1,0x0d]
// CHECK: ld1r { v31.2s }, [csp], x2      // encoding: [0xff,0xcb,0xc2,0x0d]
// CHECK: ld1r { v0.1d }, [c0], x3       // encoding: [0x00,0xcc,0xc3,0x0d]

//------------------------------------------------------------------------------
// Post-index load single N-element structure to all lanes of N consecutive
// registers (N = 2,3,4)
//------------------------------------------------------------------------------
         ld2r { v0.16b, v1.16b }, [c0], #2
         ld2r { v15.8h, v16.8h }, [c25], #4
         ld2r { v31.4s, v0.4s }, [csp], #8
         ld2r { v0.2d, v1.2d }, [c0], #16
         ld2r { v0.8b, v1.8b }, [c0], x6
         ld2r { v15.4h, v16.4h }, [c25], x7
         ld2r { v31.2s, v0.2s }, [csp], x9
         ld2r { v31.1d, v0.1d }, [c0], x5
// CHECK: ld2r { v0.16b, v1.16b }, [c0], #2 // encoding: [0x00,0xc0,0xff,0x4d]
// CHECK: ld2r { v15.8h, v16.8h }, [c25], #4 // encoding: [0x2f,0xc7,0xff,0x4d]
// CHECK: ld2r { v31.4s, v0.4s }, [csp], #8 // encoding: [0xff,0xcb,0xff,0x4d]
// CHECK: ld2r { v0.2d, v1.2d }, [c0], #16 // encoding: [0x00,0xcc,0xff,0x4d]
// CHECK: ld2r { v0.8b, v1.8b }, [c0], x6 // encoding: [0x00,0xc0,0xe6,0x0d]
// CHECK: ld2r { v15.4h, v16.4h }, [c25], x7 // encoding: [0x2f,0xc7,0xe7,0x0d]
// CHECK: ld2r { v31.2s, v0.2s }, [csp], x9 // encoding: [0xff,0xcb,0xe9,0x0d]
// CHECK: ld2r { v31.1d, v0.1d }, [c0], x5 // encoding: [0x1f,0xcc,0xe5,0x0d]

         ld3r { v0.16b, v1.16b, v2.16b }, [c0], x9
         ld3r { v15.8h, v16.8h, v17.8h }, [c25], x6
         ld3r { v31.4s, v0.4s, v1.4s }, [csp], x7
         ld3r { v0.2d, v1.2d, v2.2d }, [c0], x5
         ld3r { v0.8b, v1.8b, v2.8b }, [c0], #3
         ld3r { v15.4h, v16.4h, v17.4h }, [c25], #6
         ld3r { v31.2s, v0.2s, v1.2s }, [csp], #12
         ld3r { v31.1d, v0.1d, v1.1d }, [csp], #24
// CHECK: ld3r { v0.16b, v1.16b, v2.16b }, [c0], x9 // encoding: [0x00,0xe0,0xc9,0x4d]
// CHECK: ld3r { v15.8h, v16.8h, v17.8h }, [c25], x6 // encoding: [0x2f,0xe7,0xc6,0x4d]
// CHECK: ld3r { v31.4s, v0.4s, v1.4s }, [csp], x7 // encoding: [0xff,0xeb,0xc7,0x4d]
// CHECK: ld3r { v0.2d, v1.2d, v2.2d }, [c0], x5 // encoding: [0x00,0xec,0xc5,0x4d]
// CHECK: ld3r { v0.8b, v1.8b, v2.8b }, [c0], #3 // encoding: [0x00,0xe0,0xdf,0x0d]
// CHECK: ld3r { v15.4h, v16.4h, v17.4h }, [c25], #6 // encoding: [0x2f,0xe7,0xdf,0x0d]
// CHECK: ld3r { v31.2s, v0.2s, v1.2s }, [csp], #12 // encoding: [0xff,0xeb,0xdf,0x0d]
// CHECK: ld3r { v31.1d, v0.1d, v1.1d }, [csp], #24 // encoding: [0xff,0xef,0xdf,0x0d]

         ld4r { v0.16b, v1.16b, v2.16b, v3.16b }, [c0], #4
         ld4r { v15.8h, v16.8h, v17.8h, v18.8h }, [c25], #8
         ld4r { v31.4s, v0.4s, v1.4s, v2.4s }, [csp], #16
         ld4r { v0.2d, v1.2d, v2.2d, v3.2d }, [c0], #32
         ld4r { v0.8b, v1.8b, v2.8b, v3.8b }, [c0], x5
         ld4r { v15.4h, v16.4h, v17.4h, v18.4h }, [c25], x9
         ld4r { v31.2s, v0.2s, v1.2s, v2.2s }, [csp], x30
         ld4r { v31.1d, v0.1d, v1.1d, v2.1d }, [csp], x7
// CHECK: ld4r { v0.16b, v1.16b, v2.16b, v3.16b }, [c0], #4 // encoding: [0x00,0xe0,0xff,0x4d]
// CHECK: ld4r { v15.8h, v16.8h, v17.8h, v18.8h }, [c25], #8 // encoding: [0x2f,0xe7,0xff,0x4d]
// CHECK: ld4r { v31.4s, v0.4s, v1.4s, v2.4s }, [csp], #16 // encoding: [0xff,0xeb,0xff,0x4d]
// CHECK: ld4r { v0.2d, v1.2d, v2.2d, v3.2d }, [c0], #32 // encoding: [0x00,0xec,0xff,0x4d]
// CHECK: ld4r { v0.8b, v1.8b, v2.8b, v3.8b }, [c0], x5 // encoding: [0x00,0xe0,0xe5,0x0d]
// CHECK: ld4r { v15.4h, v16.4h, v17.4h, v18.4h }, [c25], x9 // encoding: [0x2f,0xe7,0xe9,0x0d]
// CHECK: ld4r { v31.2s, v0.2s, v1.2s, v2.2s }, [csp], x30 // encoding: [0xff,0xeb,0xfe,0x0d]
// CHECK: ld4r { v31.1d, v0.1d, v1.1d, v2.1d }, [csp], x7 // encoding: [0xff,0xef,0xe7,0x0d]

//------------------------------------------------------------------------------
// Post-index load single 1-element structure to one lane of 1 register.
//------------------------------------------------------------------------------
         ld1 { v0.b }[9], [c0], #1
         ld1 { v15.h }[7], [c25], x9
         ld1 { v31.s }[3], [csp], x6
         ld1 { v0.d }[1], [c0], #8
// CHECK: ld1 { v0.b }[9], [c0], #1     // encoding: [0x00,0x04,0xdf,0x4d]
// CHECK: ld1 { v15.h }[7], [c25], x9   // encoding: [0x2f,0x5b,0xc9,0x4d]
// CHECK: ld1 { v31.s }[3], [csp], x6    // encoding: [0xff,0x93,0xc6,0x4d]
// CHECK: ld1 { v0.d }[1], [c0], #8     // encoding: [0x00,0x84,0xdf,0x4d]

//------------------------------------------------------------------------------
// Post-index load single N-element structure to one lane of N consecutive
// registers (N = 2,3,4)
//------------------------------------------------------------------------------
         ld2 { v0.b, v1.b }[9], [c0], x3
         ld2 { v15.h, v16.h }[7], [c25], #4
         ld2 { v31.s, v0.s }[3], [csp], #8
         ld2 { v0.d, v1.d }[1], [c0], x0
// CHECK: ld2 { v0.b, v1.b }[9], [c0], x3 // encoding: [0x00,0x04,0xe3,0x4d]
// CHECK: ld2 { v15.h, v16.h }[7], [c25], #4 // encoding: [0x2f,0x5b,0xff,0x4d]
// CHECK: ld2 { v31.s, v0.s }[3], [csp], #8 // encoding: [0xff,0x93,0xff,0x4d]
// CHECK: ld2 { v0.d, v1.d }[1], [c0], x0 // encoding: [0x00,0x84,0xe0,0x4d]

         ld3 { v0.b, v1.b, v2.b }[9], [c0], #3
         ld3 { v15.h, v16.h, v17.h }[7], [c25], #6
         ld3 { v31.s, v0.s, v1.s }[3], [csp], x3
         ld3 { v0.d, v1.d, v2.d }[1], [c0], x6
// CHECK: ld3 { v0.b, v1.b, v2.b }[9], [c0], #3 // encoding: [0x00,0x24,0xdf,0x4d]
// CHECK: ld3 { v15.h, v16.h, v17.h }[7], [c25], #6 // encoding: [0x2f,0x7b,0xdf,0x4d]
// CHECK: ld3 { v31.s, v0.s, v1.s }[3], [csp], x3 // encoding: [0xff,0xb3,0xc3,0x4d]
// CHECK: ld3 { v0.d, v1.d, v2.d }[1], [c0], x6 // encoding: [0x00,0xa4,0xc6,0x4d]

         ld4 { v0.b, v1.b, v2.b, v3.b }[9], [c0], x5
         ld4 { v15.h, v16.h, v17.h, v18.h }[7], [c25], x7
         ld4 { v31.s, v0.s, v1.s, v2.s }[3], [csp], #16
         ld4 { v0.d, v1.d, v2.d, v3.d }[1], [c0], #32
// CHECK: ld4 { v0.b, v1.b, v2.b, v3.b }[9], [c0], x5 // encoding: [0x00,0x24,0xe5,0x4d]
// CHECK: ld4 { v15.h, v16.h, v17.h, v18.h }[7], [c25], x7 // encoding: [0x2f,0x7b,0xe7,0x4d]
// CHECK: ld4 { v31.s, v0.s, v1.s, v2.s }[3], [csp], #16 // encoding: [0xff,0xb3,0xff,0x4d]
// CHECK: ld4 { v0.d, v1.d, v2.d, v3.d }[1], [c0], #32 // encoding: [0x00,0xa4,0xff,0x4d]

//------------------------------------------------------------------------------
// Post-index store single 1-element structure from one lane of 1 register.
//------------------------------------------------------------------------------
         st1 { v0.b }[9], [c0], #1
         st1 { v15.h }[7], [c25], x9
         st1 { v31.s }[3], [csp], x6
         st1 { v0.d }[1], [c0], #8
// CHECK: st1 { v0.b }[9], [c0], #1     // encoding: [0x00,0x04,0x9f,0x4d]
// CHECK: st1 { v15.h }[7], [c25], x9   // encoding: [0x2f,0x5b,0x89,0x4d]
// CHECK: st1 { v31.s }[3], [csp], x6    // encoding: [0xff,0x93,0x86,0x4d]
// CHECK: st1 { v0.d }[1], [c0], #8     // encoding: [0x00,0x84,0x9f,0x4d]

//------------------------------------------------------------------------------
// Post-index store single N-element structure from one lane of N consecutive
// registers (N = 2,3,4)
//------------------------------------------------------------------------------
         st2 { v0.b, v1.b }[9], [c0], x3
         st2 { v15.h, v16.h }[7], [c25], #4
         st2 { v31.s, v0.s }[3], [csp], #8
         st2 { v0.d, v1.d }[1], [c0], x0
// CHECK: st2 { v0.b, v1.b }[9], [c0], x3 // encoding: [0x00,0x04,0xa3,0x4d]
// CHECK: st2 { v15.h, v16.h }[7], [c25], #4 // encoding: [0x2f,0x5b,0xbf,0x4d]
// CHECK: st2 { v31.s, v0.s }[3], [csp], #8 // encoding: [0xff,0x93,0xbf,0x4d]
// CHECK: st2 { v0.d, v1.d }[1], [c0], x0 // encoding: [0x00,0x84,0xa0,0x4d]

         st3 { v0.b, v1.b, v2.b }[9], [c0], #3
         st3 { v15.h, v16.h, v17.h }[7], [c25], #6
         st3 { v31.s, v0.s, v1.s }[3], [csp], x3
         st3 { v0.d, v1.d, v2.d }[1], [c0], x6
// CHECK: st3 { v0.b, v1.b, v2.b }[9], [c0], #3 // encoding: [0x00,0x24,0x9f,0x4d]
// CHECK: st3 { v15.h, v16.h, v17.h }[7], [c25], #6 // encoding: [0x2f,0x7b,0x9f,0x4d]
// CHECK: st3 { v31.s, v0.s, v1.s }[3], [csp], x3 // encoding: [0xff,0xb3,0x83,0x4d]
// CHECK: st3 { v0.d, v1.d, v2.d }[1], [c0], x6 // encoding: [0x00,0xa4,0x86,0x4d]

         st4 { v0.b, v1.b, v2.b, v3.b }[9], [c0], x5
         st4 { v15.h, v16.h, v17.h, v18.h }[7], [c25], x7
         st4 { v31.s, v0.s, v1.s, v2.s }[3], [csp], #16
         st4 { v0.d, v1.d, v2.d, v3.d }[1], [c0], #32
// CHECK: st4 { v0.b, v1.b, v2.b, v3.b }[9], [c0], x5 // encoding: [0x00,0x24,0xa5,0x4d]
// CHECK: st4 { v15.h, v16.h, v17.h, v18.h }[7], [c25], x7 // encoding: [0x2f,0x7b,0xa7,0x4d]
// CHECK: st4 { v31.s, v0.s, v1.s, v2.s }[3], [csp], #16 // encoding: [0xff,0xb3,0xbf,0x4d]
// CHECK: st4 { v0.d, v1.d, v2.d, v3.d }[1], [c0], #32 // encoding: [0x00,0xa4,0xbf,0x4d]
