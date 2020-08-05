// RUN: llvm-mc -triple aarch64-none-elf -show-encoding -mattr=+c64 < %s | FileCheck %s
// RUN: llvm-mc -triple aarch64-none-elf -show-encoding -mattr=+c64,+morello < %s | FileCheck %s
  .globl _func

_func:
// CHECK: _func

//------------------------------------------------------------------------------
// Load/store (unsigned immediate)
//------------------------------------------------------------------------------

//// Basic addressing mode limits: 8 byte access
        ldr x0, [c0]
        ldr x4, [c29, #0]
        ldr x30, [c6, #32760]
        ldr x20, [csp, #8]
// CHECK: ldr      x0, [c0]                   // encoding: [0x00,0x00,0x40,0xf9]
// CHECK: ldr      x4, [c29]                  // encoding: [0xa4,0x03,0x40,0xf9]
// CHECK: ldr      x30, [c6, #32760]          // encoding: [0xde,0xfc,0x7f,0xf9]
// CHECK: ldr      x20, [csp, #8]             // encoding: [0xf4,0x07,0x40,0xf9]

//// Rt treats 31 as zero-register
        ldr xzr, [csp]
// CHECK: ldr      xzr, [csp]                  // encoding: [0xff,0x03,0x40,0xf9]

//// 4-byte load, check still 64-bit address, limits
        ldr w2, [csp]
        ldr w17, [csp, #16380]
        ldr w13, [c2, #4]
// CHECK: ldr      w2, [csp]                   // encoding: [0xe2,0x03,0x40,0xb9]
// CHECK: ldr      w17, [csp, #16380]          // encoding: [0xf1,0xff,0x7f,0xb9]
// CHECK: ldr      w13, [c2, #4]              // encoding: [0x4d,0x04,0x40,0xb9]

//// Signed 4-byte load. Limits.
        ldrsw x2, [c5,#4]
        ldrsw x23, [csp, #16380]
// CHECK: ldrsw    x2, [c5, #4]               // encoding: [0xa2,0x04,0x80,0xb9]
// CHECK: ldrsw    x23, [csp, #16380]          // encoding: [0xf7,0xff,0xbf,0xb9]

////  2-byte loads
        ldrh w2, [c4]
        ldrsh w23, [c6, #8190]
        ldrsh wzr, [csp, #2]
        ldrsh x29, [c2, #2]
// CHECK: ldrh     w2, [c4]                   // encoding: [0x82,0x00,0x40,0x79]
// CHECK: ldrsh    w23, [c6, #8190]           // encoding: [0xd7,0xfc,0xff,0x79]
// CHECK: ldrsh    wzr, [csp, #2]             // encoding: [0xff,0x07,0xc0,0x79]
// CHECK: ldrsh    x29, [c2, #2]              // encoding: [0x5d,0x04,0x80,0x79]

//// 1-byte loads
        ldrb w26, [c3, #121]
        ldrb w12, [c2, #0]
        ldrsb w27, [csp, #4095]
        ldrsb xzr, [c25]
// CHECK: ldrb     w26, [c3, #121]            // encoding: [0x7a,0xe4,0x41,0x39]
// CHECK: ldrb     w12, [c2]                  // encoding: [0x4c,0x00,0x40,0x39]
// CHECK: ldrsb    w27, [csp, #4095]          // encoding: [0xfb,0xff,0xff,0x39]
// CHECK: ldrsb    xzr, [c25]                 // encoding: [0x3f,0x03,0x80,0x39]

//// Stores
        str x30, [csp]
        str w20, [c4, #16380]
        strh w20, [c4, #14]
        strh w17, [csp, #8190]
        strb w23, [c3, #4095]
        strb wzr, [c2]
// CHECK: str      x30, [csp]                  // encoding: [0xfe,0x03,0x00,0xf9]
// CHECK: str      w20, [c4, #16380]          // encoding: [0x94,0xfc,0x3f,0xb9]
// CHECK: strh     w20, [c4, #14]            // encoding: [0x94,0x1c,0x00,0x79]
// CHECK: strh     w17, [csp, #8190]           // encoding: [0xf1,0xff,0x3f,0x79]
// CHECK: strb     w23, [c3, #4095]           // encoding: [0x77,0xfc,0x3f,0x39]
// CHECK: strb     wzr, [c2]                  // encoding: [0x5f,0x00,0x00,0x39]


//// Floating-point versions

        ldr b31, [csp, #4095]
        ldr h20, [c2, #8190]
        ldr s10, [c27, #16380]
        ldr d3, [c7, #32760]
        str q12, [csp, #65520]
// CHECK: ldr      b31, [csp, #4095]           // encoding: [0xff,0xff,0x7f,0x3d]
// CHECK: ldr      h20, [c2, #8190]           // encoding: [0x54,0xfc,0x7f,0x7d]
// CHECK: ldr      s10, [c27, #16380]         // encoding: [0x6a,0xff,0x7f,0xbd]
// CHECK: ldr      d3, [c7, #32760]          // encoding: [0xe3,0xfc,0x7f,0xfd]
// CHECK: str      q12, [csp, #65520]          // encoding: [0xec,0xff,0xbf,0x3d]

//-----------------------------------------------------------------------------
// Load literal
//-----------------------------------------------------------------------------

  ldr    w5, foo
  ldr    x4, foo
  ldrsw  x9, foo
  prfm   #5, foo

// CHECK: ldr    w5, foo                 // encoding: [0bAAA00101,A,A,0x18]
// CHECK: ldr    x4, foo                 // encoding: [0bAAA00100,A,A,0x58]
// CHECK: ldrsw  x9, foo                 // encoding: [0bAAA01001,A,A,0x98]
// CHECK: prfm   pldl3strm, foo          // encoding: [0bAAA00101,A,A,0xd8]

//-----------------------------------------------------------------------------
// Register offset loads and stores
//-----------------------------------------------------------------------------

// Load (zext) Byte

	ldrb w3, [c4, x7, lsl #0]
	ldrb w14, [c2, x12, sxtx #0]
	ldrb w14, [c1, w2, uxtw #0]
	ldrb w14, [c1, w15, sxtw #0]

// CHECK: ldrb	w3, [c4, x7, lsl #0]    // encoding: [0x83,0x78,0x67,0x38]
// CHECK: ldrb	w14, [c2, x12, sxtx #0] // encoding: [0x4e,0xf8,0x6c,0x38]
// CHECK: ldrb	w14, [c1, w2, uxtw #0]  // encoding: [0x2e,0x58,0x62,0x38]
// CHECK: ldrb	w14, [c1, w15, sxtw #0] // encoding: [0x2e,0xd8,0x6f,0x38]

// Load (sext) Byte

	ldrsb w3, [c4, x7, lsl #0]
	ldrsb w14, [c24, x12, sxtx #0]
	ldrsb w14, [c1, w2, uxtw #0]
	ldrsb w14, [c1, w15, sxtw #0]

// CHECK: ldrsb	w3, [c4, x7, lsl #0]    // encoding: [0x83,0x78,0xe7,0x38]
// CHECK: ldrsb	w14, [c24, x12, sxtx #0] // encoding: [0x0e,0xfb,0xec,0x38]
// CHECK: ldrsb	w14, [c1, w2, uxtw #0]  // encoding: [0x2e,0x58,0xe2,0x38]
// CHECK: ldrsb	w14, [c1, w15, sxtw #0] // encoding: [0x2e,0xd8,0xef,0x38]

// Store byte
    strb w22, [c27, x2, lsl #0]
    strb w0, [c7, x17, sxtx #0]
    strb w15, [c29, w9, uxtw #0]
    strb w12, [c6, w12, sxtw #0]

// CHECK: strb	w22, [c27, x2, lsl #0]  // encoding: [0x76,0x7b,0x22,0x38]
// CHECK: strb	w0, [c7, x17, sxtx #0]  // encoding: [0xe0,0xf8,0x31,0x38]
// CHECK: strb	w15, [c29, w9, uxtw #0] // encoding: [0xaf,0x5b,0x29,0x38]
// CHECK: strb	w12, [c6, w12, sxtw #0] // encoding: [0xcc,0xd8,0x2c,0x38]

    ldr  w0, [c0, x0]
    ldr  w0, [c0, x0, lsl #2]
    ldr  x0, [c0, x0]
    ldr  x0, [c0, x0, lsl #3]
    ldr  x0, [c0, x0, sxtx]

// CHECK: ldr  w0, [c0, x0]              // encoding: [0x00,0x68,0x60,0xb8]
// CHECK: ldr  w0, [c0, x0, lsl #2]      // encoding: [0x00,0x78,0x60,0xb8]
// CHECK: ldr  x0, [c0, x0]              // encoding: [0x00,0x68,0x60,0xf8]
// CHECK: ldr  x0, [c0, x0, lsl #3]      // encoding: [0x00,0x78,0x60,0xf8]
// CHECK: ldr  x0, [c0, x0, sxtx]        // encoding: [0x00,0xe8,0x60,0xf8]

    ldr  b1, [c1, x2]
    ldr  b1, [c1, x2, lsl #0]
    ldr  h1, [c1, x2]
    ldr  h1, [c1, x2, lsl #1]
    ldr  s1, [c1, x2]
    ldr  s1, [c1, x2, lsl #2]
    ldr  d1, [c1, x2]
    ldr  d1, [c1, x2, lsl #3]
    ldr  q1, [c1, x2]
    ldr  q1, [c1, x2, lsl #4]

// CHECK: ldr  b1, [c1, x2]              // encoding: [0x21,0x68,0x62,0x3c]
// CHECK: ldr  b1, [c1, x2, lsl #0]      // encoding: [0x21,0x78,0x62,0x3c]
// CHECK: ldr  h1, [c1, x2]              // encoding: [0x21,0x68,0x62,0x7c]
// CHECK: ldr  h1, [c1, x2, lsl #1]      // encoding: [0x21,0x78,0x62,0x7c]
// CHECK: ldr  s1, [c1, x2]              // encoding: [0x21,0x68,0x62,0xbc]
// CHECK: ldr  s1, [c1, x2, lsl #2]      // encoding: [0x21,0x78,0x62,0xbc]
// CHECK: ldr  d1, [c1, x2]              // encoding: [0x21,0x68,0x62,0xfc]
// CHECK: ldr  d1, [c1, x2, lsl #3]      // encoding: [0x21,0x78,0x62,0xfc]
// CHECK: ldr  q1, [c1, x2]              // encoding: [0x21,0x68,0xe2,0x3c]
// CHECK: ldr  q1, [c1, x2, lsl #4]      // encoding: [0x21,0x78,0xe2,0x3c]

    str  d1, [csp, x3]
    str  d1, [csp, w3, uxtw #3]
    str  q1, [csp, x3]
    str  q1, [csp, w3, uxtw #4]

// CHECK: str  d1, [csp, x3]              // encoding: [0xe1,0x6b,0x23,0xfc]
// CHECK: str  d1, [csp, w3, uxtw #3]     // encoding: [0xe1,0x5b,0x23,0xfc]
// CHECK: str  q1, [csp, x3]              // encoding: [0xe1,0x6b,0xa3,0x3c]
// CHECK: str  q1, [csp, w3, uxtw #4]     // encoding: [0xe1,0x5b,0xa3,0x3c]


//-----------------------------------------------------------------------------
// Unscaled immediate loads and stores
//-----------------------------------------------------------------------------

  ldur    w2, [c3]
  ldur    w2, [csp, #24]
  ldur    x2, [c3]
  ldur    x2, [csp, #24]
  ldur    b5, [csp, #1]
  ldur    h6, [csp, #2]
  ldur    s7, [csp, #4]
  ldur    d8, [csp, #8]
  ldur    q9, [csp, #16]
  ldursb  w9, [c3]
  ldursb  x2, [csp, #128]
  ldursh  w3, [csp, #32]
  ldursh  x5, [c7, #24]
  ldursw  x9, [csp, #-128]

// CHECK: ldur    w2, [c3]               // encoding: [0x62,0x00,0x40,0xb8]
// CHECK: ldur    w2, [csp, #24]          // encoding: [0xe2,0x83,0x41,0xb8]
// CHECK: ldur    x2, [c3]               // encoding: [0x62,0x00,0x40,0xf8]
// CHECK: ldur    x2, [csp, #24]          // encoding: [0xe2,0x83,0x41,0xf8]
// CHECK: ldur    b5, [csp, #1]           // encoding: [0xe5,0x13,0x40,0x3c]
// CHECK: ldur    h6, [csp, #2]           // encoding: [0xe6,0x23,0x40,0x7c]
// CHECK: ldur    s7, [csp, #4]           // encoding: [0xe7,0x43,0x40,0xbc]
// CHECK: ldur    d8, [csp, #8]           // encoding: [0xe8,0x83,0x40,0xfc]
// CHECK: ldur    q9, [csp, #16]          // encoding: [0xe9,0x03,0xc1,0x3c]
// CHECK: ldursb  w9, [c3]               // encoding: [0x69,0x00,0xc0,0x38]
// CHECK: ldursb  x2, [csp, #128]         // encoding: [0xe2,0x03,0x88,0x38]
// CHECK: ldursh  w3, [csp, #32]          // encoding: [0xe3,0x03,0xc2,0x78]
// CHECK: ldursh  x5, [c7, #24]          // encoding: [0xe5,0x80,0x81,0x78]
// CHECK: ldursw  x9, [csp, #-128]        // encoding: [0xe9,0x03,0x98,0xb8]

  stur    w4, [c3]
  stur    w2, [csp, #32]
  stur    x4, [c3]
  stur    x2, [csp, #32]
  stur    w5, [c4, #20]
  stur    b5, [csp, #1]
  stur    h6, [csp, #2]
  stur    s7, [csp, #4]
  stur    d8, [csp, #8]
  stur    q9, [csp, #16]
  sturb   w4, [c3]
  sturb   w5, [c4, #20]
  sturh   w2, [csp, #32]

// CHECK: stur    w4, [c3]               // encoding: [0x64,0x00,0x00,0xb8]
// CHECK: stur    w2, [csp, #32]          // encoding: [0xe2,0x03,0x02,0xb8]
// CHECK: stur    x4, [c3]               // encoding: [0x64,0x00,0x00,0xf8]
// CHECK: stur    x2, [csp, #32]          // encoding: [0xe2,0x03,0x02,0xf8]
// CHECK: stur    w5, [c4, #20]          // encoding: [0x85,0x40,0x01,0xb8]
// CHECK: stur    b5, [csp, #1]           // encoding: [0xe5,0x13,0x00,0x3c]
// CHECK: stur    h6, [csp, #2]           // encoding: [0xe6,0x23,0x00,0x7c]
// CHECK: stur    s7, [csp, #4]           // encoding: [0xe7,0x43,0x00,0xbc]
// CHECK: stur    d8, [csp, #8]           // encoding: [0xe8,0x83,0x00,0xfc]
// CHECK: stur    q9, [csp, #16]          // encoding: [0xe9,0x03,0x81,0x3c]
// CHECK: sturb   w4, [c3]               // encoding: [0x64,0x00,0x00,0x38]
// CHECK: sturb   w5, [c4, #20]          // encoding: [0x85,0x40,0x01,0x38]
// CHECK: sturh   w2, [csp, #32]          // encoding: [0xe2,0x03,0x02,0x78]

//-----------------------------------------------------------------------------
// LDUR/STUR aliases for negative and unaligned LDR/STR instructions.
//
// According to the ARM ISA documentation:
// "A programmer-friendly assembler should also generate these instructions
// in response to the standard LDR/STR mnemonics when the immediate offset is
// unambiguous, i.e. negative or unaligned."
//-----------------------------------------------------------------------------

  ldr x11, [c29, #-8]
  ldr x11, [c29, #7]
  ldr w0, [c0, #2]
  ldr w0, [c0, #-256]
  ldr b2, [c1, #-2]
  ldr h3, [c2, #3]
  ldr h3, [c3, #-4]
  ldr s3, [c4, #3]
  ldr s3, [c5, #-4]
  ldr d4, [c6, #4]
  ldr d4, [c7, #-8]
  ldr q5, [c24, #8]
  ldr q5, [c25, #-16]

// CHECK: ldur	x11, [c29, #-8]         // encoding: [0xab,0x83,0x5f,0xf8]
// CHECK: ldur	x11, [c29, #7]          // encoding: [0xab,0x73,0x40,0xf8]
// CHECK: ldur	w0, [c0, #2]            // encoding: [0x00,0x20,0x40,0xb8]
// CHECK: ldur	w0, [c0, #-256]         // encoding: [0x00,0x00,0x50,0xb8]
// CHECK: ldur	b2, [c1, #-2]           // encoding: [0x22,0xe0,0x5f,0x3c]
// CHECK: ldur	h3, [c2, #3]            // encoding: [0x43,0x30,0x40,0x7c]
// CHECK: ldur	h3, [c3, #-4]           // encoding: [0x63,0xc0,0x5f,0x7c]
// CHECK: ldur	s3, [c4, #3]            // encoding: [0x83,0x30,0x40,0xbc]
// CHECK: ldur	s3, [c5, #-4]           // encoding: [0xa3,0xc0,0x5f,0xbc]
// CHECK: ldur	d4, [c6, #4]            // encoding: [0xc4,0x40,0x40,0xfc]
// CHECK: ldur	d4, [c7, #-8]           // encoding: [0xe4,0x80,0x5f,0xfc]
// CHECK: ldur	q5, [c24, #8]            // encoding: [0x05,0x83,0xc0,0x3c]
// CHECK: ldur	q5, [c25, #-16]          // encoding: [0x25,0x03,0xdf,0x3c]

  str x11, [c29, #-8]
  str x11, [c29, #7]
  str w0, [c0, #2]
  str w0, [c0, #-256]
  str b2, [c1, #-2]
  str h3, [c2, #3]
  str h3, [c3, #-4]
  str s3, [c4, #3]
  str s3, [c5, #-4]
  str d4, [c6, #4]
  str d4, [c7, #-8]
  str q5, [c24, #8]
  str q5, [c25, #-16]

// CHECK: stur	x11, [c29, #-8]         // encoding: [0xab,0x83,0x1f,0xf8]
// CHECK: stur	x11, [c29, #7]          // encoding: [0xab,0x73,0x00,0xf8]
// CHECK: stur	w0, [c0, #2]            // encoding: [0x00,0x20,0x00,0xb8]
// CHECK: stur	w0, [c0, #-256]         // encoding: [0x00,0x00,0x10,0xb8]
// CHECK: stur	b2, [c1, #-2]           // encoding: [0x22,0xe0,0x1f,0x3c]
// CHECK: stur	h3, [c2, #3]            // encoding: [0x43,0x30,0x00,0x7c]
// CHECK: stur	h3, [c3, #-4]           // encoding: [0x63,0xc0,0x1f,0x7c]
// CHECK: stur	s3, [c4, #3]            // encoding: [0x83,0x30,0x00,0xbc]
// CHECK: stur	s3, [c5, #-4]           // encoding: [0xa3,0xc0,0x1f,0xbc]
// CHECK: stur	d4, [c6, #4]            // encoding: [0xc4,0x40,0x00,0xfc]
// CHECK: stur	d4, [c7, #-8]           // encoding: [0xe4,0x80,0x1f,0xfc]
// CHECK: stur	q5, [c24, #8]            // encoding: [0x05,0x83,0x80,0x3c]
// CHECK: stur	q5, [c25, #-16]          // encoding: [0x25,0x03,0x9f,0x3c]

  ldrb w3, [c1, #-1]
  ldrh w4, [c2, #1]
  ldrh w5, [c3, #-1]
  ldrsb w6, [c4, #-1]
  ldrsb x7, [c5, #-1]
  ldrsh w8, [c6, #1]
  ldrsh w9, [c7, #-1]
  ldrsh x1, [c24, #1]
  ldrsh x2, [c25, #-1]
  ldrsw x3, [c26, #10]
  ldrsw x4, [c27, #-1]

// CHECK: ldurb	w3, [c1, #-1]               // encoding: [0x23,0xf0,0x5f,0x38]
// CHECK: ldurh	w4, [c2, #1]                // encoding: [0x44,0x10,0x40,0x78]
// CHECK: ldurh	w5, [c3, #-1]               // encoding: [0x65,0xf0,0x5f,0x78]
// CHECK: ldursb	w6, [c4, #-1]           // encoding: [0x86,0xf0,0xdf,0x38]
// CHECK: ldursb	x7, [c5, #-1]           // encoding: [0xa7,0xf0,0x9f,0x38]
// CHECK: ldursh	w8, [c6, #1]            // encoding: [0xc8,0x10,0xc0,0x78]
// CHECK: ldursh	w9, [c7, #-1]           // encoding: [0xe9,0xf0,0xdf,0x78]
// CHECK: ldursh	x1, [c24, #1]            // encoding: [0x01,0x13,0x80,0x78]
// CHECK: ldursh	x2, [c25, #-1]           // encoding: [0x22,0xf3,0x9f,0x78]
// CHECK: ldursw	x3, [c26, #10]          // encoding: [0x43,0xa3,0x80,0xb8]
// CHECK: ldursw	x4, [c27, #-1]          // encoding: [0x64,0xf3,0x9f,0xb8]

  strb w3, [c1, #-1]
  strh w4, [c2, #1]
  strh w5, [c3, #-1]

// CHECK: sturb	w3, [c1, #-1]           // encoding: [0x23,0xf0,0x1f,0x38]
// CHECK: sturh	w4, [c2, #1]            // encoding: [0x44,0x10,0x00,0x78]
// CHECK: sturh	w5, [c3, #-1]           // encoding: [0x65,0xf0,0x1f,0x78]

//-----------------------------------------------------------------------------
// Unprivileged loads and stores
//-----------------------------------------------------------------------------

  ldtr    w3, [c4, #16]
  ldtr    x3, [c4, #16]
  ldtrb   w3, [c4, #16]
  ldtrsb  w9, [c3]
  ldtrsb  x2, [csp, #128]
  ldtrh   w3, [c4, #16]
  ldtrsh  w3, [csp, #32]
  ldtrsh  x5, [c25, #24]
  ldtrsw  x9, [csp, #-128]

// CHECK: ldtr   w3, [c4, #16]           // encoding: [0x83,0x08,0x41,0xb8]
// CHECK: ldtr   x3, [c4, #16]           // encoding: [0x83,0x08,0x41,0xf8]
// CHECK: ldtrb  w3, [c4, #16]           // encoding: [0x83,0x08,0x41,0x38]
// CHECK: ldtrsb w9, [c3]                // encoding: [0x69,0x08,0xc0,0x38]
// CHECK: ldtrsb x2, [csp, #128]          // encoding: [0xe2,0x0b,0x88,0x38]
// CHECK: ldtrh  w3, [c4, #16]           // encoding: [0x83,0x08,0x41,0x78]
// CHECK: ldtrsh w3, [csp, #32]           // encoding: [0xe3,0x0b,0xc2,0x78]
// CHECK: ldtrsh x5, [c25, #24]           // encoding: [0x25,0x8b,0x81,0x78]
// CHECK: ldtrsw x9, [csp, #-128]         // encoding: [0xe9,0x0b,0x98,0xb8]

  sttr    w5, [c4, #20]
  sttr    x4, [c3]
  sttr    x2, [csp, #32]
  sttrb   w4, [c3]
  sttrb   w5, [c4, #20]
  sttrh   w2, [csp, #32]

// CHECK: sttr   w5, [c4, #20]           // encoding: [0x85,0x48,0x01,0xb8]
// CHECK: sttr   x4, [c3]                // encoding: [0x64,0x08,0x00,0xf8]
// CHECK: sttr   x2, [csp, #32]           // encoding: [0xe2,0x0b,0x02,0xf8]
// CHECK: sttrb  w4, [c3]                // encoding: [0x64,0x08,0x00,0x38]
// CHECK: sttrb  w5, [c4, #20]           // encoding: [0x85,0x48,0x01,0x38]
// CHECK: sttrh  w2, [csp, #32]           // encoding: [0xe2,0x0b,0x02,0x78]

//-----------------------------------------------------------------------------
// Pre-indexed loads and stores
//-----------------------------------------------------------------------------

  ldr   x29, [c7, #8]!
  ldr   x30, [c7, #8]!
  ldr   b5, [c0, #1]!
  ldr   h6, [c0, #2]!
  ldr   s7, [c0, #4]!
  ldr   d8, [c0, #8]!
  ldr   q9, [c0, #16]!

  str   x30, [c7, #-8]!
  str   x29, [c7, #-8]!
  str   b5, [c0, #-1]!
  str   h6, [c0, #-2]!
  str   s7, [c0, #-4]!
  str   d8, [c0, #-8]!
  str   q9, [c0, #-16]!

// CHECK: ldr  x29, [c7, #8]!             // encoding: [0xfd,0x8c,0x40,0xf8]
// CHECK: ldr  x30, [c7, #8]!             // encoding: [0xfe,0x8c,0x40,0xf8]
// CHECK: ldr  b5, [c0, #1]!             // encoding: [0x05,0x1c,0x40,0x3c]
//  CHECK: ldr  h6, [c0, #2]!             // encoding: [0x06,0x2c,0x40,0x7c]
// CHECK: ldr  s7, [c0, #4]!             // encoding: [0x07,0x4c,0x40,0xbc]
// CHECK: ldr  d8, [c0, #8]!             // encoding: [0x08,0x8c,0x40,0xfc]
// CHECK: ldr  q9, [c0, #16]!            // encoding: [0x09,0x0c,0xc1,0x3c]

// CHECK: str  x30, [c7, #-8]!            // encoding: [0xfe,0x8c,0x1f,0xf8]
// CHECK: str  x29, [c7, #-8]!            // encoding: [0xfd,0x8c,0x1f,0xf8]
// CHECK: str  b5, [c0, #-1]!            // encoding: [0x05,0xfc,0x1f,0x3c]
// CHECK: str  h6, [c0, #-2]!            // encoding: [0x06,0xec,0x1f,0x7c]
// CHECK: str  s7, [c0, #-4]!            // encoding: [0x07,0xcc,0x1f,0xbc]
// CHECK: str  d8, [c0, #-8]!            // encoding: [0x08,0x8c,0x1f,0xfc]
// CHECK: str  q9, [c0, #-16]!           // encoding: [0x09,0x0c,0x9f,0x3c]

//-----------------------------------------------------------------------------
// post-indexed loads and stores
//-----------------------------------------------------------------------------
  str x30, [c7], #-8
  str x29, [c7], #-8
  str b5, [c0], #-1
  str h6, [c0], #-2
  str s7, [c0], #-4
  str d8, [c0], #-8
  str q9, [c0], #-16

  ldr x29, [c7], #8
  ldr x30, [c7], #8
  ldr b5, [c0], #1
  ldr h6, [c0], #2
  ldr s7, [c0], #4
  ldr d8, [c0], #8
  ldr q9, [c0], #16

// CHECK: str x30, [c7], #-8             // encoding: [0xfe,0x84,0x1f,0xf8]
// CHECK: str x29, [c7], #-8             // encoding: [0xfd,0x84,0x1f,0xf8]
// CHECK: str b5, [c0], #-1             // encoding: [0x05,0xf4,0x1f,0x3c]
// CHECK: str h6, [c0], #-2             // encoding: [0x06,0xe4,0x1f,0x7c]
// CHECK: str s7, [c0], #-4             // encoding: [0x07,0xc4,0x1f,0xbc]
// CHECK: str d8, [c0], #-8             // encoding: [0x08,0x84,0x1f,0xfc]
// CHECK: str q9, [c0], #-16            // encoding: [0x09,0x04,0x9f,0x3c]

// CHECK: ldr x29, [c7], #8              // encoding: [0xfd,0x84,0x40,0xf8]
// CHECK: ldr x30, [c7], #8              // encoding: [0xfe,0x84,0x40,0xf8]
// CHECK: ldr b5, [c0], #1              // encoding: [0x05,0x14,0x40,0x3c]
// CHECK: ldr h6, [c0], #2              // encoding: [0x06,0x24,0x40,0x7c]
// CHECK: ldr s7, [c0], #4              // encoding: [0x07,0x44,0x40,0xbc]
// CHECK: ldr d8, [c0], #8              // encoding: [0x08,0x84,0x40,0xfc]
// CHECK: ldr q9, [c0], #16             // encoding: [0x09,0x04,0xc1,0x3c]

//----------------------------------------------------------------------------
// Load/Store pair (indexed, offset)
//----------------------------------------------------------------------------

  ldp    w3, w2, [c27, #16]
  ldp    x4, x9, [csp, #-16]
  ldpsw  x2, x3, [c28, #16]
  ldpsw  x2, x3, [csp, #-16]
  ldp    s10, s1, [c2, #64]
  ldp    d10, d1, [c2]
  ldp    q2, q3, [c0, #32]

// CHECK: ldp    w3, w2, [c27, #16]      // encoding: [0x63,0x0b,0x42,0x29]
// CHECK: ldp    x4, x9, [csp, #-16]      // encoding: [0xe4,0x27,0x7f,0xa9]
// CHECK: ldpsw  x2, x3, [c28, #16]      // encoding: [0x82,0x0f,0x42,0x69]
// CHECK: ldpsw  x2, x3, [csp, #-16]      // encoding: [0xe2,0x0f,0x7e,0x69]
// CHECK: ldp    s10, s1, [c2, #64]      // encoding: [0x4a,0x04,0x48,0x2d]
// CHECK: ldp    d10, d1, [c2]           // encoding: [0x4a,0x04,0x40,0x6d]
// CHECK: ldp    q2, q3, [c0, #32]       // encoding: [0x02,0x0c,0x41,0xad]

  stp    w3, w2, [c7, #16]
  stp    x4, x9, [csp, #-16]
  stp    s10, s1, [c2, #64]
  stp    d10, d1, [c2]
  stp    q2, q3, [c0, #32]

// CHECK: stp    w3, w2, [c7, #16]      // encoding: [0xe3,0x08,0x02,0x29]
// CHECK: stp    x4, x9, [csp, #-16]     // encoding: [0xe4,0x27,0x3f,0xa9]
// CHECK: stp    s10, s1, [c2, #64]      // encoding: [0x4a,0x04,0x08,0x2d]
// CHECK: stp    d10, d1, [c2]           // encoding: [0x4a,0x04,0x00,0x6d]
// CHECK: stp    q2, q3, [c0, #32]       // encoding: [0x02,0x0c,0x01,0xad]

//-----------------------------------------------------------------------------
// Load/Store pair (pre-indexed)
//-----------------------------------------------------------------------------

  ldp    w3, w2, [c7, #16]!
  ldp    x4, x9, [csp, #-16]!
  ldpsw  x2, x3, [c6, #16]!
  ldpsw  x2, x3, [csp, #-16]!
  ldp    s10, s1, [c2, #64]!
  ldp    d10, d1, [c2, #16]!

// CHECK: ldp  w3, w2, [c7, #16]!       // encoding: [0xe3,0x08,0xc2,0x29]
// CHECK: ldp  x4, x9, [csp, #-16]!      // encoding: [0xe4,0x27,0xff,0xa9]
// CHECK: ldpsw	x2, x3, [c6, #16]!      // encoding: [0xc2,0x0c,0xc2,0x69]
// CHECK: ldpsw	x2, x3, [csp, #-16]!     // encoding: [0xe2,0x0f,0xfe,0x69]
// CHECK: ldp  s10, s1, [c2, #64]!       // encoding: [0x4a,0x04,0xc8,0x2d]
// CHECK: ldp  d10, d1, [c2, #16]!       // encoding: [0x4a,0x04,0xc1,0x6d]

  stp    w3, w2, [c7, #16]!
  stp    x4, x9, [csp, #-16]!
  stp    s10, s1, [c2, #64]!
  stp    d10, d1, [c2, #16]!

// CHECK: stp  w3, w2, [c7, #16]!       // encoding: [0xe3,0x08,0x82,0x29]
// CHECK: stp  x4, x9, [csp, #-16]!      // encoding: [0xe4,0x27,0xbf,0xa9]
// CHECK: stp  s10, s1, [c2, #64]!       // encoding: [0x4a,0x04,0x88,0x2d]
// CHECK: stp  d10, d1, [c2, #16]!       // encoding: [0x4a,0x04,0x81,0x6d]

//-----------------------------------------------------------------------------
// Load/Store pair (post-indexed)
//-----------------------------------------------------------------------------

  ldp    w3, w2, [c24], #16
  ldp    x4, x9, [csp], #-16
  ldpsw  x2, x3, [c27], #16
  ldpsw  x2, x3, [csp], #-16
  ldp    s10, s1, [c2], #64
  ldp    d10, d1, [c2], #16

// CHECK: ldp  w3, w2, [c24], #16        // encoding: [0x03,0x0b,0xc2,0x28]
// CHECK: ldp  x4, x9, [csp], #-16        // encoding: [0xe4,0x27,0xff,0xa8]
// CHECK: ldpsw	x2, x3, [c27], #16       // encoding: [0x62,0x0f,0xc2,0x68]
// CHECK: ldpsw	x2, x3, [csp], #-16       // encoding: [0xe2,0x0f,0xfe,0x68]
// CHECK: ldp  s10, s1, [c2], #64        // encoding: [0x4a,0x04,0xc8,0x2c]
// CHECK: ldp  d10, d1, [c2], #16        // encoding: [0x4a,0x04,0xc1,0x6c]

  stp    w3, w2, [c5], #16
  stp    x4, x9, [csp], #-16
  stp    s10, s1, [c2], #64
  stp    d10, d1, [c2], #16

// CHECK: stp  w3, w2, [c5], #16        // encoding: [0xa3,0x08,0x82,0x28]
// CHECK: stp  x4, x9, [csp], #-16        // encoding: [0xe4,0x27,0xbf,0xa8]
// CHECK: stp  s10, s1, [c2], #64        // encoding: [0x4a,0x04,0x88,0x2c]
// CHECK: stp  d10, d1, [c2], #16        // encoding: [0x4a,0x04,0x81,0x6c]

//-----------------------------------------------------------------------------
// Load/Store pair (no-allocate)
//-----------------------------------------------------------------------------

  ldnp  w3, w2, [c7, #16]
  ldnp  x4, x9, [csp, #-16]
  ldnp  s10, s1, [c2, #64]
  ldnp  d10, d1, [c2]

// CHECK: ldnp  w3, w2, [c7, #16]       // encoding: [0xe3,0x08,0x42,0x28]
// CHECK: ldnp  x4, x9, [csp, #-16]       // encoding: [0xe4,0x27,0x7f,0xa8]
// CHECK: ldnp  s10, s1, [c2, #64]       // encoding: [0x4a,0x04,0x48,0x2c]
// CHECK: ldnp  d10, d1, [c2]            // encoding: [0x4a,0x04,0x40,0x6c]

  stnp  w3, w2, [c25, #16]
  stnp  x4, x9, [csp, #-16]
  stnp  s10, s1, [c2, #64]
  stnp  d10, d1, [c2]

// CHECK: stnp  w3, w2, [c25, #16]       // encoding: [0x23,0x0b,0x02,0x28]
// CHECK: stnp  x4, x9, [csp, #-16]       // encoding: [0xe4,0x27,0x3f,0xa8]
// CHECK: stnp  s10, s1, [c2, #64]       // encoding: [0x4a,0x04,0x08,0x2c]
// CHECK: stnp  d10, d1, [c2]            // encoding: [0x4a,0x04,0x00,0x6c]

//-----------------------------------------------------------------------------
// Load/Store exclusive
//-----------------------------------------------------------------------------

  ldxr   w6, [c1]
  ldxr   x6, [c1]
  ldxrb  w6, [c1]
  ldxrh  w6, [c1]
  ldxp   w7, w3, [c3]
  ldxp   x7, x3, [c3]

// CHECK: ldxrb  w6, [c1]                // encoding: [0x26,0x7c,0x5f,0x08]
// CHECK: ldxrh  w6, [c1]                // encoding: [0x26,0x7c,0x5f,0x48]
// CHECK: ldxp   w7, w3, [c3]            // encoding: [0x67,0x0c,0x7f,0x88]
// CHECK: ldxp   x7, x3, [c3]            // encoding: [0x67,0x0c,0x7f,0xc8]

  stxr   w1, x4, [c3]
  stxr   w1, w4, [c3]
  stxrb  w1, w4, [c3]
  stxrh  w1, w4, [c3]
  stxp   w1, x2, x6, [c1]
  stxp   w1, w2, w6, [c1]

// CHECK: stxr   w1, x4, [c3]            // encoding: [0x64,0x7c,0x01,0xc8]
// CHECK: stxr   w1, w4, [c3]            // encoding: [0x64,0x7c,0x01,0x88]
// CHECK: stxrb  w1, w4, [c3]            // encoding: [0x64,0x7c,0x01,0x08]
// CHECK: stxrh  w1, w4, [c3]            // encoding: [0x64,0x7c,0x01,0x48]
// CHECK: stxp   w1, x2, x6, [c1]        // encoding: [0x22,0x18,0x21,0xc8]
// CHECK: stxp   w1, w2, w6, [c1]        // encoding: [0x22,0x18,0x21,0x88]

//-----------------------------------------------------------------------------
// Load-acquire/Store-release non-exclusive
//-----------------------------------------------------------------------------

  ldar   w4, [csp]
  ldar   x4, [csp]
  ldarb  w4, [csp]
  ldarh  w4, [csp]

// CHECK: ldar   w4, [csp]                // encoding: [0xe4,0xff,0xdf,0x88]
// CHECK: ldar   x4, [csp]                // encoding: [0xe4,0xff,0xdf,0xc8]
// CHECK: ldarb  w4, [csp]                // encoding: [0xe4,0xff,0xdf,0x08]
// CHECK: ldarh  w4, [csp]                // encoding: [0xe4,0xff,0xdf,0x48]

  stlr   w3, [c6]
  stlr   x3, [c6]
  stlrb  w3, [c6]
  stlrh  w3, [c6]

// CHECK: stlr   w3, [c6]                // encoding: [0xc3,0xfc,0x9f,0x88]
// CHECK: stlr   x3, [c6]                // encoding: [0xc3,0xfc,0x9f,0xc8]
// CHECK: stlrb  w3, [c6]                // encoding: [0xc3,0xfc,0x9f,0x08]
// CHECK: stlrh  w3, [c6]                // encoding: [0xc3,0xfc,0x9f,0x48]

//-----------------------------------------------------------------------------
// Load-acquire/Store-release exclusive
//-----------------------------------------------------------------------------

  ldaxr   w2, [c4]
  ldaxr   x2, [c4]
// FIXME:  Instructions like ldaxrb  w2, [c4, #0] should also be matched
// (and would be matched in AArch64. However we currently don't allow this.
  ldaxrb  w2, [c4]
  ldaxrh  w2, [c4]
  ldaxp   w2, w6, [c1]
  ldaxp   x2, x6, [c1]

// CHECK: ldaxr   w2, [c4]               // encoding: [0x82,0xfc,0x5f,0x88]
// CHECK: ldaxr   x2, [c4]               // encoding: [0x82,0xfc,0x5f,0xc8]
// CHECK: ldaxrb  w2, [c4]               // encoding: [0x82,0xfc,0x5f,0x08]
// CHECK: ldaxrh  w2, [c4]               // encoding: [0x82,0xfc,0x5f,0x48]
// CHECK: ldaxp   w2, w6, [c1]           // encoding: [0x22,0x98,0x7f,0x88]
// CHECK: ldaxp   x2, x6, [c1]           // encoding: [0x22,0x98,0x7f,0xc8]

  stlxr   w8, x7, [c1]
  stlxr   w8, w7, [c1]
  stlxrb  w8, w7, [c1]
  stlxrh  w8, w7, [c1]
  stlxp   w1, x2, x6, [c1]
  stlxp   w1, w2, w6, [c1]

// CHECK: stlxr  w8, x7, [c1]            // encoding: [0x27,0xfc,0x08,0xc8]
// CHECK: stlxr  w8, w7, [c1]            // encoding: [0x27,0xfc,0x08,0x88]
// CHECK: stlxrb w8, w7, [c1]            // encoding: [0x27,0xfc,0x08,0x08]
// CHECK: stlxrh w8, w7, [c1]            // encoding: [0x27,0xfc,0x08,0x48]
// CHECK: stlxp  w1, x2, x6, [c1]        // encoding: [0x22,0x98,0x21,0xc8]
// CHECK: stlxp  w1, w2, w6, [c1]        // encoding: [0x22,0x98,0x21,0x88]

//-----------------------------------------------------------------------------
// Prefetch instructions
//-----------------------------------------------------------------------------

  prfm   #5, [csp, #32]
  prfm   #31, [csp, #32]
  prfm   pldl1keep, [c2]
  prfm   pldl1strm, [c2]
  prfm   pldl2keep, [c2]
  prfm   pldl2strm, [c2]
  prfm   pldl3keep, [c2]
  prfm   pldl3strm, [c2]
  prfm   pstl1keep, [c2]
  prfm   pstl1strm, [c2]
  prfm   pstl2keep, [c2]
  prfm   pstl2strm, [c2]
  prfm   pstl3keep, [c2]
  prfm   pstl3strm, [c2]
  prfm  pstl3strm, [c4, x5, lsl #3]
  prfum   #5, [csp, #32]

// CHECK: prfm   pldl3strm, [csp, #32]   // encoding: [0xe5,0x13,0x80,0xf9]
// CHECK: prfm	#31, [csp, #32]          // encoding: [0xff,0x13,0x80,0xf9]
// CHECK: prfm   pldl1keep, [c2]         // encoding: [0x40,0x00,0x80,0xf9]
// CHECK: prfm   pldl1strm, [c2]         // encoding: [0x41,0x00,0x80,0xf9]
// CHECK: prfm   pldl2keep, [c2]         // encoding: [0x42,0x00,0x80,0xf9]
// CHECK: prfm   pldl2strm, [c2]         // encoding: [0x43,0x00,0x80,0xf9]
// CHECK: prfm   pldl3keep, [c2]         // encoding: [0x44,0x00,0x80,0xf9]
// CHECK: prfm   pldl3strm, [c2]         // encoding: [0x45,0x00,0x80,0xf9]
// CHECK: prfm   pstl1keep, [c2]         // encoding: [0x50,0x00,0x80,0xf9]
// CHECK: prfm   pstl1strm, [c2]         // encoding: [0x51,0x00,0x80,0xf9]
// CHECK: prfm   pstl2keep, [c2]         // encoding: [0x52,0x00,0x80,0xf9]
// CHECK: prfm   pstl2strm, [c2]         // encoding: [0x53,0x00,0x80,0xf9]
// CHECK: prfm   pstl3keep, [c2]         // encoding: [0x54,0x00,0x80,0xf9]
// CHECK: prfm   pstl3strm, [c2]         // encoding: [0x55,0x00,0x80,0xf9]
// CHECK: prfm	pstl3strm, [c4, x5, lsl #3] // encoding: [0x95,0x78,0xa5,0xf8]
// CHECK: prfum   pldl3strm, [csp, #32]   // encoding: [0xe5,0x03,0x82,0xf8]


