// RUN: llvm-mc -triple=arm64 -mattr=+morello -show-encoding < %s | FileCheck %s
//
// Check that the assembler can handle the documented morello instructions

	ldar	c30, [c27]
	ldar	c30, [c4]
	ldar	c1, [c27]
	ldar	c1, [c4]
// CHECK:	ldar	c30, [c27]		// encoding: [0x7e,0x7f,0x5f,0x42]
// CHECK:	ldar	c30, [c4]		// encoding: [0x9e,0x7c,0x5f,0x42]
// CHECK:	ldar	c1, [c27]		// encoding: [0x61,0x7f,0x5f,0x42]
// CHECK:	ldar	c1, [c4]		// encoding: [0x81,0x7c,0x5f,0x42]

	stlr	c0, [c7]
	stlr	c0, [c24]
	stlr	czr, [c7]
	stlr	czr, [c24]
// CHECK:	stlr	c0, [c7]		// encoding: [0xe0,0x7c,0x1f,0x42]
// CHECK:	stlr	c0, [c24]		// encoding: [0x00,0x7f,0x1f,0x42]
// CHECK:	stlr	czr, [c7]		// encoding: [0xff,0x7c,0x1f,0x42]
// CHECK:	stlr	czr, [c24]		// encoding: [0x1f,0x7f,0x1f,0x42]

	ldarb	w29, [c28]
	ldarb	w29, [c3]
	ldarb	w2, [c28]
	ldarb	w2, [c3]
// CHECK:	ldarb	w29, [c28]		// encoding: [0x9d,0x7f,0x7f,0x42]
// CHECK:	ldarb	w29, [c3]		// encoding: [0x7d,0x7c,0x7f,0x42]
// CHECK:	ldarb	w2, [c28]		// encoding: [0x82,0x7f,0x7f,0x42]
// CHECK:	ldarb	w2, [c3]		// encoding: [0x62,0x7c,0x7f,0x42]

	ldrb	w20, [c24, #392]
	ldrb	w20, [c24, #119]
	ldrb	w20, [c7, #392]
	ldrb	w20, [c7, #119]
	ldrb	w10, [c24, #392]
	ldrb	w10, [c24, #119]
	ldrb	w10, [c7, #392]
	ldrb	w10, [c7, #119]
// CHECK:	ldrb	w20, [c24, #392]		// encoding: [0x14,0x87,0x78,0x82]
// CHECK:	ldrb	w20, [c24, #119]		// encoding: [0x14,0x77,0x67,0x82]
// CHECK:	ldrb	w20, [c7, #392]		// encoding: [0xf4,0x84,0x78,0x82]
// CHECK:	ldrb	w20, [c7, #119]		// encoding: [0xf4,0x74,0x67,0x82]
// CHECK:	ldrb	w10, [c24, #392]		// encoding: [0x0a,0x87,0x78,0x82]
// CHECK:	ldrb	w10, [c24, #119]		// encoding: [0x0a,0x77,0x67,0x82]
// CHECK:	ldrb	w10, [c7, #392]		// encoding: [0xea,0x84,0x78,0x82]
// CHECK:	ldrb	w10, [c7, #119]		// encoding: [0xea,0x74,0x67,0x82]

	ldurb	w7, [c0, #147]
	ldurb	w7, [c0, #-148]
	ldurb	w7, [csp, #147]
	ldurb	w7, [csp, #-148]
	ldurb	w24, [c0, #147]
	ldurb	w24, [c0, #-148]
	ldurb	w24, [csp, #147]
	ldurb	w24, [csp, #-148]
// CHECK:	ldurb	w7, [c0, #147]		// encoding: [0x07,0x34,0x09,0xe2]
// CHECK:	ldurb	w7, [c0, #-148]		// encoding: [0x07,0xc4,0x16,0xe2]
// CHECK:	ldurb	w7, [csp, #147]		// encoding: [0xe7,0x37,0x09,0xe2]
// CHECK:	ldurb	w7, [csp, #-148]		// encoding: [0xe7,0xc7,0x16,0xe2]
// CHECK:	ldurb	w24, [c0, #147]		// encoding: [0x18,0x34,0x09,0xe2]
// CHECK:	ldurb	w24, [c0, #-148]		// encoding: [0x18,0xc4,0x16,0xe2]
// CHECK:	ldurb	w24, [csp, #147]		// encoding: [0xf8,0x37,0x09,0xe2]
// CHECK:	ldurb	w24, [csp, #-148]		// encoding: [0xf8,0xc7,0x16,0xe2]

	ldr	c2, [c28, #5040]
	ldr	c2, [c28, #3136]
	ldr	c2, [c3, #5040]
	ldr	c2, [c3, #3136]
	ldr	c29, [c28, #5040]
	ldr	c29, [c28, #3136]
	ldr	c29, [c3, #5040]
	ldr	c29, [c3, #3136]
// CHECK:	ldr	c2, [c28, #5040]		// encoding: [0x82,0xb3,0x73,0x82]
// CHECK:	ldr	c2, [c28, #3136]		// encoding: [0x82,0x43,0x6c,0x82]
// CHECK:	ldr	c2, [c3, #5040]		// encoding: [0x62,0xb0,0x73,0x82]
// CHECK:	ldr	c2, [c3, #3136]		// encoding: [0x62,0x40,0x6c,0x82]
// CHECK:	ldr	c29, [c28, #5040]		// encoding: [0x9d,0xb3,0x73,0x82]
// CHECK:	ldr	c29, [c28, #3136]		// encoding: [0x9d,0x43,0x6c,0x82]
// CHECK:	ldr	c29, [c3, #5040]		// encoding: [0x7d,0xb0,0x73,0x82]
// CHECK:	ldr	c29, [c3, #3136]		// encoding: [0x7d,0x40,0x6c,0x82]

	ldur	c1, [c1, #-198]
	ldur	c1, [c1, #197]
	ldur	c1, [c30, #-198]
	ldur	c1, [c30, #197]
	ldur	c30, [c1, #-198]
	ldur	c30, [c1, #197]
	ldur	c30, [c30, #-198]
	ldur	c30, [c30, #197]
// CHECK:	ldur	c1, [c1, #-198]		// encoding: [0x21,0xac,0xd3,0xe2]
// CHECK:	ldur	c1, [c1, #197]		// encoding: [0x21,0x5c,0xcc,0xe2]
// CHECK:	ldur	c1, [c30, #-198]		// encoding: [0xc1,0xaf,0xd3,0xe2]
// CHECK:	ldur	c1, [c30, #197]		// encoding: [0xc1,0x5f,0xcc,0xe2]
// CHECK:	ldur	c30, [c1, #-198]		// encoding: [0x3e,0xac,0xd3,0xe2]
// CHECK:	ldur	c30, [c1, #197]		// encoding: [0x3e,0x5c,0xcc,0xe2]
// CHECK:	ldur	c30, [c30, #-198]		// encoding: [0xde,0xaf,0xd3,0xe2]
// CHECK:	ldur	c30, [c30, #197]		// encoding: [0xde,0x5f,0xcc,0xe2]

	ldr	x0, [c27, #3952]
	ldr	x0, [c27, #136]
	ldr	x0, [c4, #3952]
	ldr	x0, [c4, #136]
	ldr	x30, [c27, #3952]
	ldr	x30, [c27, #136]
	ldr	x30, [c4, #3952]
	ldr	x30, [c4, #136]
// CHECK:	ldr	x0, [c27, #3952]		// encoding: [0x60,0xef,0x7e,0x82]
// CHECK:	ldr	x0, [c27, #136]		// encoding: [0x60,0x1f,0x61,0x82]
// CHECK:	ldr	x0, [c4, #3952]		// encoding: [0x80,0xec,0x7e,0x82]
// CHECK:	ldr	x0, [c4, #136]		// encoding: [0x80,0x1c,0x61,0x82]
// CHECK:	ldr	x30, [c27, #3952]		// encoding: [0x7e,0xef,0x7e,0x82]
// CHECK:	ldr	x30, [c27, #136]		// encoding: [0x7e,0x1f,0x61,0x82]
// CHECK:	ldr	x30, [c4, #3952]		// encoding: [0x9e,0xec,0x7e,0x82]
// CHECK:	ldr	x30, [c4, #136]		// encoding: [0x9e,0x1c,0x61,0x82]

	ldur	x2, [c4, #-18]
	ldur	x2, [c4, #17]
	ldur	x2, [c27, #-18]
	ldur	x2, [c27, #17]
	ldur	x28, [c4, #-18]
	ldur	x28, [c4, #17]
	ldur	x28, [c27, #-18]
	ldur	x28, [c27, #17]
// CHECK:	ldur	x2, [c4, #-18]		// encoding: [0x82,0xe4,0xde,0xe2]
// CHECK:	ldur	x2, [c4, #17]		// encoding: [0x82,0x14,0xc1,0xe2]
// CHECK:	ldur	x2, [c27, #-18]		// encoding: [0x62,0xe7,0xde,0xe2]
// CHECK:	ldur	x2, [c27, #17]		// encoding: [0x62,0x17,0xc1,0xe2]
// CHECK:	ldur	x28, [c4, #-18]		// encoding: [0x9c,0xe4,0xde,0xe2]
// CHECK:	ldur	x28, [c4, #17]		// encoding: [0x9c,0x14,0xc1,0xe2]
// CHECK:	ldur	x28, [c27, #-18]		// encoding: [0x7c,0xe7,0xde,0xe2]
// CHECK:	ldur	x28, [c27, #17]		// encoding: [0x7c,0x17,0xc1,0xe2]

	ldur	b19, [c24, #40]
	ldur	b19, [c24, #-41]
	ldur	b19, [c7, #40]
	ldur	b19, [c7, #-41]
	ldur	b12, [c24, #40]
	ldur	b12, [c24, #-41]
	ldur	b12, [c7, #40]
	ldur	b12, [c7, #-41]
// CHECK:	ldur	b19, [c24, #40]		// encoding: [0x13,0x87,0x22,0xe2]
// CHECK:	ldur	b19, [c24, #-41]		// encoding: [0x13,0x77,0x3d,0xe2]
// CHECK:	ldur	b19, [c7, #40]		// encoding: [0xf3,0x84,0x22,0xe2]
// CHECK:	ldur	b19, [c7, #-41]		// encoding: [0xf3,0x74,0x3d,0xe2]
// CHECK:	ldur	b12, [c24, #40]		// encoding: [0x0c,0x87,0x22,0xe2]
// CHECK:	ldur	b12, [c24, #-41]		// encoding: [0x0c,0x77,0x3d,0xe2]
// CHECK:	ldur	b12, [c7, #40]		// encoding: [0xec,0x84,0x22,0xe2]
// CHECK:	ldur	b12, [c7, #-41]		// encoding: [0xec,0x74,0x3d,0xe2]

	ldur	d8, [c4, #74]
	ldur	d8, [c4, #-75]
	ldur	d8, [c27, #74]
	ldur	d8, [c27, #-75]
	ldur	d23, [c4, #74]
	ldur	d23, [c4, #-75]
	ldur	d23, [c27, #74]
	ldur	d23, [c27, #-75]
// CHECK:	ldur	d8, [c4, #74]		// encoding: [0x88,0xa4,0xe4,0xe2]
// CHECK:	ldur	d8, [c4, #-75]		// encoding: [0x88,0x54,0xfb,0xe2]
// CHECK:	ldur	d8, [c27, #74]		// encoding: [0x68,0xa7,0xe4,0xe2]
// CHECK:	ldur	d8, [c27, #-75]		// encoding: [0x68,0x57,0xfb,0xe2]
// CHECK:	ldur	d23, [c4, #74]		// encoding: [0x97,0xa4,0xe4,0xe2]
// CHECK:	ldur	d23, [c4, #-75]		// encoding: [0x97,0x54,0xfb,0xe2]
// CHECK:	ldur	d23, [c27, #74]		// encoding: [0x77,0xa7,0xe4,0xe2]
// CHECK:	ldur	d23, [c27, #-75]		// encoding: [0x77,0x57,0xfb,0xe2]

	ldur	h15, [c26, #-129]
	ldur	h15, [c26, #128]
	ldur	h15, [c5, #-129]
	ldur	h15, [c5, #128]
	ldur	h16, [c26, #-129]
	ldur	h16, [c26, #128]
	ldur	h16, [c5, #-129]
	ldur	h16, [c5, #128]
// CHECK:	ldur	h15, [c26, #-129]		// encoding: [0x4f,0xf7,0x77,0xe2]
// CHECK:	ldur	h15, [c26, #128]		// encoding: [0x4f,0x07,0x68,0xe2]
// CHECK:	ldur	h15, [c5, #-129]		// encoding: [0xaf,0xf4,0x77,0xe2]
// CHECK:	ldur	h15, [c5, #128]		// encoding: [0xaf,0x04,0x68,0xe2]
// CHECK:	ldur	h16, [c26, #-129]		// encoding: [0x50,0xf7,0x77,0xe2]
// CHECK:	ldur	h16, [c26, #128]		// encoding: [0x50,0x07,0x68,0xe2]
// CHECK:	ldur	h16, [c5, #-129]		// encoding: [0xb0,0xf4,0x77,0xe2]
// CHECK:	ldur	h16, [c5, #128]		// encoding: [0xb0,0x04,0x68,0xe2]

	ldur	q29, [c27, #15]
	ldur	q29, [c27, #-16]
	ldur	q29, [c4, #15]
	ldur	q29, [c4, #-16]
	ldur	q2, [c27, #15]
	ldur	q2, [c27, #-16]
	ldur	q2, [c4, #15]
	ldur	q2, [c4, #-16]
// CHECK:	ldur	q29, [c27, #15]		// encoding: [0x7d,0xff,0x20,0xe2]
// CHECK:	ldur	q29, [c27, #-16]		// encoding: [0x7d,0x0f,0x3f,0xe2]
// CHECK:	ldur	q29, [c4, #15]		// encoding: [0x9d,0xfc,0x20,0xe2]
// CHECK:	ldur	q29, [c4, #-16]		// encoding: [0x9d,0x0c,0x3f,0xe2]
// CHECK:	ldur	q2, [c27, #15]		// encoding: [0x62,0xff,0x20,0xe2]
// CHECK:	ldur	q2, [c27, #-16]		// encoding: [0x62,0x0f,0x3f,0xe2]
// CHECK:	ldur	q2, [c4, #15]		// encoding: [0x82,0xfc,0x20,0xe2]
// CHECK:	ldur	q2, [c4, #-16]		// encoding: [0x82,0x0c,0x3f,0xe2]

	ldur	s0, [c4, #-254]
	ldur	s0, [c4, #253]
	ldur	s0, [c27, #-254]
	ldur	s0, [c27, #253]
	ldur	s31, [c4, #-254]
	ldur	s31, [c4, #253]
	ldur	s31, [c27, #-254]
	ldur	s31, [c27, #253]
// CHECK:	ldur	s0, [c4, #-254]		// encoding: [0x80,0x24,0xb0,0xe2]
// CHECK:	ldur	s0, [c4, #253]		// encoding: [0x80,0xd4,0xaf,0xe2]
// CHECK:	ldur	s0, [c27, #-254]		// encoding: [0x60,0x27,0xb0,0xe2]
// CHECK:	ldur	s0, [c27, #253]		// encoding: [0x60,0xd7,0xaf,0xe2]
// CHECK:	ldur	s31, [c4, #-254]		// encoding: [0x9f,0x24,0xb0,0xe2]
// CHECK:	ldur	s31, [c4, #253]		// encoding: [0x9f,0xd4,0xaf,0xe2]
// CHECK:	ldur	s31, [c27, #-254]		// encoding: [0x7f,0x27,0xb0,0xe2]
// CHECK:	ldur	s31, [c27, #253]		// encoding: [0x7f,0xd7,0xaf,0xe2]

	ldurh	w4, [c27, #-63]
	ldurh	w4, [c27, #62]
	ldurh	w4, [c4, #-63]
	ldurh	w4, [c4, #62]
	ldurh	w26, [c27, #-63]
	ldurh	w26, [c27, #62]
	ldurh	w26, [c4, #-63]
	ldurh	w26, [c4, #62]
// CHECK:	ldurh	w4, [c27, #-63]		// encoding: [0x64,0x17,0x5c,0xe2]
// CHECK:	ldurh	w4, [c27, #62]		// encoding: [0x64,0xe7,0x43,0xe2]
// CHECK:	ldurh	w4, [c4, #-63]		// encoding: [0x84,0x14,0x5c,0xe2]
// CHECK:	ldurh	w4, [c4, #62]		// encoding: [0x84,0xe4,0x43,0xe2]
// CHECK:	ldurh	w26, [c27, #-63]		// encoding: [0x7a,0x17,0x5c,0xe2]
// CHECK:	ldurh	w26, [c27, #62]		// encoding: [0x7a,0xe7,0x43,0xe2]
// CHECK:	ldurh	w26, [c4, #-63]		// encoding: [0x9a,0x14,0x5c,0xe2]
// CHECK:	ldurh	w26, [c4, #62]		// encoding: [0x9a,0xe4,0x43,0xe2]

	ldursb	x1, [c28, #-173]
	ldursb	x1, [c28, #172]
	ldursb	x1, [c3, #-173]
	ldursb	x1, [c3, #172]
	ldursb	x30, [c28, #-173]
	ldursb	x30, [c28, #172]
	ldursb	x30, [c3, #-173]
	ldursb	x30, [c3, #172]
// CHECK:	ldursb	x1, [c28, #-173]		// encoding: [0x81,0x3b,0x15,0xe2]
// CHECK:	ldursb	x1, [c28, #172]		// encoding: [0x81,0xcb,0x0a,0xe2]
// CHECK:	ldursb	x1, [c3, #-173]		// encoding: [0x61,0x38,0x15,0xe2]
// CHECK:	ldursb	x1, [c3, #172]		// encoding: [0x61,0xc8,0x0a,0xe2]
// CHECK:	ldursb	x30, [c28, #-173]		// encoding: [0x9e,0x3b,0x15,0xe2]
// CHECK:	ldursb	x30, [c28, #172]		// encoding: [0x9e,0xcb,0x0a,0xe2]
// CHECK:	ldursb	x30, [c3, #-173]		// encoding: [0x7e,0x38,0x15,0xe2]
// CHECK:	ldursb	x30, [c3, #172]		// encoding: [0x7e,0xc8,0x0a,0xe2]

	ldursb	w17, [c1, #223]
	ldursb	w17, [c1, #-224]
	ldursb	w17, [c30, #223]
	ldursb	w17, [c30, #-224]
	ldursb	w14, [c1, #223]
	ldursb	w14, [c1, #-224]
	ldursb	w14, [c30, #223]
	ldursb	w14, [c30, #-224]
// CHECK:	ldursb	w17, [c1, #223]		// encoding: [0x31,0xfc,0x0d,0xe2]
// CHECK:	ldursb	w17, [c1, #-224]		// encoding: [0x31,0x0c,0x12,0xe2]
// CHECK:	ldursb	w17, [c30, #223]		// encoding: [0xd1,0xff,0x0d,0xe2]
// CHECK:	ldursb	w17, [c30, #-224]		// encoding: [0xd1,0x0f,0x12,0xe2]
// CHECK:	ldursb	w14, [c1, #223]		// encoding: [0x2e,0xfc,0x0d,0xe2]
// CHECK:	ldursb	w14, [c1, #-224]		// encoding: [0x2e,0x0c,0x12,0xe2]
// CHECK:	ldursb	w14, [c30, #223]		// encoding: [0xce,0xff,0x0d,0xe2]
// CHECK:	ldursb	w14, [c30, #-224]		// encoding: [0xce,0x0f,0x12,0xe2]

	ldursh	x23, [csp, #-184]
	ldursh	x23, [csp, #183]
	ldursh	x23, [c0, #-184]
	ldursh	x23, [c0, #183]
	ldursh	x8, [csp, #-184]
	ldursh	x8, [csp, #183]
	ldursh	x8, [c0, #-184]
	ldursh	x8, [c0, #183]
// CHECK:	ldursh	x23, [csp, #-184]		// encoding: [0xf7,0x8b,0x54,0xe2]
// CHECK:	ldursh	x23, [csp, #183]		// encoding: [0xf7,0x7b,0x4b,0xe2]
// CHECK:	ldursh	x23, [c0, #-184]		// encoding: [0x17,0x88,0x54,0xe2]
// CHECK:	ldursh	x23, [c0, #183]		// encoding: [0x17,0x78,0x4b,0xe2]
// CHECK:	ldursh	x8, [csp, #-184]		// encoding: [0xe8,0x8b,0x54,0xe2]
// CHECK:	ldursh	x8, [csp, #183]		// encoding: [0xe8,0x7b,0x4b,0xe2]
// CHECK:	ldursh	x8, [c0, #-184]		// encoding: [0x08,0x88,0x54,0xe2]
// CHECK:	ldursh	x8, [c0, #183]		// encoding: [0x08,0x78,0x4b,0xe2]

	ldursh	w9, [c0, #-115]
	ldursh	w9, [c0, #114]
	ldursh	w9, [csp, #-115]
	ldursh	w9, [csp, #114]
	ldursh	w22, [c0, #-115]
	ldursh	w22, [c0, #114]
	ldursh	w22, [csp, #-115]
	ldursh	w22, [csp, #114]
// CHECK:	ldursh	w9, [c0, #-115]		// encoding: [0x09,0xdc,0x58,0xe2]
// CHECK:	ldursh	w9, [c0, #114]		// encoding: [0x09,0x2c,0x47,0xe2]
// CHECK:	ldursh	w9, [csp, #-115]		// encoding: [0xe9,0xdf,0x58,0xe2]
// CHECK:	ldursh	w9, [csp, #114]		// encoding: [0xe9,0x2f,0x47,0xe2]
// CHECK:	ldursh	w22, [c0, #-115]		// encoding: [0x16,0xdc,0x58,0xe2]
// CHECK:	ldursh	w22, [c0, #114]		// encoding: [0x16,0x2c,0x47,0xe2]
// CHECK:	ldursh	w22, [csp, #-115]		// encoding: [0xf6,0xdf,0x58,0xe2]
// CHECK:	ldursh	w22, [csp, #114]		// encoding: [0xf6,0x2f,0x47,0xe2]

	ldursw	x25, [c1, #-177]
	ldursw	x25, [c1, #176]
	ldursw	x25, [c30, #-177]
	ldursw	x25, [c30, #176]
	ldursw	x6, [c1, #-177]
	ldursw	x6, [c1, #176]
	ldursw	x6, [c30, #-177]
	ldursw	x6, [c30, #176]
// CHECK:	ldursw	x25, [c1, #-177]		// encoding: [0x39,0xf8,0x94,0xe2]
// CHECK:	ldursw	x25, [c1, #176]		// encoding: [0x39,0x08,0x8b,0xe2]
// CHECK:	ldursw	x25, [c30, #-177]		// encoding: [0xd9,0xfb,0x94,0xe2]
// CHECK:	ldursw	x25, [c30, #176]		// encoding: [0xd9,0x0b,0x8b,0xe2]
// CHECK:	ldursw	x6, [c1, #-177]		// encoding: [0x26,0xf8,0x94,0xe2]
// CHECK:	ldursw	x6, [c1, #176]		// encoding: [0x26,0x08,0x8b,0xe2]
// CHECK:	ldursw	x6, [c30, #-177]		// encoding: [0xc6,0xfb,0x94,0xe2]
// CHECK:	ldursw	x6, [c30, #176]		// encoding: [0xc6,0x0b,0x8b,0xe2]

	ldar	w29, [c1]
	ldar	w29, [c30]
	ldar	w2, [c1]
	ldar	w2, [c30]
// CHECK:	ldar	w29, [c1]		// encoding: [0x3d,0xfc,0x7f,0x42]
// CHECK:	ldar	w29, [c30]		// encoding: [0xdd,0xff,0x7f,0x42]
// CHECK:	ldar	w2, [c1]		// encoding: [0x22,0xfc,0x7f,0x42]
// CHECK:	ldar	w2, [c30]		// encoding: [0xc2,0xff,0x7f,0x42]

	ldr	w25, [c0, #788]
	ldr	w25, [c0, #1256]
	ldr	w25, [csp, #788]
	ldr	w25, [csp, #1256]
	ldr	w6, [c0, #788]
	ldr	w6, [c0, #1256]
	ldr	w6, [csp, #788]
	ldr	w6, [csp, #1256]
// CHECK:	ldr	w25, [c0, #788]		// encoding: [0x19,0x58,0x6c,0x82]
// CHECK:	ldr	w25, [c0, #1256]		// encoding: [0x19,0xa8,0x73,0x82]
// CHECK:	ldr	w25, [csp, #788]		// encoding: [0xf9,0x5b,0x6c,0x82]
// CHECK:	ldr	w25, [csp, #1256]		// encoding: [0xf9,0xab,0x73,0x82]
// CHECK:	ldr	w6, [c0, #788]		// encoding: [0x06,0x58,0x6c,0x82]
// CHECK:	ldr	w6, [c0, #1256]		// encoding: [0x06,0xa8,0x73,0x82]
// CHECK:	ldr	w6, [csp, #788]		// encoding: [0xe6,0x5b,0x6c,0x82]
// CHECK:	ldr	w6, [csp, #1256]		// encoding: [0xe6,0xab,0x73,0x82]

	ldur	w10, [c26, #162]
	ldur	w10, [c26, #-163]
	ldur	w10, [c5, #162]
	ldur	w10, [c5, #-163]
	ldur	w20, [c26, #162]
	ldur	w20, [c26, #-163]
	ldur	w20, [c5, #162]
	ldur	w20, [c5, #-163]
// CHECK:	ldur	w10, [c26, #162]		// encoding: [0x4a,0x27,0x8a,0xe2]
// CHECK:	ldur	w10, [c26, #-163]		// encoding: [0x4a,0xd7,0x95,0xe2]
// CHECK:	ldur	w10, [c5, #162]		// encoding: [0xaa,0x24,0x8a,0xe2]
// CHECK:	ldur	w10, [c5, #-163]		// encoding: [0xaa,0xd4,0x95,0xe2]
// CHECK:	ldur	w20, [c26, #162]		// encoding: [0x54,0x27,0x8a,0xe2]
// CHECK:	ldur	w20, [c26, #-163]		// encoding: [0x54,0xd7,0x95,0xe2]
// CHECK:	ldur	w20, [c5, #162]		// encoding: [0xb4,0x24,0x8a,0xe2]
// CHECK:	ldur	w20, [c5, #-163]		// encoding: [0xb4,0xd4,0x95,0xe2]

	strb	w15, [c6, #241]
	strb	w15, [c6, #270]
	strb	w15, [c25, #241]
	strb	w15, [c25, #270]
	strb	w16, [c6, #241]
	strb	w16, [c6, #270]
	strb	w16, [c25, #241]
	strb	w16, [c25, #270]
// CHECK:	strb	w15, [c6, #241]		// encoding: [0xcf,0x14,0x4f,0x82]
// CHECK:	strb	w15, [c6, #270]		// encoding: [0xcf,0xe4,0x50,0x82]
// CHECK:	strb	w15, [c25, #241]		// encoding: [0x2f,0x17,0x4f,0x82]
// CHECK:	strb	w15, [c25, #270]		// encoding: [0x2f,0xe7,0x50,0x82]
// CHECK:	strb	w16, [c6, #241]		// encoding: [0xd0,0x14,0x4f,0x82]
// CHECK:	strb	w16, [c6, #270]		// encoding: [0xd0,0xe4,0x50,0x82]
// CHECK:	strb	w16, [c25, #241]		// encoding: [0x30,0x17,0x4f,0x82]
// CHECK:	strb	w16, [c25, #270]		// encoding: [0x30,0xe7,0x50,0x82]

	sturb	w26, [c7, #-31]
	sturb	w26, [c7, #30]
	sturb	w26, [c24, #-31]
	sturb	w26, [c24, #30]
	sturb	w5, [c7, #-31]
	sturb	w5, [c7, #30]
	sturb	w5, [c24, #-31]
	sturb	w5, [c24, #30]
// CHECK:	sturb	w26, [c7, #-31]		// encoding: [0xfa,0x10,0x1e,0xe2]
// CHECK:	sturb	w26, [c7, #30]		// encoding: [0xfa,0xe0,0x01,0xe2]
// CHECK:	sturb	w26, [c24, #-31]		// encoding: [0x1a,0x13,0x1e,0xe2]
// CHECK:	sturb	w26, [c24, #30]		// encoding: [0x1a,0xe3,0x01,0xe2]
// CHECK:	sturb	w5, [c7, #-31]		// encoding: [0xe5,0x10,0x1e,0xe2]
// CHECK:	sturb	w5, [c7, #30]		// encoding: [0xe5,0xe0,0x01,0xe2]
// CHECK:	sturb	w5, [c24, #-31]		// encoding: [0x05,0x13,0x1e,0xe2]
// CHECK:	sturb	w5, [c24, #30]		// encoding: [0x05,0xe3,0x01,0xe2]

	stlrb	w24, [c30]
	stlrb	w24, [c1]
	stlrb	w7, [c30]
	stlrb	w7, [c1]
// CHECK:	stlrb	w24, [c30]		// encoding: [0xd8,0x7f,0x3f,0x42]
// CHECK:	stlrb	w24, [c1]		// encoding: [0x38,0x7c,0x3f,0x42]
// CHECK:	stlrb	w7, [c30]		// encoding: [0xc7,0x7f,0x3f,0x42]
// CHECK:	stlrb	w7, [c1]		// encoding: [0x27,0x7c,0x3f,0x42]

	str	c2, [c24, #1520]
	str	c2, [c24, #6656]
	str	c2, [c7, #1520]
	str	c2, [c7, #6656]
	str	c29, [c24, #1520]
	str	c29, [c24, #6656]
	str	c29, [c7, #1520]
	str	c29, [c7, #6656]
// CHECK:	str	c2, [c24, #1520]		// encoding: [0x02,0xf3,0x45,0x82]
// CHECK:	str	c2, [c24, #6656]		// encoding: [0x02,0x03,0x5a,0x82]
// CHECK:	str	c2, [c7, #1520]		// encoding: [0xe2,0xf0,0x45,0x82]
// CHECK:	str	c2, [c7, #6656]		// encoding: [0xe2,0x00,0x5a,0x82]
// CHECK:	str	c29, [c24, #1520]		// encoding: [0x1d,0xf3,0x45,0x82]
// CHECK:	str	c29, [c24, #6656]		// encoding: [0x1d,0x03,0x5a,0x82]
// CHECK:	str	c29, [c7, #1520]		// encoding: [0xfd,0xf0,0x45,0x82]
// CHECK:	str	c29, [c7, #6656]		// encoding: [0xfd,0x00,0x5a,0x82]

	stur	c3, [c24, #15]
	stur	c3, [c24, #-16]
	stur	c3, [c7, #15]
	stur	c3, [c7, #-16]
	stur	c28, [c24, #15]
	stur	c28, [c24, #-16]
	stur	c28, [c7, #15]
	stur	c28, [c7, #-16]
// CHECK:	stur	c3, [c24, #15]		// encoding: [0x03,0xff,0x80,0xe2]
// CHECK:	stur	c3, [c24, #-16]		// encoding: [0x03,0x0f,0x9f,0xe2]
// CHECK:	stur	c3, [c7, #15]		// encoding: [0xe3,0xfc,0x80,0xe2]
// CHECK:	stur	c3, [c7, #-16]		// encoding: [0xe3,0x0c,0x9f,0xe2]
// CHECK:	stur	c28, [c24, #15]		// encoding: [0x1c,0xff,0x80,0xe2]
// CHECK:	stur	c28, [c24, #-16]		// encoding: [0x1c,0x0f,0x9f,0xe2]
// CHECK:	stur	c28, [c7, #15]		// encoding: [0xfc,0xfc,0x80,0xe2]
// CHECK:	stur	c28, [c7, #-16]		// encoding: [0xfc,0x0c,0x9f,0xe2]

	str	x26, [c27, #3344]
	str	x26, [c27, #744]
	str	x26, [c4, #3344]
	str	x26, [c4, #744]
	str	x5, [c27, #3344]
	str	x5, [c27, #744]
	str	x5, [c4, #3344]
	str	x5, [c4, #744]
// CHECK:	str	x26, [c27, #3344]		// encoding: [0x7a,0x2f,0x5a,0x82]
// CHECK:	str	x26, [c27, #744]		// encoding: [0x7a,0xdf,0x45,0x82]
// CHECK:	str	x26, [c4, #3344]		// encoding: [0x9a,0x2c,0x5a,0x82]
// CHECK:	str	x26, [c4, #744]		// encoding: [0x9a,0xdc,0x45,0x82]
// CHECK:	str	x5, [c27, #3344]		// encoding: [0x65,0x2f,0x5a,0x82]
// CHECK:	str	x5, [c27, #744]		// encoding: [0x65,0xdf,0x45,0x82]
// CHECK:	str	x5, [c4, #3344]		// encoding: [0x85,0x2c,0x5a,0x82]
// CHECK:	str	x5, [c4, #744]		// encoding: [0x85,0xdc,0x45,0x82]

	stur	x21, [c5, #-80]
	stur	x21, [c5, #79]
	stur	x21, [c26, #-80]
	stur	x21, [c26, #79]
	stur	x10, [c5, #-80]
	stur	x10, [c5, #79]
	stur	x10, [c26, #-80]
	stur	x10, [c26, #79]
// CHECK:	stur	x21, [c5, #-80]		// encoding: [0xb5,0x00,0xdb,0xe2]
// CHECK:	stur	x21, [c5, #79]		// encoding: [0xb5,0xf0,0xc4,0xe2]
// CHECK:	stur	x21, [c26, #-80]		// encoding: [0x55,0x03,0xdb,0xe2]
// CHECK:	stur	x21, [c26, #79]		// encoding: [0x55,0xf3,0xc4,0xe2]
// CHECK:	stur	x10, [c5, #-80]		// encoding: [0xaa,0x00,0xdb,0xe2]
// CHECK:	stur	x10, [c5, #79]		// encoding: [0xaa,0xf0,0xc4,0xe2]
// CHECK:	stur	x10, [c26, #-80]		// encoding: [0x4a,0x03,0xdb,0xe2]
// CHECK:	stur	x10, [c26, #79]		// encoding: [0x4a,0xf3,0xc4,0xe2]

	stur	b22, [c6, #-176]
	stur	b22, [c6, #175]
	stur	b22, [c25, #-176]
	stur	b22, [c25, #175]
	stur	b9, [c6, #-176]
	stur	b9, [c6, #175]
	stur	b9, [c25, #-176]
	stur	b9, [c25, #175]
// CHECK:	stur	b22, [c6, #-176]		// encoding: [0xd6,0x00,0x35,0xe2]
// CHECK:	stur	b22, [c6, #175]		// encoding: [0xd6,0xf0,0x2a,0xe2]
// CHECK:	stur	b22, [c25, #-176]		// encoding: [0x36,0x03,0x35,0xe2]
// CHECK:	stur	b22, [c25, #175]		// encoding: [0x36,0xf3,0x2a,0xe2]
// CHECK:	stur	b9, [c6, #-176]		// encoding: [0xc9,0x00,0x35,0xe2]
// CHECK:	stur	b9, [c6, #175]		// encoding: [0xc9,0xf0,0x2a,0xe2]
// CHECK:	stur	b9, [c25, #-176]		// encoding: [0x29,0x03,0x35,0xe2]
// CHECK:	stur	b9, [c25, #175]		// encoding: [0x29,0xf3,0x2a,0xe2]

	stur	d29, [c2, #-177]
	stur	d29, [c2, #176]
	stur	d29, [c29, #-177]
	stur	d29, [c29, #176]
	stur	d2, [c2, #-177]
	stur	d2, [c2, #176]
	stur	d2, [c29, #-177]
	stur	d2, [c29, #176]
// CHECK:	stur	d29, [c2, #-177]		// encoding: [0x5d,0xf0,0xf4,0xe2]
// CHECK:	stur	d29, [c2, #176]		// encoding: [0x5d,0x00,0xeb,0xe2]
// CHECK:	stur	d29, [c29, #-177]		// encoding: [0xbd,0xf3,0xf4,0xe2]
// CHECK:	stur	d29, [c29, #176]		// encoding: [0xbd,0x03,0xeb,0xe2]
// CHECK:	stur	d2, [c2, #-177]		// encoding: [0x42,0xf0,0xf4,0xe2]
// CHECK:	stur	d2, [c2, #176]		// encoding: [0x42,0x00,0xeb,0xe2]
// CHECK:	stur	d2, [c29, #-177]		// encoding: [0xa2,0xf3,0xf4,0xe2]
// CHECK:	stur	d2, [c29, #176]		// encoding: [0xa2,0x03,0xeb,0xe2]

	stur	h26, [c29, #150]
	stur	h26, [c29, #-151]
	stur	h26, [c2, #150]
	stur	h26, [c2, #-151]
	stur	h5, [c29, #150]
	stur	h5, [c29, #-151]
	stur	h5, [c2, #150]
	stur	h5, [c2, #-151]
// CHECK:	stur	h26, [c29, #150]		// encoding: [0xba,0x63,0x69,0xe2]
// CHECK:	stur	h26, [c29, #-151]		// encoding: [0xba,0x93,0x76,0xe2]
// CHECK:	stur	h26, [c2, #150]		// encoding: [0x5a,0x60,0x69,0xe2]
// CHECK:	stur	h26, [c2, #-151]		// encoding: [0x5a,0x90,0x76,0xe2]
// CHECK:	stur	h5, [c29, #150]		// encoding: [0xa5,0x63,0x69,0xe2]
// CHECK:	stur	h5, [c29, #-151]		// encoding: [0xa5,0x93,0x76,0xe2]
// CHECK:	stur	h5, [c2, #150]		// encoding: [0x45,0x60,0x69,0xe2]
// CHECK:	stur	h5, [c2, #-151]		// encoding: [0x45,0x90,0x76,0xe2]

	stur	q14, [c24, #-54]
	stur	q14, [c24, #53]
	stur	q14, [c7, #-54]
	stur	q14, [c7, #53]
	stur	q17, [c24, #-54]
	stur	q17, [c24, #53]
	stur	q17, [c7, #-54]
	stur	q17, [c7, #53]
// CHECK:	stur	q14, [c24, #-54]		// encoding: [0x0e,0xab,0x3c,0xe2]
// CHECK:	stur	q14, [c24, #53]		// encoding: [0x0e,0x5b,0x23,0xe2]
// CHECK:	stur	q14, [c7, #-54]		// encoding: [0xee,0xa8,0x3c,0xe2]
// CHECK:	stur	q14, [c7, #53]		// encoding: [0xee,0x58,0x23,0xe2]
// CHECK:	stur	q17, [c24, #-54]		// encoding: [0x11,0xab,0x3c,0xe2]
// CHECK:	stur	q17, [c24, #53]		// encoding: [0x11,0x5b,0x23,0xe2]
// CHECK:	stur	q17, [c7, #-54]		// encoding: [0xf1,0xa8,0x3c,0xe2]
// CHECK:	stur	q17, [c7, #53]		// encoding: [0xf1,0x58,0x23,0xe2]

	stur	s1, [c2, #-237]
	stur	s1, [c2, #236]
	stur	s1, [c29, #-237]
	stur	s1, [c29, #236]
	stur	s30, [c2, #-237]
	stur	s30, [c2, #236]
	stur	s30, [c29, #-237]
	stur	s30, [c29, #236]
// CHECK:	stur	s1, [c2, #-237]		// encoding: [0x41,0x30,0xb1,0xe2]
// CHECK:	stur	s1, [c2, #236]		// encoding: [0x41,0xc0,0xae,0xe2]
// CHECK:	stur	s1, [c29, #-237]		// encoding: [0xa1,0x33,0xb1,0xe2]
// CHECK:	stur	s1, [c29, #236]		// encoding: [0xa1,0xc3,0xae,0xe2]
// CHECK:	stur	s30, [c2, #-237]		// encoding: [0x5e,0x30,0xb1,0xe2]
// CHECK:	stur	s30, [c2, #236]		// encoding: [0x5e,0xc0,0xae,0xe2]
// CHECK:	stur	s30, [c29, #-237]		// encoding: [0xbe,0x33,0xb1,0xe2]
// CHECK:	stur	s30, [c29, #236]		// encoding: [0xbe,0xc3,0xae,0xe2]

	sturh	w16, [c24, #221]
	sturh	w16, [c24, #-222]
	sturh	w16, [c7, #221]
	sturh	w16, [c7, #-222]
	sturh	w15, [c24, #221]
	sturh	w15, [c24, #-222]
	sturh	w15, [c7, #221]
	sturh	w15, [c7, #-222]
// CHECK:	sturh	w16, [c24, #221]		// encoding: [0x10,0xd3,0x4d,0xe2]
// CHECK:	sturh	w16, [c24, #-222]		// encoding: [0x10,0x23,0x52,0xe2]
// CHECK:	sturh	w16, [c7, #221]		// encoding: [0xf0,0xd0,0x4d,0xe2]
// CHECK:	sturh	w16, [c7, #-222]		// encoding: [0xf0,0x20,0x52,0xe2]
// CHECK:	sturh	w15, [c24, #221]		// encoding: [0x0f,0xd3,0x4d,0xe2]
// CHECK:	sturh	w15, [c24, #-222]		// encoding: [0x0f,0x23,0x52,0xe2]
// CHECK:	sturh	w15, [c7, #221]		// encoding: [0xef,0xd0,0x4d,0xe2]
// CHECK:	sturh	w15, [c7, #-222]		// encoding: [0xef,0x20,0x52,0xe2]

	str	w22, [c26, #1932]
	str	w22, [c26, #112]
	str	w22, [c5, #1932]
	str	w22, [c5, #112]
	str	w9, [c26, #1932]
	str	w9, [c26, #112]
	str	w9, [c5, #1932]
	str	w9, [c5, #112]
// CHECK:	str	w22, [c26, #1932]		// encoding: [0x56,0x3b,0x5e,0x82]
// CHECK:	str	w22, [c26, #112]		// encoding: [0x56,0xcb,0x41,0x82]
// CHECK:	str	w22, [c5, #1932]		// encoding: [0xb6,0x38,0x5e,0x82]
// CHECK:	str	w22, [c5, #112]		// encoding: [0xb6,0xc8,0x41,0x82]
// CHECK:	str	w9, [c26, #1932]		// encoding: [0x49,0x3b,0x5e,0x82]
// CHECK:	str	w9, [c26, #112]		// encoding: [0x49,0xcb,0x41,0x82]
// CHECK:	str	w9, [c5, #1932]		// encoding: [0xa9,0x38,0x5e,0x82]
// CHECK:	str	w9, [c5, #112]		// encoding: [0xa9,0xc8,0x41,0x82]

	stur	w2, [c2, #-219]
	stur	w2, [c2, #218]
	stur	w2, [c29, #-219]
	stur	w2, [c29, #218]
	stur	w29, [c2, #-219]
	stur	w29, [c2, #218]
	stur	w29, [c29, #-219]
	stur	w29, [c29, #218]
// CHECK:	stur	w2, [c2, #-219]		// encoding: [0x42,0x50,0x92,0xe2]
// CHECK:	stur	w2, [c2, #218]		// encoding: [0x42,0xa0,0x8d,0xe2]
// CHECK:	stur	w2, [c29, #-219]		// encoding: [0xa2,0x53,0x92,0xe2]
// CHECK:	stur	w2, [c29, #218]		// encoding: [0xa2,0xa3,0x8d,0xe2]
// CHECK:	stur	w29, [c2, #-219]		// encoding: [0x5d,0x50,0x92,0xe2]
// CHECK:	stur	w29, [c2, #218]		// encoding: [0x5d,0xa0,0x8d,0xe2]
// CHECK:	stur	w29, [c29, #-219]		// encoding: [0xbd,0x53,0x92,0xe2]
// CHECK:	stur	w29, [c29, #218]		// encoding: [0xbd,0xa3,0x8d,0xe2]

	stlr	w13, [c25]
	stlr	w13, [c6]
	stlr	w18, [c25]
	stlr	w18, [c6]
// CHECK:	stlr	w13, [c25]		// encoding: [0x2d,0xff,0x3f,0x42]
// CHECK:	stlr	w13, [c6]		// encoding: [0xcd,0xfc,0x3f,0x42]
// CHECK:	stlr	w18, [c25]		// encoding: [0x32,0xff,0x3f,0x42]
// CHECK:	stlr	w18, [c6]		// encoding: [0xd2,0xfc,0x3f,0x42]

	alignd	c29, c26, #54
	alignd	c29, c26, #9
	alignd	c29, c5, #54
	alignd	c29, c5, #9
	alignd	c2, c26, #54
	alignd	c2, c26, #9
	alignd	c2, c5, #54
	alignd	c2, c5, #9
// CHECK:	alignd	c29, c26, #54		// encoding: [0x5d,0x1b,0xdb,0xc2]
// CHECK:	alignd	c29, c26, #9		// encoding: [0x5d,0x9b,0xc4,0xc2]
// CHECK:	alignd	c29, c5, #54		// encoding: [0xbd,0x18,0xdb,0xc2]
// CHECK:	alignd	c29, c5, #9		// encoding: [0xbd,0x98,0xc4,0xc2]
// CHECK:	alignd	c2, c26, #54		// encoding: [0x42,0x1b,0xdb,0xc2]
// CHECK:	alignd	c2, c26, #9		// encoding: [0x42,0x9b,0xc4,0xc2]
// CHECK:	alignd	c2, c5, #54		// encoding: [0xa2,0x18,0xdb,0xc2]
// CHECK:	alignd	c2, c5, #9		// encoding: [0xa2,0x98,0xc4,0xc2]

	alignu	c27, c29, #11
	alignu	c27, c29, #52
	alignu	c27, c2, #11
	alignu	c27, c2, #52
	alignu	c4, c29, #11
	alignu	c4, c29, #52
	alignu	c4, c2, #11
	alignu	c4, c2, #52
// CHECK:	alignu	c27, c29, #11		// encoding: [0xbb,0xdb,0xc5,0xc2]
// CHECK:	alignu	c27, c29, #52		// encoding: [0xbb,0x5b,0xda,0xc2]
// CHECK:	alignu	c27, c2, #11		// encoding: [0x5b,0xd8,0xc5,0xc2]
// CHECK:	alignu	c27, c2, #52		// encoding: [0x5b,0x58,0xda,0xc2]
// CHECK:	alignu	c4, c29, #11		// encoding: [0xa4,0xdb,0xc5,0xc2]
// CHECK:	alignu	c4, c29, #52		// encoding: [0xa4,0x5b,0xda,0xc2]
// CHECK:	alignu	c4, c2, #11		// encoding: [0x44,0xd8,0xc5,0xc2]
// CHECK:	alignu	c4, c2, #52		// encoding: [0x44,0x58,0xda,0xc2]

	bicflgs	c4, c2, #208
	bicflgs	c4, c2, #47
	bicflgs	c4, c29, #208
	bicflgs	c4, c29, #47
	bicflgs	c27, c2, #208
	bicflgs	c27, c2, #47
	bicflgs	c27, c29, #208
	bicflgs	c27, c29, #47
// CHECK:	bicflgs	c4, c2, #208		// encoding: [0x44,0x00,0xfa,0xc2]
// CHECK:	bicflgs	c4, c2, #47		// encoding: [0x44,0xe0,0xe5,0xc2]
// CHECK:	bicflgs	c4, c29, #208		// encoding: [0xa4,0x03,0xfa,0xc2]
// CHECK:	bicflgs	c4, c29, #47		// encoding: [0xa4,0xe3,0xe5,0xc2]
// CHECK:	bicflgs	c27, c2, #208		// encoding: [0x5b,0x00,0xfa,0xc2]
// CHECK:	bicflgs	c27, c2, #47		// encoding: [0x5b,0xe0,0xe5,0xc2]
// CHECK:	bicflgs	c27, c29, #208		// encoding: [0xbb,0x03,0xfa,0xc2]
// CHECK:	bicflgs	c27, c29, #47		// encoding: [0xbb,0xe3,0xe5,0xc2]

	bicflgs	c27, c27, x24
	bicflgs	c27, c27, x7
	bicflgs	c27, c4, x24
	bicflgs	c27, c4, x7
	bicflgs	c4, c27, x24
	bicflgs	c4, c27, x7
	bicflgs	c4, c4, x24
	bicflgs	c4, c4, x7
// CHECK:	bicflgs	c27, c27, x24		// encoding: [0x7b,0x2b,0xd8,0xc2]
// CHECK:	bicflgs	c27, c27, x7		// encoding: [0x7b,0x2b,0xc7,0xc2]
// CHECK:	bicflgs	c27, c4, x24		// encoding: [0x9b,0x28,0xd8,0xc2]
// CHECK:	bicflgs	c27, c4, x7		// encoding: [0x9b,0x28,0xc7,0xc2]
// CHECK:	bicflgs	c4, c27, x24		// encoding: [0x64,0x2b,0xd8,0xc2]
// CHECK:	bicflgs	c4, c27, x7		// encoding: [0x64,0x2b,0xc7,0xc2]
// CHECK:	bicflgs	c4, c4, x24		// encoding: [0x84,0x28,0xd8,0xc2]
// CHECK:	bicflgs	c4, c4, x7		// encoding: [0x84,0x28,0xc7,0xc2]

	br	c4
	br	c27
// CHECK:	br	c4		// encoding: [0x80,0x10,0xc2,0xc2]
// CHECK:	br	c27		// encoding: [0x60,0x13,0xc2,0xc2]

	brs	c26
	brs	c5
// CHECK:	brs	c26		// encoding: [0x42,0x13,0xc2,0xc2]
// CHECK:	brs	c5		// encoding: [0xa2,0x10,0xc2,0xc2]

	 bx     #4
// CHECK:	 bx	#4	// encoding: [0xe0,0x73,0xc2,0xc2]

	blr	c1
	blr	c30
// CHECK:	blr	c1		// encoding: [0x20,0x30,0xc2,0xc2]
// CHECK:	blr	c30		// encoding: [0xc0,0x33,0xc2,0xc2]

	blrs	c28
	blrs	c3
// CHECK:	blrs	c28		// encoding: [0x82,0x33,0xc2,0xc2]
// CHECK:	blrs	c3		// encoding: [0x62,0x30,0xc2,0xc2]

	blrr	c7
	blrr	c24
// CHECK:	blrr	c7		// encoding: [0xe3,0x30,0xc2,0xc2]
// CHECK:	blrr	c24		// encoding: [0x03,0x33,0xc2,0xc2]

	blrs	c29, c30, c24
	blrs	c29, c30, c7
	blrs	c29, c1, c24
	blrs	c29, c1, c7
// CHECK:	blrs	c29, c30, c24		// encoding: [0xc0,0xa7,0xd8,0xc2]
// CHECK:	blrs	c29, c30, c7		// encoding: [0xc0,0xa7,0xc7,0xc2]
// CHECK:	blrs	c29, c1, c24		// encoding: [0x20,0xa4,0xd8,0xc2]
// CHECK:	blrs	c29, c1, c7		// encoding: [0x20,0xa4,0xc7,0xc2]

	brr	c26
	brr	c5
// CHECK:	brr	c26		// encoding: [0x43,0x13,0xc2,0xc2]
// CHECK:	brr	c5		// encoding: [0xa3,0x10,0xc2,0xc2]

	brs	c29, c0, c5
	brs	c29, c0, c26
	brs	c29, czr, c5
	brs	c29, czr, c26
// CHECK:	brs	c29, c0, c5		// encoding: [0x00,0x84,0xc5,0xc2]
// CHECK:	brs	c29, c0, c26		// encoding: [0x00,0x84,0xda,0xc2]
// CHECK:	brs	c29, czr, c5		// encoding: [0xe0,0x87,0xc5,0xc2]
// CHECK:	brs	c29, czr, c26		// encoding: [0xe0,0x87,0xda,0xc2]

	build	c4, c6, c1
	build	c4, c6, c30
	build	c4, c25, c1
	build	c4, c25, c30
	build	c27, c6, c1
	build	c27, c6, c30
	build	c27, c25, c1
	build	c27, c25, c30
// CHECK:	build	c4, c6, c1		// encoding: [0xc4,0x04,0xc1,0xc2]
// CHECK:	build	c4, c6, c30		// encoding: [0xc4,0x04,0xde,0xc2]
// CHECK:	build	c4, c25, c1		// encoding: [0x24,0x07,0xc1,0xc2]
// CHECK:	build	c4, c25, c30		// encoding: [0x24,0x07,0xde,0xc2]
// CHECK:	build	c27, c6, c1		// encoding: [0xdb,0x04,0xc1,0xc2]
// CHECK:	build	c27, c6, c30		// encoding: [0xdb,0x04,0xde,0xc2]
// CHECK:	build	c27, c25, c1		// encoding: [0x3b,0x07,0xc1,0xc2]
// CHECK:	build	c27, c25, c30		// encoding: [0x3b,0x07,0xde,0xc2]

	chkeq	c25, c3
	chkeq	c25, c28
	chkeq	c6, c3
	chkeq	c6, c28
// CHECK:	chkeq	c25, c3		// encoding: [0x21,0xa7,0xc3,0xc2]
// CHECK:	chkeq	c25, c28		// encoding: [0x21,0xa7,0xdc,0xc2]
// CHECK:	chkeq	c6, c3		// encoding: [0xc1,0xa4,0xc3,0xc2]
// CHECK:	chkeq	c6, c28		// encoding: [0xc1,0xa4,0xdc,0xc2]

	chksld	c29
	chksld	c2
// CHECK:	chksld	c29		// encoding: [0xa1,0x13,0xc2,0xc2]
// CHECK:	chksld	c2		// encoding: [0x41,0x10,0xc2,0xc2]

	chkss	c25, c30
	chkss	c25, c1
	chkss	c6, c30
	chkss	c6, c1
// CHECK:	chkss	c25, c30		// encoding: [0x21,0x87,0xde,0xc2]
// CHECK:	chkss	c25, c1		// encoding: [0x21,0x87,0xc1,0xc2]
// CHECK:	chkss	c6, c30		// encoding: [0xc1,0x84,0xde,0xc2]
// CHECK:	chkss	c6, c1		// encoding: [0xc1,0x84,0xc1,0xc2]

	chkssu	c26, c30, csp
	chkssu	c26, c30, c0
	chkssu	c26, c1, csp
	chkssu	c26, c1, c0
	chkssu	c5, c30, csp
	chkssu	c5, c30, c0
	chkssu	c5, c1, csp
	chkssu	c5, c1, c0
// CHECK:	chkssu	c26, c30, csp		// encoding: [0xda,0x8b,0xdf,0xc2]
// CHECK:	chkssu	c26, c30, c0		// encoding: [0xda,0x8b,0xc0,0xc2]
// CHECK:	chkssu	c26, c1, csp		// encoding: [0x3a,0x88,0xdf,0xc2]
// CHECK:	chkssu	c26, c1, c0		// encoding: [0x3a,0x88,0xc0,0xc2]
// CHECK:	chkssu	c5, c30, csp		// encoding: [0xc5,0x8b,0xdf,0xc2]
// CHECK:	chkssu	c5, c30, c0		// encoding: [0xc5,0x8b,0xc0,0xc2]
// CHECK:	chkssu	c5, c1, csp		// encoding: [0x25,0x88,0xdf,0xc2]
// CHECK:	chkssu	c5, c1, c0		// encoding: [0x25,0x88,0xc0,0xc2]

	chktgd	c4
	chktgd	c27
// CHECK:	chktgd	c4		// encoding: [0x81,0x30,0xc2,0xc2]
// CHECK:	chktgd	c27		// encoding: [0x61,0x33,0xc2,0xc2]

	clrperm	c29, c24, x8
	clrperm	c29, c24, x23
	clrperm	c29, c7, x8
	clrperm	c29, c7, x23
	clrperm	c2, c24, x8
	clrperm	c2, c24, x23
	clrperm	c2, c7, x8
	clrperm	c2, c7, x23
// CHECK:	clrperm	c29, c24, x8		// encoding: [0x1d,0xa3,0xc8,0xc2]
// CHECK:	clrperm	c29, c24, x23		// encoding: [0x1d,0xa3,0xd7,0xc2]
// CHECK:	clrperm	c29, c7, x8		// encoding: [0xfd,0xa0,0xc8,0xc2]
// CHECK:	clrperm	c29, c7, x23		// encoding: [0xfd,0xa0,0xd7,0xc2]
// CHECK:	clrperm	c2, c24, x8		// encoding: [0x02,0xa3,0xc8,0xc2]
// CHECK:	clrperm	c2, c24, x23		// encoding: [0x02,0xa3,0xd7,0xc2]
// CHECK:	clrperm	c2, c7, x8		// encoding: [0xe2,0xa0,0xc8,0xc2]
// CHECK:	clrperm	c2, c7, x23		// encoding: [0xe2,0xa0,0xd7,0xc2]

	clrperm	c26, c30, x
	clrperm	c26, c30, w
	clrperm	c26, c30, wx
	clrperm	c26, c30, r
	clrperm	c26, c30, rx
	clrperm	c26, c30, rw
	clrperm	c26, c30, rwx
	clrperm	c26, c1, x
	clrperm	c26, c1, w
	clrperm	c26, c1, wx
	clrperm	c26, c1, r
	clrperm	c26, c1, rx
	clrperm	c26, c1, rw
	clrperm	c26, c1, rwx
	clrperm	c5, c30, x
	clrperm	c5, c30, w
	clrperm	c5, c30, wx
	clrperm	c5, c30, r
	clrperm	c5, c30, rx
	clrperm	c5, c30, rw
	clrperm	c5, c30, rwx
	clrperm	c5, c1, x
	clrperm	c5, c1, w
	clrperm	c5, c1, wx
	clrperm	c5, c1, r
	clrperm	c5, c1, rx
	clrperm	c5, c1, rw
	clrperm	c5, c1, rwx
        clrperm c3, c2, #0
// CHECK:	clrperm	c26, c30, x		// encoding: [0xda,0x33,0xc6,0xc2]
// CHECK:	clrperm	c26, c30, w		// encoding: [0xda,0x53,0xc6,0xc2]
// CHECK:	clrperm	c26, c30, wx		// encoding: [0xda,0x73,0xc6,0xc2]
// CHECK:	clrperm	c26, c30, r		// encoding: [0xda,0x93,0xc6,0xc2]
// CHECK:	clrperm	c26, c30, rx		// encoding: [0xda,0xb3,0xc6,0xc2]
// CHECK:	clrperm	c26, c30, rw		// encoding: [0xda,0xd3,0xc6,0xc2]
// CHECK:	clrperm	c26, c30, rwx		// encoding: [0xda,0xf3,0xc6,0xc2]
// CHECK:	clrperm	c26, c1, x		// encoding: [0x3a,0x30,0xc6,0xc2]
// CHECK:	clrperm	c26, c1, w		// encoding: [0x3a,0x50,0xc6,0xc2]
// CHECK:	clrperm	c26, c1, wx		// encoding: [0x3a,0x70,0xc6,0xc2]
// CHECK:	clrperm	c26, c1, r		// encoding: [0x3a,0x90,0xc6,0xc2]
// CHECK:	clrperm	c26, c1, rx		// encoding: [0x3a,0xb0,0xc6,0xc2]
// CHECK:	clrperm	c26, c1, rw		// encoding: [0x3a,0xd0,0xc6,0xc2]
// CHECK:	clrperm	c26, c1, rwx		// encoding: [0x3a,0xf0,0xc6,0xc2]
// CHECK:	clrperm	c5, c30, x		// encoding: [0xc5,0x33,0xc6,0xc2]
// CHECK:	clrperm	c5, c30, w		// encoding: [0xc5,0x53,0xc6,0xc2]
// CHECK:	clrperm	c5, c30, wx		// encoding: [0xc5,0x73,0xc6,0xc2]
// CHECK:	clrperm	c5, c30, r		// encoding: [0xc5,0x93,0xc6,0xc2]
// CHECK:	clrperm	c5, c30, rx		// encoding: [0xc5,0xb3,0xc6,0xc2]
// CHECK:	clrperm	c5, c30, rw		// encoding: [0xc5,0xd3,0xc6,0xc2]
// CHECK:	clrperm	c5, c30, rwx		// encoding: [0xc5,0xf3,0xc6,0xc2]
// CHECK:	clrperm	c5, c1, x		// encoding: [0x25,0x30,0xc6,0xc2]
// CHECK:	clrperm	c5, c1, w		// encoding: [0x25,0x50,0xc6,0xc2]
// CHECK:	clrperm	c5, c1, wx		// encoding: [0x25,0x70,0xc6,0xc2]
// CHECK:	clrperm	c5, c1, r		// encoding: [0x25,0x90,0xc6,0xc2]
// CHECK:	clrperm	c5, c1, rx		// encoding: [0x25,0xb0,0xc6,0xc2]
// CHECK:	clrperm	c5, c1, rw		// encoding: [0x25,0xd0,0xc6,0xc2]
// CHECK:	clrperm	c5, c1, rwx		// encoding: [0x25,0xf0,0xc6,0xc2]
// CHECK:	clrperm	c3, c2, #0		// encoding: [0x43,0x10,0xc6,0xc2]

	clrtag	c25, c24
	clrtag	c25, c7
	clrtag	c6, c24
	clrtag	c6, c7
// CHECK:	clrtag	c25, c24		// encoding: [0x19,0x93,0xc1,0xc2]
// CHECK:	clrtag	c25, c7		// encoding: [0xf9,0x90,0xc1,0xc2]
// CHECK:	clrtag	c6, c24		// encoding: [0x06,0x93,0xc1,0xc2]
// CHECK:	clrtag	c6, c7		// encoding: [0xe6,0x90,0xc1,0xc2]

	cas	c3, c25, [x22]
	cas	c3, c25, [x9]
	cas	c3, c6, [x22]
	cas	c3, c6, [x9]
	cas	c28, c25, [x22]
	cas	c28, c25, [x9]
	cas	c28, c6, [x22]
	cas	c28, c6, [x9]
// CHECK:	cas	c3, c25, [x22]		// encoding: [0xd9,0x7e,0xa3,0xa2]
// CHECK:	cas	c3, c25, [x9]		// encoding: [0x39,0x7d,0xa3,0xa2]
// CHECK:	cas	c3, c6, [x22]		// encoding: [0xc6,0x7e,0xa3,0xa2]
// CHECK:	cas	c3, c6, [x9]		// encoding: [0x26,0x7d,0xa3,0xa2]
// CHECK:	cas	c28, c25, [x22]		// encoding: [0xd9,0x7e,0xbc,0xa2]
// CHECK:	cas	c28, c25, [x9]		// encoding: [0x39,0x7d,0xbc,0xa2]
// CHECK:	cas	c28, c6, [x22]		// encoding: [0xc6,0x7e,0xbc,0xa2]
// CHECK:	cas	c28, c6, [x9]		// encoding: [0x26,0x7d,0xbc,0xa2]

	casa	c28, c0, [x28]
	casa	c28, c0, [x3]
	casa	c28, czr, [x28]
	casa	c28, czr, [x3]
	casa	c3, c0, [x28]
	casa	c3, c0, [x3]
	casa	c3, czr, [x28]
	casa	c3, czr, [x3]
// CHECK:	casa	c28, c0, [x28]		// encoding: [0x80,0x7f,0xfc,0xa2]
// CHECK:	casa	c28, c0, [x3]		// encoding: [0x60,0x7c,0xfc,0xa2]
// CHECK:	casa	c28, czr, [x28]		// encoding: [0x9f,0x7f,0xfc,0xa2]
// CHECK:	casa	c28, czr, [x3]		// encoding: [0x7f,0x7c,0xfc,0xa2]
// CHECK:	casa	c3, c0, [x28]		// encoding: [0x80,0x7f,0xe3,0xa2]
// CHECK:	casa	c3, c0, [x3]		// encoding: [0x60,0x7c,0xe3,0xa2]
// CHECK:	casa	c3, czr, [x28]		// encoding: [0x9f,0x7f,0xe3,0xa2]
// CHECK:	casa	c3, czr, [x3]		// encoding: [0x7f,0x7c,0xe3,0xa2]

	casal	c27, c6, [x5]
	casal	c27, c6, [x26]
	casal	c27, c25, [x5]
	casal	c27, c25, [x26]
	casal	c4, c6, [x5]
	casal	c4, c6, [x26]
	casal	c4, c25, [x5]
	casal	c4, c25, [x26]
// CHECK:	casal	c27, c6, [x5]		// encoding: [0xa6,0xfc,0xfb,0xa2]
// CHECK:	casal	c27, c6, [x26]		// encoding: [0x46,0xff,0xfb,0xa2]
// CHECK:	casal	c27, c25, [x5]		// encoding: [0xb9,0xfc,0xfb,0xa2]
// CHECK:	casal	c27, c25, [x26]		// encoding: [0x59,0xff,0xfb,0xa2]
// CHECK:	casal	c4, c6, [x5]		// encoding: [0xa6,0xfc,0xe4,0xa2]
// CHECK:	casal	c4, c6, [x26]		// encoding: [0x46,0xff,0xe4,0xa2]
// CHECK:	casal	c4, c25, [x5]		// encoding: [0xb9,0xfc,0xe4,0xa2]
// CHECK:	casal	c4, c25, [x26]		// encoding: [0x59,0xff,0xe4,0xa2]

	casl	c4, c7, [x14]
	casl	c4, c7, [x17]
	casl	c4, c24, [x14]
	casl	c4, c24, [x17]
	casl	c27, c7, [x14]
	casl	c27, c7, [x17]
	casl	c27, c24, [x14]
	casl	c27, c24, [x17]
// CHECK:	casl	c4, c7, [x14]		// encoding: [0xc7,0xfd,0xa4,0xa2]
// CHECK:	casl	c4, c7, [x17]		// encoding: [0x27,0xfe,0xa4,0xa2]
// CHECK:	casl	c4, c24, [x14]		// encoding: [0xd8,0xfd,0xa4,0xa2]
// CHECK:	casl	c4, c24, [x17]		// encoding: [0x38,0xfe,0xa4,0xa2]
// CHECK:	casl	c27, c7, [x14]		// encoding: [0xc7,0xfd,0xbb,0xa2]
// CHECK:	casl	c27, c7, [x17]		// encoding: [0x27,0xfe,0xbb,0xa2]
// CHECK:	casl	c27, c24, [x14]		// encoding: [0xd8,0xfd,0xbb,0xa2]
// CHECK:	casl	c27, c24, [x17]		// encoding: [0x38,0xfe,0xbb,0xa2]

	cvtd	c28, x21
	cvtd	c28, x10
	cvtd	c3, x21
	cvtd	c3, x10
// CHECK:	cvtd	c28, x21		// encoding: [0xbc,0x92,0xc5,0xc2]
// CHECK:	cvtd	c28, x10		// encoding: [0x5c,0x91,0xc5,0xc2]
// CHECK:	cvtd	c3, x21		// encoding: [0xa3,0x92,0xc5,0xc2]
// CHECK:	cvtd	c3, x10		// encoding: [0x43,0x91,0xc5,0xc2]

	cvtdz	c29, x23
	cvtdz	c29, x8
	cvtdz	c2, x23
	cvtdz	c2, x8
// CHECK:	cvtdz	c29, x23		// encoding: [0xfd,0xd2,0xc5,0xc2]
// CHECK:	cvtdz	c29, x8		// encoding: [0x1d,0xd1,0xc5,0xc2]
// CHECK:	cvtdz	c2, x23		// encoding: [0xe2,0xd2,0xc5,0xc2]
// CHECK:	cvtdz	c2, x8		// encoding: [0x02,0xd1,0xc5,0xc2]

	cvtp	c28, x3
	cvtp	c28, x28
	cvtp	c3, x3
	cvtp	c3, x28
// CHECK:	cvtp	c28, x3		// encoding: [0x7c,0xb0,0xc5,0xc2]
// CHECK:	cvtp	c28, x28		// encoding: [0x9c,0xb3,0xc5,0xc2]
// CHECK:	cvtp	c3, x3		// encoding: [0x63,0xb0,0xc5,0xc2]
// CHECK:	cvtp	c3, x28		// encoding: [0x83,0xb3,0xc5,0xc2]

	cvtpz	c26, x25
	cvtpz	c26, x6
	cvtpz	c5, x25
	cvtpz	c5, x6
// CHECK:	cvtpz	c26, x25		// encoding: [0x3a,0xf3,0xc5,0xc2]
// CHECK:	cvtpz	c26, x6		// encoding: [0xda,0xf0,0xc5,0xc2]
// CHECK:	cvtpz	c5, x25		// encoding: [0x25,0xf3,0xc5,0xc2]
// CHECK:	cvtpz	c5, x6		// encoding: [0xc5,0xf0,0xc5,0xc2]

	cvt	c0, c1, x28
	cvt	c0, c1, x3
	cvt	c0, c30, x28
	cvt	c0, c30, x3
	cvt	czr, c1, x28
	cvt	czr, c1, x3
	cvt	czr, c30, x28
	cvt	czr, c30, x3
// CHECK:	cvt	c0, c1, x28		// encoding: [0x20,0x18,0xfc,0xc2]
// CHECK:	cvt	c0, c1, x3		// encoding: [0x20,0x18,0xe3,0xc2]
// CHECK:	cvt	c0, c30, x28		// encoding: [0xc0,0x1b,0xfc,0xc2]
// CHECK:	cvt	c0, c30, x3		// encoding: [0xc0,0x1b,0xe3,0xc2]
// CHECK:	cvt	czr, c1, x28		// encoding: [0x3f,0x18,0xfc,0xc2]
// CHECK:	cvt	czr, c1, x3		// encoding: [0x3f,0x18,0xe3,0xc2]
// CHECK:	cvt	czr, c30, x28		// encoding: [0xdf,0x1b,0xfc,0xc2]
// CHECK:	cvt	czr, c30, x3		// encoding: [0xdf,0x1b,0xe3,0xc2]

	cvtz	c4, csp, x24
	cvtz	c4, csp, x7
	cvtz	c4, c0, x24
	cvtz	c4, c0, x7
	cvtz	c27, csp, x24
	cvtz	c27, csp, x7
	cvtz	c27, c0, x24
	cvtz	c27, c0, x7
// CHECK:	cvtz	c4, csp, x24		// encoding: [0xe4,0x5b,0xf8,0xc2]
// CHECK:	cvtz	c4, csp, x7		// encoding: [0xe4,0x5b,0xe7,0xc2]
// CHECK:	cvtz	c4, c0, x24		// encoding: [0x04,0x58,0xf8,0xc2]
// CHECK:	cvtz	c4, c0, x7		// encoding: [0x04,0x58,0xe7,0xc2]
// CHECK:	cvtz	c27, csp, x24		// encoding: [0xfb,0x5b,0xf8,0xc2]
// CHECK:	cvtz	c27, csp, x7		// encoding: [0xfb,0x5b,0xe7,0xc2]
// CHECK:	cvtz	c27, c0, x24		// encoding: [0x1b,0x58,0xf8,0xc2]
// CHECK:	cvtz	c27, c0, x7		// encoding: [0x1b,0x58,0xe7,0xc2]

	cvt	x30, c2, c5
	cvt	x30, c2, c26
	cvt	x30, c29, c5
	cvt	x30, c29, c26
	cvt	x0, c2, c5
	cvt	x0, c2, c26
	cvt	x0, c29, c5
	cvt	x0, c29, c26
// CHECK:	cvt	x30, c2, c5		// encoding: [0x5e,0xc0,0xc5,0xc2]
// CHECK:	cvt	x30, c2, c26		// encoding: [0x5e,0xc0,0xda,0xc2]
// CHECK:	cvt	x30, c29, c5		// encoding: [0xbe,0xc3,0xc5,0xc2]
// CHECK:	cvt	x30, c29, c26		// encoding: [0xbe,0xc3,0xda,0xc2]
// CHECK:	cvt	x0, c2, c5		// encoding: [0x40,0xc0,0xc5,0xc2]
// CHECK:	cvt	x0, c2, c26		// encoding: [0x40,0xc0,0xda,0xc2]
// CHECK:	cvt	x0, c29, c5		// encoding: [0xa0,0xc3,0xc5,0xc2]
// CHECK:	cvt	x0, c29, c26		// encoding: [0xa0,0xc3,0xda,0xc2]

	cvtd	x10, csp
	cvtd	x10, c0
	cvtd	x20, csp
	cvtd	x20, c0
// CHECK:	cvtd	x10, csp		// encoding: [0xea,0x13,0xc5,0xc2]
// CHECK:	cvtd	x10, c0		// encoding: [0x0a,0x10,0xc5,0xc2]
// CHECK:	cvtd	x20, csp		// encoding: [0xf4,0x13,0xc5,0xc2]
// CHECK:	cvtd	x20, c0		// encoding: [0x14,0x10,0xc5,0xc2]

	cvtp	x9, c25
	cvtp	x9, c6
	cvtp	x22, c25
	cvtp	x22, c6
// CHECK:	cvtp	x9, c25		// encoding: [0x29,0x33,0xc5,0xc2]
// CHECK:	cvtp	x9, c6		// encoding: [0xc9,0x30,0xc5,0xc2]
// CHECK:	cvtp	x22, c25		// encoding: [0x36,0x33,0xc5,0xc2]
// CHECK:	cvtp	x22, c6		// encoding: [0xd6,0x30,0xc5,0xc2]

	cpy	c29, c2
	cpy	c29, c29
	cpy	c2, c2
	cpy	c2, c29
// CHECK:	mov	c29, c2		// encoding: [0x5d,0xd0,0xc1,0xc2]
// CHECK:	mov	c29, c29		// encoding: [0xbd,0xd3,0xc1,0xc2]
// CHECK:	mov	c2, c2		// encoding: [0x42,0xd0,0xc1,0xc2]
// CHECK:	mov	c2, c29		// encoding: [0xa2,0xd3,0xc1,0xc2]

	cfhi	x16, c28
	cfhi	x16, c3
	cfhi	x14, c28
	cfhi	x14, c3
// CHECK:	cfhi	x16, c28		// encoding: [0x90,0x53,0xc1,0xc2]
// CHECK:	cfhi	x16, c3		// encoding: [0x70,0x50,0xc1,0xc2]
// CHECK:	cfhi	x14, c28		// encoding: [0x8e,0x53,0xc1,0xc2]
// CHECK:	cfhi	x14, c3		// encoding: [0x6e,0x50,0xc1,0xc2]

	cthi	c2, c26, x10
	cthi	c2, c26, x21
	cthi	c2, c5, x10
	cthi	c2, c5, x21
	cthi	c29, c26, x10
	cthi	c29, c26, x21
	cthi	c29, c5, x10
	cthi	c29, c5, x21
// CHECK:	cthi	c2, c26, x10		// encoding: [0x42,0xeb,0xca,0xc2]
// CHECK:	cthi	c2, c26, x21		// encoding: [0x42,0xeb,0xd5,0xc2]
// CHECK:	cthi	c2, c5, x10		// encoding: [0xa2,0xe8,0xca,0xc2]
// CHECK:	cthi	c2, c5, x21		// encoding: [0xa2,0xe8,0xd5,0xc2]
// CHECK:	cthi	c29, c26, x10		// encoding: [0x5d,0xeb,0xca,0xc2]
// CHECK:	cthi	c29, c26, x21		// encoding: [0x5d,0xeb,0xd5,0xc2]
// CHECK:	cthi	c29, c5, x10		// encoding: [0xbd,0xe8,0xca,0xc2]
// CHECK:	cthi	c29, c5, x21		// encoding: [0xbd,0xe8,0xd5,0xc2]

	eorflgs	c25, c6, #150
	eorflgs	c25, c6, #105
	eorflgs	c25, c25, #150
	eorflgs	c25, c25, #105
	eorflgs	c6, c6, #150
	eorflgs	c6, c6, #105
	eorflgs	c6, c25, #150
	eorflgs	c6, c25, #105
// CHECK:	eorflgs	c25, c6, #150		// encoding: [0xd9,0xd0,0xf2,0xc2]
// CHECK:	eorflgs	c25, c6, #105		// encoding: [0xd9,0x30,0xed,0xc2]
// CHECK:	eorflgs	c25, c25, #150		// encoding: [0x39,0xd3,0xf2,0xc2]
// CHECK:	eorflgs	c25, c25, #105		// encoding: [0x39,0x33,0xed,0xc2]
// CHECK:	eorflgs	c6, c6, #150		// encoding: [0xc6,0xd0,0xf2,0xc2]
// CHECK:	eorflgs	c6, c6, #105		// encoding: [0xc6,0x30,0xed,0xc2]
// CHECK:	eorflgs	c6, c25, #150		// encoding: [0x26,0xd3,0xf2,0xc2]
// CHECK:	eorflgs	c6, c25, #105		// encoding: [0x26,0x33,0xed,0xc2]

	eorflgs	c27, c30, x8
	eorflgs	c27, c30, x23
	eorflgs	c27, c1, x8
	eorflgs	c27, c1, x23
	eorflgs	c4, c30, x8
	eorflgs	c4, c30, x23
	eorflgs	c4, c1, x8
	eorflgs	c4, c1, x23
// CHECK:	eorflgs	c27, c30, x8		// encoding: [0xdb,0xab,0xc8,0xc2]
// CHECK:	eorflgs	c27, c30, x23		// encoding: [0xdb,0xab,0xd7,0xc2]
// CHECK:	eorflgs	c27, c1, x8		// encoding: [0x3b,0xa8,0xc8,0xc2]
// CHECK:	eorflgs	c27, c1, x23		// encoding: [0x3b,0xa8,0xd7,0xc2]
// CHECK:	eorflgs	c4, c30, x8		// encoding: [0xc4,0xab,0xc8,0xc2]
// CHECK:	eorflgs	c4, c30, x23		// encoding: [0xc4,0xab,0xd7,0xc2]
// CHECK:	eorflgs	c4, c1, x8		// encoding: [0x24,0xa8,0xc8,0xc2]
// CHECK:	eorflgs	c4, c1, x23		// encoding: [0x24,0xa8,0xd7,0xc2]

	gcbase	x4, c0
	gcbase	x4, csp
	gcbase	x26, c0
	gcbase	x26, csp
// CHECK:	gcbase	x4, c0		// encoding: [0x04,0x10,0xc0,0xc2]
// CHECK:	gcbase	x4, csp		// encoding: [0xe4,0x13,0xc0,0xc2]
// CHECK:	gcbase	x26, c0		// encoding: [0x1a,0x10,0xc0,0xc2]
// CHECK:	gcbase	x26, csp		// encoding: [0xfa,0x13,0xc0,0xc2]

	gcflgs	x1, csp
	gcflgs	x1, c0
	gcflgs	x30, csp
	gcflgs	x30, c0
// CHECK:	gcflgs	x1, csp		// encoding: [0xe1,0x33,0xc1,0xc2]
// CHECK:	gcflgs	x1, c0		// encoding: [0x01,0x30,0xc1,0xc2]
// CHECK:	gcflgs	x30, csp		// encoding: [0xfe,0x33,0xc1,0xc2]
// CHECK:	gcflgs	x30, c0		// encoding: [0x1e,0x30,0xc1,0xc2]

	gclen	x30, c5
	gclen	x30, c26
	gclen	x0, c5
	gclen	x0, c26
// CHECK:	gclen	x30, c5		// encoding: [0xbe,0x30,0xc0,0xc2]
// CHECK:	gclen	x30, c26		// encoding: [0x5e,0x33,0xc0,0xc2]
// CHECK:	gclen	x0, c5		// encoding: [0xa0,0x30,0xc0,0xc2]
// CHECK:	gclen	x0, c26		// encoding: [0x40,0x33,0xc0,0xc2]

	gclim	x30, c4
	gclim	x30, c27
	gclim	x0, c4
	gclim	x0, c27
// CHECK:	gclim	x30, c4		// encoding: [0x9e,0x10,0xc1,0xc2]
// CHECK:	gclim	x30, c27		// encoding: [0x7e,0x13,0xc1,0xc2]
// CHECK:	gclim	x0, c4		// encoding: [0x80,0x10,0xc1,0xc2]
// CHECK:	gclim	x0, c27		// encoding: [0x60,0x13,0xc1,0xc2]

	gcoff	x13, c4
	gcoff	x13, c27
	gcoff	x18, c4
	gcoff	x18, c27
// CHECK:	gcoff	x13, c4		// encoding: [0x8d,0x70,0xc0,0xc2]
// CHECK:	gcoff	x13, c27		// encoding: [0x6d,0x73,0xc0,0xc2]
// CHECK:	gcoff	x18, c4		// encoding: [0x92,0x70,0xc0,0xc2]
// CHECK:	gcoff	x18, c27		// encoding: [0x72,0x73,0xc0,0xc2]

	gcperm	x2, c6
	gcperm	x2, c25
	gcperm	x28, c6
	gcperm	x28, c25
// CHECK:	gcperm	x2, c6		// encoding: [0xc2,0xd0,0xc0,0xc2]
// CHECK:	gcperm	x2, c25		// encoding: [0x22,0xd3,0xc0,0xc2]
// CHECK:	gcperm	x28, c6		// encoding: [0xdc,0xd0,0xc0,0xc2]
// CHECK:	gcperm	x28, c25		// encoding: [0x3c,0xd3,0xc0,0xc2]

	gcseal	x9, c29
	gcseal	x9, c2
	gcseal	x22, c29
	gcseal	x22, c2
// CHECK:	gcseal	x9, c29		// encoding: [0xa9,0xb3,0xc0,0xc2]
// CHECK:	gcseal	x9, c2		// encoding: [0x49,0xb0,0xc0,0xc2]
// CHECK:	gcseal	x22, c29		// encoding: [0xb6,0xb3,0xc0,0xc2]
// CHECK:	gcseal	x22, c2		// encoding: [0x56,0xb0,0xc0,0xc2]

	mrs	c6, CDBGDTR_EL0
	mrs	c6, CDLR_EL0
	mrs	c6, CELR_EL1
	mrs	c6, CELR_EL12
	mrs	c6, CELR_EL2
	mrs	c6, CELR_EL3
	mrs	c6, CID_EL0
	mrs	c6, CSP_EL0
	mrs	c6, CSP_EL1
	mrs	c6, CSP_EL2
	mrs	c6, CTPIDR_EL0
	mrs	c6, CTPIDR_EL1
	mrs	c6, CTPIDR_EL2
	mrs	c6, CTPIDR_EL3
	mrs	c6, CTPIDRRO_EL0
	mrs	c6, CVBAR_EL1
	mrs	c6, CVBAR_EL12
	mrs	c6, CVBAR_EL2
	mrs	c6, CVBAR_EL3
	mrs	c6, DDC
	mrs	c6, DDC_EL0
	mrs	c6, DDC_EL1
	mrs	c6, DDC_EL2
	mrs	c6, RCSP_EL0
	mrs	c6, RCTPIDR_EL0
	mrs	c6, RDDC_EL0
	mrs	c25, CDBGDTR_EL0
	mrs	c25, CDLR_EL0
	mrs	c25, CELR_EL1
	mrs	c25, CELR_EL12
	mrs	c25, CELR_EL2
	mrs	c25, CELR_EL3
	mrs	c25, CID_EL0
	mrs	c25, CSP_EL0
	mrs	c25, CSP_EL1
	mrs	c25, CSP_EL2
	mrs	c25, CTPIDR_EL0
	mrs	c25, CTPIDR_EL1
	mrs	c25, CTPIDR_EL2
	mrs	c25, CTPIDR_EL3
	mrs	c25, CTPIDRRO_EL0
	mrs	c25, CVBAR_EL1
	mrs	c25, CVBAR_EL12
	mrs	c25, CVBAR_EL2
	mrs	c25, CVBAR_EL3
	mrs	c25, DDC
	mrs	c25, DDC_EL0
	mrs	c25, DDC_EL1
	mrs	c25, DDC_EL2
	mrs	c25, RCSP_EL0
	mrs	c25, RCTPIDR_EL0
	mrs	c25, RDDC_EL0
// CHECK:	mrs	c6, CDBGDTR_EL0		// encoding: [0x06,0x04,0x93,0xc2]
// CHECK:	mrs	c6, CDLR_EL0		// encoding: [0x26,0x45,0x9b,0xc2]
// CHECK:	mrs	c6, CELR_EL1		// encoding: [0x26,0x40,0x98,0xc2]
// CHECK:	mrs	c6, CELR_EL12		// encoding: [0x26,0x40,0x9d,0xc2]
// CHECK:	mrs	c6, CELR_EL2		// encoding: [0x26,0x40,0x9c,0xc2]
// CHECK:	mrs	c6, CELR_EL3		// encoding: [0x26,0x40,0x9e,0xc2]
// CHECK:	mrs	c6, CID_EL0		// encoding: [0xe6,0xd0,0x9b,0xc2]
// CHECK:	mrs	c6, CSP_EL0		// encoding: [0x06,0x41,0x98,0xc2]
// CHECK:	mrs	c6, CSP_EL1		// encoding: [0x06,0x41,0x9c,0xc2]
// CHECK:	mrs	c6, CSP_EL2		// encoding: [0x06,0x41,0x9e,0xc2]
// CHECK:	mrs	c6, CTPIDR_EL0		// encoding: [0x46,0xd0,0x9b,0xc2]
// CHECK:	mrs	c6, CTPIDR_EL1		// encoding: [0x86,0xd0,0x98,0xc2]
// CHECK:	mrs	c6, CTPIDR_EL2		// encoding: [0x46,0xd0,0x9c,0xc2]
// CHECK:	mrs	c6, CTPIDR_EL3		// encoding: [0x46,0xd0,0x9e,0xc2]
// CHECK:	mrs	c6, CTPIDRRO_EL0		// encoding: [0x66,0xd0,0x9b,0xc2]
// CHECK:	mrs	c6, CVBAR_EL1		// encoding: [0x06,0xc0,0x98,0xc2]
// CHECK:	mrs	c6, CVBAR_EL12		// encoding: [0x06,0xc0,0x9d,0xc2]
// CHECK:	mrs	c6, CVBAR_EL2		// encoding: [0x06,0xc0,0x9c,0xc2]
// CHECK:	mrs	c6, CVBAR_EL3		// encoding: [0x06,0xc0,0x9e,0xc2]
// CHECK:	mrs	c6, DDC		// encoding: [0x26,0x41,0x9b,0xc2]
// CHECK:	mrs	c6, DDC_EL0		// encoding: [0x26,0x41,0x98,0xc2]
// CHECK:	mrs	c6, DDC_EL1		// encoding: [0x26,0x41,0x9c,0xc2]
// CHECK:	mrs	c6, DDC_EL2		// encoding: [0x26,0x41,0x9e,0xc2]
// CHECK:	mrs	c6, RCSP_EL0		// encoding: [0x66,0x41,0x9f,0xc2]
// CHECK:	mrs	c6, RCTPIDR_EL0		// encoding: [0x86,0xd0,0x9b,0xc2]
// CHECK:	mrs	c6, RDDC_EL0		// encoding: [0x26,0x43,0x9b,0xc2]
// CHECK:	mrs	c25, CDBGDTR_EL0		// encoding: [0x19,0x04,0x93,0xc2]
// CHECK:	mrs	c25, CDLR_EL0		// encoding: [0x39,0x45,0x9b,0xc2]
// CHECK:	mrs	c25, CELR_EL1		// encoding: [0x39,0x40,0x98,0xc2]
// CHECK:	mrs	c25, CELR_EL12		// encoding: [0x39,0x40,0x9d,0xc2]
// CHECK:	mrs	c25, CELR_EL2		// encoding: [0x39,0x40,0x9c,0xc2]
// CHECK:	mrs	c25, CELR_EL3		// encoding: [0x39,0x40,0x9e,0xc2]
// CHECK:	mrs	c25, CID_EL0		// encoding: [0xf9,0xd0,0x9b,0xc2]
// CHECK:	mrs	c25, CSP_EL0		// encoding: [0x19,0x41,0x98,0xc2]
// CHECK:	mrs	c25, CSP_EL1		// encoding: [0x19,0x41,0x9c,0xc2]
// CHECK:	mrs	c25, CSP_EL2		// encoding: [0x19,0x41,0x9e,0xc2]
// CHECK:	mrs	c25, CTPIDR_EL0		// encoding: [0x59,0xd0,0x9b,0xc2]
// CHECK:	mrs	c25, CTPIDR_EL1		// encoding: [0x99,0xd0,0x98,0xc2]
// CHECK:	mrs	c25, CTPIDR_EL2		// encoding: [0x59,0xd0,0x9c,0xc2]
// CHECK:	mrs	c25, CTPIDR_EL3		// encoding: [0x59,0xd0,0x9e,0xc2]
// CHECK:	mrs	c25, CTPIDRRO_EL0		// encoding: [0x79,0xd0,0x9b,0xc2]
// CHECK:	mrs	c25, CVBAR_EL1		// encoding: [0x19,0xc0,0x98,0xc2]
// CHECK:	mrs	c25, CVBAR_EL12		// encoding: [0x19,0xc0,0x9d,0xc2]
// CHECK:	mrs	c25, CVBAR_EL2		// encoding: [0x19,0xc0,0x9c,0xc2]
// CHECK:	mrs	c25, CVBAR_EL3		// encoding: [0x19,0xc0,0x9e,0xc2]
// CHECK:	mrs	c25, DDC		// encoding: [0x39,0x41,0x9b,0xc2]
// CHECK:	mrs	c25, DDC_EL0		// encoding: [0x39,0x41,0x98,0xc2]
// CHECK:	mrs	c25, DDC_EL1		// encoding: [0x39,0x41,0x9c,0xc2]
// CHECK:	mrs	c25, DDC_EL2		// encoding: [0x39,0x41,0x9e,0xc2]
// CHECK:	mrs	c25, RCSP_EL0		// encoding: [0x79,0x41,0x9f,0xc2]
// CHECK:	mrs	c25, RCTPIDR_EL0		// encoding: [0x99,0xd0,0x9b,0xc2]
// CHECK:	mrs	c25, RDDC_EL0		// encoding: [0x39,0x43,0x9b,0xc2]

	gctag	x6, c4
	gctag	x6, c27
	gctag	x24, c4
	gctag	x24, c27
// CHECK:	gctag	x6, c4		// encoding: [0x86,0x90,0xc0,0xc2]
// CHECK:	gctag	x6, c27		// encoding: [0x66,0x93,0xc0,0xc2]
// CHECK:	gctag	x24, c4		// encoding: [0x98,0x90,0xc0,0xc2]
// CHECK:	gctag	x24, c27		// encoding: [0x78,0x93,0xc0,0xc2]

	gctype	x20, c6
	gctype	x20, c25
	gctype	x10, c6
	gctype	x10, c25
// CHECK:	gctype	x20, c6		// encoding: [0xd4,0xf0,0xc0,0xc2]
// CHECK:	gctype	x20, c25		// encoding: [0x34,0xf3,0xc0,0xc2]
// CHECK:	gctype	x10, c6		// encoding: [0xca,0xf0,0xc0,0xc2]
// CHECK:	gctype	x10, c25		// encoding: [0x2a,0xf3,0xc0,0xc2]

	gcvalue	x21, c26
	gcvalue	x21, c5
	gcvalue	x10, c26
	gcvalue	x10, c5
// CHECK:	gcvalue	x21, c26		// encoding: [0x55,0x53,0xc0,0xc2]
// CHECK:	gcvalue	x21, c5		// encoding: [0xb5,0x50,0xc0,0xc2]
// CHECK:	gcvalue	x10, c26		// encoding: [0x4a,0x53,0xc0,0xc2]
// CHECK:	gcvalue	x10, c5		// encoding: [0xaa,0x50,0xc0,0xc2]

	ldar	c27, [x5]
	ldar	c27, [x26]
	ldar	c4, [x5]
	ldar	c4, [x26]
// CHECK:	ldar	c27, [x5]		// encoding: [0xbb,0xfc,0x5f,0x42]
// CHECK:	ldar	c27, [x26]		// encoding: [0x5b,0xff,0x5f,0x42]
// CHECK:	ldar	c4, [x5]		// encoding: [0xa4,0xfc,0x5f,0x42]
// CHECK:	ldar	c4, [x26]		// encoding: [0x44,0xff,0x5f,0x42]

	ldapr	c3, [x30]
	ldapr	c3, [x1]
	ldapr	c28, [x30]
	ldapr	c28, [x1]
// CHECK:	ldapr	c3, [x30]		// encoding: [0xc3,0xc3,0x3f,0xa2]
// CHECK:	ldapr	c3, [x1]		// encoding: [0x23,0xc0,0x3f,0xa2]
// CHECK:	ldapr	c28, [x30]		// encoding: [0xdc,0xc3,0x3f,0xa2]
// CHECK:	ldapr	c28, [x1]		// encoding: [0x3c,0xc0,0x3f,0xa2]

	br	[csp, #-752]
	br	[csp, #736]
	br	[c0, #-752]
	br	[c0, #736]
// CHECK:	br	[csp, #-752]		// encoding: [0xe0,0x33,0xda,0xc2]
// CHECK:	br	[csp, #736]		// encoding: [0xe0,0xd3,0xd5,0xc2]
// CHECK:	br	[c0, #-752]		// encoding: [0x00,0x30,0xda,0xc2]
// CHECK:	br	[c0, #736]		// encoding: [0x00,0xd0,0xd5,0xc2]

	blr	[c4, #240]
	blr	[c4, #-256]
	blr	[c27, #240]
	blr	[c27, #-256]
// CHECK:	blr	[c4, #240]		// encoding: [0x81,0xf0,0xd1,0xc2]
// CHECK:	blr	[c4, #-256]		// encoding: [0x81,0x10,0xde,0xc2]
// CHECK:	blr	[c27, #240]		// encoding: [0x61,0xf3,0xd1,0xc2]
// CHECK:	blr	[c27, #-256]		// encoding: [0x61,0x13,0xde,0xc2]

	ldxr	c1, [x30]
	ldxr	c1, [x1]
	ldxr	c30, [x30]
	ldxr	c30, [x1]
// CHECK:	ldxr	c1, [x30]		// encoding: [0xc1,0x7f,0x5f,0x22]
// CHECK:	ldxr	c1, [x1]		// encoding: [0x21,0x7c,0x5f,0x22]
// CHECK:	ldxr	c30, [x30]		// encoding: [0xde,0x7f,0x5f,0x22]
// CHECK:	ldxr	c30, [x1]		// encoding: [0x3e,0x7c,0x5f,0x22]

	ldaxr	c25, [x5]
	ldaxr	c25, [x26]
	ldaxr	c6, [x5]
	ldaxr	c6, [x26]
// CHECK:	ldaxr	c25, [x5]		// encoding: [0xb9,0xfc,0x5f,0x22]
// CHECK:	ldaxr	c25, [x26]		// encoding: [0x59,0xff,0x5f,0x22]
// CHECK:	ldaxr	c6, [x5]		// encoding: [0xa6,0xfc,0x5f,0x22]
// CHECK:	ldaxr	c6, [x26]		// encoding: [0x46,0xff,0x5f,0x22]

	ldxp	c27, c27, [x24]
	ldxp	c27, c27, [x7]
	ldxp	c27, c4, [x24]
	ldxp	c27, c4, [x7]
	ldxp	c4, c27, [x24]
	ldxp	c4, c27, [x7]
	ldxp	c4, c4, [x24]
	ldxp	c4, c4, [x7]
// CHECK:	ldxp	c27, c27, [x24]		// encoding: [0x1b,0x6f,0x7f,0x22]
// CHECK:	ldxp	c27, c27, [x7]		// encoding: [0xfb,0x6c,0x7f,0x22]
// CHECK:	ldxp	c27, c4, [x24]		// encoding: [0x1b,0x13,0x7f,0x22]
// CHECK:	ldxp	c27, c4, [x7]		// encoding: [0xfb,0x10,0x7f,0x22]
// CHECK:	ldxp	c4, c27, [x24]		// encoding: [0x04,0x6f,0x7f,0x22]
// CHECK:	ldxp	c4, c27, [x7]		// encoding: [0xe4,0x6c,0x7f,0x22]
// CHECK:	ldxp	c4, c4, [x24]		// encoding: [0x04,0x13,0x7f,0x22]
// CHECK:	ldxp	c4, c4, [x7]		// encoding: [0xe4,0x10,0x7f,0x22]

	ldaxp	c29, c2, [x22]
	ldaxp	c29, c2, [x9]
	ldaxp	c29, c29, [x22]
	ldaxp	c29, c29, [x9]
	ldaxp	c2, c2, [x22]
	ldaxp	c2, c2, [x9]
	ldaxp	c2, c29, [x22]
	ldaxp	c2, c29, [x9]
// CHECK:	ldaxp	c29, c2, [x22]		// encoding: [0xdd,0x8a,0x7f,0x22]
// CHECK:	ldaxp	c29, c2, [x9]		// encoding: [0x3d,0x89,0x7f,0x22]
// CHECK:	ldaxp	c29, c29, [x22]		// encoding: [0xdd,0xf6,0x7f,0x22]
// CHECK:	ldaxp	c29, c29, [x9]		// encoding: [0x3d,0xf5,0x7f,0x22]
// CHECK:	ldaxp	c2, c2, [x22]		// encoding: [0xc2,0x8a,0x7f,0x22]
// CHECK:	ldaxp	c2, c2, [x9]		// encoding: [0x22,0x89,0x7f,0x22]
// CHECK:	ldaxp	c2, c29, [x22]		// encoding: [0xc2,0xf6,0x7f,0x22]
// CHECK:	ldaxp	c2, c29, [x9]		// encoding: [0x22,0xf5,0x7f,0x22]

	ldr	c27, [x17], #800
	ldr	c27, [x17], #-816
	ldr	c27, [x14], #800
	ldr	c27, [x14], #-816
	ldr	c4, [x17], #800
	ldr	c4, [x17], #-816
	ldr	c4, [x14], #800
	ldr	c4, [x14], #-816
// CHECK:	ldr	c27, [x17], #800		// encoding: [0x3b,0x26,0x43,0xa2]
// CHECK:	ldr	c27, [x17], #-816		// encoding: [0x3b,0xd6,0x5c,0xa2]
// CHECK:	ldr	c27, [x14], #800		// encoding: [0xdb,0x25,0x43,0xa2]
// CHECK:	ldr	c27, [x14], #-816		// encoding: [0xdb,0xd5,0x5c,0xa2]
// CHECK:	ldr	c4, [x17], #800		// encoding: [0x24,0x26,0x43,0xa2]
// CHECK:	ldr	c4, [x17], #-816		// encoding: [0x24,0xd6,0x5c,0xa2]
// CHECK:	ldr	c4, [x14], #800		// encoding: [0xc4,0x25,0x43,0xa2]
// CHECK:	ldr	c4, [x14], #-816		// encoding: [0xc4,0xd5,0x5c,0xa2]

	ldr	c3, [x11, #60928]
	ldr	c3, [x11, #4592]
	ldr	c3, [x20, #60928]
	ldr	c3, [x20, #4592]
	ldr	c28, [x11, #60928]
	ldr	c28, [x11, #4592]
	ldr	c28, [x20, #60928]
	ldr	c28, [x20, #4592]
// CHECK:	ldr	c3, [x11, #60928]		// encoding: [0x63,0x81,0x7b,0xc2]
// CHECK:	ldr	c3, [x11, #4592]		// encoding: [0x63,0x7d,0x44,0xc2]
// CHECK:	ldr	c3, [x20, #60928]		// encoding: [0x83,0x82,0x7b,0xc2]
// CHECK:	ldr	c3, [x20, #4592]		// encoding: [0x83,0x7e,0x44,0xc2]
// CHECK:	ldr	c28, [x11, #60928]		// encoding: [0x7c,0x81,0x7b,0xc2]
// CHECK:	ldr	c28, [x11, #4592]		// encoding: [0x7c,0x7d,0x44,0xc2]
// CHECK:	ldr	c28, [x20, #60928]		// encoding: [0x9c,0x82,0x7b,0xc2]
// CHECK:	ldr	c28, [x20, #4592]		// encoding: [0x9c,0x7e,0x44,0xc2]

	ldr	c5, [x21, #3152]!
	ldr	c5, [x21, #-3168]!
	ldr	c5, [x10, #3152]!
	ldr	c5, [x10, #-3168]!
	ldr	c26, [x21, #3152]!
	ldr	c26, [x21, #-3168]!
	ldr	c26, [x10, #3152]!
	ldr	c26, [x10, #-3168]!
// CHECK:	ldr	c5, [x21, #3152]!		// encoding: [0xa5,0x5e,0x4c,0xa2]
// CHECK:	ldr	c5, [x21, #-3168]!		// encoding: [0xa5,0xae,0x53,0xa2]
// CHECK:	ldr	c5, [x10, #3152]!		// encoding: [0x45,0x5d,0x4c,0xa2]
// CHECK:	ldr	c5, [x10, #-3168]!		// encoding: [0x45,0xad,0x53,0xa2]
// CHECK:	ldr	c26, [x21, #3152]!		// encoding: [0xba,0x5e,0x4c,0xa2]
// CHECK:	ldr	c26, [x21, #-3168]!		// encoding: [0xba,0xae,0x53,0xa2]
// CHECK:	ldr	c26, [x10, #3152]!		// encoding: [0x5a,0x5d,0x4c,0xa2]
// CHECK:	ldr	c26, [x10, #-3168]!		// encoding: [0x5a,0xad,0x53,0xa2]

	ldr	c4, #-224976
	ldr	c4, #224960
	ldr	c27, #-224976
	ldr	c27, #224960
// CHECK:	ldr	c4, #-224976		// encoding: [0x64,0x22,0x39,0x82]
// CHECK:	ldr	c4, #224960		// encoding: [0x84,0xdd,0x06,0x82]
// CHECK:	ldr	c27, #-224976		// encoding: [0x7b,0x22,0x39,0x82]
// CHECK:	ldr	c27, #224960		// encoding: [0x9b,0xdd,0x06,0x82]

	ldpbr	c25, [c6]
	ldpbr	c25, [c25]
	ldpbr	c6, [c6]
	ldpbr	c6, [c25]
// CHECK:	ldpbr	c25, [c6]		// encoding: [0xd9,0x10,0xc4,0xc2]
// CHECK:	ldpbr	c25, [c25]		// encoding: [0x39,0x13,0xc4,0xc2]
// CHECK:	ldpbr	c6, [c6]		// encoding: [0xc6,0x10,0xc4,0xc2]
// CHECK:	ldpbr	c6, [c25]		// encoding: [0x26,0x13,0xc4,0xc2]

	ldpblr	c2, [csp]
	ldpblr	c2, [c0]
	ldpblr	c29, [csp]
	ldpblr	c29, [c0]
// CHECK:	ldpblr	c2, [csp]		// encoding: [0xe2,0x33,0xc4,0xc2]
// CHECK:	ldpblr	c2, [c0]		// encoding: [0x02,0x30,0xc4,0xc2]
// CHECK:	ldpblr	c29, [csp]		// encoding: [0xfd,0x33,0xc4,0xc2]
// CHECK:	ldpblr	c29, [c0]		// encoding: [0x1d,0x30,0xc4,0xc2]

	ldp	c28, c26, [x15], #-928
	ldp	c28, c26, [x15], #912
	ldp	c28, c26, [x16], #-928
	ldp	c28, c26, [x16], #912
	ldp	c28, c5, [x15], #-928
	ldp	c28, c5, [x15], #912
	ldp	c28, c5, [x16], #-928
	ldp	c28, c5, [x16], #912
	ldp	c3, c26, [x15], #-928
	ldp	c3, c26, [x15], #912
	ldp	c3, c26, [x16], #-928
	ldp	c3, c26, [x16], #912
	ldp	c3, c5, [x15], #-928
	ldp	c3, c5, [x15], #912
	ldp	c3, c5, [x16], #-928
	ldp	c3, c5, [x16], #912
// CHECK:	ldp	c28, c26, [x15], #-928		// encoding: [0xfc,0x69,0xe3,0x22]
// CHECK:	ldp	c28, c26, [x15], #912		// encoding: [0xfc,0xe9,0xdc,0x22]
// CHECK:	ldp	c28, c26, [x16], #-928		// encoding: [0x1c,0x6a,0xe3,0x22]
// CHECK:	ldp	c28, c26, [x16], #912		// encoding: [0x1c,0xea,0xdc,0x22]
// CHECK:	ldp	c28, c5, [x15], #-928		// encoding: [0xfc,0x15,0xe3,0x22]
// CHECK:	ldp	c28, c5, [x15], #912		// encoding: [0xfc,0x95,0xdc,0x22]
// CHECK:	ldp	c28, c5, [x16], #-928		// encoding: [0x1c,0x16,0xe3,0x22]
// CHECK:	ldp	c28, c5, [x16], #912		// encoding: [0x1c,0x96,0xdc,0x22]
// CHECK:	ldp	c3, c26, [x15], #-928		// encoding: [0xe3,0x69,0xe3,0x22]
// CHECK:	ldp	c3, c26, [x15], #912		// encoding: [0xe3,0xe9,0xdc,0x22]
// CHECK:	ldp	c3, c26, [x16], #-928		// encoding: [0x03,0x6a,0xe3,0x22]
// CHECK:	ldp	c3, c26, [x16], #912		// encoding: [0x03,0xea,0xdc,0x22]
// CHECK:	ldp	c3, c5, [x15], #-928		// encoding: [0xe3,0x15,0xe3,0x22]
// CHECK:	ldp	c3, c5, [x15], #912		// encoding: [0xe3,0x95,0xdc,0x22]
// CHECK:	ldp	c3, c5, [x16], #-928		// encoding: [0x03,0x16,0xe3,0x22]
// CHECK:	ldp	c3, c5, [x16], #912		// encoding: [0x03,0x96,0xdc,0x22]

	ldp	c3, c24, [x9, #864]
	ldp	c3, c24, [x9, #-880]
	ldp	c3, c24, [x22, #864]
	ldp	c3, c24, [x22, #-880]
	ldp	c3, c7, [x9, #864]
	ldp	c3, c7, [x9, #-880]
	ldp	c3, c7, [x22, #864]
	ldp	c3, c7, [x22, #-880]
	ldp	c28, c24, [x9, #864]
	ldp	c28, c24, [x9, #-880]
	ldp	c28, c24, [x22, #864]
	ldp	c28, c24, [x22, #-880]
	ldp	c28, c7, [x9, #864]
	ldp	c28, c7, [x9, #-880]
	ldp	c28, c7, [x22, #864]
	ldp	c28, c7, [x22, #-880]
// CHECK:	ldp	c3, c24, [x9, #864]		// encoding: [0x23,0x61,0xdb,0x42]
// CHECK:	ldp	c3, c24, [x9, #-880]		// encoding: [0x23,0xe1,0xe4,0x42]
// CHECK:	ldp	c3, c24, [x22, #864]		// encoding: [0xc3,0x62,0xdb,0x42]
// CHECK:	ldp	c3, c24, [x22, #-880]		// encoding: [0xc3,0xe2,0xe4,0x42]
// CHECK:	ldp	c3, c7, [x9, #864]		// encoding: [0x23,0x1d,0xdb,0x42]
// CHECK:	ldp	c3, c7, [x9, #-880]		// encoding: [0x23,0x9d,0xe4,0x42]
// CHECK:	ldp	c3, c7, [x22, #864]		// encoding: [0xc3,0x1e,0xdb,0x42]
// CHECK:	ldp	c3, c7, [x22, #-880]		// encoding: [0xc3,0x9e,0xe4,0x42]
// CHECK:	ldp	c28, c24, [x9, #864]		// encoding: [0x3c,0x61,0xdb,0x42]
// CHECK:	ldp	c28, c24, [x9, #-880]		// encoding: [0x3c,0xe1,0xe4,0x42]
// CHECK:	ldp	c28, c24, [x22, #864]		// encoding: [0xdc,0x62,0xdb,0x42]
// CHECK:	ldp	c28, c24, [x22, #-880]		// encoding: [0xdc,0xe2,0xe4,0x42]
// CHECK:	ldp	c28, c7, [x9, #864]		// encoding: [0x3c,0x1d,0xdb,0x42]
// CHECK:	ldp	c28, c7, [x9, #-880]		// encoding: [0x3c,0x9d,0xe4,0x42]
// CHECK:	ldp	c28, c7, [x22, #864]		// encoding: [0xdc,0x1e,0xdb,0x42]
// CHECK:	ldp	c28, c7, [x22, #-880]		// encoding: [0xdc,0x9e,0xe4,0x42]

	ldp	c1, c28, [x20, #384]!
	ldp	c1, c28, [x20, #-400]!
	ldp	c1, c28, [x11, #384]!
	ldp	c1, c28, [x11, #-400]!
	ldp	c1, c3, [x20, #384]!
	ldp	c1, c3, [x20, #-400]!
	ldp	c1, c3, [x11, #384]!
	ldp	c1, c3, [x11, #-400]!
	ldp	c30, c28, [x20, #384]!
	ldp	c30, c28, [x20, #-400]!
	ldp	c30, c28, [x11, #384]!
	ldp	c30, c28, [x11, #-400]!
	ldp	c30, c3, [x20, #384]!
	ldp	c30, c3, [x20, #-400]!
	ldp	c30, c3, [x11, #384]!
	ldp	c30, c3, [x11, #-400]!
// CHECK:	ldp	c1, c28, [x20, #384]!		// encoding: [0x81,0x72,0xcc,0x62]
// CHECK:	ldp	c1, c28, [x20, #-400]!		// encoding: [0x81,0xf2,0xf3,0x62]
// CHECK:	ldp	c1, c28, [x11, #384]!		// encoding: [0x61,0x71,0xcc,0x62]
// CHECK:	ldp	c1, c28, [x11, #-400]!		// encoding: [0x61,0xf1,0xf3,0x62]
// CHECK:	ldp	c1, c3, [x20, #384]!		// encoding: [0x81,0x0e,0xcc,0x62]
// CHECK:	ldp	c1, c3, [x20, #-400]!		// encoding: [0x81,0x8e,0xf3,0x62]
// CHECK:	ldp	c1, c3, [x11, #384]!		// encoding: [0x61,0x0d,0xcc,0x62]
// CHECK:	ldp	c1, c3, [x11, #-400]!		// encoding: [0x61,0x8d,0xf3,0x62]
// CHECK:	ldp	c30, c28, [x20, #384]!		// encoding: [0x9e,0x72,0xcc,0x62]
// CHECK:	ldp	c30, c28, [x20, #-400]!		// encoding: [0x9e,0xf2,0xf3,0x62]
// CHECK:	ldp	c30, c28, [x11, #384]!		// encoding: [0x7e,0x71,0xcc,0x62]
// CHECK:	ldp	c30, c28, [x11, #-400]!		// encoding: [0x7e,0xf1,0xf3,0x62]
// CHECK:	ldp	c30, c3, [x20, #384]!		// encoding: [0x9e,0x0e,0xcc,0x62]
// CHECK:	ldp	c30, c3, [x20, #-400]!		// encoding: [0x9e,0x8e,0xf3,0x62]
// CHECK:	ldp	c30, c3, [x11, #384]!		// encoding: [0x7e,0x0d,0xcc,0x62]
// CHECK:	ldp	c30, c3, [x11, #-400]!		// encoding: [0x7e,0x8d,0xf3,0x62]

	ldnp	c29, c6, [x11, #-272]
	ldnp	c29, c6, [x11, #256]
	ldnp	c29, c6, [x20, #-272]
	ldnp	c29, c6, [x20, #256]
	ldnp	c29, c25, [x11, #-272]
	ldnp	c29, c25, [x11, #256]
	ldnp	c29, c25, [x20, #-272]
	ldnp	c29, c25, [x20, #256]
	ldnp	c2, c6, [x11, #-272]
	ldnp	c2, c6, [x11, #256]
	ldnp	c2, c6, [x20, #-272]
	ldnp	c2, c6, [x20, #256]
	ldnp	c2, c25, [x11, #-272]
	ldnp	c2, c25, [x11, #256]
	ldnp	c2, c25, [x20, #-272]
	ldnp	c2, c25, [x20, #256]
// CHECK:	ldnp	c29, c6, [x11, #-272]		// encoding: [0x7d,0x99,0x77,0x62]
// CHECK:	ldnp	c29, c6, [x11, #256]		// encoding: [0x7d,0x19,0x48,0x62]
// CHECK:	ldnp	c29, c6, [x20, #-272]		// encoding: [0x9d,0x9a,0x77,0x62]
// CHECK:	ldnp	c29, c6, [x20, #256]		// encoding: [0x9d,0x1a,0x48,0x62]
// CHECK:	ldnp	c29, c25, [x11, #-272]		// encoding: [0x7d,0xe5,0x77,0x62]
// CHECK:	ldnp	c29, c25, [x11, #256]		// encoding: [0x7d,0x65,0x48,0x62]
// CHECK:	ldnp	c29, c25, [x20, #-272]		// encoding: [0x9d,0xe6,0x77,0x62]
// CHECK:	ldnp	c29, c25, [x20, #256]		// encoding: [0x9d,0x66,0x48,0x62]
// CHECK:	ldnp	c2, c6, [x11, #-272]		// encoding: [0x62,0x99,0x77,0x62]
// CHECK:	ldnp	c2, c6, [x11, #256]		// encoding: [0x62,0x19,0x48,0x62]
// CHECK:	ldnp	c2, c6, [x20, #-272]		// encoding: [0x82,0x9a,0x77,0x62]
// CHECK:	ldnp	c2, c6, [x20, #256]		// encoding: [0x82,0x1a,0x48,0x62]
// CHECK:	ldnp	c2, c25, [x11, #-272]		// encoding: [0x62,0xe5,0x77,0x62]
// CHECK:	ldnp	c2, c25, [x11, #256]		// encoding: [0x62,0x65,0x48,0x62]
// CHECK:	ldnp	c2, c25, [x20, #-272]		// encoding: [0x82,0xe6,0x77,0x62]
// CHECK:	ldnp	c2, c25, [x20, #256]		// encoding: [0x82,0x66,0x48,0x62]

	ldct	x5, [x20]
	ldct	x5, [x11]
	ldct	x26, [x20]
	ldct	x26, [x11]
// CHECK:	ldct	x5, [x20]		// encoding: [0x85,0xb2,0xc4,0xc2]
// CHECK:	ldct	x5, [x11]		// encoding: [0x65,0xb1,0xc4,0xc2]
// CHECK:	ldct	x26, [x20]		// encoding: [0x9a,0xb2,0xc4,0xc2]
// CHECK:	ldct	x26, [x11]		// encoding: [0x7a,0xb1,0xc4,0xc2]

	ldtr	c1, [x6, #4000]
	ldtr	c1, [x6, #-4016]
	ldtr	c1, [x25, #4000]
	ldtr	c1, [x25, #-4016]
	ldtr	c30, [x6, #4000]
	ldtr	c30, [x6, #-4016]
	ldtr	c30, [x25, #4000]
	ldtr	c30, [x25, #-4016]
// CHECK:	ldtr	c1, [x6, #4000]		// encoding: [0xc1,0xa8,0x4f,0xa2]
// CHECK:	ldtr	c1, [x6, #-4016]		// encoding: [0xc1,0x58,0x50,0xa2]
// CHECK:	ldtr	c1, [x25, #4000]		// encoding: [0x21,0xab,0x4f,0xa2]
// CHECK:	ldtr	c1, [x25, #-4016]		// encoding: [0x21,0x5b,0x50,0xa2]
// CHECK:	ldtr	c30, [x6, #4000]		// encoding: [0xde,0xa8,0x4f,0xa2]
// CHECK:	ldtr	c30, [x6, #-4016]		// encoding: [0xde,0x58,0x50,0xa2]
// CHECK:	ldtr	c30, [x25, #4000]		// encoding: [0x3e,0xab,0x4f,0xa2]
// CHECK:	ldtr	c30, [x25, #-4016]		// encoding: [0x3e,0x5b,0x50,0xa2]

	ldur	c4, [x23, #0]
	ldur	c4, [x23, #-1]
	ldur	c4, [x8, #0]
	ldur	c4, [x8, #-1]
	ldur	c27, [x23, #0]
	ldur	c27, [x23, #-1]
	ldur	c27, [x8, #0]
	ldur	c27, [x8, #-1]
// CHECK:	ldur	c4, [x23, #0]		// encoding: [0xe4,0x02,0x40,0xa2]
// CHECK:	ldur	c4, [x23, #-1]		// encoding: [0xe4,0xf2,0x5f,0xa2]
// CHECK:	ldur	c4, [x8, #0]		// encoding: [0x04,0x01,0x40,0xa2]
// CHECK:	ldur	c4, [x8, #-1]		// encoding: [0x04,0xf1,0x5f,0xa2]
// CHECK:	ldur	c27, [x23, #0]		// encoding: [0xfb,0x02,0x40,0xa2]
// CHECK:	ldur	c27, [x23, #-1]		// encoding: [0xfb,0xf2,0x5f,0xa2]
// CHECK:	ldur	c27, [x8, #0]		// encoding: [0x1b,0x01,0x40,0xa2]
// CHECK:	ldur	c27, [x8, #-1]		// encoding: [0x1b,0xf1,0x5f,0xa2]

	mov	c24, c7
	mov	c24, c24
	mov	c7, c7
	mov	c7, c24
// CHECK:	mov	c24, c7		// encoding: [0xf8,0xd0,0xc1,0xc2]
// CHECK:	mov	c24, c24		// encoding: [0x18,0xd3,0xc1,0xc2]
// CHECK:	mov	c7, c7		// encoding: [0xe7,0xd0,0xc1,0xc2]
// CHECK:	mov	c7, c24		// encoding: [0x07,0xd3,0xc1,0xc2]

	orrflgs	c28, c0, #233
	orrflgs	c28, c0, #22
	orrflgs	c28, csp, #233
	orrflgs	c28, csp, #22
	orrflgs	c3, c0, #233
	orrflgs	c3, c0, #22
	orrflgs	c3, csp, #233
	orrflgs	c3, csp, #22
// CHECK:	orrflgs	c28, c0, #233		// encoding: [0x1c,0x28,0xfd,0xc2]
// CHECK:	orrflgs	c28, c0, #22		// encoding: [0x1c,0xc8,0xe2,0xc2]
// CHECK:	orrflgs	c28, csp, #233		// encoding: [0xfc,0x2b,0xfd,0xc2]
// CHECK:	orrflgs	c28, csp, #22		// encoding: [0xfc,0xcb,0xe2,0xc2]
// CHECK:	orrflgs	c3, c0, #233		// encoding: [0x03,0x28,0xfd,0xc2]
// CHECK:	orrflgs	c3, c0, #22		// encoding: [0x03,0xc8,0xe2,0xc2]
// CHECK:	orrflgs	c3, csp, #233		// encoding: [0xe3,0x2b,0xfd,0xc2]
// CHECK:	orrflgs	c3, csp, #22		// encoding: [0xe3,0xcb,0xe2,0xc2]

	orrflgs	c3, c28, x11
	orrflgs	c3, c28, x20
	orrflgs	c3, c3, x11
	orrflgs	c3, c3, x20
	orrflgs	c28, c28, x11
	orrflgs	c28, c28, x20
	orrflgs	c28, c3, x11
	orrflgs	c28, c3, x20
// CHECK:	orrflgs	c3, c28, x11		// encoding: [0x83,0x6b,0xcb,0xc2]
// CHECK:	orrflgs	c3, c28, x20		// encoding: [0x83,0x6b,0xd4,0xc2]
// CHECK:	orrflgs	c3, c3, x11		// encoding: [0x63,0x68,0xcb,0xc2]
// CHECK:	orrflgs	c3, c3, x20		// encoding: [0x63,0x68,0xd4,0xc2]
// CHECK:	orrflgs	c28, c28, x11		// encoding: [0x9c,0x6b,0xcb,0xc2]
// CHECK:	orrflgs	c28, c28, x20		// encoding: [0x9c,0x6b,0xd4,0xc2]
// CHECK:	orrflgs	c28, c3, x11		// encoding: [0x7c,0x68,0xcb,0xc2]
// CHECK:	orrflgs	c28, c3, x20		// encoding: [0x7c,0x68,0xd4,0xc2]

	ret	c3
	ret	c28
// CHECK:	ret	c3		// encoding: [0x60,0x50,0xc2,0xc2]
// CHECK:	ret	c28		// encoding: [0x80,0x53,0xc2,0xc2]

	rets	c6
	rets	c25
// CHECK:	rets	c6		// encoding: [0xc2,0x50,0xc2,0xc2]
// CHECK:	rets	c25		// encoding: [0x22,0x53,0xc2,0xc2]

	retr	c25
	retr	c6
// CHECK:	retr	c25		// encoding: [0x23,0x53,0xc2,0xc2]
// CHECK:	retr	c6		// encoding: [0xc3,0x50,0xc2,0xc2]

	rets	c29, c0, c26
	rets	c29, c0, c5
	rets	c29, czr, c26
	rets	c29, czr, c5
// CHECK:	rets	c29, c0, c26		// encoding: [0x00,0xc4,0xda,0xc2]
// CHECK:	rets	c29, c0, c5		// encoding: [0x00,0xc4,0xc5,0xc2]
// CHECK:	rets	c29, czr, c26		// encoding: [0xe0,0xc7,0xda,0xc2]
// CHECK:	rets	c29, czr, c5		// encoding: [0xe0,0xc7,0xc5,0xc2]

	rrlen	x30, x3
	rrlen	x30, x28
	rrlen	x0, x3
	rrlen	x0, x28
// CHECK:	rrlen	x30, x3		// encoding: [0x7e,0x10,0xc7,0xc2]
// CHECK:	rrlen	x30, x28		// encoding: [0x9e,0x13,0xc7,0xc2]
// CHECK:	rrlen	x0, x3		// encoding: [0x60,0x10,0xc7,0xc2]
// CHECK:	rrlen	x0, x28		// encoding: [0x80,0x13,0xc7,0xc2]

	rrmask	x18, x27
	rrmask	x18, x4
	rrmask	x12, x27
	rrmask	x12, x4
// CHECK:	rrmask	x18, x27		// encoding: [0x72,0x33,0xc7,0xc2]
// CHECK:	rrmask	x18, x4		// encoding: [0x92,0x30,0xc7,0xc2]
// CHECK:	rrmask	x12, x27		// encoding: [0x6c,0x33,0xc7,0xc2]
// CHECK:	rrmask	x12, x4		// encoding: [0x8c,0x30,0xc7,0xc2]

	seal	c27, c28, c4
	seal	c27, c28, c27
	seal	c27, c3, c4
	seal	c27, c3, c27
	seal	c4, c28, c4
	seal	c4, c28, c27
	seal	c4, c3, c4
	seal	c4, c3, c27
// CHECK:	seal	c27, c28, c4		// encoding: [0x9b,0x0b,0xc4,0xc2]
// CHECK:	seal	c27, c28, c27		// encoding: [0x9b,0x0b,0xdb,0xc2]
// CHECK:	seal	c27, c3, c4		// encoding: [0x7b,0x08,0xc4,0xc2]
// CHECK:	seal	c27, c3, c27		// encoding: [0x7b,0x08,0xdb,0xc2]
// CHECK:	seal	c4, c28, c4		// encoding: [0x84,0x0b,0xc4,0xc2]
// CHECK:	seal	c4, c28, c27		// encoding: [0x84,0x0b,0xdb,0xc2]
// CHECK:	seal	c4, c3, c4		// encoding: [0x64,0x08,0xc4,0xc2]
// CHECK:	seal	c4, c3, c27		// encoding: [0x64,0x08,0xdb,0xc2]

	cseal	c2, c26, c7
	cseal	c2, c26, c24
	cseal	c2, c5, c7
	cseal	c2, c5, c24
	cseal	c29, c26, c7
	cseal	c29, c26, c24
	cseal	c29, c5, c7
	cseal	c29, c5, c24
// CHECK:	cseal	c2, c26, c7		// encoding: [0x42,0x47,0xc7,0xc2]
// CHECK:	cseal	c2, c26, c24		// encoding: [0x42,0x47,0xd8,0xc2]
// CHECK:	cseal	c2, c5, c7		// encoding: [0xa2,0x44,0xc7,0xc2]
// CHECK:	cseal	c2, c5, c24		// encoding: [0xa2,0x44,0xd8,0xc2]
// CHECK:	cseal	c29, c26, c7		// encoding: [0x5d,0x47,0xc7,0xc2]
// CHECK:	cseal	c29, c26, c24		// encoding: [0x5d,0x47,0xd8,0xc2]
// CHECK:	cseal	c29, c5, c7		// encoding: [0xbd,0x44,0xc7,0xc2]
// CHECK:	cseal	c29, c5, c24		// encoding: [0xbd,0x44,0xd8,0xc2]

	seal	c28, c5, rb
	seal	c28, c5, lpb
	seal	c28, c5, lb
	seal	c28, c26, rb
	seal	c28, c26, lpb
	seal	c28, c26, lb
	seal	c3, c5, rb
	seal	c3, c5, lpb
	seal	c3, c5, lb
	seal	c3, c26, rb
	seal	c3, c26, lpb
	seal	c3, c26, lb
// CHECK:	seal	c28, c5, rb		// encoding: [0xbc,0x30,0xc3,0xc2]
// CHECK:	seal	c28, c5, lpb		// encoding: [0xbc,0x50,0xc3,0xc2]
// CHECK:	seal	c28, c5, lb		// encoding: [0xbc,0x70,0xc3,0xc2]
// CHECK:	seal	c28, c26, rb		// encoding: [0x5c,0x33,0xc3,0xc2]
// CHECK:	seal	c28, c26, lpb		// encoding: [0x5c,0x53,0xc3,0xc2]
// CHECK:	seal	c28, c26, lb		// encoding: [0x5c,0x73,0xc3,0xc2]
// CHECK:	seal	c3, c5, rb		// encoding: [0xa3,0x30,0xc3,0xc2]
// CHECK:	seal	c3, c5, lpb		// encoding: [0xa3,0x50,0xc3,0xc2]
// CHECK:	seal	c3, c5, lb		// encoding: [0xa3,0x70,0xc3,0xc2]
// CHECK:	seal	c3, c26, rb		// encoding: [0x43,0x33,0xc3,0xc2]
// CHECK:	seal	c3, c26, lpb		// encoding: [0x43,0x53,0xc3,0xc2]
// CHECK:	seal	c3, c26, lb		// encoding: [0x43,0x73,0xc3,0xc2]

	scbnds	c3, c7, x28
	scbnds	c3, c7, x3
	scbnds	c3, c24, x28
	scbnds	c3, c24, x3
	scbnds	c28, c7, x28
	scbnds	c28, c7, x3
	scbnds	c28, c24, x28
	scbnds	c28, c24, x3
// CHECK:	scbnds	c3, c7, x28		// encoding: [0xe3,0x00,0xdc,0xc2]
// CHECK:	scbnds	c3, c7, x3		// encoding: [0xe3,0x00,0xc3,0xc2]
// CHECK:	scbnds	c3, c24, x28		// encoding: [0x03,0x03,0xdc,0xc2]
// CHECK:	scbnds	c3, c24, x3		// encoding: [0x03,0x03,0xc3,0xc2]
// CHECK:	scbnds	c28, c7, x28		// encoding: [0xfc,0x00,0xdc,0xc2]
// CHECK:	scbnds	c28, c7, x3		// encoding: [0xfc,0x00,0xc3,0xc2]
// CHECK:	scbnds	c28, c24, x28		// encoding: [0x1c,0x03,0xdc,0xc2]
// CHECK:	scbnds	c28, c24, x3		// encoding: [0x1c,0x03,0xc3,0xc2]

	scbndse	c30, c4, x13
	scbndse	c30, c4, x18
	scbndse	c30, c27, x13
	scbndse	c30, c27, x18
	scbndse	c1, c4, x13
	scbndse	c1, c4, x18
	scbndse	c1, c27, x13
	scbndse	c1, c27, x18
// CHECK:	scbndse	c30, c4, x13		// encoding: [0x9e,0x20,0xcd,0xc2]
// CHECK:	scbndse	c30, c4, x18		// encoding: [0x9e,0x20,0xd2,0xc2]
// CHECK:	scbndse	c30, c27, x13		// encoding: [0x7e,0x23,0xcd,0xc2]
// CHECK:	scbndse	c30, c27, x18		// encoding: [0x7e,0x23,0xd2,0xc2]
// CHECK:	scbndse	c1, c4, x13		// encoding: [0x81,0x20,0xcd,0xc2]
// CHECK:	scbndse	c1, c4, x18		// encoding: [0x81,0x20,0xd2,0xc2]
// CHECK:	scbndse	c1, c27, x13		// encoding: [0x61,0x23,0xcd,0xc2]
// CHECK:	scbndse	c1, c27, x18		// encoding: [0x61,0x23,0xd2,0xc2]

	scbnds	c1, c2, #55
	scbnds	c1, c2, #8
	scbnds	c1, c29, #55
	scbnds	c1, c29, #8
	scbnds	c30, c2, #55
	scbnds	c30, c2, #8
	scbnds	c30, c29, #55
	scbnds	c30, c29, #8
// CHECK:	scbnds	c1, c2, #55		// encoding: [0x41,0xb8,0xdb,0xc2]
// CHECK:	scbnds	c1, c2, #8		// encoding: [0x41,0x38,0xc4,0xc2]
// CHECK:	scbnds	c1, c29, #55		// encoding: [0xa1,0xbb,0xdb,0xc2]
// CHECK:	scbnds	c1, c29, #8		// encoding: [0xa1,0x3b,0xc4,0xc2]
// CHECK:	scbnds	c30, c2, #55		// encoding: [0x5e,0xb8,0xdb,0xc2]
// CHECK:	scbnds	c30, c2, #8		// encoding: [0x5e,0x38,0xc4,0xc2]
// CHECK:	scbnds	c30, c29, #55		// encoding: [0xbe,0xbb,0xdb,0xc2]
// CHECK:	scbnds	c30, c29, #8		// encoding: [0xbe,0x3b,0xc4,0xc2]

	scflgs	c29, c4, x24
	scflgs	c29, c4, x7
	scflgs	c29, c27, x24
	scflgs	c29, c27, x7
	scflgs	c2, c4, x24
	scflgs	c2, c4, x7
	scflgs	c2, c27, x24
	scflgs	c2, c27, x7
// CHECK:	scflgs	c29, c4, x24		// encoding: [0x9d,0xe0,0xd8,0xc2]
// CHECK:	scflgs	c29, c4, x7		// encoding: [0x9d,0xe0,0xc7,0xc2]
// CHECK:	scflgs	c29, c27, x24		// encoding: [0x7d,0xe3,0xd8,0xc2]
// CHECK:	scflgs	c29, c27, x7		// encoding: [0x7d,0xe3,0xc7,0xc2]
// CHECK:	scflgs	c2, c4, x24		// encoding: [0x82,0xe0,0xd8,0xc2]
// CHECK:	scflgs	c2, c4, x7		// encoding: [0x82,0xe0,0xc7,0xc2]
// CHECK:	scflgs	c2, c27, x24		// encoding: [0x62,0xe3,0xd8,0xc2]
// CHECK:	scflgs	c2, c27, x7		// encoding: [0x62,0xe3,0xc7,0xc2]

	scoff	c4, c30, x16
	scoff	c4, c30, x15
	scoff	c4, c1, x16
	scoff	c4, c1, x15
	scoff	c27, c30, x16
	scoff	c27, c30, x15
	scoff	c27, c1, x16
	scoff	c27, c1, x15
// CHECK:	scoff	c4, c30, x16		// encoding: [0xc4,0x63,0xd0,0xc2]
// CHECK:	scoff	c4, c30, x15		// encoding: [0xc4,0x63,0xcf,0xc2]
// CHECK:	scoff	c4, c1, x16		// encoding: [0x24,0x60,0xd0,0xc2]
// CHECK:	scoff	c4, c1, x15		// encoding: [0x24,0x60,0xcf,0xc2]
// CHECK:	scoff	c27, c30, x16		// encoding: [0xdb,0x63,0xd0,0xc2]
// CHECK:	scoff	c27, c30, x15		// encoding: [0xdb,0x63,0xcf,0xc2]
// CHECK:	scoff	c27, c1, x16		// encoding: [0x3b,0x60,0xd0,0xc2]
// CHECK:	scoff	c27, c1, x15		// encoding: [0x3b,0x60,0xcf,0xc2]

	msr	CDBGDTR_EL0, c29
	msr	CDBGDTR_EL0, c2
	msr	CDLR_EL0, c29
	msr	CDLR_EL0, c2
	msr	CELR_EL1, c29
	msr	CELR_EL1, c2
	msr	CELR_EL12, c29
	msr	CELR_EL12, c2
	msr	CELR_EL2, c29
	msr	CELR_EL2, c2
	msr	CELR_EL3, c29
	msr	CELR_EL3, c2
	msr	CID_EL0, c29
	msr	CID_EL0, c2
	msr	CSP_EL0, c29
	msr	CSP_EL0, c2
	msr	CSP_EL1, c29
	msr	CSP_EL1, c2
	msr	CSP_EL2, c29
	msr	CSP_EL2, c2
	msr	CTPIDR_EL0, c29
	msr	CTPIDR_EL0, c2
	msr	CTPIDR_EL1, c29
	msr	CTPIDR_EL1, c2
	msr	CTPIDR_EL2, c29
	msr	CTPIDR_EL2, c2
	msr	CTPIDR_EL3, c29
	msr	CTPIDR_EL3, c2
	msr	CTPIDRRO_EL0, c29
	msr	CTPIDRRO_EL0, c2
	msr	CVBAR_EL1, c29
	msr	CVBAR_EL1, c2
	msr	CVBAR_EL12, c29
	msr	CVBAR_EL12, c2
	msr	CVBAR_EL2, c29
	msr	CVBAR_EL2, c2
	msr	CVBAR_EL3, c29
	msr	CVBAR_EL3, c2
	msr	DDC, c29
	msr	DDC, c2
	msr	DDC_EL0, c29
	msr	DDC_EL0, c2
	msr	DDC_EL1, c29
	msr	DDC_EL1, c2
	msr	DDC_EL2, c29
	msr	DDC_EL2, c2
	msr	RCSP_EL0, c29
	msr	RCSP_EL0, c2
	msr	RCTPIDR_EL0, c29
	msr	RCTPIDR_EL0, c2
	msr	RDDC_EL0, c29
	msr	RDDC_EL0, c2
// CHECK:	msr	CDBGDTR_EL0, c29		// encoding: [0x1d,0x04,0x83,0xc2]
// CHECK:	msr	CDBGDTR_EL0, c2		// encoding: [0x02,0x04,0x83,0xc2]
// CHECK:	msr	CDLR_EL0, c29		// encoding: [0x3d,0x45,0x8b,0xc2]
// CHECK:	msr	CDLR_EL0, c2		// encoding: [0x22,0x45,0x8b,0xc2]
// CHECK:	msr	CELR_EL1, c29		// encoding: [0x3d,0x40,0x88,0xc2]
// CHECK:	msr	CELR_EL1, c2		// encoding: [0x22,0x40,0x88,0xc2]
// CHECK:	msr	CELR_EL12, c29		// encoding: [0x3d,0x40,0x8d,0xc2]
// CHECK:	msr	CELR_EL12, c2		// encoding: [0x22,0x40,0x8d,0xc2]
// CHECK:	msr	CELR_EL2, c29		// encoding: [0x3d,0x40,0x8c,0xc2]
// CHECK:	msr	CELR_EL2, c2		// encoding: [0x22,0x40,0x8c,0xc2]
// CHECK:	msr	CELR_EL3, c29		// encoding: [0x3d,0x40,0x8e,0xc2]
// CHECK:	msr	CELR_EL3, c2		// encoding: [0x22,0x40,0x8e,0xc2]
// CHECK:	msr	CID_EL0, c29		// encoding: [0xfd,0xd0,0x8b,0xc2]
// CHECK:	msr	CID_EL0, c2		// encoding: [0xe2,0xd0,0x8b,0xc2]
// CHECK:	msr	CSP_EL0, c29		// encoding: [0x1d,0x41,0x88,0xc2]
// CHECK:	msr	CSP_EL0, c2		// encoding: [0x02,0x41,0x88,0xc2]
// CHECK:	msr	CSP_EL1, c29		// encoding: [0x1d,0x41,0x8c,0xc2]
// CHECK:	msr	CSP_EL1, c2		// encoding: [0x02,0x41,0x8c,0xc2]
// CHECK:	msr	CSP_EL2, c29		// encoding: [0x1d,0x41,0x8e,0xc2]
// CHECK:	msr	CSP_EL2, c2		// encoding: [0x02,0x41,0x8e,0xc2]
// CHECK:	msr	CTPIDR_EL0, c29		// encoding: [0x5d,0xd0,0x8b,0xc2]
// CHECK:	msr	CTPIDR_EL0, c2		// encoding: [0x42,0xd0,0x8b,0xc2]
// CHECK:	msr	CTPIDR_EL1, c29		// encoding: [0x9d,0xd0,0x88,0xc2]
// CHECK:	msr	CTPIDR_EL1, c2		// encoding: [0x82,0xd0,0x88,0xc2]
// CHECK:	msr	CTPIDR_EL2, c29		// encoding: [0x5d,0xd0,0x8c,0xc2]
// CHECK:	msr	CTPIDR_EL2, c2		// encoding: [0x42,0xd0,0x8c,0xc2]
// CHECK:	msr	CTPIDR_EL3, c29		// encoding: [0x5d,0xd0,0x8e,0xc2]
// CHECK:	msr	CTPIDR_EL3, c2		// encoding: [0x42,0xd0,0x8e,0xc2]
// CHECK:	msr	CTPIDRRO_EL0, c29		// encoding: [0x7d,0xd0,0x8b,0xc2]
// CHECK:	msr	CTPIDRRO_EL0, c2		// encoding: [0x62,0xd0,0x8b,0xc2]
// CHECK:	msr	CVBAR_EL1, c29		// encoding: [0x1d,0xc0,0x88,0xc2]
// CHECK:	msr	CVBAR_EL1, c2		// encoding: [0x02,0xc0,0x88,0xc2]
// CHECK:	msr	CVBAR_EL12, c29		// encoding: [0x1d,0xc0,0x8d,0xc2]
// CHECK:	msr	CVBAR_EL12, c2		// encoding: [0x02,0xc0,0x8d,0xc2]
// CHECK:	msr	CVBAR_EL2, c29		// encoding: [0x1d,0xc0,0x8c,0xc2]
// CHECK:	msr	CVBAR_EL2, c2		// encoding: [0x02,0xc0,0x8c,0xc2]
// CHECK:	msr	CVBAR_EL3, c29		// encoding: [0x1d,0xc0,0x8e,0xc2]
// CHECK:	msr	CVBAR_EL3, c2		// encoding: [0x02,0xc0,0x8e,0xc2]
// CHECK:	msr	DDC, c29		// encoding: [0x3d,0x41,0x8b,0xc2]
// CHECK:	msr	DDC, c2		// encoding: [0x22,0x41,0x8b,0xc2]
// CHECK:	msr	DDC_EL0, c29		// encoding: [0x3d,0x41,0x88,0xc2]
// CHECK:	msr	DDC_EL0, c2		// encoding: [0x22,0x41,0x88,0xc2]
// CHECK:	msr	DDC_EL1, c29		// encoding: [0x3d,0x41,0x8c,0xc2]
// CHECK:	msr	DDC_EL1, c2		// encoding: [0x22,0x41,0x8c,0xc2]
// CHECK:	msr	DDC_EL2, c29		// encoding: [0x3d,0x41,0x8e,0xc2]
// CHECK:	msr	DDC_EL2, c2		// encoding: [0x22,0x41,0x8e,0xc2]
// CHECK:	msr	RCSP_EL0, c29		// encoding: [0x7d,0x41,0x8f,0xc2]
// CHECK:	msr	RCSP_EL0, c2		// encoding: [0x62,0x41,0x8f,0xc2]
// CHECK:	msr	RCTPIDR_EL0, c29		// encoding: [0x9d,0xd0,0x8b,0xc2]
// CHECK:	msr	RCTPIDR_EL0, c2		// encoding: [0x82,0xd0,0x8b,0xc2]
// CHECK:	msr	RDDC_EL0, c29		// encoding: [0x3d,0x43,0x8b,0xc2]
// CHECK:	msr	RDDC_EL0, c2		// encoding: [0x22,0x43,0x8b,0xc2]

	sctag	c29, c26, x3
	sctag	c29, c26, x28
	sctag	c29, c5, x3
	sctag	c29, c5, x28
	sctag	c2, c26, x3
	sctag	c2, c26, x28
	sctag	c2, c5, x3
	sctag	c2, c5, x28
// CHECK:	sctag	c29, c26, x3		// encoding: [0x5d,0x83,0xc3,0xc2]
// CHECK:	sctag	c29, c26, x28		// encoding: [0x5d,0x83,0xdc,0xc2]
// CHECK:	sctag	c29, c5, x3		// encoding: [0xbd,0x80,0xc3,0xc2]
// CHECK:	sctag	c29, c5, x28		// encoding: [0xbd,0x80,0xdc,0xc2]
// CHECK:	sctag	c2, c26, x3		// encoding: [0x42,0x83,0xc3,0xc2]
// CHECK:	sctag	c2, c26, x28		// encoding: [0x42,0x83,0xdc,0xc2]
// CHECK:	sctag	c2, c5, x3		// encoding: [0xa2,0x80,0xc3,0xc2]
// CHECK:	sctag	c2, c5, x28		// encoding: [0xa2,0x80,0xdc,0xc2]

	scvalue	c28, c30, x26
	scvalue	c28, c30, x5
	scvalue	c28, c1, x26
	scvalue	c28, c1, x5
	scvalue	c3, c30, x26
	scvalue	c3, c30, x5
	scvalue	c3, c1, x26
	scvalue	c3, c1, x5
// CHECK:	scvalue	c28, c30, x26		// encoding: [0xdc,0x43,0xda,0xc2]
// CHECK:	scvalue	c28, c30, x5		// encoding: [0xdc,0x43,0xc5,0xc2]
// CHECK:	scvalue	c28, c1, x26		// encoding: [0x3c,0x40,0xda,0xc2]
// CHECK:	scvalue	c28, c1, x5		// encoding: [0x3c,0x40,0xc5,0xc2]
// CHECK:	scvalue	c3, c30, x26		// encoding: [0xc3,0x43,0xda,0xc2]
// CHECK:	scvalue	c3, c30, x5		// encoding: [0xc3,0x43,0xc5,0xc2]
// CHECK:	scvalue	c3, c1, x26		// encoding: [0x23,0x40,0xda,0xc2]
// CHECK:	scvalue	c3, c1, x5		// encoding: [0x23,0x40,0xc5,0xc2]

	cpytype	c24, c6, c27
	cpytype	c24, c6, c4
	cpytype	c24, c25, c27
	cpytype	c24, c25, c4
	cpytype	c7, c6, c27
	cpytype	c7, c6, c4
	cpytype	c7, c25, c27
	cpytype	c7, c25, c4
// CHECK:	cpytype	c24, c6, c27		// encoding: [0xd8,0x24,0xdb,0xc2]
// CHECK:	cpytype	c24, c6, c4		// encoding: [0xd8,0x24,0xc4,0xc2]
// CHECK:	cpytype	c24, c25, c27		// encoding: [0x38,0x27,0xdb,0xc2]
// CHECK:	cpytype	c24, c25, c4		// encoding: [0x38,0x27,0xc4,0xc2]
// CHECK:	cpytype	c7, c6, c27		// encoding: [0xc7,0x24,0xdb,0xc2]
// CHECK:	cpytype	c7, c6, c4		// encoding: [0xc7,0x24,0xc4,0xc2]
// CHECK:	cpytype	c7, c25, c27		// encoding: [0x27,0x27,0xdb,0xc2]
// CHECK:	cpytype	c7, c25, c4		// encoding: [0x27,0x27,0xc4,0xc2]

	cpyvalue	c27, c1, c6
	cpyvalue	c27, c1, c25
	cpyvalue	c27, c30, c6
	cpyvalue	c27, c30, c25
	cpyvalue	c4, c1, c6
	cpyvalue	c4, c1, c25
	cpyvalue	c4, c30, c6
	cpyvalue	c4, c30, c25
// CHECK:	cpyvalue	c27, c1, c6		// encoding: [0x3b,0x64,0xc6,0xc2]
// CHECK:	cpyvalue	c27, c1, c25		// encoding: [0x3b,0x64,0xd9,0xc2]
// CHECK:	cpyvalue	c27, c30, c6		// encoding: [0xdb,0x67,0xc6,0xc2]
// CHECK:	cpyvalue	c27, c30, c25		// encoding: [0xdb,0x67,0xd9,0xc2]
// CHECK:	cpyvalue	c4, c1, c6		// encoding: [0x24,0x64,0xc6,0xc2]
// CHECK:	cpyvalue	c4, c1, c25		// encoding: [0x24,0x64,0xd9,0xc2]
// CHECK:	cpyvalue	c4, c30, c6		// encoding: [0xc4,0x67,0xc6,0xc2]
// CHECK:	cpyvalue	c4, c30, c25		// encoding: [0xc4,0x67,0xd9,0xc2]

	stxr	w7, c29, [x10]
	stxr	w7, c29, [x21]
	stxr	w7, c2, [x10]
	stxr	w7, c2, [x21]
	stxr	w24, c29, [x10]
	stxr	w24, c29, [x21]
	stxr	w24, c2, [x10]
	stxr	w24, c2, [x21]
// CHECK:	stxr	w7, c29, [x10]		// encoding: [0x5d,0x7d,0x07,0x22]
// CHECK:	stxr	w7, c29, [x21]		// encoding: [0xbd,0x7e,0x07,0x22]
// CHECK:	stxr	w7, c2, [x10]		// encoding: [0x42,0x7d,0x07,0x22]
// CHECK:	stxr	w7, c2, [x21]		// encoding: [0xa2,0x7e,0x07,0x22]
// CHECK:	stxr	w24, c29, [x10]		// encoding: [0x5d,0x7d,0x18,0x22]
// CHECK:	stxr	w24, c29, [x21]		// encoding: [0xbd,0x7e,0x18,0x22]
// CHECK:	stxr	w24, c2, [x10]		// encoding: [0x42,0x7d,0x18,0x22]
// CHECK:	stxr	w24, c2, [x21]		// encoding: [0xa2,0x7e,0x18,0x22]

	stxp	w29, c29, c26, [x17]
	stxp	w29, c29, c26, [x14]
	stxp	w29, c29, c5, [x17]
	stxp	w29, c29, c5, [x14]
	stxp	w29, c2, c26, [x17]
	stxp	w29, c2, c26, [x14]
	stxp	w29, c2, c5, [x17]
	stxp	w29, c2, c5, [x14]
	stxp	w2, c29, c26, [x17]
	stxp	w2, c29, c26, [x14]
	stxp	w2, c29, c5, [x17]
	stxp	w2, c29, c5, [x14]
	stxp	w2, c2, c26, [x17]
	stxp	w2, c2, c26, [x14]
	stxp	w2, c2, c5, [x17]
	stxp	w2, c2, c5, [x14]
// CHECK:	stxp	w29, c29, c26, [x17]		// encoding: [0x3d,0x6a,0x3d,0x22]
// CHECK:	stxp	w29, c29, c26, [x14]		// encoding: [0xdd,0x69,0x3d,0x22]
// CHECK:	stxp	w29, c29, c5, [x17]		// encoding: [0x3d,0x16,0x3d,0x22]
// CHECK:	stxp	w29, c29, c5, [x14]		// encoding: [0xdd,0x15,0x3d,0x22]
// CHECK:	stxp	w29, c2, c26, [x17]		// encoding: [0x22,0x6a,0x3d,0x22]
// CHECK:	stxp	w29, c2, c26, [x14]		// encoding: [0xc2,0x69,0x3d,0x22]
// CHECK:	stxp	w29, c2, c5, [x17]		// encoding: [0x22,0x16,0x3d,0x22]
// CHECK:	stxp	w29, c2, c5, [x14]		// encoding: [0xc2,0x15,0x3d,0x22]
// CHECK:	stxp	w2, c29, c26, [x17]		// encoding: [0x3d,0x6a,0x22,0x22]
// CHECK:	stxp	w2, c29, c26, [x14]		// encoding: [0xdd,0x69,0x22,0x22]
// CHECK:	stxp	w2, c29, c5, [x17]		// encoding: [0x3d,0x16,0x22,0x22]
// CHECK:	stxp	w2, c29, c5, [x14]		// encoding: [0xdd,0x15,0x22,0x22]
// CHECK:	stxp	w2, c2, c26, [x17]		// encoding: [0x22,0x6a,0x22,0x22]
// CHECK:	stxp	w2, c2, c26, [x14]		// encoding: [0xc2,0x69,0x22,0x22]
// CHECK:	stxp	w2, c2, c5, [x17]		// encoding: [0x22,0x16,0x22,0x22]
// CHECK:	stxp	w2, c2, c5, [x14]		// encoding: [0xc2,0x15,0x22,0x22]

	stlxp	w5, c27, c7, [x29]
	stlxp	w5, c27, c7, [x2]
	stlxp	w5, c27, c24, [x29]
	stlxp	w5, c27, c24, [x2]
	stlxp	w5, c4, c7, [x29]
	stlxp	w5, c4, c7, [x2]
	stlxp	w5, c4, c24, [x29]
	stlxp	w5, c4, c24, [x2]
	stlxp	w26, c27, c7, [x29]
	stlxp	w26, c27, c7, [x2]
	stlxp	w26, c27, c24, [x29]
	stlxp	w26, c27, c24, [x2]
	stlxp	w26, c4, c7, [x29]
	stlxp	w26, c4, c7, [x2]
	stlxp	w26, c4, c24, [x29]
	stlxp	w26, c4, c24, [x2]
// CHECK:	stlxp	w5, c27, c7, [x29]		// encoding: [0xbb,0x9f,0x25,0x22]
// CHECK:	stlxp	w5, c27, c7, [x2]		// encoding: [0x5b,0x9c,0x25,0x22]
// CHECK:	stlxp	w5, c27, c24, [x29]		// encoding: [0xbb,0xe3,0x25,0x22]
// CHECK:	stlxp	w5, c27, c24, [x2]		// encoding: [0x5b,0xe0,0x25,0x22]
// CHECK:	stlxp	w5, c4, c7, [x29]		// encoding: [0xa4,0x9f,0x25,0x22]
// CHECK:	stlxp	w5, c4, c7, [x2]		// encoding: [0x44,0x9c,0x25,0x22]
// CHECK:	stlxp	w5, c4, c24, [x29]		// encoding: [0xa4,0xe3,0x25,0x22]
// CHECK:	stlxp	w5, c4, c24, [x2]		// encoding: [0x44,0xe0,0x25,0x22]
// CHECK:	stlxp	w26, c27, c7, [x29]		// encoding: [0xbb,0x9f,0x3a,0x22]
// CHECK:	stlxp	w26, c27, c7, [x2]		// encoding: [0x5b,0x9c,0x3a,0x22]
// CHECK:	stlxp	w26, c27, c24, [x29]		// encoding: [0xbb,0xe3,0x3a,0x22]
// CHECK:	stlxp	w26, c27, c24, [x2]		// encoding: [0x5b,0xe0,0x3a,0x22]
// CHECK:	stlxp	w26, c4, c7, [x29]		// encoding: [0xa4,0x9f,0x3a,0x22]
// CHECK:	stlxp	w26, c4, c7, [x2]		// encoding: [0x44,0x9c,0x3a,0x22]
// CHECK:	stlxp	w26, c4, c24, [x29]		// encoding: [0xa4,0xe3,0x3a,0x22]
// CHECK:	stlxp	w26, c4, c24, [x2]		// encoding: [0x44,0xe0,0x3a,0x22]

	stlxr	w9, c27, [x16]
	stlxr	w9, c27, [x15]
	stlxr	w9, c4, [x16]
	stlxr	w9, c4, [x15]
	stlxr	w22, c27, [x16]
	stlxr	w22, c27, [x15]
	stlxr	w22, c4, [x16]
	stlxr	w22, c4, [x15]
// CHECK:	stlxr	w9, c27, [x16]		// encoding: [0x1b,0xfe,0x09,0x22]
// CHECK:	stlxr	w9, c27, [x15]		// encoding: [0xfb,0xfd,0x09,0x22]
// CHECK:	stlxr	w9, c4, [x16]		// encoding: [0x04,0xfe,0x09,0x22]
// CHECK:	stlxr	w9, c4, [x15]		// encoding: [0xe4,0xfd,0x09,0x22]
// CHECK:	stlxr	w22, c27, [x16]		// encoding: [0x1b,0xfe,0x16,0x22]
// CHECK:	stlxr	w22, c27, [x15]		// encoding: [0xfb,0xfd,0x16,0x22]
// CHECK:	stlxr	w22, c4, [x16]		// encoding: [0x04,0xfe,0x16,0x22]
// CHECK:	stlxr	w22, c4, [x15]		// encoding: [0xe4,0xfd,0x16,0x22]

	str	c4, [sp], #-3408
	str	c4, [sp], #3392
	str	c4, [x0], #-3408
	str	c4, [x0], #3392
	str	c27, [sp], #-3408
	str	c27, [sp], #3392
	str	c27, [x0], #-3408
	str	c27, [x0], #3392
// CHECK:	str	c4, [sp], #-3408		// encoding: [0xe4,0xb7,0x12,0xa2]
// CHECK:	str	c4, [sp], #3392		// encoding: [0xe4,0x47,0x0d,0xa2]
// CHECK:	str	c4, [x0], #-3408		// encoding: [0x04,0xb4,0x12,0xa2]
// CHECK:	str	c4, [x0], #3392		// encoding: [0x04,0x44,0x0d,0xa2]
// CHECK:	str	c27, [sp], #-3408		// encoding: [0xfb,0xb7,0x12,0xa2]
// CHECK:	str	c27, [sp], #3392		// encoding: [0xfb,0x47,0x0d,0xa2]
// CHECK:	str	c27, [x0], #-3408		// encoding: [0x1b,0xb4,0x12,0xa2]
// CHECK:	str	c27, [x0], #3392		// encoding: [0x1b,0x44,0x0d,0xa2]

	str	c25, [x19, #22000]
	str	c25, [x19, #43520]
	str	c25, [x12, #22000]
	str	c25, [x12, #43520]
	str	c6, [x19, #22000]
	str	c6, [x19, #43520]
	str	c6, [x12, #22000]
	str	c6, [x12, #43520]
// CHECK:	str	c25, [x19, #22000]		// encoding: [0x79,0x7e,0x15,0xc2]
// CHECK:	str	c25, [x19, #43520]		// encoding: [0x79,0x82,0x2a,0xc2]
// CHECK:	str	c25, [x12, #22000]		// encoding: [0x99,0x7d,0x15,0xc2]
// CHECK:	str	c25, [x12, #43520]		// encoding: [0x99,0x81,0x2a,0xc2]
// CHECK:	str	c6, [x19, #22000]		// encoding: [0x66,0x7e,0x15,0xc2]
// CHECK:	str	c6, [x19, #43520]		// encoding: [0x66,0x82,0x2a,0xc2]
// CHECK:	str	c6, [x12, #22000]		// encoding: [0x86,0x7d,0x15,0xc2]
// CHECK:	str	c6, [x12, #43520]		// encoding: [0x86,0x81,0x2a,0xc2]

	str	c3, [x22, #-2464]!
	str	c3, [x22, #2448]!
	str	c3, [x9, #-2464]!
	str	c3, [x9, #2448]!
	str	c28, [x22, #-2464]!
	str	c28, [x22, #2448]!
	str	c28, [x9, #-2464]!
	str	c28, [x9, #2448]!
// CHECK:	str	c3, [x22, #-2464]!		// encoding: [0xc3,0x6e,0x16,0xa2]
// CHECK:	str	c3, [x22, #2448]!		// encoding: [0xc3,0x9e,0x09,0xa2]
// CHECK:	str	c3, [x9, #-2464]!		// encoding: [0x23,0x6d,0x16,0xa2]
// CHECK:	str	c3, [x9, #2448]!		// encoding: [0x23,0x9d,0x09,0xa2]
// CHECK:	str	c28, [x22, #-2464]!		// encoding: [0xdc,0x6e,0x16,0xa2]
// CHECK:	str	c28, [x22, #2448]!		// encoding: [0xdc,0x9e,0x09,0xa2]
// CHECK:	str	c28, [x9, #-2464]!		// encoding: [0x3c,0x6d,0x16,0xa2]
// CHECK:	str	c28, [x9, #2448]!		// encoding: [0x3c,0x9d,0x09,0xa2]

	stp	c0, czr, [x10], #-832
	stp	c0, czr, [x10], #816
	stp	c0, czr, [x21], #-832
	stp	c0, czr, [x21], #816
	stp	c0, c0, [x10], #-832
	stp	c0, c0, [x10], #816
	stp	c0, c0, [x21], #-832
	stp	c0, c0, [x21], #816
	stp	czr, czr, [x10], #-832
	stp	czr, czr, [x10], #816
	stp	czr, czr, [x21], #-832
	stp	czr, czr, [x21], #816
	stp	czr, c0, [x10], #-832
	stp	czr, c0, [x10], #816
	stp	czr, c0, [x21], #-832
	stp	czr, c0, [x21], #816
// CHECK:	stp	c0, czr, [x10], #-832		// encoding: [0x40,0x7d,0xa6,0x22]
// CHECK:	stp	c0, czr, [x10], #816		// encoding: [0x40,0xfd,0x99,0x22]
// CHECK:	stp	c0, czr, [x21], #-832		// encoding: [0xa0,0x7e,0xa6,0x22]
// CHECK:	stp	c0, czr, [x21], #816		// encoding: [0xa0,0xfe,0x99,0x22]
// CHECK:	stp	c0, c0, [x10], #-832		// encoding: [0x40,0x01,0xa6,0x22]
// CHECK:	stp	c0, c0, [x10], #816		// encoding: [0x40,0x81,0x99,0x22]
// CHECK:	stp	c0, c0, [x21], #-832		// encoding: [0xa0,0x02,0xa6,0x22]
// CHECK:	stp	c0, c0, [x21], #816		// encoding: [0xa0,0x82,0x99,0x22]
// CHECK:	stp	czr, czr, [x10], #-832		// encoding: [0x5f,0x7d,0xa6,0x22]
// CHECK:	stp	czr, czr, [x10], #816		// encoding: [0x5f,0xfd,0x99,0x22]
// CHECK:	stp	czr, czr, [x21], #-832		// encoding: [0xbf,0x7e,0xa6,0x22]
// CHECK:	stp	czr, czr, [x21], #816		// encoding: [0xbf,0xfe,0x99,0x22]
// CHECK:	stp	czr, c0, [x10], #-832		// encoding: [0x5f,0x01,0xa6,0x22]
// CHECK:	stp	czr, c0, [x10], #816		// encoding: [0x5f,0x81,0x99,0x22]
// CHECK:	stp	czr, c0, [x21], #-832		// encoding: [0xbf,0x02,0xa6,0x22]
// CHECK:	stp	czr, c0, [x21], #816		// encoding: [0xbf,0x82,0x99,0x22]

	stp	c0, c5, [x13, #-336]
	stp	c0, c5, [x13, #320]
	stp	c0, c5, [x18, #-336]
	stp	c0, c5, [x18, #320]
	stp	c0, c26, [x13, #-336]
	stp	c0, c26, [x13, #320]
	stp	c0, c26, [x18, #-336]
	stp	c0, c26, [x18, #320]
	stp	czr, c5, [x13, #-336]
	stp	czr, c5, [x13, #320]
	stp	czr, c5, [x18, #-336]
	stp	czr, c5, [x18, #320]
	stp	czr, c26, [x13, #-336]
	stp	czr, c26, [x13, #320]
	stp	czr, c26, [x18, #-336]
	stp	czr, c26, [x18, #320]
// CHECK:	stp	c0, c5, [x13, #-336]		// encoding: [0xa0,0x95,0xb5,0x42]
// CHECK:	stp	c0, c5, [x13, #320]		// encoding: [0xa0,0x15,0x8a,0x42]
// CHECK:	stp	c0, c5, [x18, #-336]		// encoding: [0x40,0x96,0xb5,0x42]
// CHECK:	stp	c0, c5, [x18, #320]		// encoding: [0x40,0x16,0x8a,0x42]
// CHECK:	stp	c0, c26, [x13, #-336]		// encoding: [0xa0,0xe9,0xb5,0x42]
// CHECK:	stp	c0, c26, [x13, #320]		// encoding: [0xa0,0x69,0x8a,0x42]
// CHECK:	stp	c0, c26, [x18, #-336]		// encoding: [0x40,0xea,0xb5,0x42]
// CHECK:	stp	c0, c26, [x18, #320]		// encoding: [0x40,0x6a,0x8a,0x42]
// CHECK:	stp	czr, c5, [x13, #-336]		// encoding: [0xbf,0x95,0xb5,0x42]
// CHECK:	stp	czr, c5, [x13, #320]		// encoding: [0xbf,0x15,0x8a,0x42]
// CHECK:	stp	czr, c5, [x18, #-336]		// encoding: [0x5f,0x96,0xb5,0x42]
// CHECK:	stp	czr, c5, [x18, #320]		// encoding: [0x5f,0x16,0x8a,0x42]
// CHECK:	stp	czr, c26, [x13, #-336]		// encoding: [0xbf,0xe9,0xb5,0x42]
// CHECK:	stp	czr, c26, [x13, #320]		// encoding: [0xbf,0x69,0x8a,0x42]
// CHECK:	stp	czr, c26, [x18, #-336]		// encoding: [0x5f,0xea,0xb5,0x42]
// CHECK:	stp	czr, c26, [x18, #320]		// encoding: [0x5f,0x6a,0x8a,0x42]

	stp	czr, c7, [x22, #816]!
	stp	czr, c7, [x22, #-832]!
	stp	czr, c7, [x9, #816]!
	stp	czr, c7, [x9, #-832]!
	stp	czr, c24, [x22, #816]!
	stp	czr, c24, [x22, #-832]!
	stp	czr, c24, [x9, #816]!
	stp	czr, c24, [x9, #-832]!
	stp	c0, c7, [x22, #816]!
	stp	c0, c7, [x22, #-832]!
	stp	c0, c7, [x9, #816]!
	stp	c0, c7, [x9, #-832]!
	stp	c0, c24, [x22, #816]!
	stp	c0, c24, [x22, #-832]!
	stp	c0, c24, [x9, #816]!
	stp	c0, c24, [x9, #-832]!
// CHECK:	stp	czr, c7, [x22, #816]!		// encoding: [0xdf,0x9e,0x99,0x62]
// CHECK:	stp	czr, c7, [x22, #-832]!		// encoding: [0xdf,0x1e,0xa6,0x62]
// CHECK:	stp	czr, c7, [x9, #816]!		// encoding: [0x3f,0x9d,0x99,0x62]
// CHECK:	stp	czr, c7, [x9, #-832]!		// encoding: [0x3f,0x1d,0xa6,0x62]
// CHECK:	stp	czr, c24, [x22, #816]!		// encoding: [0xdf,0xe2,0x99,0x62]
// CHECK:	stp	czr, c24, [x22, #-832]!		// encoding: [0xdf,0x62,0xa6,0x62]
// CHECK:	stp	czr, c24, [x9, #816]!		// encoding: [0x3f,0xe1,0x99,0x62]
// CHECK:	stp	czr, c24, [x9, #-832]!		// encoding: [0x3f,0x61,0xa6,0x62]
// CHECK:	stp	c0, c7, [x22, #816]!		// encoding: [0xc0,0x9e,0x99,0x62]
// CHECK:	stp	c0, c7, [x22, #-832]!		// encoding: [0xc0,0x1e,0xa6,0x62]
// CHECK:	stp	c0, c7, [x9, #816]!		// encoding: [0x20,0x9d,0x99,0x62]
// CHECK:	stp	c0, c7, [x9, #-832]!		// encoding: [0x20,0x1d,0xa6,0x62]
// CHECK:	stp	c0, c24, [x22, #816]!		// encoding: [0xc0,0xe2,0x99,0x62]
// CHECK:	stp	c0, c24, [x22, #-832]!		// encoding: [0xc0,0x62,0xa6,0x62]
// CHECK:	stp	c0, c24, [x9, #816]!		// encoding: [0x20,0xe1,0x99,0x62]
// CHECK:	stp	c0, c24, [x9, #-832]!		// encoding: [0x20,0x61,0xa6,0x62]

	stnp	c1, czr, [x0, #192]
	stnp	c1, czr, [x0, #-208]
	stnp	c1, czr, [sp, #192]
	stnp	c1, czr, [sp, #-208]
	stnp	c1, c0, [x0, #192]
	stnp	c1, c0, [x0, #-208]
	stnp	c1, c0, [sp, #192]
	stnp	c1, c0, [sp, #-208]
	stnp	c30, czr, [x0, #192]
	stnp	c30, czr, [x0, #-208]
	stnp	c30, czr, [sp, #192]
	stnp	c30, czr, [sp, #-208]
	stnp	c30, c0, [x0, #192]
	stnp	c30, c0, [x0, #-208]
	stnp	c30, c0, [sp, #192]
	stnp	c30, c0, [sp, #-208]
// CHECK:	stnp	c1, czr, [x0, #192]		// encoding: [0x01,0x7c,0x06,0x62]
// CHECK:	stnp	c1, czr, [x0, #-208]		// encoding: [0x01,0xfc,0x39,0x62]
// CHECK:	stnp	c1, czr, [sp, #192]		// encoding: [0xe1,0x7f,0x06,0x62]
// CHECK:	stnp	c1, czr, [sp, #-208]		// encoding: [0xe1,0xff,0x39,0x62]
// CHECK:	stnp	c1, c0, [x0, #192]		// encoding: [0x01,0x00,0x06,0x62]
// CHECK:	stnp	c1, c0, [x0, #-208]		// encoding: [0x01,0x80,0x39,0x62]
// CHECK:	stnp	c1, c0, [sp, #192]		// encoding: [0xe1,0x03,0x06,0x62]
// CHECK:	stnp	c1, c0, [sp, #-208]		// encoding: [0xe1,0x83,0x39,0x62]
// CHECK:	stnp	c30, czr, [x0, #192]		// encoding: [0x1e,0x7c,0x06,0x62]
// CHECK:	stnp	c30, czr, [x0, #-208]		// encoding: [0x1e,0xfc,0x39,0x62]
// CHECK:	stnp	c30, czr, [sp, #192]		// encoding: [0xfe,0x7f,0x06,0x62]
// CHECK:	stnp	c30, czr, [sp, #-208]		// encoding: [0xfe,0xff,0x39,0x62]
// CHECK:	stnp	c30, c0, [x0, #192]		// encoding: [0x1e,0x00,0x06,0x62]
// CHECK:	stnp	c30, c0, [x0, #-208]		// encoding: [0x1e,0x80,0x39,0x62]
// CHECK:	stnp	c30, c0, [sp, #192]		// encoding: [0xfe,0x03,0x06,0x62]
// CHECK:	stnp	c30, c0, [sp, #-208]		// encoding: [0xfe,0x83,0x39,0x62]

	stlr	c7, [x29]
	stlr	c7, [x2]
	stlr	c24, [x29]
	stlr	c24, [x2]
// CHECK:	stlr	c7, [x29]		// encoding: [0xa7,0xff,0x1f,0x42]
// CHECK:	stlr	c7, [x2]		// encoding: [0x47,0xfc,0x1f,0x42]
// CHECK:	stlr	c24, [x29]		// encoding: [0xb8,0xff,0x1f,0x42]
// CHECK:	stlr	c24, [x2]		// encoding: [0x58,0xfc,0x1f,0x42]

	stct	x22, [x29]
	stct	x22, [x2]
	stct	x9, [x29]
	stct	x9, [x2]
// CHECK:	stct	x22, [x29]		// encoding: [0xb6,0x93,0xc4,0xc2]
// CHECK:	stct	x22, [x2]		// encoding: [0x56,0x90,0xc4,0xc2]
// CHECK:	stct	x9, [x29]		// encoding: [0xa9,0x93,0xc4,0xc2]
// CHECK:	stct	x9, [x2]		// encoding: [0x49,0x90,0xc4,0xc2]

	sttr	c28, [x4, #3440]
	sttr	c28, [x4, #-3456]
	sttr	c28, [x27, #3440]
	sttr	c28, [x27, #-3456]
	sttr	c3, [x4, #3440]
	sttr	c3, [x4, #-3456]
	sttr	c3, [x27, #3440]
	sttr	c3, [x27, #-3456]
// CHECK:	sttr	c28, [x4, #3440]		// encoding: [0x9c,0x78,0x0d,0xa2]
// CHECK:	sttr	c28, [x4, #-3456]		// encoding: [0x9c,0x88,0x12,0xa2]
// CHECK:	sttr	c28, [x27, #3440]		// encoding: [0x7c,0x7b,0x0d,0xa2]
// CHECK:	sttr	c28, [x27, #-3456]		// encoding: [0x7c,0x8b,0x12,0xa2]
// CHECK:	sttr	c3, [x4, #3440]		// encoding: [0x83,0x78,0x0d,0xa2]
// CHECK:	sttr	c3, [x4, #-3456]		// encoding: [0x83,0x88,0x12,0xa2]
// CHECK:	sttr	c3, [x27, #3440]		// encoding: [0x63,0x7b,0x0d,0xa2]
// CHECK:	sttr	c3, [x27, #-3456]		// encoding: [0x63,0x8b,0x12,0xa2]

	stur	c25, [x14, #-29]
	stur	c25, [x14, #28]
	stur	c25, [x17, #-29]
	stur	c25, [x17, #28]
	stur	c6, [x14, #-29]
	stur	c6, [x14, #28]
	stur	c6, [x17, #-29]
	stur	c6, [x17, #28]
// CHECK:	stur	c25, [x14, #-29]		// encoding: [0xd9,0x31,0x1e,0xa2]
// CHECK:	stur	c25, [x14, #28]		// encoding: [0xd9,0xc1,0x01,0xa2]
// CHECK:	stur	c25, [x17, #-29]		// encoding: [0x39,0x32,0x1e,0xa2]
// CHECK:	stur	c25, [x17, #28]		// encoding: [0x39,0xc2,0x01,0xa2]
// CHECK:	stur	c6, [x14, #-29]		// encoding: [0xc6,0x31,0x1e,0xa2]
// CHECK:	stur	c6, [x14, #28]		// encoding: [0xc6,0xc1,0x01,0xa2]
// CHECK:	stur	c6, [x17, #-29]		// encoding: [0x26,0x32,0x1e,0xa2]
// CHECK:	stur	c6, [x17, #28]		// encoding: [0x26,0xc2,0x01,0xa2]

	subs	x15, c26, c2
	subs	x15, c26, c29
	subs	x15, c5, c2
	subs	x15, c5, c29
	subs	x16, c26, c2
	subs	x16, c26, c29
	subs	x16, c5, c2
	subs	x16, c5, c29
// CHECK:	subs	x15, c26, c2		// encoding: [0x4f,0x9b,0xe2,0xc2]
// CHECK:	subs	x15, c26, c29		// encoding: [0x4f,0x9b,0xfd,0xc2]
// CHECK:	subs	x15, c5, c2		// encoding: [0xaf,0x98,0xe2,0xc2]
// CHECK:	subs	x15, c5, c29		// encoding: [0xaf,0x98,0xfd,0xc2]
// CHECK:	subs	x16, c26, c2		// encoding: [0x50,0x9b,0xe2,0xc2]
// CHECK:	subs	x16, c26, c29		// encoding: [0x50,0x9b,0xfd,0xc2]
// CHECK:	subs	x16, c5, c2		// encoding: [0xb0,0x98,0xe2,0xc2]
// CHECK:	subs	x16, c5, c29		// encoding: [0xb0,0x98,0xfd,0xc2]

	swp	c7, c26, [x21]
	swp	c7, c26, [x10]
	swp	c7, c5, [x21]
	swp	c7, c5, [x10]
	swp	c24, c26, [x21]
	swp	c24, c26, [x10]
	swp	c24, c5, [x21]
	swp	c24, c5, [x10]
// CHECK:	swp	c7, c26, [x21]		// encoding: [0xba,0x82,0x27,0xa2]
// CHECK:	swp	c7, c26, [x10]		// encoding: [0x5a,0x81,0x27,0xa2]
// CHECK:	swp	c7, c5, [x21]		// encoding: [0xa5,0x82,0x27,0xa2]
// CHECK:	swp	c7, c5, [x10]		// encoding: [0x45,0x81,0x27,0xa2]
// CHECK:	swp	c24, c26, [x21]		// encoding: [0xba,0x82,0x38,0xa2]
// CHECK:	swp	c24, c26, [x10]		// encoding: [0x5a,0x81,0x38,0xa2]
// CHECK:	swp	c24, c5, [x21]		// encoding: [0xa5,0x82,0x38,0xa2]
// CHECK:	swp	c24, c5, [x10]		// encoding: [0x45,0x81,0x38,0xa2]

	swpa	c27, c25, [x9]
	swpa	c27, c25, [x22]
	swpa	c27, c6, [x9]
	swpa	c27, c6, [x22]
	swpa	c4, c25, [x9]
	swpa	c4, c25, [x22]
	swpa	c4, c6, [x9]
	swpa	c4, c6, [x22]
// CHECK:	swpa	c27, c25, [x9]		// encoding: [0x39,0x81,0xbb,0xa2]
// CHECK:	swpa	c27, c25, [x22]		// encoding: [0xd9,0x82,0xbb,0xa2]
// CHECK:	swpa	c27, c6, [x9]		// encoding: [0x26,0x81,0xbb,0xa2]
// CHECK:	swpa	c27, c6, [x22]		// encoding: [0xc6,0x82,0xbb,0xa2]
// CHECK:	swpa	c4, c25, [x9]		// encoding: [0x39,0x81,0xa4,0xa2]
// CHECK:	swpa	c4, c25, [x22]		// encoding: [0xd9,0x82,0xa4,0xa2]
// CHECK:	swpa	c4, c6, [x9]		// encoding: [0x26,0x81,0xa4,0xa2]
// CHECK:	swpa	c4, c6, [x22]		// encoding: [0xc6,0x82,0xa4,0xa2]

	swpal	czr, c6, [x5]
	swpal	czr, c6, [x26]
	swpal	czr, c25, [x5]
	swpal	czr, c25, [x26]
	swpal	c0, c6, [x5]
	swpal	c0, c6, [x26]
	swpal	c0, c25, [x5]
	swpal	c0, c25, [x26]
// CHECK:	swpal	czr, c6, [x5]		// encoding: [0xa6,0x80,0xff,0xa2]
// CHECK:	swpal	czr, c6, [x26]		// encoding: [0x46,0x83,0xff,0xa2]
// CHECK:	swpal	czr, c25, [x5]		// encoding: [0xb9,0x80,0xff,0xa2]
// CHECK:	swpal	czr, c25, [x26]		// encoding: [0x59,0x83,0xff,0xa2]
// CHECK:	swpal	c0, c6, [x5]		// encoding: [0xa6,0x80,0xe0,0xa2]
// CHECK:	swpal	c0, c6, [x26]		// encoding: [0x46,0x83,0xe0,0xa2]
// CHECK:	swpal	c0, c25, [x5]		// encoding: [0xb9,0x80,0xe0,0xa2]
// CHECK:	swpal	c0, c25, [x26]		// encoding: [0x59,0x83,0xe0,0xa2]

	swpl	c25, c30, [x29]
	swpl	c25, c30, [x2]
	swpl	c25, c1, [x29]
	swpl	c25, c1, [x2]
	swpl	c6, c30, [x29]
	swpl	c6, c30, [x2]
	swpl	c6, c1, [x29]
	swpl	c6, c1, [x2]
// CHECK:	swpl	c25, c30, [x29]		// encoding: [0xbe,0x83,0x79,0xa2]
// CHECK:	swpl	c25, c30, [x2]		// encoding: [0x5e,0x80,0x79,0xa2]
// CHECK:	swpl	c25, c1, [x29]		// encoding: [0xa1,0x83,0x79,0xa2]
// CHECK:	swpl	c25, c1, [x2]		// encoding: [0x41,0x80,0x79,0xa2]
// CHECK:	swpl	c6, c30, [x29]		// encoding: [0xbe,0x83,0x66,0xa2]
// CHECK:	swpl	c6, c30, [x2]		// encoding: [0x5e,0x80,0x66,0xa2]
// CHECK:	swpl	c6, c1, [x29]		// encoding: [0xa1,0x83,0x66,0xa2]
// CHECK:	swpl	c6, c1, [x2]		// encoding: [0x41,0x80,0x66,0xa2]

	unseal	c2, c4, c3
	unseal	c2, c4, c28
	unseal	c2, c27, c3
	unseal	c2, c27, c28
	unseal	c29, c4, c3
	unseal	c29, c4, c28
	unseal	c29, c27, c3
	unseal	c29, c27, c28
// CHECK:	unseal	c2, c4, c3		// encoding: [0x82,0x48,0xc3,0xc2]
// CHECK:	unseal	c2, c4, c28		// encoding: [0x82,0x48,0xdc,0xc2]
// CHECK:	unseal	c2, c27, c3		// encoding: [0x62,0x4b,0xc3,0xc2]
// CHECK:	unseal	c2, c27, c28		// encoding: [0x62,0x4b,0xdc,0xc2]
// CHECK:	unseal	c29, c4, c3		// encoding: [0x9d,0x48,0xc3,0xc2]
// CHECK:	unseal	c29, c4, c28		// encoding: [0x9d,0x48,0xdc,0xc2]
// CHECK:	unseal	c29, c27, c3		// encoding: [0x7d,0x4b,0xc3,0xc2]
// CHECK:	unseal	c29, c27, c28		// encoding: [0x7d,0x4b,0xdc,0xc2]
