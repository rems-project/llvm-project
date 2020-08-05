# RUN: llvm-mc -triple aarch64-none-elf -mattr=+c64,+neon -output-asm-variant=1 -show-encoding < %s | FileCheck %s
# RUN: llvm-mc -triple aarch64-none-elf -mattr=+c64,+morello,+neon -output-asm-variant=1 -show-encoding < %s | FileCheck %s

# Ported from arm64-simd-ldst.s

_ld1st1_multiple:
  ld1.8b {v0}, [c1]
  ld1.8b {v0, v1}, [c1]
  ld1.8b {v0, v1, v2}, [c1]
  ld1.8b {v0, v1, v2, v3}, [c1]

  ld1.8b {v3}, [c1]
  ld1.8b {v3, v4}, [c2]
  ld1.8b {v4, v5, v6}, [c3]
  ld1.8b {v7, v8, v9, v10}, [c4]

  ld1.16b {v0}, [c1]
  ld1.16b {v0, v1}, [c1]
  ld1.16b {v0, v1, v2}, [c1]
  ld1.16b {v0, v1, v2, v3}, [c1]

  ld1.4h {v0}, [c1]
  ld1.4h {v0, v1}, [c1]
  ld1.4h {v0, v1, v2}, [c1]
  ld1.4h {v0, v1, v2, v3}, [c1]

  ld1.8h {v0}, [c1]
  ld1.8h {v0, v1}, [c1]
  ld1.8h {v0, v1, v2}, [c1]
  ld1.8h {v0, v1, v2, v3}, [c1]

  ld1.2s {v0}, [c1]
  ld1.2s {v0, v1}, [c1]
  ld1.2s {v0, v1, v2}, [c1]
  ld1.2s {v0, v1, v2, v3}, [c1]

  ld1.4s {v0}, [c1]
  ld1.4s {v0, v1}, [c1]
  ld1.4s {v0, v1, v2}, [c1]
  ld1.4s {v0, v1, v2, v3}, [c1]

  ld1.1d {v0}, [c1]
  ld1.1d {v0, v1}, [c1]
  ld1.1d {v0, v1, v2}, [c1]
  ld1.1d {v0, v1, v2, v3}, [c1]

  ld1.2d {v0}, [c1]
  ld1.2d {v0, v1}, [c1]
  ld1.2d {v0, v1, v2}, [c1]
  ld1.2d {v0, v1, v2, v3}, [c1]

  st1.8b {v0}, [c1]
  st1.8b {v0, v1}, [c1]
  st1.8b {v0, v1, v2}, [c1]
  st1.8b {v0, v1, v2, v3}, [c1]

  st1.16b {v0}, [c1]
  st1.16b {v0, v1}, [c1]
  st1.16b {v0, v1, v2}, [c1]
  st1.16b {v0, v1, v2, v3}, [c1]

  st1.4h {v0}, [c1]
  st1.4h {v0, v1}, [c1]
  st1.4h {v0, v1, v2}, [c1]
  st1.4h {v0, v1, v2, v3}, [c1]

  st1.8h {v0}, [c1]
  st1.8h {v0, v1}, [c1]
  st1.8h {v0, v1, v2}, [c1]
  st1.8h {v0, v1, v2, v3}, [c1]

  st1.2s {v0}, [c1]
  st1.2s {v0, v1}, [c1]
  st1.2s {v0, v1, v2}, [c1]
  st1.2s {v0, v1, v2, v3}, [c1]

  st1.4s {v0}, [c1]
  st1.4s {v0, v1}, [c1]
  st1.4s {v0, v1, v2}, [c1]
  st1.4s {v0, v1, v2, v3}, [c1]

  st1.1d {v0}, [c1]
  st1.1d {v0, v1}, [c1]
  st1.1d {v0, v1, v2}, [c1]
  st1.1d {v0, v1, v2, v3}, [c1]

  st1.2d {v0}, [c1]
  st1.2d {v0, v1}, [c1]
  st1.2d {v0, v1, v2}, [c1]
  st1.2d {v0, v1, v2, v3}, [c1]

  st1.2d {v5}, [c1]
  st1.2d {v7, v8}, [c26]
  st1.2d {v11, v12, v13}, [c1]
  st1.2d {v28, v29, v30, v31}, [c28]

# CHECK: _ld1st1_multiple:
# CHECK: ld1.8b	{ v0 }, [c1]            // encoding: [0x20,0x70,0x40,0x0c]
# CHECK: ld1.8b	{ v0, v1 }, [c1]        // encoding: [0x20,0xa0,0x40,0x0c]
# CHECK: ld1.8b	{ v0, v1, v2 }, [c1]    // encoding: [0x20,0x60,0x40,0x0c]
# CHECK: ld1.8b	{ v0, v1, v2, v3 }, [c1] // encoding: [0x20,0x20,0x40,0x0c]

# CHECK: ld1.8b { v3 }, [c1]            // encoding: [0x23,0x70,0x40,0x0c]
# CHECK: ld1.8b { v3, v4 }, [c2]        // encoding: [0x43,0xa0,0x40,0x0c]
# CHECK: ld1.8b { v4, v5, v6 }, [c3]    // encoding: [0x64,0x60,0x40,0x0c]
# CHECK: ld1.8b { v7, v8, v9, v10 }, [c4] // encoding: [0x87,0x20,0x40,0x0c]

# CHECK: ld1.16b	{ v0 }, [c1]            // encoding: [0x20,0x70,0x40,0x4c]
# CHECK: ld1.16b	{ v0, v1 }, [c1]        // encoding: [0x20,0xa0,0x40,0x4c]
# CHECK: ld1.16b	{ v0, v1, v2 }, [c1]    // encoding: [0x20,0x60,0x40,0x4c]
# CHECK: ld1.16b	{ v0, v1, v2, v3 }, [c1] // encoding: [0x20,0x20,0x40,0x4c]

# CHECK: ld1.4h	{ v0 }, [c1]            // encoding: [0x20,0x74,0x40,0x0c]
# CHECK: ld1.4h	{ v0, v1 }, [c1]        // encoding: [0x20,0xa4,0x40,0x0c]
# CHECK: ld1.4h	{ v0, v1, v2 }, [c1]    // encoding: [0x20,0x64,0x40,0x0c]
# CHECK: ld1.4h	{ v0, v1, v2, v3 }, [c1] // encoding: [0x20,0x24,0x40,0x0c]

# CHECK: ld1.8h	{ v0 }, [c1]            // encoding: [0x20,0x74,0x40,0x4c]
# CHECK: ld1.8h	{ v0, v1 }, [c1]        // encoding: [0x20,0xa4,0x40,0x4c]
# CHECK: ld1.8h	{ v0, v1, v2 }, [c1]    // encoding: [0x20,0x64,0x40,0x4c]
# CHECK: ld1.8h	{ v0, v1, v2, v3 }, [c1] // encoding: [0x20,0x24,0x40,0x4c]

# CHECK: ld1.2s	{ v0 }, [c1]            // encoding: [0x20,0x78,0x40,0x0c]
# CHECK: ld1.2s	{ v0, v1 }, [c1]        // encoding: [0x20,0xa8,0x40,0x0c]
# CHECK: ld1.2s	{ v0, v1, v2 }, [c1]    // encoding: [0x20,0x68,0x40,0x0c]
# CHECK: ld1.2s	{ v0, v1, v2, v3 }, [c1] // encoding: [0x20,0x28,0x40,0x0c]

# CHECK: ld1.4s	{ v0 }, [c1]            // encoding: [0x20,0x78,0x40,0x4c]
# CHECK: ld1.4s	{ v0, v1 }, [c1]        // encoding: [0x20,0xa8,0x40,0x4c]
# CHECK: ld1.4s	{ v0, v1, v2 }, [c1]    // encoding: [0x20,0x68,0x40,0x4c]
# CHECK: ld1.4s	{ v0, v1, v2, v3 }, [c1] // encoding: [0x20,0x28,0x40,0x4c]

# CHECK: ld1.1d	{ v0 }, [c1]            // encoding: [0x20,0x7c,0x40,0x0c]
# CHECK: ld1.1d	{ v0, v1 }, [c1]        // encoding: [0x20,0xac,0x40,0x0c]
# CHECK: ld1.1d	{ v0, v1, v2 }, [c1]    // encoding: [0x20,0x6c,0x40,0x0c]
# CHECK: ld1.1d	{ v0, v1, v2, v3 }, [c1] // encoding: [0x20,0x2c,0x40,0x0c]

# CHECK: ld1.2d	{ v0 }, [c1]            // encoding: [0x20,0x7c,0x40,0x4c]
# CHECK: ld1.2d	{ v0, v1 }, [c1]        // encoding: [0x20,0xac,0x40,0x4c]
# CHECK: ld1.2d	{ v0, v1, v2 }, [c1]    // encoding: [0x20,0x6c,0x40,0x4c]
# CHECK: ld1.2d	{ v0, v1, v2, v3 }, [c1] // encoding: [0x20,0x2c,0x40,0x4c]


# CHECK: st1.8b	{ v0 }, [c1]            // encoding: [0x20,0x70,0x00,0x0c]
# CHECK: st1.8b	{ v0, v1 }, [c1]        // encoding: [0x20,0xa0,0x00,0x0c]
# CHECK: st1.8b	{ v0, v1, v2 }, [c1]    // encoding: [0x20,0x60,0x00,0x0c]
# CHECK: st1.8b	{ v0, v1, v2, v3 }, [c1] // encoding: [0x20,0x20,0x00,0x0c]

# CHECK: st1.16b	{ v0 }, [c1]            // encoding: [0x20,0x70,0x00,0x4c]
# CHECK: st1.16b	{ v0, v1 }, [c1]        // encoding: [0x20,0xa0,0x00,0x4c]
# CHECK: st1.16b	{ v0, v1, v2 }, [c1]    // encoding: [0x20,0x60,0x00,0x4c]
# CHECK: st1.16b	{ v0, v1, v2, v3 }, [c1] // encoding: [0x20,0x20,0x00,0x4c]

# CHECK: st1.4h	{ v0 }, [c1]            // encoding: [0x20,0x74,0x00,0x0c]
# CHECK: st1.4h	{ v0, v1 }, [c1]        // encoding: [0x20,0xa4,0x00,0x0c]
# CHECK: st1.4h	{ v0, v1, v2 }, [c1]    // encoding: [0x20,0x64,0x00,0x0c]
# CHECK: st1.4h	{ v0, v1, v2, v3 }, [c1] // encoding: [0x20,0x24,0x00,0x0c]

# CHECK: st1.8h	{ v0 }, [c1]            // encoding: [0x20,0x74,0x00,0x4c]
# CHECK: st1.8h	{ v0, v1 }, [c1]        // encoding: [0x20,0xa4,0x00,0x4c]
# CHECK: st1.8h	{ v0, v1, v2 }, [c1]    // encoding: [0x20,0x64,0x00,0x4c]
# CHECK: st1.8h	{ v0, v1, v2, v3 }, [c1] // encoding: [0x20,0x24,0x00,0x4c]

# CHECK: st1.2s	{ v0 }, [c1]            // encoding: [0x20,0x78,0x00,0x0c]
# CHECK: st1.2s	{ v0, v1 }, [c1]        // encoding: [0x20,0xa8,0x00,0x0c]
# CHECK: st1.2s	{ v0, v1, v2 }, [c1]    // encoding: [0x20,0x68,0x00,0x0c]
# CHECK: st1.2s	{ v0, v1, v2, v3 }, [c1] // encoding: [0x20,0x28,0x00,0x0c]

# CHECK: st1.4s	{ v0 }, [c1]            // encoding: [0x20,0x78,0x00,0x4c]
# CHECK: st1.4s	{ v0, v1 }, [c1]        // encoding: [0x20,0xa8,0x00,0x4c]
# CHECK: st1.4s	{ v0, v1, v2 }, [c1]    // encoding: [0x20,0x68,0x00,0x4c]
# CHECK: st1.4s	{ v0, v1, v2, v3 }, [c1] // encoding: [0x20,0x28,0x00,0x4c]

# CHECK: st1.1d	{ v0 }, [c1]            // encoding: [0x20,0x7c,0x00,0x0c]
# CHECK: st1.1d	{ v0, v1 }, [c1]        // encoding: [0x20,0xac,0x00,0x0c]
# CHECK: st1.1d	{ v0, v1, v2 }, [c1]    // encoding: [0x20,0x6c,0x00,0x0c]
# CHECK: st1.1d	{ v0, v1, v2, v3 }, [c1] // encoding: [0x20,0x2c,0x00,0x0c]

# CHECK: st1.2d	{ v0 }, [c1]            // encoding: [0x20,0x7c,0x00,0x4c]
# CHECK: st1.2d	{ v0, v1 }, [c1]        // encoding: [0x20,0xac,0x00,0x4c]
# CHECK: st1.2d	{ v0, v1, v2 }, [c1]    // encoding: [0x20,0x6c,0x00,0x4c]
# CHECK: st1.2d	{ v0, v1, v2, v3 }, [c1] // encoding: [0x20,0x2c,0x00,0x4c]

# CHECK: st1.2d { v5 }, [c1]            // encoding: [0x25,0x7c,0x00,0x4c]
# CHECK: st1.2d { v7, v8 }, [c26]       // encoding: [0x47,0xaf,0x00,0x4c]
# CHECK: st1.2d { v11, v12, v13 }, [c1] // encoding: [0x2b,0x6c,0x00,0x4c]
# CHECK: st1.2d { v28, v29, v30, v31 }, [c28] // encoding: [0x9c,0x2f,0x00,0x4c]

_ld2st2_multiple:
  ld2.8b {v4, v5}, [c7]
  ld2.16b {v4, v5}, [c7]
  ld2.4h {v4, v5}, [c7]
  ld2.8h {v4, v5}, [c7]
  ld2.2s {v4, v5}, [c7]
  ld2.4s {v4, v5}, [c7]
  ld2.2d {v4, v5}, [c7]

  st2.8b {v4, v5}, [c7]
  st2.16b {v4, v5}, [c7]
  st2.4h {v4, v5}, [c7]
  st2.8h {v4, v5}, [c7]
  st2.2s {v4, v5}, [c7]
  st2.4s {v4, v5}, [c7]
  st2.2d {v4, v5}, [c7]


# CHECK: _ld2st2_multiple
# CHECK: ld2.8b { v4, v5 }, [c7]       // encoding: [0xe4,0x80,0x40,0x0c]
# CHECK: ld2.16b { v4, v5 }, [c7]      // encoding: [0xe4,0x80,0x40,0x4c]
# CHECK: ld2.4h { v4, v5 }, [c7]       // encoding: [0xe4,0x84,0x40,0x0c]
# CHECK: ld2.8h { v4, v5 }, [c7]       // encoding: [0xe4,0x84,0x40,0x4c]
# CHECK: ld2.2s { v4, v5 }, [c7]       // encoding: [0xe4,0x88,0x40,0x0c]
# CHECK: ld2.4s { v4, v5 }, [c7]       // encoding: [0xe4,0x88,0x40,0x4c]
# CHECK: ld2.2d { v4, v5 }, [c7]       // encoding: [0xe4,0x8c,0x40,0x4c]

# CHECK: st2.8b { v4, v5 }, [c7]       // encoding: [0xe4,0x80,0x00,0x0c]
# CHECK: st2.16b { v4, v5 }, [c7]      // encoding: [0xe4,0x80,0x00,0x4c]
# CHECK: st2.4h { v4, v5 }, [c7]       // encoding: [0xe4,0x84,0x00,0x0c]
# CHECK: st2.8h { v4, v5 }, [c7]       // encoding: [0xe4,0x84,0x00,0x4c]
# CHECK: st2.2s { v4, v5 }, [c7]       // encoding: [0xe4,0x88,0x00,0x0c]
# CHECK: st2.4s { v4, v5 }, [c7]       // encoding: [0xe4,0x88,0x00,0x4c]
# CHECK: st2.2d { v4, v5 }, [c7]       // encoding: [0xe4,0x8c,0x00,0x4c]


ld3st3_multiple:
    ld3.8b {v4, v5, v6}, [c7]
    ld3.16b {v4, v5, v6}, [c7]
    ld3.4h {v4, v5, v6}, [c7]
    ld3.8h {v4, v5, v6}, [c7]
    ld3.2s {v4, v5, v6}, [c7]
    ld3.4s {v4, v5, v6}, [c7]
    ld3.2d {v4, v5, v6}, [c7]

    ld3.8b {v9, v10, v11}, [c24]
    ld3.16b {v14, v15, v16}, [c7]
    ld3.4h {v24, v25, v26}, [c29]
    ld3.8h {v30, v31, v0}, [c24]
    ld3.2s {v2, v3, v4}, [c7]
    ld3.4s {v4, v5, v6}, [c29]
    ld3.2d {v7, v8, v9}, [c24]

    st3.8b {v4, v5, v6}, [c7]
    st3.16b {v4, v5, v6}, [c7]
    st3.4h {v4, v5, v6}, [c7]
    st3.8h {v4, v5, v6}, [c7]
    st3.2s {v4, v5, v6}, [c7]
    st3.4s {v4, v5, v6}, [c7]
    st3.2d {v4, v5, v6}, [c7]

    st3.8b {v10, v11, v12}, [c24]
    st3.16b {v14, v15, v16}, [c7]
    st3.4h {v24, v25, v26}, [c29]
    st3.8h {v30, v31, v0}, [c24]
    st3.2s {v2, v3, v4}, [c7]
    st3.4s {v7, v8, v9}, [c29]
    st3.2d {v4, v5, v6}, [c24]

# CHECK: ld3st3_multiple:
# CHECK: ld3.8b { v4, v5, v6 }, [c7]   // encoding: [0xe4,0x40,0x40,0x0c]
# CHECK: ld3.16b { v4, v5, v6 }, [c7]   // encoding: [0xe4,0x40,0x40,0x4c]
# CHECK: ld3.4h { v4, v5, v6 }, [c7]   // encoding: [0xe4,0x44,0x40,0x0c]
# CHECK: ld3.8h { v4, v5, v6 }, [c7]   // encoding: [0xe4,0x44,0x40,0x4c]
# CHECK: ld3.2s { v4, v5, v6 }, [c7]   // encoding: [0xe4,0x48,0x40,0x0c]
# CHECK: ld3.4s { v4, v5, v6 }, [c7]   // encoding: [0xe4,0x48,0x40,0x4c]
# CHECK: ld3.2d { v4, v5, v6 }, [c7]   // encoding: [0xe4,0x4c,0x40,0x4c]

# CHECK: ld3.8b { v9, v10, v11 }, [c24]  // encoding: [0x09,0x43,0x40,0x0c]
# CHECK: ld3.16b { v14, v15, v16 }, [c7] // encoding: [0xee,0x40,0x40,0x4c]
# CHECK: ld3.4h { v24, v25, v26 }, [c29] // encoding: [0xb8,0x47,0x40,0x0c]
# CHECK: ld3.8h { v30, v31, v0 }, [c24]  // encoding: [0x1e,0x47,0x40,0x4c]
# CHECK: ld3.2s { v2, v3, v4 }, [c7]   // encoding: [0xe2,0x48,0x40,0x0c]
# CHECK: ld3.4s { v4, v5, v6 }, [c29]    // encoding: [0xa4,0x4b,0x40,0x4c]
# CHECK: ld3.2d { v7, v8, v9 }, [c24]    // encoding: [0x07,0x4f,0x40,0x4c]

# CHECK: st3.8b { v4, v5, v6 }, [c7]   // encoding: [0xe4,0x40,0x00,0x0c]
# CHECK: st3.16b { v4, v5, v6 }, [c7]   // encoding: [0xe4,0x40,0x00,0x4c]
# CHECK: st3.4h { v4, v5, v6 }, [c7]   // encoding: [0xe4,0x44,0x00,0x0c]
# CHECK: st3.8h { v4, v5, v6 }, [c7]   // encoding: [0xe4,0x44,0x00,0x4c]
# CHECK: st3.2s { v4, v5, v6 }, [c7]   // encoding: [0xe4,0x48,0x00,0x0c]
# CHECK: st3.4s { v4, v5, v6 }, [c7]   // encoding: [0xe4,0x48,0x00,0x4c]
# CHECK: st3.2d { v4, v5, v6 }, [c7]   // encoding: [0xe4,0x4c,0x00,0x4c]

# CHECK: st3.8b { v10, v11, v12 }, [c24] // encoding: [0x0a,0x43,0x00,0x0c]
# CHECK: st3.16b { v14, v15, v16 }, [c7] // encoding: [0xee,0x40,0x00,0x4c]
# CHECK: st3.4h { v24, v25, v26 }, [c29] // encoding: [0xb8,0x47,0x00,0x0c]
# CHECK: st3.8h { v30, v31, v0 }, [c24]  // encoding: [0x1e,0x47,0x00,0x4c]
# CHECK: st3.2s { v2, v3, v4 }, [c7]   // encoding: [0xe2,0x48,0x00,0x0c]
# CHECK: st3.4s { v7, v8, v9 }, [c29]    // encoding: [0xa7,0x4b,0x00,0x4c]
# CHECK: st3.2d { v4, v5, v6 }, [c24]    // encoding: [0x04,0x4f,0x00,0x4c]

ld4st4_multiple:
    ld4.8b {v4, v5, v6, v7}, [c7]
    ld4.16b {v4, v5, v6, v7}, [c7]
    ld4.4h {v4, v5, v6, v7}, [c7]
    ld4.8h {v4, v5, v6, v7}, [c7]
    ld4.2s {v4, v5, v6, v7}, [c7]
    ld4.4s {v4, v5, v6, v7}, [c7]
    ld4.2d {v4, v5, v6, v7}, [c7]

    st4.8b {v4, v5, v6, v7}, [c7]
    st4.16b {v4, v5, v6, v7}, [c7]
    st4.4h {v4, v5, v6, v7}, [c7]
    st4.8h {v4, v5, v6, v7}, [c7]
    st4.2s {v4, v5, v6, v7}, [c7]
    st4.4s {v4, v5, v6, v7}, [c7]
    st4.2d {v4, v5, v6, v7}, [c7]

# CHECK: ld4st4_multiple:
# CHECK: ld4.8b { v4, v5, v6, v7 }, [c7] // encoding: [0xe4,0x00,0x40,0x0c]
# CHECK: ld4.16b { v4, v5, v6, v7 }, [c7] // encoding: [0xe4,0x00,0x40,0x4c]
# CHECK: ld4.4h { v4, v5, v6, v7 }, [c7] // encoding: [0xe4,0x04,0x40,0x0c]
# CHECK: ld4.8h { v4, v5, v6, v7 }, [c7] // encoding: [0xe4,0x04,0x40,0x4c]
# CHECK: ld4.2s { v4, v5, v6, v7 }, [c7] // encoding: [0xe4,0x08,0x40,0x0c]
# CHECK: ld4.4s { v4, v5, v6, v7 }, [c7] // encoding: [0xe4,0x08,0x40,0x4c]
# CHECK: ld4.2d { v4, v5, v6, v7 }, [c7] // encoding: [0xe4,0x0c,0x40,0x4c]

# CHECK: st4.8b { v4, v5, v6, v7 }, [c7] // encoding: [0xe4,0x00,0x00,0x0c]
# CHECK: st4.16b { v4, v5, v6, v7 }, [c7] // encoding: [0xe4,0x00,0x00,0x4c]
# CHECK: st4.4h { v4, v5, v6, v7 }, [c7] // encoding: [0xe4,0x04,0x00,0x0c]
# CHECK: st4.8h { v4, v5, v6, v7 }, [c7] // encoding: [0xe4,0x04,0x00,0x4c]
# CHECK: st4.2s { v4, v5, v6, v7 }, [c7] // encoding: [0xe4,0x08,0x00,0x0c]
# CHECK: st4.4s { v4, v5, v6, v7 }, [c7] // encoding: [0xe4,0x08,0x00,0x4c]
# CHECK: st4.2d { v4, v5, v6, v7 }, [c7] // encoding: [0xe4,0x0c,0x00,0x4c]

#-----------------------------------------------------------------------------
# Post-increment versions.
#-----------------------------------------------------------------------------

_ld1st1_multiple_post:
  ld1.8b {v0}, [c1], x15
  ld1.8b {v0, v1}, [c1], x15
  ld1.8b {v0, v1, v2}, [c1], x15
  ld1.8b {v0, v1, v2, v3}, [c1], x15

  ld1.16b {v0}, [c1], x15
  ld1.16b {v0, v1}, [c1], x15
  ld1.16b {v0, v1, v2}, [c1], x15
  ld1.16b {v0, v1, v2, v3}, [c1], x15

  ld1.4h {v0}, [c1], x15
  ld1.4h {v0, v1}, [c1], x15
  ld1.4h {v0, v1, v2}, [c1], x15
  ld1.4h {v0, v1, v2, v3}, [c1], x15

  ld1.8h {v0}, [c1], x15
  ld1.8h {v0, v1}, [c1], x15
  ld1.8h {v0, v1, v2}, [c1], x15
  ld1.8h {v0, v1, v2, v3}, [c1], x15

  ld1.2s {v0}, [c1], x15
  ld1.2s {v0, v1}, [c1], x15
  ld1.2s {v0, v1, v2}, [c1], x15
  ld1.2s {v0, v1, v2, v3}, [c1], x15

  ld1.4s {v0}, [c1], x15
  ld1.4s {v0, v1}, [c1], x15
  ld1.4s {v0, v1, v2}, [c1], x15
  ld1.4s {v0, v1, v2, v3}, [c1], x15

  ld1.1d {v0}, [c1], x15
  ld1.1d {v0, v1}, [c1], x15
  ld1.1d {v0, v1, v2}, [c1], x15
  ld1.1d {v0, v1, v2, v3}, [c1], x15

  ld1.2d {v0}, [c1], x15
  ld1.2d {v0, v1}, [c1], x15
  ld1.2d {v0, v1, v2}, [c1], x15
  ld1.2d {v0, v1, v2, v3}, [c1], x15

  st1.8b {v0}, [c1], x15
  st1.8b {v0, v1}, [c1], x15
  st1.8b {v0, v1, v2}, [c1], x15
  st1.8b {v0, v1, v2, v3}, [c1], x15

  st1.16b {v0}, [c1], x15
  st1.16b {v0, v1}, [c1], x15
  st1.16b {v0, v1, v2}, [c1], x15
  st1.16b {v0, v1, v2, v3}, [c1], x15

  st1.4h {v0}, [c1], x15
  st1.4h {v0, v1}, [c1], x15
  st1.4h {v0, v1, v2}, [c1], x15
  st1.4h {v0, v1, v2, v3}, [c1], x15

  st1.8h {v0}, [c1], x15
  st1.8h {v0, v1}, [c1], x15
  st1.8h {v0, v1, v2}, [c1], x15
  st1.8h {v0, v1, v2, v3}, [c1], x15

  st1.2s {v0}, [c1], x15
  st1.2s {v0, v1}, [c1], x15
  st1.2s {v0, v1, v2}, [c1], x15
  st1.2s {v0, v1, v2, v3}, [c1], x15

  st1.4s {v0}, [c1], x15
  st1.4s {v0, v1}, [c1], x15
  st1.4s {v0, v1, v2}, [c1], x15
  st1.4s {v0, v1, v2, v3}, [c1], x15

  st1.1d {v0}, [c1], x15
  st1.1d {v0, v1}, [c1], x15
  st1.1d {v0, v1, v2}, [c1], x15
  st1.1d {v0, v1, v2, v3}, [c1], x15

  st1.2d {v0}, [c1], x15
  st1.2d {v0, v1}, [c1], x15
  st1.2d {v0, v1, v2}, [c1], x15
  st1.2d {v0, v1, v2, v3}, [c1], x15

  ld1.8b {v0}, [c1], #8
  ld1.8b {v0, v1}, [c1], #16
  ld1.8b {v0, v1, v2}, [c1], #24
  ld1.8b {v0, v1, v2, v3}, [c1], #32

  ld1.16b {v0}, [c1], #16
  ld1.16b {v0, v1}, [c1], #32
  ld1.16b {v0, v1, v2}, [c1], #48
  ld1.16b {v0, v1, v2, v3}, [c1], #64

  ld1.4h {v0}, [c1], #8
  ld1.4h {v0, v1}, [c1], #16
  ld1.4h {v0, v1, v2}, [c1], #24
  ld1.4h {v0, v1, v2, v3}, [c1], #32

  ld1.8h {v0}, [c1], #16
  ld1.8h {v0, v1}, [c1], #32
  ld1.8h {v0, v1, v2}, [c1], #48
  ld1.8h {v0, v1, v2, v3}, [c1], #64

  ld1.2s {v0}, [c1], #8
  ld1.2s {v0, v1}, [c1], #16
  ld1.2s {v0, v1, v2}, [c1], #24
  ld1.2s {v0, v1, v2, v3}, [c1], #32

  ld1.4s {v0}, [c1], #16
  ld1.4s {v0, v1}, [c1], #32
  ld1.4s {v0, v1, v2}, [c1], #48
  ld1.4s {v0, v1, v2, v3}, [c1], #64

  ld1.1d {v0}, [c1], #8
  ld1.1d {v0, v1}, [c1], #16
  ld1.1d {v0, v1, v2}, [c1], #24
  ld1.1d {v0, v1, v2, v3}, [c1], #32

  ld1.2d {v0}, [c1], #16
  ld1.2d {v0, v1}, [c1], #32
  ld1.2d {v0, v1, v2}, [c1], #48
  ld1.2d {v0, v1, v2, v3}, [c1], #64

  st1.8b {v0}, [c1], #8
  st1.8b {v0, v1}, [c1], #16
  st1.8b {v0, v1, v2}, [c1], #24
  st1.8b {v0, v1, v2, v3}, [c1], #32

  st1.16b {v0}, [c1], #16
  st1.16b {v0, v1}, [c1], #32
  st1.16b {v0, v1, v2}, [c1], #48
  st1.16b {v0, v1, v2, v3}, [c1], #64

  st1.4h {v0}, [c1], #8
  st1.4h {v0, v1}, [c1], #16
  st1.4h {v0, v1, v2}, [c1], #24
  st1.4h {v0, v1, v2, v3}, [c1], #32

  st1.8h {v0}, [c1], #16
  st1.8h {v0, v1}, [c1], #32
  st1.8h {v0, v1, v2}, [c1], #48
  st1.8h {v0, v1, v2, v3}, [c1], #64

  st1.2s {v0}, [c1], #8
  st1.2s {v0, v1}, [c1], #16
  st1.2s {v0, v1, v2}, [c1], #24
  st1.2s {v0, v1, v2, v3}, [c1], #32

  st1.4s {v0}, [c1], #16
  st1.4s {v0, v1}, [c1], #32
  st1.4s {v0, v1, v2}, [c1], #48
  st1.4s {v0, v1, v2, v3}, [c1], #64

  st1.1d {v0}, [c1], #8
  st1.1d {v0, v1}, [c1], #16
  st1.1d {v0, v1, v2}, [c1], #24
  st1.1d {v0, v1, v2, v3}, [c1], #32

  st1.2d {v0}, [c1], #16
  st1.2d {v0, v1}, [c1], #32
  st1.2d {v0, v1, v2}, [c1], #48
  st1.2d {v0, v1, v2, v3}, [c1], #64

# CHECK: ld1st1_multiple_post:
# CHECK: ld1.8b { v0 }, [c1], x15       // encoding: [0x20,0x70,0xcf,0x0c]
# CHECK: ld1.8b { v0, v1 }, [c1], x15   // encoding: [0x20,0xa0,0xcf,0x0c]
# CHECK: ld1.8b { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x60,0xcf,0x0c]
# CHECK: ld1.8b { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x20,0xcf,0x0c]

# CHECK: ld1.16b { v0 }, [c1], x15       // encoding: [0x20,0x70,0xcf,0x4c]
# CHECK: ld1.16b { v0, v1 }, [c1], x15   // encoding: [0x20,0xa0,0xcf,0x4c]
# CHECK: ld1.16b { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x60,0xcf,0x4c]
# CHECK: ld1.16b { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x20,0xcf,0x4c]

# CHECK: ld1.4h { v0 }, [c1], x15       // encoding: [0x20,0x74,0xcf,0x0c]
# CHECK: ld1.4h { v0, v1 }, [c1], x15   // encoding: [0x20,0xa4,0xcf,0x0c]
# CHECK: ld1.4h { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x64,0xcf,0x0c]
# CHECK: ld1.4h { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x24,0xcf,0x0c]

# CHECK: ld1.8h { v0 }, [c1], x15       // encoding: [0x20,0x74,0xcf,0x4c]
# CHECK: ld1.8h { v0, v1 }, [c1], x15   // encoding: [0x20,0xa4,0xcf,0x4c]
# CHECK: ld1.8h { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x64,0xcf,0x4c]
# CHECK: ld1.8h { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x24,0xcf,0x4c]

# CHECK: ld1.2s { v0 }, [c1], x15       // encoding: [0x20,0x78,0xcf,0x0c]
# CHECK: ld1.2s { v0, v1 }, [c1], x15   // encoding: [0x20,0xa8,0xcf,0x0c]
# CHECK: ld1.2s { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x68,0xcf,0x0c]
# CHECK: ld1.2s { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x28,0xcf,0x0c]

# CHECK: ld1.4s { v0 }, [c1], x15       // encoding: [0x20,0x78,0xcf,0x4c]
# CHECK: ld1.4s { v0, v1 }, [c1], x15   // encoding: [0x20,0xa8,0xcf,0x4c]
# CHECK: ld1.4s { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x68,0xcf,0x4c]
# CHECK: ld1.4s { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x28,0xcf,0x4c]

# CHECK: ld1.1d { v0 }, [c1], x15       // encoding: [0x20,0x7c,0xcf,0x0c]
# CHECK: ld1.1d { v0, v1 }, [c1], x15   // encoding: [0x20,0xac,0xcf,0x0c]
# CHECK: ld1.1d { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x6c,0xcf,0x0c]
# CHECK: ld1.1d { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x2c,0xcf,0x0c]

# CHECK: ld1.2d { v0 }, [c1], x15       // encoding: [0x20,0x7c,0xcf,0x4c]
# CHECK: ld1.2d { v0, v1 }, [c1], x15   // encoding: [0x20,0xac,0xcf,0x4c]
# CHECK: ld1.2d { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x6c,0xcf,0x4c]
# CHECK: ld1.2d { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x2c,0xcf,0x4c]

# CHECK: st1.8b { v0 }, [c1], x15       // encoding: [0x20,0x70,0x8f,0x0c]
# CHECK: st1.8b { v0, v1 }, [c1], x15   // encoding: [0x20,0xa0,0x8f,0x0c]
# CHECK: st1.8b { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x60,0x8f,0x0c]
# CHECK: st1.8b { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x20,0x8f,0x0c]

# CHECK: st1.16b { v0 }, [c1], x15       // encoding: [0x20,0x70,0x8f,0x4c]
# CHECK: st1.16b { v0, v1 }, [c1], x15   // encoding: [0x20,0xa0,0x8f,0x4c]
# CHECK: st1.16b { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x60,0x8f,0x4c]
# CHECK: st1.16b { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x20,0x8f,0x4c]

# CHECK: st1.4h { v0 }, [c1], x15       // encoding: [0x20,0x74,0x8f,0x0c]
# CHECK: st1.4h { v0, v1 }, [c1], x15   // encoding: [0x20,0xa4,0x8f,0x0c]
# CHECK: st1.4h { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x64,0x8f,0x0c]
# CHECK: st1.4h { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x24,0x8f,0x0c]

# CHECK: st1.8h { v0 }, [c1], x15       // encoding: [0x20,0x74,0x8f,0x4c]
# CHECK: st1.8h { v0, v1 }, [c1], x15   // encoding: [0x20,0xa4,0x8f,0x4c]
# CHECK: st1.8h { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x64,0x8f,0x4c]
# CHECK: st1.8h { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x24,0x8f,0x4c]

# CHECK: st1.2s { v0 }, [c1], x15       // encoding: [0x20,0x78,0x8f,0x0c]
# CHECK: st1.2s { v0, v1 }, [c1], x15   // encoding: [0x20,0xa8,0x8f,0x0c]
# CHECK: st1.2s { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x68,0x8f,0x0c]
# CHECK: st1.2s { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x28,0x8f,0x0c]

# CHECK: st1.4s { v0 }, [c1], x15       // encoding: [0x20,0x78,0x8f,0x4c]
# CHECK: st1.4s { v0, v1 }, [c1], x15   // encoding: [0x20,0xa8,0x8f,0x4c]
# CHECK: st1.4s { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x68,0x8f,0x4c]
# CHECK: st1.4s { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x28,0x8f,0x4c]

# CHECK: st1.1d { v0 }, [c1], x15       // encoding: [0x20,0x7c,0x8f,0x0c]
# CHECK: st1.1d { v0, v1 }, [c1], x15   // encoding: [0x20,0xac,0x8f,0x0c]
# CHECK: st1.1d { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x6c,0x8f,0x0c]
# CHECK: st1.1d { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x2c,0x8f,0x0c]

# CHECK: st1.2d { v0 }, [c1], x15       // encoding: [0x20,0x7c,0x8f,0x4c]
# CHECK: st1.2d { v0, v1 }, [c1], x15   // encoding: [0x20,0xac,0x8f,0x4c]
# CHECK: st1.2d { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x6c,0x8f,0x4c]
# CHECK: st1.2d { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x2c,0x8f,0x4c]

# CHECK: ld1.8b { v0 }, [c1], #8       // encoding: [0x20,0x70,0xdf,0x0c]
# CHECK: ld1.8b { v0, v1 }, [c1], #16   // encoding: [0x20,0xa0,0xdf,0x0c]
# CHECK: ld1.8b { v0, v1, v2 }, [c1], #24 // encoding: [0x20,0x60,0xdf,0x0c]
# CHECK: ld1.8b { v0, v1, v2, v3 }, [c1], #32 // encoding: [0x20,0x20,0xdf,0x0c]

# CHECK: ld1.16b { v0 }, [c1], #16       // encoding: [0x20,0x70,0xdf,0x4c]
# CHECK: ld1.16b { v0, v1 }, [c1], #32   // encoding: [0x20,0xa0,0xdf,0x4c]
# CHECK: ld1.16b { v0, v1, v2 }, [c1], #48 // encoding: [0x20,0x60,0xdf,0x4c]
# CHECK: ld1.16b { v0, v1, v2, v3 }, [c1], #64 // encoding: [0x20,0x20,0xdf,0x4c]

# CHECK: ld1.4h { v0 }, [c1], #8       // encoding: [0x20,0x74,0xdf,0x0c]
# CHECK: ld1.4h { v0, v1 }, [c1], #16   // encoding: [0x20,0xa4,0xdf,0x0c]
# CHECK: ld1.4h { v0, v1, v2 }, [c1], #24 // encoding: [0x20,0x64,0xdf,0x0c]
# CHECK: ld1.4h { v0, v1, v2, v3 }, [c1], #32 // encoding: [0x20,0x24,0xdf,0x0c]

# CHECK: ld1.8h { v0 }, [c1], #16       // encoding: [0x20,0x74,0xdf,0x4c]
# CHECK: ld1.8h { v0, v1 }, [c1], #32   // encoding: [0x20,0xa4,0xdf,0x4c]
# CHECK: ld1.8h { v0, v1, v2 }, [c1], #48 // encoding: [0x20,0x64,0xdf,0x4c]
# CHECK: ld1.8h { v0, v1, v2, v3 }, [c1], #64 // encoding: [0x20,0x24,0xdf,0x4c]

# CHECK: ld1.2s { v0 }, [c1], #8       // encoding: [0x20,0x78,0xdf,0x0c]
# CHECK: ld1.2s { v0, v1 }, [c1], #16   // encoding: [0x20,0xa8,0xdf,0x0c]
# CHECK: ld1.2s { v0, v1, v2 }, [c1], #24 // encoding: [0x20,0x68,0xdf,0x0c]
# CHECK: ld1.2s { v0, v1, v2, v3 }, [c1], #32 // encoding: [0x20,0x28,0xdf,0x0c]

# CHECK: ld1.4s { v0 }, [c1], #16       // encoding: [0x20,0x78,0xdf,0x4c]
# CHECK: ld1.4s { v0, v1 }, [c1], #32   // encoding: [0x20,0xa8,0xdf,0x4c]
# CHECK: ld1.4s { v0, v1, v2 }, [c1], #48 // encoding: [0x20,0x68,0xdf,0x4c]
# CHECK: ld1.4s { v0, v1, v2, v3 }, [c1], #64 // encoding: [0x20,0x28,0xdf,0x4c]

# CHECK: ld1.1d { v0 }, [c1], #8       // encoding: [0x20,0x7c,0xdf,0x0c]
# CHECK: ld1.1d { v0, v1 }, [c1], #16   // encoding: [0x20,0xac,0xdf,0x0c]
# CHECK: ld1.1d { v0, v1, v2 }, [c1], #24 // encoding: [0x20,0x6c,0xdf,0x0c]
# CHECK: ld1.1d { v0, v1, v2, v3 }, [c1], #32 // encoding: [0x20,0x2c,0xdf,0x0c]

# CHECK: ld1.2d { v0 }, [c1], #16       // encoding: [0x20,0x7c,0xdf,0x4c]
# CHECK: ld1.2d { v0, v1 }, [c1], #32   // encoding: [0x20,0xac,0xdf,0x4c]
# CHECK: ld1.2d { v0, v1, v2 }, [c1], #48 // encoding: [0x20,0x6c,0xdf,0x4c]
# CHECK: ld1.2d { v0, v1, v2, v3 }, [c1], #64 // encoding: [0x20,0x2c,0xdf,0x4c]

# CHECK: st1.8b { v0 }, [c1], #8       // encoding: [0x20,0x70,0x9f,0x0c]
# CHECK: st1.8b { v0, v1 }, [c1], #16   // encoding: [0x20,0xa0,0x9f,0x0c]
# CHECK: st1.8b { v0, v1, v2 }, [c1], #24 // encoding: [0x20,0x60,0x9f,0x0c]
# CHECK: st1.8b { v0, v1, v2, v3 }, [c1], #32 // encoding: [0x20,0x20,0x9f,0x0c]

# CHECK: st1.16b { v0 }, [c1], #16       // encoding: [0x20,0x70,0x9f,0x4c]
# CHECK: st1.16b { v0, v1 }, [c1], #32   // encoding: [0x20,0xa0,0x9f,0x4c]
# CHECK: st1.16b { v0, v1, v2 }, [c1], #48 // encoding: [0x20,0x60,0x9f,0x4c]
# CHECK: st1.16b { v0, v1, v2, v3 }, [c1], #64 // encoding: [0x20,0x20,0x9f,0x4c]

# CHECK: st1.4h { v0 }, [c1], #8       // encoding: [0x20,0x74,0x9f,0x0c]
# CHECK: st1.4h { v0, v1 }, [c1], #16   // encoding: [0x20,0xa4,0x9f,0x0c]
# CHECK: st1.4h { v0, v1, v2 }, [c1], #24 // encoding: [0x20,0x64,0x9f,0x0c]
# CHECK: st1.4h { v0, v1, v2, v3 }, [c1], #32 // encoding: [0x20,0x24,0x9f,0x0c]

# CHECK: st1.8h { v0 }, [c1], #16       // encoding: [0x20,0x74,0x9f,0x4c]
# CHECK: st1.8h { v0, v1 }, [c1], #32   // encoding: [0x20,0xa4,0x9f,0x4c]
# CHECK: st1.8h { v0, v1, v2 }, [c1], #48 // encoding: [0x20,0x64,0x9f,0x4c]
# CHECK: st1.8h { v0, v1, v2, v3 }, [c1], #64 // encoding: [0x20,0x24,0x9f,0x4c]

# CHECK: st1.2s { v0 }, [c1], #8       // encoding: [0x20,0x78,0x9f,0x0c]
# CHECK: st1.2s { v0, v1 }, [c1], #16   // encoding: [0x20,0xa8,0x9f,0x0c]
# CHECK: st1.2s { v0, v1, v2 }, [c1], #24 // encoding: [0x20,0x68,0x9f,0x0c]
# CHECK: st1.2s { v0, v1, v2, v3 }, [c1], #32 // encoding: [0x20,0x28,0x9f,0x0c]

# CHECK: st1.4s { v0 }, [c1], #16       // encoding: [0x20,0x78,0x9f,0x4c]
# CHECK: st1.4s { v0, v1 }, [c1], #32   // encoding: [0x20,0xa8,0x9f,0x4c]
# CHECK: st1.4s { v0, v1, v2 }, [c1], #48 // encoding: [0x20,0x68,0x9f,0x4c]
# CHECK: st1.4s { v0, v1, v2, v3 }, [c1], #64 // encoding: [0x20,0x28,0x9f,0x4c]

# CHECK: st1.1d { v0 }, [c1], #8       // encoding: [0x20,0x7c,0x9f,0x0c]
# CHECK: st1.1d { v0, v1 }, [c1], #16   // encoding: [0x20,0xac,0x9f,0x0c]
# CHECK: st1.1d { v0, v1, v2 }, [c1], #24 // encoding: [0x20,0x6c,0x9f,0x0c]
# CHECK: st1.1d { v0, v1, v2, v3 }, [c1], #32 // encoding: [0x20,0x2c,0x9f,0x0c]

# CHECK: st1.2d { v0 }, [c1], #16       // encoding: [0x20,0x7c,0x9f,0x4c]
# CHECK: st1.2d { v0, v1 }, [c1], #32   // encoding: [0x20,0xac,0x9f,0x4c]
# CHECK: st1.2d { v0, v1, v2 }, [c1], #48 // encoding: [0x20,0x6c,0x9f,0x4c]
# CHECK: st1.2d { v0, v1, v2, v3 }, [c1], #64 // encoding: [0x20,0x2c,0x9f,0x4c]


_ld2st2_multiple_post:
  ld2.8b {v0, v1}, [c1], x15
  ld2.16b {v0, v1}, [c1], x15
  ld2.4h {v0, v1}, [c1], x15
  ld2.8h {v0, v1}, [c1], x15
  ld2.2s {v0, v1}, [c1], x15
  ld2.4s {v0, v1}, [c1], x15
  ld2.2d {v0, v1}, [c1], x15

  st2.8b {v0, v1}, [c1], x15
  st2.16b {v0, v1}, [c1], x15
  st2.4h {v0, v1}, [c1], x15
  st2.8h {v0, v1}, [c1], x15
  st2.2s {v0, v1}, [c1], x15
  st2.4s {v0, v1}, [c1], x15
  st2.2d {v0, v1}, [c1], x15

  ld2.8b {v0, v1}, [c1], #16
  ld2.16b {v0, v1}, [c1], #32
  ld2.4h {v0, v1}, [c1], #16
  ld2.8h {v0, v1}, [c1], #32
  ld2.2s {v0, v1}, [c1], #16
  ld2.4s {v0, v1}, [c1], #32
  ld2.2d {v0, v1}, [c1], #32

  st2.8b {v0, v1}, [c1], #16
  st2.16b {v0, v1}, [c1], #32
  st2.4h {v0, v1}, [c1], #16
  st2.8h {v0, v1}, [c1], #32
  st2.2s {v0, v1}, [c1], #16
  st2.4s {v0, v1}, [c1], #32
  st2.2d {v0, v1}, [c1], #32


# CHECK: ld2st2_multiple_post:
# CHECK: ld2.8b { v0, v1 }, [c1], x15   // encoding: [0x20,0x80,0xcf,0x0c]
# CHECK: ld2.16b { v0, v1 }, [c1], x15   // encoding: [0x20,0x80,0xcf,0x4c]
# CHECK: ld2.4h { v0, v1 }, [c1], x15   // encoding: [0x20,0x84,0xcf,0x0c]
# CHECK: ld2.8h { v0, v1 }, [c1], x15   // encoding: [0x20,0x84,0xcf,0x4c]
# CHECK: ld2.2s { v0, v1 }, [c1], x15   // encoding: [0x20,0x88,0xcf,0x0c]
# CHECK: ld2.4s { v0, v1 }, [c1], x15   // encoding: [0x20,0x88,0xcf,0x4c]
# CHECK: ld2.2d { v0, v1 }, [c1], x15   // encoding: [0x20,0x8c,0xcf,0x4c]

# CHECK: st2.8b { v0, v1 }, [c1], x15   // encoding: [0x20,0x80,0x8f,0x0c]
# CHECK: st2.16b { v0, v1 }, [c1], x15   // encoding: [0x20,0x80,0x8f,0x4c]
# CHECK: st2.4h { v0, v1 }, [c1], x15   // encoding: [0x20,0x84,0x8f,0x0c]
# CHECK: st2.8h { v0, v1 }, [c1], x15   // encoding: [0x20,0x84,0x8f,0x4c]
# CHECK: st2.2s { v0, v1 }, [c1], x15   // encoding: [0x20,0x88,0x8f,0x0c]
# CHECK: st2.4s { v0, v1 }, [c1], x15   // encoding: [0x20,0x88,0x8f,0x4c]
# CHECK: st2.2d { v0, v1 }, [c1], x15   // encoding: [0x20,0x8c,0x8f,0x4c]

# CHECK: ld2.8b { v0, v1 }, [c1], #16   // encoding: [0x20,0x80,0xdf,0x0c]
# CHECK: ld2.16b { v0, v1 }, [c1], #32   // encoding: [0x20,0x80,0xdf,0x4c]
# CHECK: ld2.4h { v0, v1 }, [c1], #16   // encoding: [0x20,0x84,0xdf,0x0c]
# CHECK: ld2.8h { v0, v1 }, [c1], #32   // encoding: [0x20,0x84,0xdf,0x4c]
# CHECK: ld2.2s { v0, v1 }, [c1], #16   // encoding: [0x20,0x88,0xdf,0x0c]
# CHECK: ld2.4s { v0, v1 }, [c1], #32   // encoding: [0x20,0x88,0xdf,0x4c]
# CHECK: ld2.2d { v0, v1 }, [c1], #32   // encoding: [0x20,0x8c,0xdf,0x4c]

# CHECK: st2.8b { v0, v1 }, [c1], #16   // encoding: [0x20,0x80,0x9f,0x0c]
# CHECK: st2.16b { v0, v1 }, [c1], #32   // encoding: [0x20,0x80,0x9f,0x4c]
# CHECK: st2.4h { v0, v1 }, [c1], #16   // encoding: [0x20,0x84,0x9f,0x0c]
# CHECK: st2.8h { v0, v1 }, [c1], #32   // encoding: [0x20,0x84,0x9f,0x4c]
# CHECK: st2.2s { v0, v1 }, [c1], #16   // encoding: [0x20,0x88,0x9f,0x0c]
# CHECK: st2.4s { v0, v1 }, [c1], #32   // encoding: [0x20,0x88,0x9f,0x4c]
# CHECK: st2.2d { v0, v1 }, [c1], #32   // encoding: [0x20,0x8c,0x9f,0x4c]


_ld3st3_multiple_post:
  ld3.8b {v0, v1, v2}, [c1], x15
  ld3.16b {v0, v1, v2}, [c1], x15
  ld3.4h {v0, v1, v2}, [c1], x15
  ld3.8h {v0, v1, v2}, [c1], x15
  ld3.2s {v0, v1, v2}, [c1], x15
  ld3.4s {v0, v1, v2}, [c1], x15
  ld3.2d {v0, v1, v2}, [c1], x15

  st3.8b {v0, v1, v2}, [c1], x15
  st3.16b {v0, v1, v2}, [c1], x15
  st3.4h {v0, v1, v2}, [c1], x15
  st3.8h {v0, v1, v2}, [c1], x15
  st3.2s {v0, v1, v2}, [c1], x15
  st3.4s {v0, v1, v2}, [c1], x15
  st3.2d {v0, v1, v2}, [c1], x15

  ld3.8b {v0, v1, v2}, [c1], #24
  ld3.16b {v0, v1, v2}, [c1], #48
  ld3.4h {v0, v1, v2}, [c1], #24
  ld3.8h {v0, v1, v2}, [c1], #48
  ld3.2s {v0, v1, v2}, [c1], #24
  ld3.4s {v0, v1, v2}, [c1], #48
  ld3.2d {v0, v1, v2}, [c1], #48

  st3.8b {v0, v1, v2}, [c1], #24
  st3.16b {v0, v1, v2}, [c1], #48
  st3.4h {v0, v1, v2}, [c1], #24
  st3.8h {v0, v1, v2}, [c1], #48
  st3.2s {v0, v1, v2}, [c1], #24
  st3.4s {v0, v1, v2}, [c1], #48
  st3.2d {v0, v1, v2}, [c1], #48

# CHECK: ld3st3_multiple_post:
# CHECK: ld3.8b { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x40,0xcf,0x0c]
# CHECK: ld3.16b { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x40,0xcf,0x4c]
# CHECK: ld3.4h { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x44,0xcf,0x0c]
# CHECK: ld3.8h { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x44,0xcf,0x4c]
# CHECK: ld3.2s { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x48,0xcf,0x0c]
# CHECK: ld3.4s { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x48,0xcf,0x4c]
# CHECK: ld3.2d { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x4c,0xcf,0x4c]

# CHECK: st3.8b { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x40,0x8f,0x0c]
# CHECK: st3.16b { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x40,0x8f,0x4c]
# CHECK: st3.4h { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x44,0x8f,0x0c]
# CHECK: st3.8h { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x44,0x8f,0x4c]
# CHECK: st3.2s { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x48,0x8f,0x0c]
# CHECK: st3.4s { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x48,0x8f,0x4c]
# CHECK: st3.2d { v0, v1, v2 }, [c1], x15 // encoding: [0x20,0x4c,0x8f,0x4c]

# CHECK: ld3.8b { v0, v1, v2 }, [c1], #24 // encoding: [0x20,0x40,0xdf,0x0c]
# CHECK: ld3.16b { v0, v1, v2 }, [c1], #48 // encoding: [0x20,0x40,0xdf,0x4c]
# CHECK: ld3.4h { v0, v1, v2 }, [c1], #24 // encoding: [0x20,0x44,0xdf,0x0c]
# CHECK: ld3.8h { v0, v1, v2 }, [c1], #48 // encoding: [0x20,0x44,0xdf,0x4c]
# CHECK: ld3.2s { v0, v1, v2 }, [c1], #24 // encoding: [0x20,0x48,0xdf,0x0c]
# CHECK: ld3.4s { v0, v1, v2 }, [c1], #48 // encoding: [0x20,0x48,0xdf,0x4c]
# CHECK: ld3.2d { v0, v1, v2 }, [c1], #48 // encoding: [0x20,0x4c,0xdf,0x4c]

# CHECK: st3.8b { v0, v1, v2 }, [c1], #24 // encoding: [0x20,0x40,0x9f,0x0c]
# CHECK: st3.16b { v0, v1, v2 }, [c1], #48 // encoding: [0x20,0x40,0x9f,0x4c]
# CHECK: st3.4h { v0, v1, v2 }, [c1], #24 // encoding: [0x20,0x44,0x9f,0x0c]
# CHECK: st3.8h { v0, v1, v2 }, [c1], #48 // encoding: [0x20,0x44,0x9f,0x4c]
# CHECK: st3.2s { v0, v1, v2 }, [c1], #24 // encoding: [0x20,0x48,0x9f,0x0c]
# CHECK: st3.4s { v0, v1, v2 }, [c1], #48 // encoding: [0x20,0x48,0x9f,0x4c]
# CHECK: st3.2d { v0, v1, v2 }, [c1], #48 // encoding: [0x20,0x4c,0x9f,0x4c]

_ld4st4_multiple_post:
  ld4.8b {v0, v1, v2, v3}, [c1], x15
  ld4.16b {v0, v1, v2, v3}, [c1], x15
  ld4.4h {v0, v1, v2, v3}, [c1], x15
  ld4.8h {v0, v1, v2, v3}, [c1], x15
  ld4.2s {v0, v1, v2, v3}, [c1], x15
  ld4.4s {v0, v1, v2, v3}, [c1], x15
  ld4.2d {v0, v1, v2, v3}, [c1], x15

  st4.8b {v0, v1, v2, v3}, [c1], x15
  st4.16b {v0, v1, v2, v3}, [c1], x15
  st4.4h {v0, v1, v2, v3}, [c1], x15
  st4.8h {v0, v1, v2, v3}, [c1], x15
  st4.2s {v0, v1, v2, v3}, [c1], x15
  st4.4s {v0, v1, v2, v3}, [c1], x15
  st4.2d {v0, v1, v2, v3}, [c1], x15

  ld4.8b {v0, v1, v2, v3}, [c1], #32
  ld4.16b {v0, v1, v2, v3}, [c1], #64
  ld4.4h {v0, v1, v2, v3}, [c1], #32
  ld4.8h {v0, v1, v2, v3}, [c1], #64
  ld4.2s {v0, v1, v2, v3}, [c1], #32
  ld4.4s {v0, v1, v2, v3}, [c1], #64
  ld4.2d {v0, v1, v2, v3}, [c1], #64

  st4.8b {v0, v1, v2, v3}, [c1], #32
  st4.16b {v0, v1, v2, v3}, [c1], #64
  st4.4h {v0, v1, v2, v3}, [c1], #32
  st4.8h {v0, v1, v2, v3}, [c1], #64
  st4.2s {v0, v1, v2, v3}, [c1], #32
  st4.4s {v0, v1, v2, v3}, [c1], #64
  st4.2d {v0, v1, v2, v3}, [c1], #64


# CHECK: ld4st4_multiple_post:
# CHECK: ld4.8b { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x00,0xcf,0x0c]
# CHECK: ld4.16b { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x00,0xcf,0x4c]
# CHECK: ld4.4h { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x04,0xcf,0x0c]
# CHECK: ld4.8h { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x04,0xcf,0x4c]
# CHECK: ld4.2s { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x08,0xcf,0x0c]
# CHECK: ld4.4s { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x08,0xcf,0x4c]
# CHECK: ld4.2d { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x0c,0xcf,0x4c]

# CHECK: st4.8b { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x00,0x8f,0x0c]
# CHECK: st4.16b { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x00,0x8f,0x4c]
# CHECK: st4.4h { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x04,0x8f,0x0c]
# CHECK: st4.8h { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x04,0x8f,0x4c]
# CHECK: st4.2s { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x08,0x8f,0x0c]
# CHECK: st4.4s { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x08,0x8f,0x4c]
# CHECK: st4.2d { v0, v1, v2, v3 }, [c1], x15 // encoding: [0x20,0x0c,0x8f,0x4c]

# CHECK: ld4.8b { v0, v1, v2, v3 }, [c1], #32 // encoding: [0x20,0x00,0xdf,0x0c]
# CHECK: ld4.16b { v0, v1, v2, v3 }, [c1], #64 // encoding: [0x20,0x00,0xdf,0x4c]
# CHECK: ld4.4h { v0, v1, v2, v3 }, [c1], #32 // encoding: [0x20,0x04,0xdf,0x0c]
# CHECK: ld4.8h { v0, v1, v2, v3 }, [c1], #64 // encoding: [0x20,0x04,0xdf,0x4c]
# CHECK: ld4.2s { v0, v1, v2, v3 }, [c1], #32 // encoding: [0x20,0x08,0xdf,0x0c]
# CHECK: ld4.4s { v0, v1, v2, v3 }, [c1], #64 // encoding: [0x20,0x08,0xdf,0x4c]
# CHECK: ld4.2d { v0, v1, v2, v3 }, [c1], #64 // encoding: [0x20,0x0c,0xdf,0x4c]

# CHECK: st4.8b { v0, v1, v2, v3 }, [c1], #32 // encoding: [0x20,0x00,0x9f,0x0c]
# CHECK: st4.16b { v0, v1, v2, v3 }, [c1], #64 // encoding: [0x20,0x00,0x9f,0x4c]
# CHECK: st4.4h { v0, v1, v2, v3 }, [c1], #32 // encoding: [0x20,0x04,0x9f,0x0c]
# CHECK: st4.8h { v0, v1, v2, v3 }, [c1], #64 // encoding: [0x20,0x04,0x9f,0x4c]
# CHECK: st4.2s { v0, v1, v2, v3 }, [c1], #32 // encoding: [0x20,0x08,0x9f,0x0c]
# CHECK: st4.4s { v0, v1, v2, v3 }, [c1], #64 // encoding: [0x20,0x08,0x9f,0x4c]
# CHECK: st4.2d { v0, v1, v2, v3 }, [c1], #64 // encoding: [0x20,0x0c,0x9f,0x4c]

ld1r:
  ld1r.8b {v4}, [c2]
  ld1r.8b {v4}, [c2], x3
  ld1r.16b {v4}, [c2]
  ld1r.16b {v4}, [c2], x3
  ld1r.4h {v4}, [c2]
  ld1r.4h {v4}, [c2], x3
  ld1r.8h {v4}, [c2]
  ld1r.8h {v4}, [c2], x3
  ld1r.2s {v4}, [c2]
  ld1r.2s {v4}, [c2], x3
  ld1r.4s {v4}, [c2]
  ld1r.4s {v4}, [c2], x3
  ld1r.1d {v4}, [c2]
  ld1r.1d {v4}, [c2], x3
  ld1r.2d {v4}, [c2]
  ld1r.2d {v4}, [c2], x3

  ld1r.8b {v4}, [c2], #1
  ld1r.16b {v4}, [c2], #1
  ld1r.4h {v4}, [c2], #2
  ld1r.8h {v4}, [c2], #2
  ld1r.2s {v4}, [c2], #4
  ld1r.4s {v4}, [c2], #4
  ld1r.1d {v4}, [c2], #8
  ld1r.2d {v4}, [c2], #8

# CHECK: ld1r:
# CHECK: ld1r.8b { v4 }, [c2]            // encoding: [0x44,0xc0,0x40,0x0d]
# CHECK: ld1r.8b { v4 }, [c2], x3        // encoding: [0x44,0xc0,0xc3,0x0d]
# CHECK: ld1r.16b { v4 }, [c2]    // encoding: [0x44,0xc0,0x40,0x4d]
# CHECK: ld1r.16b { v4 }, [c2], x3 // encoding: [0x44,0xc0,0xc3,0x4d]
# CHECK: ld1r.4h { v4 }, [c2]            // encoding: [0x44,0xc4,0x40,0x0d]
# CHECK: ld1r.4h { v4 }, [c2], x3        // encoding: [0x44,0xc4,0xc3,0x0d]
# CHECK: ld1r.8h { v4 }, [c2]            // encoding: [0x44,0xc4,0x40,0x4d]
# CHECK: ld1r.8h { v4 }, [c2], x3        // encoding: [0x44,0xc4,0xc3,0x4d]
# CHECK: ld1r.2s { v4 }, [c2]            // encoding: [0x44,0xc8,0x40,0x0d]
# CHECK: ld1r.2s { v4 }, [c2], x3        // encoding: [0x44,0xc8,0xc3,0x0d]
# CHECK: ld1r.4s { v4 }, [c2]            // encoding: [0x44,0xc8,0x40,0x4d]
# CHECK: ld1r.4s { v4 }, [c2], x3        // encoding: [0x44,0xc8,0xc3,0x4d]
# CHECK: ld1r.1d { v4 }, [c2]            // encoding: [0x44,0xcc,0x40,0x0d]
# CHECK: ld1r.1d { v4 }, [c2], x3        // encoding: [0x44,0xcc,0xc3,0x0d]
# CHECK: ld1r.2d { v4 }, [c2]            // encoding: [0x44,0xcc,0x40,0x4d]
# CHECK: ld1r.2d { v4 }, [c2], x3        // encoding: [0x44,0xcc,0xc3,0x4d]

# CHECK: ld1r.8b { v4 }, [c2], #1        // encoding: [0x44,0xc0,0xdf,0x0d]
# CHECK: ld1r.16b { v4 }, [c2], #1 // encoding: [0x44,0xc0,0xdf,0x4d]
# CHECK: ld1r.4h { v4 }, [c2], #2        // encoding: [0x44,0xc4,0xdf,0x0d]
# CHECK: ld1r.8h { v4 }, [c2], #2        // encoding: [0x44,0xc4,0xdf,0x4d]
# CHECK: ld1r.2s { v4 }, [c2], #4        // encoding: [0x44,0xc8,0xdf,0x0d]
# CHECK: ld1r.4s { v4 }, [c2], #4        // encoding: [0x44,0xc8,0xdf,0x4d]
# CHECK: ld1r.1d { v4 }, [c2], #8        // encoding: [0x44,0xcc,0xdf,0x0d]
# CHECK: ld1r.2d { v4 }, [c2], #8        // encoding: [0x44,0xcc,0xdf,0x4d]

ld2r:
  ld2r.8b {v4, v5}, [c2]
  ld2r.8b {v4, v5}, [c2], x3
  ld2r.16b {v4, v5}, [c2]
  ld2r.16b {v4, v5}, [c2], x3
  ld2r.4h {v4, v5}, [c2]
  ld2r.4h {v4, v5}, [c2], x3
  ld2r.8h {v4, v5}, [c2]
  ld2r.8h {v4, v5}, [c2], x3
  ld2r.2s {v4, v5}, [c2]
  ld2r.2s {v4, v5}, [c2], x3
  ld2r.4s {v4, v5}, [c2]
  ld2r.4s {v4, v5}, [c2], x3
  ld2r.1d {v4, v5}, [c2]
  ld2r.1d {v4, v5}, [c2], x3
  ld2r.2d {v4, v5}, [c2]
  ld2r.2d {v4, v5}, [c2], x3

  ld2r.8b {v4, v5}, [c2], #2
  ld2r.16b {v4, v5}, [c2], #2
  ld2r.4h {v4, v5}, [c2], #4
  ld2r.8h {v4, v5}, [c2], #4
  ld2r.2s {v4, v5}, [c2], #8
  ld2r.4s {v4, v5}, [c2], #8
  ld2r.1d {v4, v5}, [c2], #16
  ld2r.2d {v4, v5}, [c2], #16

# CHECK: ld2r:
# CHECK: ld2r.8b { v4, v5 }, [c2]        // encoding: [0x44,0xc0,0x60,0x0d]
# CHECK: ld2r.8b { v4, v5 }, [c2], x3    // encoding: [0x44,0xc0,0xe3,0x0d]
# CHECK: ld2r.16b { v4, v5 }, [c2] // encoding: [0x44,0xc0,0x60,0x4d]
# CHECK: ld2r.16b { v4, v5 }, [c2], x3 // encoding: [0x44,0xc0,0xe3,0x4d]
# CHECK: ld2r.4h { v4, v5 }, [c2]        // encoding: [0x44,0xc4,0x60,0x0d]
# CHECK: ld2r.4h { v4, v5 }, [c2], x3    // encoding: [0x44,0xc4,0xe3,0x0d]
# CHECK: ld2r.8h { v4, v5 }, [c2]        // encoding: [0x44,0xc4,0x60,0x4d]
# CHECK: ld2r.8h { v4, v5 }, [c2], x3    // encoding: [0x44,0xc4,0xe3,0x4d]
# CHECK: ld2r.2s { v4, v5 }, [c2]        // encoding: [0x44,0xc8,0x60,0x0d]
# CHECK: ld2r.2s { v4, v5 }, [c2], x3    // encoding: [0x44,0xc8,0xe3,0x0d]
# CHECK: ld2r.4s { v4, v5 }, [c2]        // encoding: [0x44,0xc8,0x60,0x4d]
# CHECK: ld2r.4s { v4, v5 }, [c2], x3    // encoding: [0x44,0xc8,0xe3,0x4d]
# CHECK: ld2r.1d { v4, v5 }, [c2]        // encoding: [0x44,0xcc,0x60,0x0d]
# CHECK: ld2r.1d { v4, v5 }, [c2], x3    // encoding: [0x44,0xcc,0xe3,0x0d]
# CHECK: ld2r.2d { v4, v5 }, [c2]        // encoding: [0x44,0xcc,0x60,0x4d]
# CHECK: ld2r.2d { v4, v5 }, [c2], x3    // encoding: [0x44,0xcc,0xe3,0x4d]

# CHECK: ld2r.8b { v4, v5 }, [c2], #2    // encoding: [0x44,0xc0,0xff,0x0d]
# CHECK: ld2r.16b { v4, v5 }, [c2], #2 // encoding: [0x44,0xc0,0xff,0x4d]
# CHECK: ld2r.4h { v4, v5 }, [c2], #4    // encoding: [0x44,0xc4,0xff,0x0d]
# CHECK: ld2r.8h { v4, v5 }, [c2], #4    // encoding: [0x44,0xc4,0xff,0x4d]
# CHECK: ld2r.2s { v4, v5 }, [c2], #8    // encoding: [0x44,0xc8,0xff,0x0d]
# CHECK: ld2r.4s { v4, v5 }, [c2], #8    // encoding: [0x44,0xc8,0xff,0x4d]
# CHECK: ld2r.1d { v4, v5 }, [c2], #16    // encoding: [0x44,0xcc,0xff,0x0d]
# CHECK: ld2r.2d { v4, v5 }, [c2], #16    // encoding: [0x44,0xcc,0xff,0x4d]

ld3r:
  ld3r.8b {v4, v5, v6}, [c2]
  ld3r.8b {v4, v5, v6}, [c2], x3
  ld3r.16b {v4, v5, v6}, [c2]
  ld3r.16b {v4, v5, v6}, [c2], x3
  ld3r.4h {v4, v5, v6}, [c2]
  ld3r.4h {v4, v5, v6}, [c2], x3
  ld3r.8h {v4, v5, v6}, [c2]
  ld3r.8h {v4, v5, v6}, [c2], x3
  ld3r.2s {v4, v5, v6}, [c2]
  ld3r.2s {v4, v5, v6}, [c2], x3
  ld3r.4s {v4, v5, v6}, [c2]
  ld3r.4s {v4, v5, v6}, [c2], x3
  ld3r.1d {v4, v5, v6}, [c2]
  ld3r.1d {v4, v5, v6}, [c2], x3
  ld3r.2d {v4, v5, v6}, [c2]
  ld3r.2d {v4, v5, v6}, [c2], x3

  ld3r.8b {v4, v5, v6}, [c2], #3
  ld3r.16b {v4, v5, v6}, [c2], #3
  ld3r.4h {v4, v5, v6}, [c2], #6
  ld3r.8h {v4, v5, v6}, [c2], #6
  ld3r.2s {v4, v5, v6}, [c2], #12
  ld3r.4s {v4, v5, v6}, [c2], #12
  ld3r.1d {v4, v5, v6}, [c2], #24
  ld3r.2d {v4, v5, v6}, [c2], #24

# CHECK: ld3r:
# CHECK: ld3r.8b { v4, v5, v6 }, [c2]    // encoding: [0x44,0xe0,0x40,0x0d]
# CHECK: ld3r.8b { v4, v5, v6 }, [c2], x3 // encoding: [0x44,0xe0,0xc3,0x0d]
# CHECK: ld3r.16b { v4, v5, v6 }, [c2] // encoding: [0x44,0xe0,0x40,0x4d]
# CHECK: ld3r.16b { v4, v5, v6 }, [c2], x3 // encoding: [0x44,0xe0,0xc3,0x4d]
# CHECK: ld3r.4h { v4, v5, v6 }, [c2]    // encoding: [0x44,0xe4,0x40,0x0d]
# CHECK: ld3r.4h { v4, v5, v6 }, [c2], x3 // encoding: [0x44,0xe4,0xc3,0x0d]
# CHECK: ld3r.8h { v4, v5, v6 }, [c2]    // encoding: [0x44,0xe4,0x40,0x4d]
# CHECK: ld3r.8h { v4, v5, v6 }, [c2], x3 // encoding: [0x44,0xe4,0xc3,0x4d]
# CHECK: ld3r.2s { v4, v5, v6 }, [c2]    // encoding: [0x44,0xe8,0x40,0x0d]
# CHECK: ld3r.2s { v4, v5, v6 }, [c2], x3 // encoding: [0x44,0xe8,0xc3,0x0d]
# CHECK: ld3r.4s { v4, v5, v6 }, [c2]    // encoding: [0x44,0xe8,0x40,0x4d]
# CHECK: ld3r.4s { v4, v5, v6 }, [c2], x3 // encoding: [0x44,0xe8,0xc3,0x4d]
# CHECK: ld3r.1d { v4, v5, v6 }, [c2]    // encoding: [0x44,0xec,0x40,0x0d]
# CHECK: ld3r.1d { v4, v5, v6 }, [c2], x3 // encoding: [0x44,0xec,0xc3,0x0d]
# CHECK: ld3r.2d { v4, v5, v6 }, [c2]    // encoding: [0x44,0xec,0x40,0x4d]
# CHECK: ld3r.2d { v4, v5, v6 }, [c2], x3 // encoding: [0x44,0xec,0xc3,0x4d]

# CHECK: ld3r.8b { v4, v5, v6 }, [c2], #3 // encoding: [0x44,0xe0,0xdf,0x0d]
# CHECK: ld3r.16b { v4, v5, v6 }, [c2], #3 // encoding: [0x44,0xe0,0xdf,0x4d]
# CHECK: ld3r.4h { v4, v5, v6 }, [c2], #6 // encoding: [0x44,0xe4,0xdf,0x0d]
# CHECK: ld3r.8h { v4, v5, v6 }, [c2], #6 // encoding: [0x44,0xe4,0xdf,0x4d]
# CHECK: ld3r.2s { v4, v5, v6 }, [c2], #12 // encoding: [0x44,0xe8,0xdf,0x0d]
# CHECK: ld3r.4s { v4, v5, v6 }, [c2], #12 // encoding: [0x44,0xe8,0xdf,0x4d]
# CHECK: ld3r.1d { v4, v5, v6 }, [c2], #24 // encoding: [0x44,0xec,0xdf,0x0d]
# CHECK: ld3r.2d { v4, v5, v6 }, [c2], #24 // encoding: [0x44,0xec,0xdf,0x4d]

ld4r:
  ld4r.8b {v4, v5, v6, v7}, [c2]
  ld4r.8b {v4, v5, v6, v7}, [c2], x3
  ld4r.16b {v4, v5, v6, v7}, [c2]
  ld4r.16b {v4, v5, v6, v7}, [c2], x3
  ld4r.4h {v4, v5, v6, v7}, [c2]
  ld4r.4h {v4, v5, v6, v7}, [c2], x3
  ld4r.8h {v4, v5, v6, v7}, [c2]
  ld4r.8h {v4, v5, v6, v7}, [c2], x3
  ld4r.2s {v4, v5, v6, v7}, [c2]
  ld4r.2s {v4, v5, v6, v7}, [c2], x3
  ld4r.4s {v4, v5, v6, v7}, [c2]
  ld4r.4s {v4, v5, v6, v7}, [c2], x3
  ld4r.1d {v4, v5, v6, v7}, [c2]
  ld4r.1d {v4, v5, v6, v7}, [c2], x3
  ld4r.2d {v4, v5, v6, v7}, [c2]
  ld4r.2d {v4, v5, v6, v7}, [c2], x3

  ld4r.8b {v4, v5, v6, v7}, [c2], #4
  ld4r.16b {v5, v6, v7, v8}, [c2], #4
  ld4r.4h {v6, v7, v8, v9}, [c2], #8
  ld4r.8h {v1, v2, v3, v4}, [c2], #8
  ld4r.2s {v2, v3, v4, v5}, [c2], #16
  ld4r.4s {v3, v4, v5, v6}, [c2], #16
  ld4r.1d {v0, v1, v2, v3}, [c2], #32
  ld4r.2d {v4, v5, v6, v7}, [c2], #32

# CHECK: ld4r:
# CHECK: ld4r.8b { v4, v5, v6, v7 }, [c2] // encoding: [0x44,0xe0,0x60,0x0d]
# CHECK: ld4r.8b { v4, v5, v6, v7 }, [c2], x3 // encoding: [0x44,0xe0,0xe3,0x0d]
# CHECK: ld4r.16b { v4, v5, v6, v7 }, [c2] // encoding: [0x44,0xe0,0x60,0x4d]
# CHECK: ld4r.16b { v4, v5, v6, v7 }, [c2], x3 // encoding: [0x44,0xe0,0xe3,0x4d]
# CHECK: ld4r.4h { v4, v5, v6, v7 }, [c2] // encoding: [0x44,0xe4,0x60,0x0d]
# CHECK: ld4r.4h { v4, v5, v6, v7 }, [c2], x3 // encoding: [0x44,0xe4,0xe3,0x0d]
# CHECK: ld4r.8h { v4, v5, v6, v7 }, [c2] // encoding: [0x44,0xe4,0x60,0x4d]
# CHECK: ld4r.8h { v4, v5, v6, v7 }, [c2], x3 // encoding: [0x44,0xe4,0xe3,0x4d]
# CHECK: ld4r.2s { v4, v5, v6, v7 }, [c2] // encoding: [0x44,0xe8,0x60,0x0d]
# CHECK: ld4r.2s { v4, v5, v6, v7 }, [c2], x3 // encoding: [0x44,0xe8,0xe3,0x0d]
# CHECK: ld4r.4s { v4, v5, v6, v7 }, [c2] // encoding: [0x44,0xe8,0x60,0x4d]
# CHECK: ld4r.4s { v4, v5, v6, v7 }, [c2], x3 // encoding: [0x44,0xe8,0xe3,0x4d]
# CHECK: ld4r.1d { v4, v5, v6, v7 }, [c2] // encoding: [0x44,0xec,0x60,0x0d]
# CHECK: ld4r.1d { v4, v5, v6, v7 }, [c2], x3 // encoding: [0x44,0xec,0xe3,0x0d]
# CHECK: ld4r.2d { v4, v5, v6, v7 }, [c2] // encoding: [0x44,0xec,0x60,0x4d]
# CHECK: ld4r.2d { v4, v5, v6, v7 }, [c2], x3 // encoding: [0x44,0xec,0xe3,0x4d]

# CHECK: ld4r.8b { v4, v5, v6, v7 }, [c2], #4 // encoding: [0x44,0xe0,0xff,0x0d]
# CHECK: ld4r.16b { v5, v6, v7, v8 }, [c2], #4 // encoding: [0x45,0xe0,0xff,0x4d]
# CHECK: ld4r.4h { v6, v7, v8, v9 }, [c2], #8 // encoding: [0x46,0xe4,0xff,0x0d]
# CHECK: ld4r.8h { v1, v2, v3, v4 }, [c2], #8 // encoding: [0x41,0xe4,0xff,0x4d]
# CHECK: ld4r.2s { v2, v3, v4, v5 }, [c2], #16 // encoding: [0x42,0xe8,0xff,0x0d]
# CHECK: ld4r.4s { v3, v4, v5, v6 }, [c2], #16 // encoding: [0x43,0xe8,0xff,0x4d]
# CHECK: ld4r.1d { v0, v1, v2, v3 }, [c2], #32 // encoding: [0x40,0xec,0xff,0x0d]
# CHECK: ld4r.2d { v4, v5, v6, v7 }, [c2], #32 // encoding: [0x44,0xec,0xff,0x4d]


_ld1:
  ld1.b {v4}[13], [c3]
  ld1.h {v4}[2], [c3]
  ld1.s {v4}[2], [c3]
  ld1.d {v4}[1], [c3]
  ld1.b {v4}[13], [c3], x5
  ld1.h {v4}[2], [c3], x5
  ld1.s {v4}[2], [c3], x5
  ld1.d {v4}[1], [c3], x5
  ld1.b {v4}[13], [c3], #1
  ld1.h {v4}[2], [c3], #2
  ld1.s {v4}[2], [c3], #4
  ld1.d {v4}[1], [c3], #8

# CHECK: _ld1:
# CHECK: ld1.b { v4 }[13], [c3]        // encoding: [0x64,0x14,0x40,0x4d]
# CHECK: ld1.h { v4 }[2], [c3]         // encoding: [0x64,0x50,0x40,0x0d]
# CHECK: ld1.s { v4 }[2], [c3]         // encoding: [0x64,0x80,0x40,0x4d]
# CHECK: ld1.d { v4 }[1], [c3]         // encoding: [0x64,0x84,0x40,0x4d]
# CHECK: ld1.b { v4 }[13], [c3], x5    // encoding: [0x64,0x14,0xc5,0x4d]
# CHECK: ld1.h { v4 }[2], [c3], x5     // encoding: [0x64,0x50,0xc5,0x0d]
# CHECK: ld1.s { v4 }[2], [c3], x5     // encoding: [0x64,0x80,0xc5,0x4d]
# CHECK: ld1.d { v4 }[1], [c3], x5     // encoding: [0x64,0x84,0xc5,0x4d]
# CHECK: ld1.b { v4 }[13], [c3], #1   // encoding: [0x64,0x14,0xdf,0x4d]
# CHECK: ld1.h { v4 }[2], [c3], #2    // encoding: [0x64,0x50,0xdf,0x0d]
# CHECK: ld1.s { v4 }[2], [c3], #4    // encoding: [0x64,0x80,0xdf,0x4d]
# CHECK: ld1.d { v4 }[1], [c3], #8    // encoding: [0x64,0x84,0xdf,0x4d]

_ld2:
  ld2.b {v4, v5}[13], [c3]
  ld2.h {v4, v5}[2], [c3]
  ld2.s {v4, v5}[2], [c3]
  ld2.d {v4, v5}[1], [c3]
  ld2.b {v4, v5}[13], [c3], x5
  ld2.h {v4, v5}[2], [c3], x5
  ld2.s {v4, v5}[2], [c3], x5
  ld2.d {v4, v5}[1], [c3], x5
  ld2.b {v4, v5}[13], [c3], #2
  ld2.h {v4, v5}[2], [c3], #4
  ld2.s {v4, v5}[2], [c3], #8
  ld2.d {v4, v5}[1], [c3], #16


# CHECK: _ld2:
# CHECK: ld2.b { v4, v5 }[13], [c3]    // encoding: [0x64,0x14,0x60,0x4d]
# CHECK: ld2.h { v4, v5 }[2], [c3]     // encoding: [0x64,0x50,0x60,0x0d]
# CHECK: ld2.s { v4, v5 }[2], [c3]     // encoding: [0x64,0x80,0x60,0x4d]
# CHECK: ld2.d { v4, v5 }[1], [c3]     // encoding: [0x64,0x84,0x60,0x4d]
# CHECK: ld2.b { v4, v5 }[13], [c3], x5 // encoding: [0x64,0x14,0xe5,0x4d]
# CHECK: ld2.h { v4, v5 }[2], [c3], x5 // encoding: [0x64,0x50,0xe5,0x0d]
# CHECK: ld2.s { v4, v5 }[2], [c3], x5 // encoding: [0x64,0x80,0xe5,0x4d]
# CHECK: ld2.d { v4, v5 }[1], [c3], x5 // encoding: [0x64,0x84,0xe5,0x4d]
# CHECK: ld2.b { v4, v5 }[13], [c3], #2 // encoding: [0x64,0x14,0xff,0x4d]
# CHECK: ld2.h { v4, v5 }[2], [c3], #4 // encoding: [0x64,0x50,0xff,0x0d]
# CHECK: ld2.s { v4, v5 }[2], [c3], #8 // encoding: [0x64,0x80,0xff,0x4d]
# CHECK: ld2.d { v4, v5 }[1], [c3], #16 // encoding: [0x64,0x84,0xff,0x4d]


_ld3:
  ld3.b {v4, v5, v6}[13], [c3]
  ld3.h {v4, v5, v6}[2], [c3]
  ld3.s {v4, v5, v6}[2], [c3]
  ld3.d {v4, v5, v6}[1], [c3]
  ld3.b {v4, v5, v6}[13], [c3], x5
  ld3.h {v4, v5, v6}[2], [c3], x5
  ld3.s {v4, v5, v6}[2], [c3], x5
  ld3.d {v4, v5, v6}[1], [c3], x5
  ld3.b {v4, v5, v6}[13], [c3], #3
  ld3.h {v4, v5, v6}[2], [c3], #6
  ld3.s {v4, v5, v6}[2], [c3], #12
  ld3.d {v4, v5, v6}[1], [c3], #24


# CHECK: _ld3:
# CHECK: ld3.b { v4, v5, v6 }[13], [c3] // encoding: [0x64,0x34,0x40,0x4d]
# CHECK: ld3.h { v4, v5, v6 }[2], [c3] // encoding: [0x64,0x70,0x40,0x0d]
# CHECK: ld3.s { v4, v5, v6 }[2], [c3] // encoding: [0x64,0xa0,0x40,0x4d]
# CHECK: ld3.d { v4, v5, v6 }[1], [c3] // encoding: [0x64,0xa4,0x40,0x4d]
# CHECK: ld3.b { v4, v5, v6 }[13], [c3], x5 // encoding: [0x64,0x34,0xc5,0x4d]
# CHECK: ld3.h { v4, v5, v6 }[2], [c3], x5 // encoding: [0x64,0x70,0xc5,0x0d]
# CHECK: ld3.s { v4, v5, v6 }[2], [c3], x5 // encoding: [0x64,0xa0,0xc5,0x4d]
# CHECK: ld3.d { v4, v5, v6 }[1], [c3], x5 // encoding: [0x64,0xa4,0xc5,0x4d]
# CHECK: ld3.b { v4, v5, v6 }[13], [c3], #3 // encoding: [0x64,0x34,0xdf,0x4d]
# CHECK: ld3.h { v4, v5, v6 }[2], [c3], #6 // encoding: [0x64,0x70,0xdf,0x0d]
# CHECK: ld3.s { v4, v5, v6 }[2], [c3], #12 // encoding: [0x64,0xa0,0xdf,0x4d]
# CHECK: ld3.d { v4, v5, v6 }[1], [c3], #24 // encoding: [0x64,0xa4,0xdf,0x4d]


_ld4:
  ld4.b {v4, v5, v6, v7}[13], [c3]
  ld4.h {v4, v5, v6, v7}[2], [c3]
  ld4.s {v4, v5, v6, v7}[2], [c3]
  ld4.d {v4, v5, v6, v7}[1], [c3]
  ld4.b {v4, v5, v6, v7}[13], [c3], x5
  ld4.h {v4, v5, v6, v7}[2], [c3], x5
  ld4.s {v4, v5, v6, v7}[2], [c3], x5
  ld4.d {v4, v5, v6, v7}[1], [c3], x5
  ld4.b {v4, v5, v6, v7}[13], [c3], #4
  ld4.h {v4, v5, v6, v7}[2], [c3], #8
  ld4.s {v4, v5, v6, v7}[2], [c3], #16
  ld4.d {v4, v5, v6, v7}[1], [c3], #32

# CHECK: _ld4:
# CHECK: ld4.b { v4, v5, v6, v7 }[13], [c3] // encoding: [0x64,0x34,0x60,0x4d]
# CHECK: ld4.h { v4, v5, v6, v7 }[2], [c3] // encoding: [0x64,0x70,0x60,0x0d]
# CHECK: ld4.s { v4, v5, v6, v7 }[2], [c3] // encoding: [0x64,0xa0,0x60,0x4d]
# CHECK: ld4.d { v4, v5, v6, v7 }[1], [c3] // encoding: [0x64,0xa4,0x60,0x4d]
# CHECK: ld4.b { v4, v5, v6, v7 }[13], [c3], x5 // encoding: [0x64,0x34,0xe5,0x4d]
# CHECK: ld4.h { v4, v5, v6, v7 }[2], [c3], x5 // encoding: [0x64,0x70,0xe5,0x0d]
# CHECK: ld4.s { v4, v5, v6, v7 }[2], [c3], x5 // encoding: [0x64,0xa0,0xe5,0x4d]
# CHECK: ld4.d { v4, v5, v6, v7 }[1], [c3], x5 // encoding: [0x64,0xa4,0xe5,0x4d]
# CHECK: ld4.b { v4, v5, v6, v7 }[13], [c3], #4 // encoding: [0x64,0x34,0xff,0x4d]
# CHECK: ld4.h { v4, v5, v6, v7 }[2], [c3], #8 // encoding: [0x64,0x70,0xff,0x0d]
# CHECK: ld4.s { v4, v5, v6, v7 }[2], [c3], #16 // encoding: [0x64,0xa0,0xff,0x4d]
# CHECK: ld4.d { v4, v5, v6, v7 }[1], [c3], #32 // encoding: [0x64,0xa4,0xff,0x4d]

_st1:
  st1.b {v4}[13], [c3]
  st1.h {v4}[2], [c3]
  st1.s {v4}[2], [c3]
  st1.d {v4}[1], [c3]
  st1.b {v4}[13], [c3], x5
  st1.h {v4}[2], [c3], x5
  st1.s {v4}[2], [c3], x5
  st1.d {v4}[1], [c3], x5
  st1.b {v4}[13], [c3], #1
  st1.h {v4}[2], [c3], #2
  st1.s {v4}[2], [c3], #4
  st1.d {v4}[1], [c3], #8

# CHECK: _st1:
# CHECK: st1.b { v4 }[13], [c3]        // encoding: [0x64,0x14,0x00,0x4d]
# CHECK: st1.h { v4 }[2], [c3]         // encoding: [0x64,0x50,0x00,0x0d]
# CHECK: st1.s { v4 }[2], [c3]         // encoding: [0x64,0x80,0x00,0x4d]
# CHECK: st1.d { v4 }[1], [c3]         // encoding: [0x64,0x84,0x00,0x4d]
# CHECK: st1.b { v4 }[13], [c3], x5    // encoding: [0x64,0x14,0x85,0x4d]
# CHECK: st1.h { v4 }[2], [c3], x5     // encoding: [0x64,0x50,0x85,0x0d]
# CHECK: st1.s { v4 }[2], [c3], x5     // encoding: [0x64,0x80,0x85,0x4d]
# CHECK: st1.d { v4 }[1], [c3], x5     // encoding: [0x64,0x84,0x85,0x4d]
# CHECK: st1.b { v4 }[13], [c3], #1   // encoding: [0x64,0x14,0x9f,0x4d]
# CHECK: st1.h { v4 }[2], [c3], #2    // encoding: [0x64,0x50,0x9f,0x0d]
# CHECK: st1.s { v4 }[2], [c3], #4    // encoding: [0x64,0x80,0x9f,0x4d]
# CHECK: st1.d { v4 }[1], [c3], #8    // encoding: [0x64,0x84,0x9f,0x4d]

_st2:
  st2.b {v4, v5}[13], [c3]
  st2.h {v4, v5}[2], [c3]
  st2.s {v4, v5}[2], [c3]
  st2.d {v4, v5}[1], [c3]
  st2.b {v4, v5}[13], [c3], x5
  st2.h {v4, v5}[2], [c3], x5
  st2.s {v4, v5}[2], [c3], x5
  st2.d {v4, v5}[1], [c3], x5
  st2.b {v4, v5}[13], [c3], #2
  st2.h {v4, v5}[2], [c3], #4
  st2.s {v4, v5}[2], [c3], #8
  st2.d {v4, v5}[1], [c3], #16

# CHECK: _st2:
# CHECK: st2.b { v4, v5 }[13], [c3]    // encoding: [0x64,0x14,0x20,0x4d]
# CHECK: st2.h { v4, v5 }[2], [c3]     // encoding: [0x64,0x50,0x20,0x0d]
# CHECK: st2.s { v4, v5 }[2], [c3]     // encoding: [0x64,0x80,0x20,0x4d]
# CHECK: st2.d { v4, v5 }[1], [c3]     // encoding: [0x64,0x84,0x20,0x4d]
# CHECK: st2.b { v4, v5 }[13], [c3], x5 // encoding: [0x64,0x14,0xa5,0x4d]
# CHECK: st2.h { v4, v5 }[2], [c3], x5 // encoding: [0x64,0x50,0xa5,0x0d]
# CHECK: st2.s { v4, v5 }[2], [c3], x5 // encoding: [0x64,0x80,0xa5,0x4d]
# CHECK: st2.d { v4, v5 }[1], [c3], x5 // encoding: [0x64,0x84,0xa5,0x4d]
# CHECK: st2.b { v4, v5 }[13], [c3], #2 // encoding: [0x64,0x14,0xbf,0x4d]
# CHECK: st2.h { v4, v5 }[2], [c3], #4 // encoding: [0x64,0x50,0xbf,0x0d]
# CHECK: st2.s { v4, v5 }[2], [c3], #8 // encoding: [0x64,0x80,0xbf,0x4d]
# CHECK: st2.d { v4, v5 }[1], [c3], #16 // encoding: [0x64,0x84,0xbf,0x4d]


_st3:
  st3.b {v4, v5, v6}[13], [c3]
  st3.h {v4, v5, v6}[2], [c3]
  st3.s {v4, v5, v6}[2], [c3]
  st3.d {v4, v5, v6}[1], [c3]
  st3.b {v4, v5, v6}[13], [c3], x5
  st3.h {v4, v5, v6}[2], [c3], x5
  st3.s {v4, v5, v6}[2], [c3], x5
  st3.d {v4, v5, v6}[1], [c3], x5
  st3.b {v4, v5, v6}[13], [c3], #3
  st3.h {v4, v5, v6}[2], [c3], #6
  st3.s {v4, v5, v6}[2], [c3], #12
  st3.d {v4, v5, v6}[1], [c3], #24

# CHECK: _st3:
# CHECK: st3.b { v4, v5, v6 }[13], [c3] // encoding: [0x64,0x34,0x00,0x4d]
# CHECK: st3.h { v4, v5, v6 }[2], [c3] // encoding: [0x64,0x70,0x00,0x0d]
# CHECK: st3.s { v4, v5, v6 }[2], [c3] // encoding: [0x64,0xa0,0x00,0x4d]
# CHECK: st3.d { v4, v5, v6 }[1], [c3] // encoding: [0x64,0xa4,0x00,0x4d]
# CHECK: st3.b { v4, v5, v6 }[13], [c3], x5 // encoding: [0x64,0x34,0x85,0x4d]
# CHECK: st3.h { v4, v5, v6 }[2], [c3], x5 // encoding: [0x64,0x70,0x85,0x0d]
# CHECK: st3.s { v4, v5, v6 }[2], [c3], x5 // encoding: [0x64,0xa0,0x85,0x4d]
# CHECK: st3.d { v4, v5, v6 }[1], [c3], x5 // encoding: [0x64,0xa4,0x85,0x4d]
# CHECK: st3.b { v4, v5, v6 }[13], [c3], #3 // encoding: [0x64,0x34,0x9f,0x4d]
# CHECK: st3.h { v4, v5, v6 }[2], [c3], #6 // encoding: [0x64,0x70,0x9f,0x0d]
# CHECK: st3.s { v4, v5, v6 }[2], [c3], #12 // encoding: [0x64,0xa0,0x9f,0x4d]
# CHECK: st3.d { v4, v5, v6 }[1], [c3], #24 // encoding: [0x64,0xa4,0x9f,0x4d]

_st4:
  st4.b {v4, v5, v6, v7}[13], [c3]
  st4.h {v4, v5, v6, v7}[2], [c3]
  st4.s {v4, v5, v6, v7}[2], [c3]
  st4.d {v4, v5, v6, v7}[1], [c3]
  st4.b {v4, v5, v6, v7}[13], [c3], x5
  st4.h {v4, v5, v6, v7}[2], [c3], x5
  st4.s {v4, v5, v6, v7}[2], [c3], x5
  st4.d {v4, v5, v6, v7}[1], [c3], x5
  st4.b {v4, v5, v6, v7}[13], [c3], #4
  st4.h {v4, v5, v6, v7}[2], [c3], #8
  st4.s {v4, v5, v6, v7}[2], [c3], #16
  st4.d {v4, v5, v6, v7}[1], [c3], #32

# CHECK: _st4:
# CHECK: st4.b { v4, v5, v6, v7 }[13], [c3] // encoding: [0x64,0x34,0x20,0x4d]
# CHECK: st4.h { v4, v5, v6, v7 }[2], [c3] // encoding: [0x64,0x70,0x20,0x0d]
# CHECK: st4.s { v4, v5, v6, v7 }[2], [c3] // encoding: [0x64,0xa0,0x20,0x4d]
# CHECK: st4.d { v4, v5, v6, v7 }[1], [c3] // encoding: [0x64,0xa4,0x20,0x4d]
# CHECK: st4.b { v4, v5, v6, v7 }[13], [c3], x5 // encoding: [0x64,0x34,0xa5,0x4d]
# CHECK: st4.h { v4, v5, v6, v7 }[2], [c3], x5 // encoding: [0x64,0x70,0xa5,0x0d]
# CHECK: st4.s { v4, v5, v6, v7 }[2], [c3], x5 // encoding: [0x64,0xa0,0xa5,0x4d]
# CHECK: st4.d { v4, v5, v6, v7 }[1], [c3], x5 // encoding: [0x64,0xa4,0xa5,0x4d]
# CHECK: st4.b { v4, v5, v6, v7 }[13], [c3], #4 // encoding: [0x64,0x34,0xbf,0x4d]
# CHECK: st4.h { v4, v5, v6, v7 }[2], [c3], #8 // encoding: [0x64,0x70,0xbf,0x0d]
# CHECK: st4.s { v4, v5, v6, v7 }[2], [c3], #16 // encoding: [0x64,0xa0,0xbf,0x4d]
# CHECK: st4.d { v4, v5, v6, v7 }[1], [c3], #32 // encoding: [0x64,0xa4,0xbf,0x4d]


#---------
# Arm verbose syntax equivalents to the above.
#---------
verbose_syntax:

  ld1 { v1.8b }, [c1]
  ld1 { v2.8b, v3.8b }, [c1]
  ld1 { v3.8b, v4.8b, v5.8b }, [c1]
  ld1 { v4.8b, v5.8b, v6.8b, v7.8b }, [c1]

  ld1 { v1.16b }, [c1]
  ld1 { v2.16b, v3.16b }, [c1]
  ld1 { v3.16b, v4.16b, v5.16b }, [c1]
  ld1 { v4.16b, v5.16b, v6.16b, v7.16b }, [c1]

  ld1 { v1.4h }, [c1]
  ld1 { v2.4h, v3.4h }, [c1]
  ld1 { v3.4h, v4.4h, v5.4h }, [c1]
  ld1 { v7.4h, v8.4h, v9.4h, v10.4h }, [c1]

  ld1 { v1.8h }, [c1]
  ld1 { v2.8h, v3.8h }, [c1]
  ld1 { v3.8h, v4.8h, v5.8h }, [c1]
  ld1 { v7.8h, v8.8h, v9.8h, v10.8h }, [c1]

  ld1 { v1.2s }, [c1]
  ld1 { v2.2s, v3.2s }, [c1]
  ld1 { v3.2s, v4.2s, v5.2s }, [c1]
  ld1 { v7.2s, v8.2s, v9.2s, v10.2s }, [c1]

  ld1 { v1.4s }, [c1]
  ld1 { v2.4s, v3.4s }, [c1]
  ld1 { v3.4s, v4.4s, v5.4s }, [c1]
  ld1 { v7.4s, v8.4s, v9.4s, v10.4s }, [c1]

  ld1 { v1.1d }, [c1]
  ld1 { v2.1d, v3.1d }, [c1]
  ld1 { v3.1d, v4.1d, v5.1d }, [c1]
  ld1 { v7.1d, v8.1d, v9.1d, v10.1d }, [c1]

  ld1 { v1.2d }, [c1]
  ld1 { v2.2d, v3.2d }, [c1]
  ld1 { v3.2d, v4.2d, v5.2d }, [c1]
  ld1 { v7.2d, v8.2d, v9.2d, v10.2d }, [c1]

  st1 { v1.8b }, [c1]
  st1 { v2.8b, v3.8b }, [c1]
  st1 { v3.8b, v4.8b, v5.8b }, [c1]
  st1 { v4.8b, v5.8b, v6.8b, v7.8b }, [c1]

  st1 { v1.16b }, [c1]
  st1 { v2.16b, v3.16b }, [c1]
  st1 { v3.16b, v4.16b, v5.16b }, [c1]
  st1 { v4.16b, v5.16b, v6.16b, v7.16b }, [c1]

  st1 { v1.4h }, [c1]
  st1 { v2.4h, v3.4h }, [c1]
  st1 { v3.4h, v4.4h, v5.4h }, [c1]
  st1 { v7.4h, v8.4h, v9.4h, v10.4h }, [c1]

  st1 { v1.8h }, [c1]
  st1 { v2.8h, v3.8h }, [c1]
  st1 { v3.8h, v4.8h, v5.8h }, [c1]
  st1 { v7.8h, v8.8h, v9.8h, v10.8h }, [c1]

  st1 { v1.2s }, [c1]
  st1 { v2.2s, v3.2s }, [c1]
  st1 { v3.2s, v4.2s, v5.2s }, [c1]
  st1 { v7.2s, v8.2s, v9.2s, v10.2s }, [c1]

  st1 { v1.4s }, [c1]
  st1 { v2.4s, v3.4s }, [c1]
  st1 { v3.4s, v4.4s, v5.4s }, [c1]
  st1 { v7.4s, v8.4s, v9.4s, v10.4s }, [c1]

  st1 { v1.1d }, [c1]
  st1 { v2.1d, v3.1d }, [c1]
  st1 { v3.1d, v4.1d, v5.1d }, [c1]
  st1 { v7.1d, v8.1d, v9.1d, v10.1d }, [c1]

  st1 { v1.2d }, [c1]
  st1 { v2.2d, v3.2d }, [c1]
  st1 { v3.2d, v4.2d, v5.2d }, [c1]
  st1 { v7.2d, v8.2d, v9.2d, v10.2d }, [c1]

  ld2 { v3.8b, v4.8b }, [c7]
  ld2 { v3.16b, v4.16b }, [c7]
  ld2 { v3.4h, v4.4h }, [c7]
  ld2 { v3.8h, v4.8h }, [c7]
  ld2 { v3.2s, v4.2s }, [c7]
  ld2 { v3.4s, v4.4s }, [c7]
  ld2 { v3.2d, v4.2d }, [c7]

  st2 { v3.8b, v4.8b }, [c7]
  st2 { v3.16b, v4.16b }, [c7]
  st2 { v3.4h, v4.4h }, [c7]
  st2 { v3.8h, v4.8h }, [c7]
  st2 { v3.2s, v4.2s }, [c7]
  st2 { v3.4s, v4.4s }, [c7]
  st2 { v3.2d, v4.2d }, [c7]

  ld3 { v2.8b, v3.8b, v4.8b }, [c7]
  ld3 { v2.16b, v3.16b, v4.16b }, [c7]
  ld3 { v2.4h, v3.4h, v4.4h }, [c7]
  ld3 { v2.8h, v3.8h, v4.8h }, [c7]
  ld3 { v2.2s, v3.2s, v4.2s }, [c7]
  ld3 { v2.4s, v3.4s, v4.4s }, [c7]
  ld3 { v2.2d, v3.2d, v4.2d }, [c7]

  st3 { v2.8b, v3.8b, v4.8b }, [c7]
  st3 { v2.16b, v3.16b, v4.16b }, [c7]
  st3 { v2.4h, v3.4h, v4.4h }, [c7]
  st3 { v2.8h, v3.8h, v4.8h }, [c7]
  st3 { v2.2s, v3.2s, v4.2s }, [c7]
  st3 { v2.4s, v3.4s, v4.4s }, [c7]
  st3 { v2.2d, v3.2d, v4.2d }, [c7]

  ld4 { v2.8b, v3.8b, v4.8b, v5.8b }, [c7]
  ld4 { v2.16b, v3.16b, v4.16b, v5.16b }, [c7]
  ld4 { v2.4h, v3.4h, v4.4h, v5.4h }, [c7]
  ld4 { v2.8h, v3.8h, v4.8h, v5.8h }, [c7]
  ld4 { v2.2s, v3.2s, v4.2s, v5.2s }, [c7]
  ld4 { v2.4s, v3.4s, v4.4s, v5.4s }, [c7]
  ld4 { v2.2d, v3.2d, v4.2d, v5.2d }, [c7]

  st4 { v2.8b, v3.8b, v4.8b, v5.8b }, [c7]
  st4 { v2.16b, v3.16b, v4.16b, v5.16b }, [c7]
  st4 { v2.4h, v3.4h, v4.4h, v5.4h }, [c7]
  st4 { v2.8h, v3.8h, v4.8h, v5.8h }, [c7]
  st4 { v2.2s, v3.2s, v4.2s, v5.2s }, [c7]
  st4 { v2.4s, v3.4s, v4.4s, v5.4s }, [c7]
  st4 { v2.2d, v3.2d, v4.2d, v5.2d }, [c7]

  ld1 { v1.8b }, [c1], x15
  ld1 { v2.8b, v3.8b }, [c1], x15
  ld1 { v3.8b, v4.8b, v5.8b }, [c1], x15
  ld1 { v4.8b, v5.8b, v6.8b, v7.8b }, [c1], x15

  ld1 { v1.16b }, [c1], x15
  ld1 { v2.16b, v3.16b }, [c1], x15
  ld1 { v3.16b, v4.16b, v5.16b }, [c1], x15
  ld1 { v4.16b, v5.16b, v6.16b, v7.16b }, [c1], x15

  ld1 { v1.4h }, [c1], x15
  ld1 { v2.4h, v3.4h }, [c1], x15
  ld1 { v3.4h, v4.4h, v5.4h }, [c1], x15
  ld1 { v7.4h, v8.4h, v9.4h, v10.4h }, [c1], x15

  ld1 { v1.8h }, [c1], x15
  ld1 { v2.8h, v3.8h }, [c1], x15
  ld1 { v3.8h, v4.8h, v5.8h }, [c1], x15
  ld1 { v7.8h, v8.8h, v9.8h, v10.8h }, [c1], x15

  ld1 { v1.2s }, [c1], x15
  ld1 { v2.2s, v3.2s }, [c1], x15
  ld1 { v3.2s, v4.2s, v5.2s }, [c1], x15
  ld1 { v7.2s, v8.2s, v9.2s, v10.2s }, [c1], x15

  ld1 { v1.4s }, [c1], x15
  ld1 { v2.4s, v3.4s }, [c1], x15
  ld1 { v3.4s, v4.4s, v5.4s }, [c1], x15
  ld1 { v7.4s, v8.4s, v9.4s, v10.4s }, [c1], x15

  ld1 { v1.1d }, [c1], x15
  ld1 { v2.1d, v3.1d }, [c1], x15
  ld1 { v3.1d, v4.1d, v5.1d }, [c1], x15
  ld1 { v7.1d, v8.1d, v9.1d, v10.1d }, [c1], x15

  ld1 { v1.2d }, [c1], x15
  ld1 { v2.2d, v3.2d }, [c1], x15
  ld1 { v3.2d, v4.2d, v5.2d }, [c1], x15
  ld1 { v7.2d, v8.2d, v9.2d, v10.2d }, [c1], x15

  st1 { v1.8b }, [c1], x15
  st1 { v2.8b, v3.8b }, [c1], x15
  st1 { v3.8b, v4.8b, v5.8b }, [c1], x15
  st1 { v4.8b, v5.8b, v6.8b, v7.8b }, [c1], x15

  st1 { v1.16b }, [c1], x15
  st1 { v2.16b, v3.16b }, [c1], x15
  st1 { v3.16b, v4.16b, v5.16b }, [c1], x15
  st1 { v4.16b, v5.16b, v6.16b, v7.16b }, [c1], x15

  st1 { v1.4h }, [c1], x15
  st1 { v2.4h, v3.4h }, [c1], x15
  st1 { v3.4h, v4.4h, v5.4h }, [c1], x15
  st1 { v7.4h, v8.4h, v9.4h, v10.4h }, [c1], x15

  st1 { v1.8h }, [c1], x15
  st1 { v2.8h, v3.8h }, [c1], x15
  st1 { v3.8h, v4.8h, v5.8h }, [c1], x15
  st1 { v7.8h, v8.8h, v9.8h, v10.8h }, [c1], x15

  st1 { v1.2s }, [c1], x15
  st1 { v2.2s, v3.2s }, [c1], x15
  st1 { v3.2s, v4.2s, v5.2s }, [c1], x15
  st1 { v7.2s, v8.2s, v9.2s, v10.2s }, [c1], x15

  st1 { v1.4s }, [c1], x15
  st1 { v2.4s, v3.4s }, [c1], x15
  st1 { v3.4s, v4.4s, v5.4s }, [c1], x15
  st1 { v7.4s, v8.4s, v9.4s, v10.4s }, [c1], x15

  st1 { v1.1d }, [c1], x15
  st1 { v2.1d, v3.1d }, [c1], x15
  st1 { v3.1d, v4.1d, v5.1d }, [c1], x15
  st1 { v7.1d, v8.1d, v9.1d, v10.1d }, [c1], x15

  st1 { v1.2d }, [c1], x15
  st1 { v2.2d, v3.2d }, [c1], x15
  st1 { v3.2d, v4.2d, v5.2d }, [c1], x15
  st1 { v7.2d, v8.2d, v9.2d, v10.2d }, [c1], x15

  ld1 { v1.8b }, [c1], #8
  ld1 { v2.8b, v3.8b }, [c1], #16
  ld1 { v3.8b, v4.8b, v5.8b }, [c1], #24
  ld1 { v4.8b, v5.8b, v6.8b, v7.8b }, [c1], #32

  ld1 { v1.16b }, [c1], #16
  ld1 { v2.16b, v3.16b }, [c1], #32
  ld1 { v3.16b, v4.16b, v5.16b }, [c1], #48
  ld1 { v4.16b, v5.16b, v6.16b, v7.16b }, [c1], #64

  ld1 { v1.4h }, [c1], #8
  ld1 { v2.4h, v3.4h }, [c1], #16
  ld1 { v3.4h, v4.4h, v5.4h }, [c1], #24
  ld1 { v7.4h, v8.4h, v9.4h, v10.4h }, [c1], #32

  ld1 { v1.8h }, [c1], #16
  ld1 { v2.8h, v3.8h }, [c1], #32
  ld1 { v3.8h, v4.8h, v5.8h }, [c1], #48
  ld1 { v7.8h, v8.8h, v9.8h, v10.8h }, [c1], #64

  ld1 { v1.2s }, [c1], #8
  ld1 { v2.2s, v3.2s }, [c1], #16
  ld1 { v3.2s, v4.2s, v5.2s }, [c1], #24
  ld1 { v7.2s, v8.2s, v9.2s, v10.2s }, [c1], #32

  ld1 { v1.4s }, [c1], #16
  ld1 { v2.4s, v3.4s }, [c1], #32
  ld1 { v3.4s, v4.4s, v5.4s }, [c1], #48
  ld1 { v7.4s, v8.4s, v9.4s, v10.4s }, [c1], #64

  ld1 { v1.1d }, [c1], #8
  ld1 { v2.1d, v3.1d }, [c1], #16
  ld1 { v3.1d, v4.1d, v5.1d }, [c1], #24
  ld1 { v7.1d, v8.1d, v9.1d, v10.1d }, [c1], #32

  ld1 { v1.2d }, [c1], #16
  ld1 { v2.2d, v3.2d }, [c1], #32
  ld1 { v3.2d, v4.2d, v5.2d }, [c1], #48
  ld1 { v7.2d, v8.2d, v9.2d, v10.2d }, [c1], #64

  st1 { v1.8b }, [c1], #8
  st1 { v2.8b, v3.8b }, [c1], #16
  st1 { v3.8b, v4.8b, v5.8b }, [c1], #24
  st1 { v4.8b, v5.8b, v6.8b, v7.8b }, [c1], #32

  st1 { v1.16b }, [c1], #16
  st1 { v2.16b, v3.16b }, [c1], #32
  st1 { v3.16b, v4.16b, v5.16b }, [c1], #48
  st1 { v4.16b, v5.16b, v6.16b, v7.16b }, [c1], #64

  st1 { v1.4h }, [c1], #8
  st1 { v2.4h, v3.4h }, [c1], #16
  st1 { v3.4h, v4.4h, v5.4h }, [c1], #24
  st1 { v7.4h, v8.4h, v9.4h, v10.4h }, [c1], #32

  st1 { v1.8h }, [c1], #16
  st1 { v2.8h, v3.8h }, [c1], #32
  st1 { v3.8h, v4.8h, v5.8h }, [c1], #48
  st1 { v7.8h, v8.8h, v9.8h, v10.8h }, [c1], #64

  st1 { v1.2s }, [c1], #8
  st1 { v2.2s, v3.2s }, [c1], #16
  st1 { v3.2s, v4.2s, v5.2s }, [c1], #24
  st1 { v7.2s, v8.2s, v9.2s, v10.2s }, [c1], #32

  st1 { v1.4s }, [c1], #16
  st1 { v2.4s, v3.4s }, [c1], #32
  st1 { v3.4s, v4.4s, v5.4s }, [c1], #48
  st1 { v7.4s, v8.4s, v9.4s, v10.4s }, [c1], #64

  st1 { v1.1d }, [c1], #8
  st1 { v2.1d, v3.1d }, [c1], #16
  st1 { v3.1d, v4.1d, v5.1d }, [c1], #24
  st1 { v7.1d, v8.1d, v9.1d, v10.1d }, [c1], #32

  st1 { v1.2d }, [c1], #16
  st1 { v2.2d, v3.2d }, [c1], #32
  st1 { v3.2d, v4.2d, v5.2d }, [c1], #48
  st1 { v7.2d, v8.2d, v9.2d, v10.2d }, [c1], #64

  ld2 { v2.8b, v3.8b }, [c1], x15
  ld2 { v2.16b, v3.16b }, [c1], x15
  ld2 { v2.4h, v3.4h }, [c1], x15
  ld2 { v2.8h, v3.8h }, [c1], x15
  ld2 { v2.2s, v3.2s }, [c1], x15
  ld2 { v2.4s, v3.4s }, [c1], x15
  ld2 { v2.2d, v3.2d }, [c1], x15

  st2 { v2.8b, v3.8b }, [c1], x15
  st2 { v2.16b, v3.16b }, [c1], x15
  st2 { v2.4h, v3.4h }, [c1], x15
  st2 { v2.8h, v3.8h }, [c1], x15
  st2 { v2.2s, v3.2s }, [c1], x15
  st2 { v2.4s, v3.4s }, [c1], x15
  st2 { v2.2d, v3.2d }, [c1], x15

  ld2 { v2.8b, v3.8b }, [c1], #16
  ld2 { v2.16b, v3.16b }, [c1], #32
  ld2 { v2.4h, v3.4h }, [c1], #16
  ld2 { v2.8h, v3.8h }, [c1], #32
  ld2 { v2.2s, v3.2s }, [c1], #16
  ld2 { v2.4s, v3.4s }, [c1], #32
  ld2 { v2.2d, v3.2d }, [c1], #32

  st2 { v2.8b, v3.8b }, [c1], #16
  st2 { v2.16b, v3.16b }, [c1], #32
  st2 { v2.4h, v3.4h }, [c1], #16
  st2 { v2.8h, v3.8h }, [c1], #32
  st2 { v2.2s, v3.2s }, [c1], #16
  st2 { v2.4s, v3.4s }, [c1], #32
  st2 { v2.2d, v3.2d }, [c1], #32

  ld3 { v3.8b, v4.8b, v5.8b }, [c1], x15
  ld3 { v3.16b, v4.16b, v5.16b }, [c1], x15
  ld3 { v3.4h, v4.4h, v5.4h }, [c1], x15
  ld3 { v3.8h, v4.8h, v5.8h }, [c1], x15
  ld3 { v3.2s, v4.2s, v5.2s }, [c1], x15
  ld3 { v3.4s, v4.4s, v5.4s }, [c1], x15
  ld3 { v3.2d, v4.2d, v5.2d }, [c1], x15

  st3 { v3.8b, v4.8b, v5.8b }, [c1], x15
  st3 { v3.16b, v4.16b, v5.16b }, [c1], x15
  st3 { v3.4h, v4.4h, v5.4h }, [c1], x15
  st3 { v3.8h, v4.8h, v5.8h }, [c1], x15
  st3 { v3.2s, v4.2s, v5.2s }, [c1], x15
  st3 { v3.4s, v4.4s, v5.4s }, [c1], x15
  st3 { v3.2d, v4.2d, v5.2d }, [c1], x15
  ld3 { v3.8b, v4.8b, v5.8b }, [c1], #24

  ld3 { v3.16b, v4.16b, v5.16b }, [c1], #48
  ld3 { v3.4h, v4.4h, v5.4h }, [c1], #24
  ld3 { v3.8h, v4.8h, v5.8h }, [c1], #48
  ld3 { v3.2s, v4.2s, v5.2s }, [c1], #24
  ld3 { v3.4s, v4.4s, v5.4s }, [c1], #48
  ld3 { v3.2d, v4.2d, v5.2d }, [c1], #48

  st3 { v3.8b, v4.8b, v5.8b }, [c1], #24
  st3 { v3.16b, v4.16b, v5.16b }, [c1], #48
  st3 { v3.4h, v4.4h, v5.4h }, [c1], #24
  st3 { v3.8h, v4.8h, v5.8h }, [c1], #48
  st3 { v3.2s, v4.2s, v5.2s }, [c1], #24
  st3 { v3.4s, v4.4s, v5.4s }, [c1], #48
  st3 { v3.2d, v4.2d, v5.2d }, [c1], #48

  ld4 { v4.8b, v5.8b, v6.8b, v7.8b }, [c1], x15
  ld4 { v4.16b, v5.16b, v6.16b, v7.16b }, [c1], x15
  ld4 { v7.4h, v8.4h, v9.4h, v10.4h }, [c1], x15
  ld4 { v7.8h, v8.8h, v9.8h, v10.8h }, [c1], x15
  ld4 { v7.2s, v8.2s, v9.2s, v10.2s }, [c1], x15
  ld4 { v7.4s, v8.4s, v9.4s, v10.4s }, [c1], x15
  ld4 { v7.2d, v8.2d, v9.2d, v10.2d }, [c1], x15

  st4 { v4.8b, v5.8b, v6.8b, v7.8b }, [c1], x15
  st4 { v4.16b, v5.16b, v6.16b, v7.16b }, [c1], x15
  st4 { v7.4h, v8.4h, v9.4h, v10.4h }, [c1], x15
  st4 { v7.8h, v8.8h, v9.8h, v10.8h }, [c1], x15
  st4 { v7.2s, v8.2s, v9.2s, v10.2s }, [c1], x15
  st4 { v7.4s, v8.4s, v9.4s, v10.4s }, [c1], x15
  st4 { v7.2d, v8.2d, v9.2d, v10.2d }, [c1], x15

  ld4 { v4.8b, v5.8b, v6.8b, v7.8b }, [c1], #32
  ld4 { v4.16b, v5.16b, v6.16b, v7.16b }, [c1], #64
  ld4 { v7.4h, v8.4h, v9.4h, v10.4h }, [c1], #32
  ld4 { v7.8h, v8.8h, v9.8h, v10.8h }, [c1], #64
  ld4 { v7.2s, v8.2s, v9.2s, v10.2s }, [c1], #32
  ld4 { v7.4s, v8.4s, v9.4s, v10.4s }, [c1], #64
  ld4 { v7.2d, v8.2d, v9.2d, v10.2d }, [c1], #64

  st4 { v4.8b, v5.8b, v6.8b, v7.8b }, [c1], #32
  st4 { v4.16b, v5.16b, v6.16b, v7.16b }, [c1], #64
  st4 { v7.4h, v8.4h, v9.4h, v10.4h }, [c1], #32
  st4 { v7.8h, v8.8h, v9.8h, v10.8h }, [c1], #64
  st4 { v7.2s, v8.2s, v9.2s, v10.2s }, [c1], #32
  st4 { v7.4s, v8.4s, v9.4s, v10.4s }, [c1], #64
  st4 { v7.2d, v8.2d, v9.2d, v10.2d }, [c1], #64


  ld1r { v12.8b }, [c2]
  ld1r { v12.8b }, [c2], x3
  ld1r { v12.16b }, [c2]
  ld1r { v12.16b }, [c2], x3
  ld1r { v12.4h }, [c2]
  ld1r { v12.4h }, [c2], x3
  ld1r { v12.8h }, [c2]
  ld1r { v12.8h }, [c2], x3
  ld1r { v12.2s }, [c2]
  ld1r { v12.2s }, [c2], x3
  ld1r { v12.4s }, [c2]
  ld1r { v12.4s }, [c2], x3
  ld1r { v12.1d }, [c2]
  ld1r { v12.1d }, [c2], x3
  ld1r { v12.2d }, [c2]
  ld1r { v12.2d }, [c2], x3

  ld1r { v12.8b }, [c2], #1
  ld1r { v12.16b }, [c2], #1
  ld1r { v12.4h }, [c2], #2
  ld1r { v12.8h }, [c2], #2
  ld1r { v12.2s }, [c2], #4
  ld1r { v12.4s }, [c2], #4
  ld1r { v12.1d }, [c2], #8
  ld1r { v12.2d }, [c2], #8
  ld2r { v3.8b, v4.8b }, [c2]
  ld2r { v3.8b, v4.8b }, [c2], x3
  ld2r { v3.16b, v4.16b }, [c2]
  ld2r { v3.16b, v4.16b }, [c2], x3
  ld2r { v3.4h, v4.4h }, [c2]
  ld2r { v3.4h, v4.4h }, [c2], x3
  ld2r { v3.8h, v4.8h }, [c2]
  ld2r { v3.8h, v4.8h }, [c2], x3
  ld2r { v3.2s, v4.2s }, [c2]
  ld2r { v3.2s, v4.2s }, [c2], x3
  ld2r { v3.4s, v4.4s }, [c2]
  ld2r { v3.4s, v4.4s }, [c2], x3
  ld2r { v3.1d, v4.1d }, [c2]
  ld2r { v3.1d, v4.1d }, [c2], x3
  ld2r { v3.2d, v4.2d }, [c2]
  ld2r { v3.2d, v4.2d }, [c2], x3

  ld2r { v3.8b, v4.8b }, [c2], #2
  ld2r { v3.16b, v4.16b }, [c2], #2
  ld2r { v3.4h, v4.4h }, [c2], #4
  ld2r { v3.8h, v4.8h }, [c2], #4
  ld2r { v3.2s, v4.2s }, [c2], #8
  ld2r { v3.4s, v4.4s }, [c2], #8
  ld2r { v3.1d, v4.1d }, [c2], #16
  ld2r { v3.2d, v4.2d }, [c2], #16

  ld3r { v2.8b, v3.8b, v4.8b }, [c2]
  ld3r { v2.8b, v3.8b, v4.8b }, [c2], x3
  ld3r { v2.16b, v3.16b, v4.16b }, [c2]
  ld3r { v2.16b, v3.16b, v4.16b }, [c2], x3
  ld3r { v2.4h, v3.4h, v4.4h }, [c2]
  ld3r { v2.4h, v3.4h, v4.4h }, [c2], x3
  ld3r { v2.8h, v3.8h, v4.8h }, [c2]
  ld3r { v2.8h, v3.8h, v4.8h }, [c2], x3
  ld3r { v2.2s, v3.2s, v4.2s }, [c2]
  ld3r { v2.2s, v3.2s, v4.2s }, [c2], x3
  ld3r { v2.4s, v3.4s, v4.4s }, [c2]
  ld3r { v2.4s, v3.4s, v4.4s }, [c2], x3
  ld3r { v2.1d, v3.1d, v4.1d }, [c2]
  ld3r { v2.1d, v3.1d, v4.1d }, [c2], x3
  ld3r { v2.2d, v3.2d, v4.2d }, [c2]
  ld3r { v2.2d, v3.2d, v4.2d }, [c2], x3

  ld3r { v2.8b, v3.8b, v4.8b }, [c2], #3
  ld3r { v2.16b, v3.16b, v4.16b }, [c2], #3
  ld3r { v2.4h, v3.4h, v4.4h }, [c2], #6
  ld3r { v2.8h, v3.8h, v4.8h }, [c2], #6
  ld3r { v2.2s, v3.2s, v4.2s }, [c2], #12
  ld3r { v2.4s, v3.4s, v4.4s }, [c2], #12
  ld3r { v2.1d, v3.1d, v4.1d }, [c2], #24
  ld3r { v2.2d, v3.2d, v4.2d }, [c2], #24

  ld4r { v2.8b, v3.8b, v4.8b, v5.8b }, [c2]
  ld4r { v2.8b, v3.8b, v4.8b, v5.8b }, [c2], x3
  ld4r { v2.16b, v3.16b, v4.16b, v5.16b }, [c2]
  ld4r { v2.16b, v3.16b, v4.16b, v5.16b }, [c2], x3
  ld4r { v2.4h, v3.4h, v4.4h, v5.4h }, [c2]
  ld4r { v2.4h, v3.4h, v4.4h, v5.4h }, [c2], x3
  ld4r { v2.8h, v3.8h, v4.8h, v5.8h }, [c2]
  ld4r { v2.8h, v3.8h, v4.8h, v5.8h }, [c2], x3
  ld4r { v2.2s, v3.2s, v4.2s, v5.2s }, [c2]
  ld4r { v2.2s, v3.2s, v4.2s, v5.2s }, [c2], x3
  ld4r { v2.4s, v3.4s, v4.4s, v5.4s }, [c2]
  ld4r { v2.4s, v3.4s, v4.4s, v5.4s }, [c2], x3
  ld4r { v2.1d, v3.1d, v4.1d, v5.1d }, [c2]
  ld4r { v2.1d, v3.1d, v4.1d, v5.1d }, [c2], x3
  ld4r { v2.2d, v3.2d, v4.2d, v5.2d }, [c2]
  ld4r { v2.2d, v3.2d, v4.2d, v5.2d }, [c2], x3

  ld4r { v2.8b, v3.8b, v4.8b, v5.8b }, [c2], #4
  ld4r { v2.16b, v3.16b, v4.16b, v5.16b }, [c2], #4
  ld4r { v2.4h, v3.4h, v4.4h, v5.4h }, [c2], #8
  ld4r { v2.8h, v3.8h, v4.8h, v5.8h }, [c2], #8
  ld4r { v2.2s, v3.2s, v4.2s, v5.2s }, [c2], #16
  ld4r { v2.4s, v3.4s, v4.4s, v5.4s }, [c2], #16
  ld4r { v2.1d, v3.1d, v4.1d, v5.1d }, [c2], #32
  ld4r { v2.2d, v3.2d, v4.2d, v5.2d }, [c2], #32

  ld1 { v6.b }[13], [c3]
  ld1 { v6.h }[2], [c3]
  ld1 { v6.s }[2], [c3]
  ld1 { v6.d }[1], [c3]
  ld1 { v6.b }[13], [c3], x5
  ld1 { v6.h }[2], [c3], x5
  ld1 { v6.s }[2], [c3], x5
  ld1 { v6.d }[1], [c3], x5
  ld1 { v6.b }[13], [c3], #1
  ld1 { v6.h }[2], [c3], #2
  ld1 { v6.s }[2], [c3], #4
  ld1 { v6.d }[1], [c3], #8

  ld2 { v5.b, v6.b }[13], [c3]
  ld2 { v5.h, v6.h }[2], [c3]
  ld2 { v5.s, v6.s }[2], [c3]
  ld2 { v5.d, v6.d }[1], [c3]
  ld2 { v5.b, v6.b }[13], [c3], x5
  ld2 { v5.h, v6.h }[2], [c3], x5
  ld2 { v5.s, v6.s }[2], [c3], x5
  ld2 { v5.d, v6.d }[1], [c3], x5
  ld2 { v5.b, v6.b }[13], [c3], #2
  ld2 { v5.h, v6.h }[2], [c3], #4
  ld2 { v5.s, v6.s }[2], [c3], #8
  ld2 { v5.d, v6.d }[1], [c3], #16

  ld3 { v7.b, v8.b, v9.b }[13], [c3]
  ld3 { v7.h, v8.h, v9.h }[2], [c3]
  ld3 { v7.s, v8.s, v9.s }[2], [c3]
  ld3 { v7.d, v8.d, v9.d }[1], [c3]
  ld3 { v7.b, v8.b, v9.b }[13], [c3], x5
  ld3 { v7.h, v8.h, v9.h }[2], [c3], x5
  ld3 { v7.s, v8.s, v9.s }[2], [c3], x5
  ld3 { v7.d, v8.d, v9.d }[1], [c3], x5
  ld3 { v7.b, v8.b, v9.b }[13], [c3], #3
  ld3 { v7.h, v8.h, v9.h }[2], [c3], #6
  ld3 { v7.s, v8.s, v9.s }[2], [c3], #12
  ld3 { v7.d, v8.d, v9.d }[1], [c3], #24

  ld4 { v7.b, v8.b, v9.b, v10.b }[13], [c3]
  ld4 { v7.h, v8.h, v9.h, v10.h }[2], [c3]
  ld4 { v7.s, v8.s, v9.s, v10.s }[2], [c3]
  ld4 { v7.d, v8.d, v9.d, v10.d }[1], [c3]
  ld4 { v7.b, v8.b, v9.b, v10.b }[13], [c3], x5
  ld4 { v7.h, v8.h, v9.h, v10.h }[2], [c3], x5
  ld4 { v7.s, v8.s, v9.s, v10.s }[2], [c3], x5
  ld4 { v7.d, v8.d, v9.d, v10.d }[1], [c3], x5
  ld4 { v7.b, v8.b, v9.b, v10.b }[13], [c3], #4
  ld4 { v7.h, v8.h, v9.h, v10.h }[2], [c3], #8
  ld4 { v7.s, v8.s, v9.s, v10.s }[2], [c3], #16
  ld4 { v7.d, v8.d, v9.d, v10.d }[1], [c3], #32

  st1 { v6.b }[13], [c3]
  st1 { v6.h }[2], [c3]
  st1 { v6.s }[2], [c3]
  st1 { v6.d }[1], [c3]
  st1 { v6.b }[13], [c3], x5
  st1 { v6.h }[2], [c3], x5
  st1 { v6.s }[2], [c3], x5
  st1 { v6.d }[1], [c3], x5
  st1 { v6.b }[13], [c3], #1
  st1 { v6.h }[2], [c3], #2
  st1 { v6.s }[2], [c3], #4
  st1 { v6.d }[1], [c3], #8


  st2 { v5.b, v6.b }[13], [c3]
  st2 { v5.h, v6.h }[2], [c3]
  st2 { v5.s, v6.s }[2], [c3]
  st2 { v5.d, v6.d }[1], [c3]
  st2 { v5.b, v6.b }[13], [c3], x5
  st2 { v5.h, v6.h }[2], [c3], x5
  st2 { v5.s, v6.s }[2], [c3], x5
  st2 { v5.d, v6.d }[1], [c3], x5
  st2 { v5.b, v6.b }[13], [c3], #2
  st2 { v5.h, v6.h }[2], [c3], #4
  st2 { v5.s, v6.s }[2], [c3], #8
  st2 { v5.d, v6.d }[1], [c3], #16

  st3 { v7.b, v8.b, v9.b }[13], [c3]
  st3 { v7.h, v8.h, v9.h }[2], [c3]
  st3 { v7.s, v8.s, v9.s }[2], [c3]
  st3 { v7.d, v8.d, v9.d }[1], [c3]
  st3 { v7.b, v8.b, v9.b }[13], [c3], x5
  st3 { v7.h, v8.h, v9.h }[2], [c3], x5
  st3 { v7.s, v8.s, v9.s }[2], [c3], x5
  st3 { v7.d, v8.d, v9.d }[1], [c3], x5
  st3 { v7.b, v8.b, v9.b }[13], [c3], #3
  st3 { v7.h, v8.h, v9.h }[2], [c3], #6
  st3 { v7.s, v8.s, v9.s }[2], [c3], #12
  st3 { v7.d, v8.d, v9.d }[1], [c3], #24

  st4 { v7.b, v8.b, v9.b, v10.b }[13], [c3]
  st4 { v7.h, v8.h, v9.h, v10.h }[2], [c3]
  st4 { v7.s, v8.s, v9.s, v10.s }[2], [c3]
  st4 { v7.d, v8.d, v9.d, v10.d }[1], [c3]
  st4 { v7.b, v8.b, v9.b, v10.b }[13], [c3], x5
  st4 { v7.h, v8.h, v9.h, v10.h }[2], [c3], x5
  st4 { v7.s, v8.s, v9.s, v10.s }[2], [c3], x5
  st4 { v7.d, v8.d, v9.d, v10.d }[1], [c3], x5
  st4 { v7.b, v8.b, v9.b, v10.b }[13], [c3], #4
  st4 { v7.h, v8.h, v9.h, v10.h }[2], [c3], #8
  st4 { v7.s, v8.s, v9.s, v10.s }[2], [c3], #16
  st4 { v7.d, v8.d, v9.d, v10.d }[1], [c3], #32

# CHECK: ld1.8b	{ v1 }, [c1]            // encoding: [0x21,0x70,0x40,0x0c]
# CHECK: ld1.8b	{ v2, v3 }, [c1]        // encoding: [0x22,0xa0,0x40,0x0c]
# CHECK: ld1.8b	{ v3, v4, v5 }, [c1]    // encoding: [0x23,0x60,0x40,0x0c]
# CHECK: ld1.8b	{ v4, v5, v6, v7 }, [c1] // encoding: [0x24,0x20,0x40,0x0c]
# CHECK: ld1.16b	{ v1 }, [c1]            // encoding: [0x21,0x70,0x40,0x4c]
# CHECK: ld1.16b	{ v2, v3 }, [c1]        // encoding: [0x22,0xa0,0x40,0x4c]
# CHECK: ld1.16b	{ v3, v4, v5 }, [c1]    // encoding: [0x23,0x60,0x40,0x4c]
# CHECK: ld1.16b	{ v4, v5, v6, v7 }, [c1] // encoding: [0x24,0x20,0x40,0x4c]
# CHECK: ld1.4h	{ v1 }, [c1]            // encoding: [0x21,0x74,0x40,0x0c]
# CHECK: ld1.4h	{ v2, v3 }, [c1]        // encoding: [0x22,0xa4,0x40,0x0c]
# CHECK: ld1.4h	{ v3, v4, v5 }, [c1]    // encoding: [0x23,0x64,0x40,0x0c]
# CHECK: ld1.4h	{ v7, v8, v9, v10 }, [c1] // encoding: [0x27,0x24,0x40,0x0c]
# CHECK: ld1.8h	{ v1 }, [c1]            // encoding: [0x21,0x74,0x40,0x4c]
# CHECK: ld1.8h	{ v2, v3 }, [c1]        // encoding: [0x22,0xa4,0x40,0x4c]
# CHECK: ld1.8h	{ v3, v4, v5 }, [c1]    // encoding: [0x23,0x64,0x40,0x4c]
# CHECK: ld1.8h	{ v7, v8, v9, v10 }, [c1] // encoding: [0x27,0x24,0x40,0x4c]
# CHECK: ld1.2s	{ v1 }, [c1]            // encoding: [0x21,0x78,0x40,0x0c]
# CHECK: ld1.2s	{ v2, v3 }, [c1]        // encoding: [0x22,0xa8,0x40,0x0c]
# CHECK: ld1.2s	{ v3, v4, v5 }, [c1]    // encoding: [0x23,0x68,0x40,0x0c]
# CHECK: ld1.2s	{ v7, v8, v9, v10 }, [c1] // encoding: [0x27,0x28,0x40,0x0c]
# CHECK: ld1.4s	{ v1 }, [c1]            // encoding: [0x21,0x78,0x40,0x4c]
# CHECK: ld1.4s	{ v2, v3 }, [c1]        // encoding: [0x22,0xa8,0x40,0x4c]
# CHECK: ld1.4s	{ v3, v4, v5 }, [c1]    // encoding: [0x23,0x68,0x40,0x4c]
# CHECK: ld1.4s	{ v7, v8, v9, v10 }, [c1] // encoding: [0x27,0x28,0x40,0x4c]
# CHECK: ld1.1d	{ v1 }, [c1]            // encoding: [0x21,0x7c,0x40,0x0c]
# CHECK: ld1.1d	{ v2, v3 }, [c1]        // encoding: [0x22,0xac,0x40,0x0c]
# CHECK: ld1.1d	{ v3, v4, v5 }, [c1]    // encoding: [0x23,0x6c,0x40,0x0c]
# CHECK: ld1.1d	{ v7, v8, v9, v10 }, [c1] // encoding: [0x27,0x2c,0x40,0x0c]
# CHECK: ld1.2d	{ v1 }, [c1]            // encoding: [0x21,0x7c,0x40,0x4c]
# CHECK: ld1.2d	{ v2, v3 }, [c1]        // encoding: [0x22,0xac,0x40,0x4c]
# CHECK: ld1.2d	{ v3, v4, v5 }, [c1]    // encoding: [0x23,0x6c,0x40,0x4c]
# CHECK: ld1.2d	{ v7, v8, v9, v10 }, [c1] // encoding: [0x27,0x2c,0x40,0x4c]
# CHECK: st1.8b	{ v1 }, [c1]            // encoding: [0x21,0x70,0x00,0x0c]
# CHECK: st1.8b	{ v2, v3 }, [c1]        // encoding: [0x22,0xa0,0x00,0x0c]
# CHECK: st1.8b	{ v3, v4, v5 }, [c1]    // encoding: [0x23,0x60,0x00,0x0c]
# CHECK: st1.8b	{ v4, v5, v6, v7 }, [c1] // encoding: [0x24,0x20,0x00,0x0c]
# CHECK: st1.16b	{ v1 }, [c1]            // encoding: [0x21,0x70,0x00,0x4c]
# CHECK: st1.16b	{ v2, v3 }, [c1]        // encoding: [0x22,0xa0,0x00,0x4c]
# CHECK: st1.16b	{ v3, v4, v5 }, [c1]    // encoding: [0x23,0x60,0x00,0x4c]
# CHECK: st1.16b	{ v4, v5, v6, v7 }, [c1] // encoding: [0x24,0x20,0x00,0x4c]
# CHECK: st1.4h	{ v1 }, [c1]            // encoding: [0x21,0x74,0x00,0x0c]
# CHECK: st1.4h	{ v2, v3 }, [c1]        // encoding: [0x22,0xa4,0x00,0x0c]
# CHECK: st1.4h	{ v3, v4, v5 }, [c1]    // encoding: [0x23,0x64,0x00,0x0c]
# CHECK: st1.4h	{ v7, v8, v9, v10 }, [c1] // encoding: [0x27,0x24,0x00,0x0c]
# CHECK: st1.8h	{ v1 }, [c1]            // encoding: [0x21,0x74,0x00,0x4c]
# CHECK: st1.8h	{ v2, v3 }, [c1]        // encoding: [0x22,0xa4,0x00,0x4c]
# CHECK: st1.8h	{ v3, v4, v5 }, [c1]    // encoding: [0x23,0x64,0x00,0x4c]
# CHECK: st1.8h	{ v7, v8, v9, v10 }, [c1] // encoding: [0x27,0x24,0x00,0x4c]
# CHECK: st1.2s	{ v1 }, [c1]            // encoding: [0x21,0x78,0x00,0x0c]
# CHECK: st1.2s	{ v2, v3 }, [c1]        // encoding: [0x22,0xa8,0x00,0x0c]
# CHECK: st1.2s	{ v3, v4, v5 }, [c1]    // encoding: [0x23,0x68,0x00,0x0c]
# CHECK: st1.2s	{ v7, v8, v9, v10 }, [c1] // encoding: [0x27,0x28,0x00,0x0c]
# CHECK: st1.4s	{ v1 }, [c1]            // encoding: [0x21,0x78,0x00,0x4c]
# CHECK: st1.4s	{ v2, v3 }, [c1]        // encoding: [0x22,0xa8,0x00,0x4c]
# CHECK: st1.4s	{ v3, v4, v5 }, [c1]    // encoding: [0x23,0x68,0x00,0x4c]
# CHECK: st1.4s	{ v7, v8, v9, v10 }, [c1] // encoding: [0x27,0x28,0x00,0x4c]
# CHECK: st1.1d	{ v1 }, [c1]            // encoding: [0x21,0x7c,0x00,0x0c]
# CHECK: st1.1d	{ v2, v3 }, [c1]        // encoding: [0x22,0xac,0x00,0x0c]
# CHECK: st1.1d	{ v3, v4, v5 }, [c1]    // encoding: [0x23,0x6c,0x00,0x0c]
# CHECK: st1.1d	{ v7, v8, v9, v10 }, [c1] // encoding: [0x27,0x2c,0x00,0x0c]
# CHECK: st1.2d	{ v1 }, [c1]            // encoding: [0x21,0x7c,0x00,0x4c]
# CHECK: st1.2d	{ v2, v3 }, [c1]        // encoding: [0x22,0xac,0x00,0x4c]
# CHECK: st1.2d	{ v3, v4, v5 }, [c1]    // encoding: [0x23,0x6c,0x00,0x4c]
# CHECK: st1.2d	{ v7, v8, v9, v10 }, [c1] // encoding: [0x27,0x2c,0x00,0x4c]
# CHECK: ld2.8b	{ v3, v4 }, [c7]       // encoding: [0xe3,0x80,0x40,0x0c]
# CHECK: ld2.16b	{ v3, v4 }, [c7]       // encoding: [0xe3,0x80,0x40,0x4c]
# CHECK: ld2.4h	{ v3, v4 }, [c7]       // encoding: [0xe3,0x84,0x40,0x0c]
# CHECK: ld2.8h	{ v3, v4 }, [c7]       // encoding: [0xe3,0x84,0x40,0x4c]
# CHECK: ld2.2s	{ v3, v4 }, [c7]       // encoding: [0xe3,0x88,0x40,0x0c]
# CHECK: ld2.4s	{ v3, v4 }, [c7]       // encoding: [0xe3,0x88,0x40,0x4c]
# CHECK: ld2.2d	{ v3, v4 }, [c7]       // encoding: [0xe3,0x8c,0x40,0x4c]
# CHECK: st2.8b	{ v3, v4 }, [c7]       // encoding: [0xe3,0x80,0x00,0x0c]
# CHECK: st2.16b { v3, v4 }, [c7]       // encoding: [0xe3,0x80,0x00,0x4c]
# CHECK: st2.4h	{ v3, v4 }, [c7]       // encoding: [0xe3,0x84,0x00,0x0c]
# CHECK: st2.8h	{ v3, v4 }, [c7]       // encoding: [0xe3,0x84,0x00,0x4c]
# CHECK: st2.2s	{ v3, v4 }, [c7]       // encoding: [0xe3,0x88,0x00,0x0c]
# CHECK: st2.4s	{ v3, v4 }, [c7]       // encoding: [0xe3,0x88,0x00,0x4c]
# CHECK: st2.2d	{ v3, v4 }, [c7]       // encoding: [0xe3,0x8c,0x00,0x4c]
# CHECK: ld3.8b	{ v2, v3, v4 }, [c7]   // encoding: [0xe2,0x40,0x40,0x0c]
# CHECK: ld3.16b	{ v2, v3, v4 }, [c7]   // encoding: [0xe2,0x40,0x40,0x4c]
# CHECK: ld3.4h	{ v2, v3, v4 }, [c7]   // encoding: [0xe2,0x44,0x40,0x0c]
# CHECK: ld3.8h	{ v2, v3, v4 }, [c7]   // encoding: [0xe2,0x44,0x40,0x4c]
# CHECK: ld3.2s	{ v2, v3, v4 }, [c7]   // encoding: [0xe2,0x48,0x40,0x0c]
# CHECK: ld3.4s	{ v2, v3, v4 }, [c7]   // encoding: [0xe2,0x48,0x40,0x4c]
# CHECK: ld3.2d	{ v2, v3, v4 }, [c7]   // encoding: [0xe2,0x4c,0x40,0x4c]
# CHECK: st3.8b	{ v2, v3, v4 }, [c7]   // encoding: [0xe2,0x40,0x00,0x0c]
# CHECK: st3.16b	{ v2, v3, v4 }, [c7]   // encoding: [0xe2,0x40,0x00,0x4c]
# CHECK: st3.4h	{ v2, v3, v4 }, [c7]   // encoding: [0xe2,0x44,0x00,0x0c]
# CHECK: st3.8h	{ v2, v3, v4 }, [c7]   // encoding: [0xe2,0x44,0x00,0x4c]
# CHECK: st3.2s	{ v2, v3, v4 }, [c7]   // encoding: [0xe2,0x48,0x00,0x0c]
# CHECK: st3.4s	{ v2, v3, v4 }, [c7]   // encoding: [0xe2,0x48,0x00,0x4c]
# CHECK: st3.2d	{ v2, v3, v4 }, [c7]   // encoding: [0xe2,0x4c,0x00,0x4c]
# CHECK: ld4.8b	{ v2, v3, v4, v5 }, [c7] // encoding: [0xe2,0x00,0x40,0x0c]
# CHECK: ld4.16b	{ v2, v3, v4, v5 }, [c7] // encoding: [0xe2,0x00,0x40,0x4c]
# CHECK: ld4.4h	{ v2, v3, v4, v5 }, [c7] // encoding: [0xe2,0x04,0x40,0x0c]
# CHECK: ld4.8h	{ v2, v3, v4, v5 }, [c7] // encoding: [0xe2,0x04,0x40,0x4c]
# CHECK: ld4.2s	{ v2, v3, v4, v5 }, [c7] // encoding: [0xe2,0x08,0x40,0x0c]
# CHECK: ld4.4s	{ v2, v3, v4, v5 }, [c7] // encoding: [0xe2,0x08,0x40,0x4c]
# CHECK: ld4.2d	{ v2, v3, v4, v5 }, [c7] // encoding: [0xe2,0x0c,0x40,0x4c]
# CHECK: st4.8b	{ v2, v3, v4, v5 }, [c7] // encoding: [0xe2,0x00,0x00,0x0c]
# CHECK: st4.16b	{ v2, v3, v4, v5 }, [c7] // encoding: [0xe2,0x00,0x00,0x4c]
# CHECK: st4.4h	{ v2, v3, v4, v5 }, [c7] // encoding: [0xe2,0x04,0x00,0x0c]
# CHECK: st4.8h	{ v2, v3, v4, v5 }, [c7] // encoding: [0xe2,0x04,0x00,0x4c]
# CHECK: st4.2s	{ v2, v3, v4, v5 }, [c7] // encoding: [0xe2,0x08,0x00,0x0c]
# CHECK: st4.4s	{ v2, v3, v4, v5 }, [c7] // encoding: [0xe2,0x08,0x00,0x4c]
# CHECK: st4.2d	{ v2, v3, v4, v5 }, [c7] // encoding: [0xe2,0x0c,0x00,0x4c]
# CHECK: ld1.8b	{ v1 }, [c1], x15       // encoding: [0x21,0x70,0xcf,0x0c]
# CHECK: ld1.8b	{ v2, v3 }, [c1], x15   // encoding: [0x22,0xa0,0xcf,0x0c]
# CHECK: ld1.8b	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x60,0xcf,0x0c]
# CHECK: ld1.8b	{ v4, v5, v6, v7 }, [c1], x15 // encoding: [0x24,0x20,0xcf,0x0c]
# CHECK: ld1.16b	{ v1 }, [c1], x15       // encoding: [0x21,0x70,0xcf,0x4c]
# CHECK: ld1.16b	{ v2, v3 }, [c1], x15   // encoding: [0x22,0xa0,0xcf,0x4c]
# CHECK: ld1.16b	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x60,0xcf,0x4c]
# CHECK: ld1.16b	{ v4, v5, v6, v7 }, [c1], x15 // encoding: [0x24,0x20,0xcf,0x4c]
# CHECK: ld1.4h	{ v1 }, [c1], x15       // encoding: [0x21,0x74,0xcf,0x0c]
# CHECK: ld1.4h	{ v2, v3 }, [c1], x15   // encoding: [0x22,0xa4,0xcf,0x0c]
# CHECK: ld1.4h	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x64,0xcf,0x0c]
# CHECK: ld1.4h	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x24,0xcf,0x0c]
# CHECK: ld1.8h	{ v1 }, [c1], x15       // encoding: [0x21,0x74,0xcf,0x4c]
# CHECK: ld1.8h	{ v2, v3 }, [c1], x15   // encoding: [0x22,0xa4,0xcf,0x4c]
# CHECK: ld1.8h	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x64,0xcf,0x4c]
# CHECK: ld1.8h	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x24,0xcf,0x4c]
# CHECK: ld1.2s	{ v1 }, [c1], x15       // encoding: [0x21,0x78,0xcf,0x0c]
# CHECK: ld1.2s	{ v2, v3 }, [c1], x15   // encoding: [0x22,0xa8,0xcf,0x0c]
# CHECK: ld1.2s	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x68,0xcf,0x0c]
# CHECK: ld1.2s	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x28,0xcf,0x0c]
# CHECK: ld1.4s	{ v1 }, [c1], x15       // encoding: [0x21,0x78,0xcf,0x4c]
# CHECK: ld1.4s	{ v2, v3 }, [c1], x15   // encoding: [0x22,0xa8,0xcf,0x4c]
# CHECK: ld1.4s	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x68,0xcf,0x4c]
# CHECK: ld1.4s	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x28,0xcf,0x4c]
# CHECK: ld1.1d	{ v1 }, [c1], x15       // encoding: [0x21,0x7c,0xcf,0x0c]
# CHECK: ld1.1d	{ v2, v3 }, [c1], x15   // encoding: [0x22,0xac,0xcf,0x0c]
# CHECK: ld1.1d	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x6c,0xcf,0x0c]
# CHECK: ld1.1d	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x2c,0xcf,0x0c]
# CHECK: ld1.2d	{ v1 }, [c1], x15       // encoding: [0x21,0x7c,0xcf,0x4c]
# CHECK: ld1.2d	{ v2, v3 }, [c1], x15   // encoding: [0x22,0xac,0xcf,0x4c]
# CHECK: ld1.2d	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x6c,0xcf,0x4c]
# CHECK: ld1.2d	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x2c,0xcf,0x4c]
# CHECK: st1.8b	{ v1 }, [c1], x15       // encoding: [0x21,0x70,0x8f,0x0c]
# CHECK: st1.8b	{ v2, v3 }, [c1], x15   // encoding: [0x22,0xa0,0x8f,0x0c]
# CHECK: st1.8b	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x60,0x8f,0x0c]
# CHECK: st1.8b	{ v4, v5, v6, v7 }, [c1], x15 // encoding: [0x24,0x20,0x8f,0x0c]
# CHECK: st1.16b	{ v1 }, [c1], x15       // encoding: [0x21,0x70,0x8f,0x4c]
# CHECK: st1.16b	{ v2, v3 }, [c1], x15   // encoding: [0x22,0xa0,0x8f,0x4c]
# CHECK: st1.16b	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x60,0x8f,0x4c]
# CHECK: st1.16b	{ v4, v5, v6, v7 }, [c1], x15 // encoding: [0x24,0x20,0x8f,0x4c]
# CHECK: st1.4h	{ v1 }, [c1], x15       // encoding: [0x21,0x74,0x8f,0x0c]
# CHECK: st1.4h	{ v2, v3 }, [c1], x15   // encoding: [0x22,0xa4,0x8f,0x0c]
# CHECK: st1.4h	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x64,0x8f,0x0c]
# CHECK: st1.4h	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x24,0x8f,0x0c]
# CHECK: st1.8h	{ v1 }, [c1], x15       // encoding: [0x21,0x74,0x8f,0x4c]
# CHECK: st1.8h	{ v2, v3 }, [c1], x15   // encoding: [0x22,0xa4,0x8f,0x4c]
# CHECK: st1.8h	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x64,0x8f,0x4c]
# CHECK: st1.8h	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x24,0x8f,0x4c]
# CHECK: st1.2s	{ v1 }, [c1], x15       // encoding: [0x21,0x78,0x8f,0x0c]
# CHECK: st1.2s	{ v2, v3 }, [c1], x15   // encoding: [0x22,0xa8,0x8f,0x0c]
# CHECK: st1.2s	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x68,0x8f,0x0c]
# CHECK: st1.2s	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x28,0x8f,0x0c]
# CHECK: st1.4s	{ v1 }, [c1], x15       // encoding: [0x21,0x78,0x8f,0x4c]
# CHECK: st1.4s	{ v2, v3 }, [c1], x15   // encoding: [0x22,0xa8,0x8f,0x4c]
# CHECK: st1.4s	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x68,0x8f,0x4c]
# CHECK: st1.4s	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x28,0x8f,0x4c]
# CHECK: st1.1d	{ v1 }, [c1], x15       // encoding: [0x21,0x7c,0x8f,0x0c]
# CHECK: st1.1d	{ v2, v3 }, [c1], x15   // encoding: [0x22,0xac,0x8f,0x0c]
# CHECK: st1.1d	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x6c,0x8f,0x0c]
# CHECK: st1.1d	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x2c,0x8f,0x0c]
# CHECK: st1.2d	{ v1 }, [c1], x15       // encoding: [0x21,0x7c,0x8f,0x4c]
# CHECK: st1.2d	{ v2, v3 }, [c1], x15   // encoding: [0x22,0xac,0x8f,0x4c]
# CHECK: st1.2d	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x6c,0x8f,0x4c]
# CHECK: st1.2d	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x2c,0x8f,0x4c]
# CHECK: ld1.8b	{ v1 }, [c1], #8       // encoding: [0x21,0x70,0xdf,0x0c]
# CHECK: ld1.8b	{ v2, v3 }, [c1], #16   // encoding: [0x22,0xa0,0xdf,0x0c]
# CHECK: ld1.8b	{ v3, v4, v5 }, [c1], #24 // encoding: [0x23,0x60,0xdf,0x0c]
# CHECK: ld1.8b	{ v4, v5, v6, v7 }, [c1], #32 // encoding: [0x24,0x20,0xdf,0x0c]
# CHECK: ld1.16b	{ v1 }, [c1], #16       // encoding: [0x21,0x70,0xdf,0x4c]
# CHECK: ld1.16b	{ v2, v3 }, [c1], #32   // encoding: [0x22,0xa0,0xdf,0x4c]
# CHECK: ld1.16b	{ v3, v4, v5 }, [c1], #48 // encoding: [0x23,0x60,0xdf,0x4c]
# CHECK: ld1.16b	{ v4, v5, v6, v7 }, [c1], #64 // encoding: [0x24,0x20,0xdf,0x4c]
# CHECK: ld1.4h	{ v1 }, [c1], #8       // encoding: [0x21,0x74,0xdf,0x0c]
# CHECK: ld1.4h	{ v2, v3 }, [c1], #16   // encoding: [0x22,0xa4,0xdf,0x0c]
# CHECK: ld1.4h	{ v3, v4, v5 }, [c1], #24 // encoding: [0x23,0x64,0xdf,0x0c]
# CHECK: ld1.4h	{ v7, v8, v9, v10 }, [c1], #32 // encoding: [0x27,0x24,0xdf,0x0c]
# CHECK: ld1.8h	{ v1 }, [c1], #16       // encoding: [0x21,0x74,0xdf,0x4c]
# CHECK: ld1.8h	{ v2, v3 }, [c1], #32   // encoding: [0x22,0xa4,0xdf,0x4c]
# CHECK: ld1.8h	{ v3, v4, v5 }, [c1], #48 // encoding: [0x23,0x64,0xdf,0x4c]
# CHECK: ld1.8h	{ v7, v8, v9, v10 }, [c1], #64 // encoding: [0x27,0x24,0xdf,0x4c]
# CHECK: ld1.2s	{ v1 }, [c1], #8       // encoding: [0x21,0x78,0xdf,0x0c]
# CHECK: ld1.2s	{ v2, v3 }, [c1], #16   // encoding: [0x22,0xa8,0xdf,0x0c]
# CHECK: ld1.2s	{ v3, v4, v5 }, [c1], #24 // encoding: [0x23,0x68,0xdf,0x0c]
# CHECK: ld1.2s	{ v7, v8, v9, v10 }, [c1], #32 // encoding: [0x27,0x28,0xdf,0x0c]
# CHECK: ld1.4s	{ v1 }, [c1], #16       // encoding: [0x21,0x78,0xdf,0x4c]
# CHECK: ld1.4s	{ v2, v3 }, [c1], #32   // encoding: [0x22,0xa8,0xdf,0x4c]
# CHECK: ld1.4s	{ v3, v4, v5 }, [c1], #48 // encoding: [0x23,0x68,0xdf,0x4c]
# CHECK: ld1.4s	{ v7, v8, v9, v10 }, [c1], #64 // encoding: [0x27,0x28,0xdf,0x4c]
# CHECK: ld1.1d	{ v1 }, [c1], #8       // encoding: [0x21,0x7c,0xdf,0x0c]
# CHECK: ld1.1d	{ v2, v3 }, [c1], #16   // encoding: [0x22,0xac,0xdf,0x0c]
# CHECK: ld1.1d	{ v3, v4, v5 }, [c1], #24 // encoding: [0x23,0x6c,0xdf,0x0c]
# CHECK: ld1.1d	{ v7, v8, v9, v10 }, [c1], #32 // encoding: [0x27,0x2c,0xdf,0x0c]
# CHECK: ld1.2d	{ v1 }, [c1], #16       // encoding: [0x21,0x7c,0xdf,0x4c]
# CHECK: ld1.2d	{ v2, v3 }, [c1], #32   // encoding: [0x22,0xac,0xdf,0x4c]
# CHECK: ld1.2d	{ v3, v4, v5 }, [c1], #48 // encoding: [0x23,0x6c,0xdf,0x4c]
# CHECK: ld1.2d	{ v7, v8, v9, v10 }, [c1], #64 // encoding: [0x27,0x2c,0xdf,0x4c]
# CHECK: st1.8b	{ v1 }, [c1], #8       // encoding: [0x21,0x70,0x9f,0x0c]
# CHECK: st1.8b	{ v2, v3 }, [c1], #16   // encoding: [0x22,0xa0,0x9f,0x0c]
# CHECK: st1.8b	{ v3, v4, v5 }, [c1], #24 // encoding: [0x23,0x60,0x9f,0x0c]
# CHECK: st1.8b	{ v4, v5, v6, v7 }, [c1], #32 // encoding: [0x24,0x20,0x9f,0x0c]
# CHECK: st1.16b	{ v1 }, [c1], #16       // encoding: [0x21,0x70,0x9f,0x4c]
# CHECK: st1.16b	{ v2, v3 }, [c1], #32   // encoding: [0x22,0xa0,0x9f,0x4c]
# CHECK: st1.16b	{ v3, v4, v5 }, [c1], #48 // encoding: [0x23,0x60,0x9f,0x4c]
# CHECK: st1.16b	{ v4, v5, v6, v7 }, [c1], #64 // encoding: [0x24,0x20,0x9f,0x4c]
# CHECK: st1.4h	{ v1 }, [c1], #8       // encoding: [0x21,0x74,0x9f,0x0c]
# CHECK: st1.4h	{ v2, v3 }, [c1], #16   // encoding: [0x22,0xa4,0x9f,0x0c]
# CHECK: st1.4h	{ v3, v4, v5 }, [c1], #24 // encoding: [0x23,0x64,0x9f,0x0c]
# CHECK: st1.4h	{ v7, v8, v9, v10 }, [c1], #32 // encoding: [0x27,0x24,0x9f,0x0c]
# CHECK: st1.8h	{ v1 }, [c1], #16       // encoding: [0x21,0x74,0x9f,0x4c]
# CHECK: st1.8h	{ v2, v3 }, [c1], #32   // encoding: [0x22,0xa4,0x9f,0x4c]
# CHECK: st1.8h	{ v3, v4, v5 }, [c1], #48 // encoding: [0x23,0x64,0x9f,0x4c]
# CHECK: st1.8h	{ v7, v8, v9, v10 }, [c1], #64 // encoding: [0x27,0x24,0x9f,0x4c]
# CHECK: st1.2s	{ v1 }, [c1], #8       // encoding: [0x21,0x78,0x9f,0x0c]
# CHECK: st1.2s	{ v2, v3 }, [c1], #16   // encoding: [0x22,0xa8,0x9f,0x0c]
# CHECK: st1.2s	{ v3, v4, v5 }, [c1], #24 // encoding: [0x23,0x68,0x9f,0x0c]
# CHECK: st1.2s	{ v7, v8, v9, v10 }, [c1], #32 // encoding: [0x27,0x28,0x9f,0x0c]
# CHECK: st1.4s	{ v1 }, [c1], #16       // encoding: [0x21,0x78,0x9f,0x4c]
# CHECK: st1.4s	{ v2, v3 }, [c1], #32   // encoding: [0x22,0xa8,0x9f,0x4c]
# CHECK: st1.4s	{ v3, v4, v5 }, [c1], #48 // encoding: [0x23,0x68,0x9f,0x4c]
# CHECK: st1.4s	{ v7, v8, v9, v10 }, [c1], #64 // encoding: [0x27,0x28,0x9f,0x4c]
# CHECK: st1.1d	{ v1 }, [c1], #8       // encoding: [0x21,0x7c,0x9f,0x0c]
# CHECK: st1.1d	{ v2, v3 }, [c1], #16   // encoding: [0x22,0xac,0x9f,0x0c]
# CHECK: st1.1d	{ v3, v4, v5 }, [c1], #24 // encoding: [0x23,0x6c,0x9f,0x0c]
# CHECK: st1.1d	{ v7, v8, v9, v10 }, [c1], #32 // encoding: [0x27,0x2c,0x9f,0x0c]
# CHECK: st1.2d	{ v1 }, [c1], #16       // encoding: [0x21,0x7c,0x9f,0x4c]
# CHECK: st1.2d	{ v2, v3 }, [c1], #32   // encoding: [0x22,0xac,0x9f,0x4c]
# CHECK: st1.2d	{ v3, v4, v5 }, [c1], #48 // encoding: [0x23,0x6c,0x9f,0x4c]
# CHECK: st1.2d	{ v7, v8, v9, v10 }, [c1], #64 // encoding: [0x27,0x2c,0x9f,0x4c]
# CHECK: ld2.8b	{ v2, v3 }, [c1], x15   // encoding: [0x22,0x80,0xcf,0x0c]
# CHECK: ld2.16b	{ v2, v3 }, [c1], x15   // encoding: [0x22,0x80,0xcf,0x4c]
# CHECK: ld2.4h	{ v2, v3 }, [c1], x15   // encoding: [0x22,0x84,0xcf,0x0c]
# CHECK: ld2.8h	{ v2, v3 }, [c1], x15   // encoding: [0x22,0x84,0xcf,0x4c]
# CHECK: ld2.2s	{ v2, v3 }, [c1], x15   // encoding: [0x22,0x88,0xcf,0x0c]
# CHECK: ld2.4s	{ v2, v3 }, [c1], x15   // encoding: [0x22,0x88,0xcf,0x4c]
# CHECK: ld2.2d	{ v2, v3 }, [c1], x15   // encoding: [0x22,0x8c,0xcf,0x4c]
# CHECK: st2.8b	{ v2, v3 }, [c1], x15   // encoding: [0x22,0x80,0x8f,0x0c]
# CHECK: st2.16b	{ v2, v3 }, [c1], x15   // encoding: [0x22,0x80,0x8f,0x4c]
# CHECK: st2.4h	{ v2, v3 }, [c1], x15   // encoding: [0x22,0x84,0x8f,0x0c]
# CHECK: st2.8h	{ v2, v3 }, [c1], x15   // encoding: [0x22,0x84,0x8f,0x4c]
# CHECK: st2.2s	{ v2, v3 }, [c1], x15   // encoding: [0x22,0x88,0x8f,0x0c]
# CHECK: st2.4s	{ v2, v3 }, [c1], x15   // encoding: [0x22,0x88,0x8f,0x4c]
# CHECK: st2.2d	{ v2, v3 }, [c1], x15   // encoding: [0x22,0x8c,0x8f,0x4c]
# CHECK: ld2.8b	{ v2, v3 }, [c1], #16   // encoding: [0x22,0x80,0xdf,0x0c]
# CHECK: ld2.16b	{ v2, v3 }, [c1], #32   // encoding: [0x22,0x80,0xdf,0x4c]
# CHECK: ld2.4h	{ v2, v3 }, [c1], #16   // encoding: [0x22,0x84,0xdf,0x0c]
# CHECK: ld2.8h	{ v2, v3 }, [c1], #32   // encoding: [0x22,0x84,0xdf,0x4c]
# CHECK: ld2.2s	{ v2, v3 }, [c1], #16   // encoding: [0x22,0x88,0xdf,0x0c]
# CHECK: ld2.4s	{ v2, v3 }, [c1], #32   // encoding: [0x22,0x88,0xdf,0x4c]
# CHECK: ld2.2d	{ v2, v3 }, [c1], #32	// encoding: [0x22,0x8c,0xdf,0x4c]
# CHECK: st2.8b	{ v2, v3 }, [c1], #16   // encoding: [0x22,0x80,0x9f,0x0c]
# CHECK: st2.16b	{ v2, v3 }, [c1], #32   // encoding: [0x22,0x80,0x9f,0x4c]
# CHECK: st2.4h	{ v2, v3 }, [c1], #16   // encoding: [0x22,0x84,0x9f,0x0c]
# CHECK: st2.8h	{ v2, v3 }, [c1], #32   // encoding: [0x22,0x84,0x9f,0x4c]
# CHECK: st2.2s	{ v2, v3 }, [c1], #16   // encoding: [0x22,0x88,0x9f,0x0c]
# CHECK: st2.4s	{ v2, v3 }, [c1], #32   // encoding: [0x22,0x88,0x9f,0x4c]
# CHECK: st2.2d	{ v2, v3 }, [c1], #32   // encoding: [0x22,0x8c,0x9f,0x4c]
# CHECK: ld3.8b	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x40,0xcf,0x0c]
# CHECK: ld3.16b	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x40,0xcf,0x4c]
# CHECK: ld3.4h	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x44,0xcf,0x0c]
# CHECK: ld3.8h	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x44,0xcf,0x4c]
# CHECK: ld3.2s	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x48,0xcf,0x0c]
# CHECK: ld3.4s	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x48,0xcf,0x4c]
# CHECK: ld3.2d	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x4c,0xcf,0x4c]
# CHECK: st3.8b	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x40,0x8f,0x0c]
# CHECK: st3.16b	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x40,0x8f,0x4c]
# CHECK: st3.4h	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x44,0x8f,0x0c]
# CHECK: st3.8h	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x44,0x8f,0x4c]
# CHECK: st3.2s	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x48,0x8f,0x0c]
# CHECK: st3.4s	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x48,0x8f,0x4c]
# CHECK: st3.2d	{ v3, v4, v5 }, [c1], x15 // encoding: [0x23,0x4c,0x8f,0x4c]
# CHECK: ld3.8b	{ v3, v4, v5 }, [c1], #24 // encoding: [0x23,0x40,0xdf,0x0c]
# CHECK: ld3.16b	{ v3, v4, v5 }, [c1], #48 // encoding: [0x23,0x40,0xdf,0x4c]
# CHECK: ld3.4h	{ v3, v4, v5 }, [c1], #24 // encoding: [0x23,0x44,0xdf,0x0c]
# CHECK: ld3.8h	{ v3, v4, v5 }, [c1], #48 // encoding: [0x23,0x44,0xdf,0x4c]
# CHECK: ld3.2s	{ v3, v4, v5 }, [c1], #24 // encoding: [0x23,0x48,0xdf,0x0c]
# CHECK: ld3.4s	{ v3, v4, v5 }, [c1], #48 // encoding: [0x23,0x48,0xdf,0x4c]
# CHECK: ld3.2d	{ v3, v4, v5 }, [c1], #48 // encoding: [0x23,0x4c,0xdf,0x4c]
# CHECK: st3.8b	{ v3, v4, v5 }, [c1], #24 // encoding: [0x23,0x40,0x9f,0x0c]
# CHECK: st3.16b	{ v3, v4, v5 }, [c1], #48 // encoding: [0x23,0x40,0x9f,0x4c]
# CHECK: st3.4h	{ v3, v4, v5 }, [c1], #24 // encoding: [0x23,0x44,0x9f,0x0c]
# CHECK: st3.8h	{ v3, v4, v5 }, [c1], #48 // encoding: [0x23,0x44,0x9f,0x4c]
# CHECK: st3.2s	{ v3, v4, v5 }, [c1], #24 // encoding: [0x23,0x48,0x9f,0x0c]
# CHECK: st3.4s	{ v3, v4, v5 }, [c1], #48 // encoding: [0x23,0x48,0x9f,0x4c]
# CHECK: st3.2d	{ v3, v4, v5 }, [c1], #48 // encoding: [0x23,0x4c,0x9f,0x4c]
# CHECK: ld4.8b	{ v4, v5, v6, v7 }, [c1], x15 // encoding: [0x24,0x00,0xcf,0x0c]
# CHECK: ld4.16b	{ v4, v5, v6, v7 }, [c1], x15 // encoding: [0x24,0x00,0xcf,0x4c]
# CHECK: ld4.4h	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x04,0xcf,0x0c]
# CHECK: ld4.8h	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x04,0xcf,0x4c]
# CHECK: ld4.2s	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x08,0xcf,0x0c]
# CHECK: ld4.4s	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x08,0xcf,0x4c]
# CHECK: ld4.2d	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x0c,0xcf,0x4c]
# CHECK: st4.8b	{ v4, v5, v6, v7 }, [c1], x15 // encoding: [0x24,0x00,0x8f,0x0c]
# CHECK: st4.16b	{ v4, v5, v6, v7 }, [c1], x15 // encoding: [0x24,0x00,0x8f,0x4c]
# CHECK: st4.4h	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x04,0x8f,0x0c]
# CHECK: st4.8h	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x04,0x8f,0x4c]
# CHECK: st4.2s	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x08,0x8f,0x0c]
# CHECK: st4.4s	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x08,0x8f,0x4c]
# CHECK: st4.2d	{ v7, v8, v9, v10 }, [c1], x15 // encoding: [0x27,0x0c,0x8f,0x4c]
# CHECK: ld4.8b	{ v4, v5, v6, v7 }, [c1], #32 // encoding: [0x24,0x00,0xdf,0x0c]
# CHECK: ld4.16b	{ v4, v5, v6, v7 }, [c1], #64 // encoding: [0x24,0x00,0xdf,0x4c]
# CHECK: ld4.4h	{ v7, v8, v9, v10 }, [c1], #32 // encoding: [0x27,0x04,0xdf,0x0c]
# CHECK: ld4.8h	{ v7, v8, v9, v10 }, [c1], #64 // encoding: [0x27,0x04,0xdf,0x4c]
# CHECK: ld4.2s	{ v7, v8, v9, v10 }, [c1], #32 // encoding: [0x27,0x08,0xdf,0x0c]
# CHECK: ld4.4s	{ v7, v8, v9, v10 }, [c1], #64 // encoding: [0x27,0x08,0xdf,0x4c]
# CHECK: ld4.2d	{ v7, v8, v9, v10 }, [c1], #64 // encoding: [0x27,0x0c,0xdf,0x4c]
# CHECK: st4.8b	{ v4, v5, v6, v7 }, [c1], #32 // encoding: [0x24,0x00,0x9f,0x0c]
# CHECK: st4.16b	{ v4, v5, v6, v7 }, [c1], #64 // encoding: [0x24,0x00,0x9f,0x4c]
# CHECK: st4.4h	{ v7, v8, v9, v10 }, [c1], #32 // encoding: [0x27,0x04,0x9f,0x0c]
# CHECK: st4.8h	{ v7, v8, v9, v10 }, [c1], #64 // encoding: [0x27,0x04,0x9f,0x4c]
# CHECK: st4.2s	{ v7, v8, v9, v10 }, [c1], #32 // encoding: [0x27,0x08,0x9f,0x0c]
# CHECK: st4.4s	{ v7, v8, v9, v10 }, [c1], #64 // encoding: [0x27,0x08,0x9f,0x4c]
# CHECK: st4.2d	{ v7, v8, v9, v10 }, [c1], #64 // encoding: [0x27,0x0c,0x9f,0x4c]
# CHECK: ld1r.8b	{ v12 }, [c2]           // encoding: [0x4c,0xc0,0x40,0x0d]
# CHECK: ld1r.8b	{ v12 }, [c2], x3       // encoding: [0x4c,0xc0,0xc3,0x0d]
# CHECK: ld1r.16b	{ v12 }, [c2]   // encoding: [0x4c,0xc0,0x40,0x4d]
# CHECK: ld1r.16b	{ v12 }, [c2], x3 // encoding: [0x4c,0xc0,0xc3,0x4d]
# CHECK: ld1r.4h	{ v12 }, [c2]           // encoding: [0x4c,0xc4,0x40,0x0d]
# CHECK: ld1r.4h	{ v12 }, [c2], x3       // encoding: [0x4c,0xc4,0xc3,0x0d]
# CHECK: ld1r.8h	{ v12 }, [c2]           // encoding: [0x4c,0xc4,0x40,0x4d]
# CHECK: ld1r.8h	{ v12 }, [c2], x3       // encoding: [0x4c,0xc4,0xc3,0x4d]
# CHECK: ld1r.2s	{ v12 }, [c2]           // encoding: [0x4c,0xc8,0x40,0x0d]
# CHECK: ld1r.2s	{ v12 }, [c2], x3       // encoding: [0x4c,0xc8,0xc3,0x0d]
# CHECK: ld1r.4s	{ v12 }, [c2]           // encoding: [0x4c,0xc8,0x40,0x4d]
# CHECK: ld1r.4s	{ v12 }, [c2], x3       // encoding: [0x4c,0xc8,0xc3,0x4d]
# CHECK: ld1r.1d	{ v12 }, [c2]           // encoding: [0x4c,0xcc,0x40,0x0d]
# CHECK: ld1r.1d	{ v12 }, [c2], x3       // encoding: [0x4c,0xcc,0xc3,0x0d]
# CHECK: ld1r.2d	{ v12 }, [c2]           // encoding: [0x4c,0xcc,0x40,0x4d]
# CHECK: ld1r.2d	{ v12 }, [c2], x3       // encoding: [0x4c,0xcc,0xc3,0x4d]
# CHECK: ld1r.8b	{ v12 }, [c2], #1      // encoding: [0x4c,0xc0,0xdf,0x0d]
# CHECK: ld1r.16b	{ v12 }, [c2], #1 // encoding: [0x4c,0xc0,0xdf,0x4d]
# CHECK: ld1r.4h	{ v12 }, [c2], #2      // encoding: [0x4c,0xc4,0xdf,0x0d]
# CHECK: ld1r.8h	{ v12 }, [c2], #2      // encoding: [0x4c,0xc4,0xdf,0x4d]
# CHECK: ld1r.2s	{ v12 }, [c2], #4      // encoding: [0x4c,0xc8,0xdf,0x0d]
# CHECK: ld1r.4s	{ v12 }, [c2], #4      // encoding: [0x4c,0xc8,0xdf,0x4d]
# CHECK: ld1r.1d	{ v12 }, [c2], #8      // encoding: [0x4c,0xcc,0xdf,0x0d]
# CHECK: ld1r.2d	{ v12 }, [c2], #8      // encoding: [0x4c,0xcc,0xdf,0x4d]
# CHECK: ld2r.8b	{ v3, v4 }, [c2]        // encoding: [0x43,0xc0,0x60,0x0d]
# CHECK: ld2r.8b	{ v3, v4 }, [c2], x3    // encoding: [0x43,0xc0,0xe3,0x0d]
# CHECK: ld2r.16b	{ v3, v4 }, [c2] // encoding: [0x43,0xc0,0x60,0x4d]
# CHECK: ld2r.16b	{ v3, v4 }, [c2], x3 // encoding: [0x43,0xc0,0xe3,0x4d]
# CHECK: ld2r.4h	{ v3, v4 }, [c2]        // encoding: [0x43,0xc4,0x60,0x0d]
# CHECK: ld2r.4h	{ v3, v4 }, [c2], x3    // encoding: [0x43,0xc4,0xe3,0x0d]
# CHECK: ld2r.8h	{ v3, v4 }, [c2]        // encoding: [0x43,0xc4,0x60,0x4d]
# CHECK: ld2r.8h	{ v3, v4 }, [c2], x3    // encoding: [0x43,0xc4,0xe3,0x4d]
# CHECK: ld2r.2s	{ v3, v4 }, [c2]        // encoding: [0x43,0xc8,0x60,0x0d]
# CHECK: ld2r.2s	{ v3, v4 }, [c2], x3    // encoding: [0x43,0xc8,0xe3,0x0d]
# CHECK: ld2r.4s	{ v3, v4 }, [c2]        // encoding: [0x43,0xc8,0x60,0x4d]
# CHECK: ld2r.4s	{ v3, v4 }, [c2], x3    // encoding: [0x43,0xc8,0xe3,0x4d]
# CHECK: ld2r.1d	{ v3, v4 }, [c2]        // encoding: [0x43,0xcc,0x60,0x0d]
# CHECK: ld2r.1d	{ v3, v4 }, [c2], x3    // encoding: [0x43,0xcc,0xe3,0x0d]
# CHECK: ld2r.2d	{ v3, v4 }, [c2]        // encoding: [0x43,0xcc,0x60,0x4d]
# CHECK: ld2r.2d	{ v3, v4 }, [c2], x3    // encoding: [0x43,0xcc,0xe3,0x4d]
# CHECK: ld2r.8b	{ v3, v4 }, [c2], #2   // encoding: [0x43,0xc0,0xff,0x0d]
# CHECK: ld2r.16b	{ v3, v4 }, [c2], #2 // encoding: [0x43,0xc0,0xff,0x4d]
# CHECK: ld2r.4h	{ v3, v4 }, [c2], #4   // encoding: [0x43,0xc4,0xff,0x0d]
# CHECK: ld2r.8h	{ v3, v4 }, [c2], #4   // encoding: [0x43,0xc4,0xff,0x4d]
# CHECK: ld2r.2s	{ v3, v4 }, [c2], #8   // encoding: [0x43,0xc8,0xff,0x0d]
# CHECK: ld2r.4s	{ v3, v4 }, [c2], #8   // encoding: [0x43,0xc8,0xff,0x4d]
# CHECK: ld2r.1d	{ v3, v4 }, [c2], #16   // encoding: [0x43,0xcc,0xff,0x0d]
# CHECK: ld2r.2d	{ v3, v4 }, [c2], #16   // encoding: [0x43,0xcc,0xff,0x4d]
# CHECK: ld3r.8b	{ v2, v3, v4 }, [c2]    // encoding: [0x42,0xe0,0x40,0x0d]
# CHECK: ld3r.8b	{ v2, v3, v4 }, [c2], x3 // encoding: [0x42,0xe0,0xc3,0x0d]
# CHECK: ld3r.16b	{ v2, v3, v4 }, [c2] // encoding: [0x42,0xe0,0x40,0x4d]
# CHECK: ld3r.16b	{ v2, v3, v4 }, [c2], x3 // encoding: [0x42,0xe0,0xc3,0x4d]
# CHECK: ld3r.4h	{ v2, v3, v4 }, [c2]    // encoding: [0x42,0xe4,0x40,0x0d]
# CHECK: ld3r.4h	{ v2, v3, v4 }, [c2], x3 // encoding: [0x42,0xe4,0xc3,0x0d]
# CHECK: ld3r.8h	{ v2, v3, v4 }, [c2]    // encoding: [0x42,0xe4,0x40,0x4d]
# CHECK: ld3r.8h	{ v2, v3, v4 }, [c2], x3 // encoding: [0x42,0xe4,0xc3,0x4d]
# CHECK: ld3r.2s	{ v2, v3, v4 }, [c2]    // encoding: [0x42,0xe8,0x40,0x0d]
# CHECK: ld3r.2s	{ v2, v3, v4 }, [c2], x3 // encoding: [0x42,0xe8,0xc3,0x0d]
# CHECK: ld3r.4s	{ v2, v3, v4 }, [c2]    // encoding: [0x42,0xe8,0x40,0x4d]
# CHECK: ld3r.4s	{ v2, v3, v4 }, [c2], x3 // encoding: [0x42,0xe8,0xc3,0x4d]
# CHECK: ld3r.1d	{ v2, v3, v4 }, [c2]    // encoding: [0x42,0xec,0x40,0x0d]
# CHECK: ld3r.1d	{ v2, v3, v4 }, [c2], x3 // encoding: [0x42,0xec,0xc3,0x0d]
# CHECK: ld3r.2d	{ v2, v3, v4 }, [c2]    // encoding: [0x42,0xec,0x40,0x4d]
# CHECK: ld3r.2d	{ v2, v3, v4 }, [c2], x3 // encoding: [0x42,0xec,0xc3,0x4d]
# CHECK: ld3r.8b	{ v2, v3, v4 }, [c2], #3 // encoding: [0x42,0xe0,0xdf,0x0d]
# CHECK: ld3r.16b	{ v2, v3, v4 }, [c2], #3 // encoding: [0x42,0xe0,0xdf,0x4d]
# CHECK: ld3r.4h	{ v2, v3, v4 }, [c2], #6 // encoding: [0x42,0xe4,0xdf,0x0d]
# CHECK: ld3r.8h	{ v2, v3, v4 }, [c2], #6 // encoding: [0x42,0xe4,0xdf,0x4d]
# CHECK: ld3r.2s	{ v2, v3, v4 }, [c2], #12 // encoding: [0x42,0xe8,0xdf,0x0d]
# CHECK: ld3r.4s	{ v2, v3, v4 }, [c2], #12 // encoding: [0x42,0xe8,0xdf,0x4d]
# CHECK: ld3r.1d	{ v2, v3, v4 }, [c2], #24 // encoding: [0x42,0xec,0xdf,0x0d]
# CHECK: ld3r.2d	{ v2, v3, v4 }, [c2], #24 // encoding: [0x42,0xec,0xdf,0x4d]
# CHECK: ld4r.8b	{ v2, v3, v4, v5 }, [c2] // encoding: [0x42,0xe0,0x60,0x0d]
# CHECK: ld4r.8b	{ v2, v3, v4, v5 }, [c2], x3 // encoding: [0x42,0xe0,0xe3,0x0d]
# CHECK: ld4r.16b	{ v2, v3, v4, v5 }, [c2] // encoding: [0x42,0xe0,0x60,0x4d]
# CHECK: ld4r.16b	{ v2, v3, v4, v5 }, [c2], x3 // encoding: [0x42,0xe0,0xe3,0x4d]
# CHECK: ld4r.4h	{ v2, v3, v4, v5 }, [c2] // encoding: [0x42,0xe4,0x60,0x0d]
# CHECK: ld4r.4h	{ v2, v3, v4, v5 }, [c2], x3 // encoding: [0x42,0xe4,0xe3,0x0d]
# CHECK: ld4r.8h	{ v2, v3, v4, v5 }, [c2] // encoding: [0x42,0xe4,0x60,0x4d]
# CHECK: ld4r.8h	{ v2, v3, v4, v5 }, [c2], x3 // encoding: [0x42,0xe4,0xe3,0x4d]
# CHECK: ld4r.2s	{ v2, v3, v4, v5 }, [c2] // encoding: [0x42,0xe8,0x60,0x0d]
# CHECK: ld4r.2s	{ v2, v3, v4, v5 }, [c2], x3 // encoding: [0x42,0xe8,0xe3,0x0d]
# CHECK: ld4r.4s	{ v2, v3, v4, v5 }, [c2] // encoding: [0x42,0xe8,0x60,0x4d]
# CHECK: ld4r.4s	{ v2, v3, v4, v5 }, [c2], x3 // encoding: [0x42,0xe8,0xe3,0x4d]
# CHECK: ld4r.1d	{ v2, v3, v4, v5 }, [c2] // encoding: [0x42,0xec,0x60,0x0d]
# CHECK: ld4r.1d	{ v2, v3, v4, v5 }, [c2], x3 // encoding: [0x42,0xec,0xe3,0x0d]
# CHECK: ld4r.2d	{ v2, v3, v4, v5 }, [c2] // encoding: [0x42,0xec,0x60,0x4d]
# CHECK: ld4r.2d	{ v2, v3, v4, v5 }, [c2], x3 // encoding: [0x42,0xec,0xe3,0x4d]
# CHECK: ld4r.8b	{ v2, v3, v4, v5 }, [c2], #4 // encoding: [0x42,0xe0,0xff,0x0d]
# CHECK: ld4r.16b	{ v2, v3, v4, v5 }, [c2], #4 // encoding: [0x42,0xe0,0xff,0x4d]
# CHECK: ld4r.4h	{ v2, v3, v4, v5 }, [c2], #8 // encoding: [0x42,0xe4,0xff,0x0d]
# CHECK: ld4r.8h	{ v2, v3, v4, v5 }, [c2], #8 // encoding: [0x42,0xe4,0xff,0x4d]
# CHECK: ld4r.2s	{ v2, v3, v4, v5 }, [c2], #16 // encoding: [0x42,0xe8,0xff,0x0d]
# CHECK: ld4r.4s	{ v2, v3, v4, v5 }, [c2], #16 // encoding: [0x42,0xe8,0xff,0x4d]
# CHECK: ld4r.1d	{ v2, v3, v4, v5 }, [c2], #32 // encoding: [0x42,0xec,0xff,0x0d]
# CHECK: ld4r.2d	{ v2, v3, v4, v5 }, [c2], #32 // encoding: [0x42,0xec,0xff,0x4d]
# CHECK: ld1.b	{ v6 }[13], [c3]        // encoding: [0x66,0x14,0x40,0x4d]
# CHECK: ld1.h	{ v6 }[2], [c3]         // encoding: [0x66,0x50,0x40,0x0d]
# CHECK: ld1.s	{ v6 }[2], [c3]         // encoding: [0x66,0x80,0x40,0x4d]
# CHECK: ld1.d	{ v6 }[1], [c3]         // encoding: [0x66,0x84,0x40,0x4d]
# CHECK: ld1.b	{ v6 }[13], [c3], x5    // encoding: [0x66,0x14,0xc5,0x4d]
# CHECK: ld1.h	{ v6 }[2], [c3], x5     // encoding: [0x66,0x50,0xc5,0x0d]
# CHECK: ld1.s	{ v6 }[2], [c3], x5     // encoding: [0x66,0x80,0xc5,0x4d]
# CHECK: ld1.d	{ v6 }[1], [c3], x5     // encoding: [0x66,0x84,0xc5,0x4d]
# CHECK: ld1.b	{ v6 }[13], [c3], #1   // encoding: [0x66,0x14,0xdf,0x4d]
# CHECK: ld1.h	{ v6 }[2], [c3], #2    // encoding: [0x66,0x50,0xdf,0x0d]
# CHECK: ld1.s	{ v6 }[2], [c3], #4    // encoding: [0x66,0x80,0xdf,0x4d]
# CHECK: ld1.d	{ v6 }[1], [c3], #8    // encoding: [0x66,0x84,0xdf,0x4d]
# CHECK: ld2.b	{ v5, v6 }[13], [c3]    // encoding: [0x65,0x14,0x60,0x4d]
# CHECK: ld2.h	{ v5, v6 }[2], [c3]     // encoding: [0x65,0x50,0x60,0x0d]
# CHECK: ld2.s	{ v5, v6 }[2], [c3]     // encoding: [0x65,0x80,0x60,0x4d]
# CHECK: ld2.d	{ v5, v6 }[1], [c3]     // encoding: [0x65,0x84,0x60,0x4d]
# CHECK: ld2.b	{ v5, v6 }[13], [c3], x5 // encoding: [0x65,0x14,0xe5,0x4d]
# CHECK: ld2.h	{ v5, v6 }[2], [c3], x5 // encoding: [0x65,0x50,0xe5,0x0d]
# CHECK: ld2.s	{ v5, v6 }[2], [c3], x5 // encoding: [0x65,0x80,0xe5,0x4d]
# CHECK: ld2.d	{ v5, v6 }[1], [c3], x5 // encoding: [0x65,0x84,0xe5,0x4d]
# CHECK: ld2.b	{ v5, v6 }[13], [c3], #2 // encoding: [0x65,0x14,0xff,0x4d]
# CHECK: ld2.h	{ v5, v6 }[2], [c3], #4 // encoding: [0x65,0x50,0xff,0x0d]
# CHECK: ld2.s	{ v5, v6 }[2], [c3], #8 // encoding: [0x65,0x80,0xff,0x4d]
# CHECK: ld2.d	{ v5, v6 }[1], [c3], #16 // encoding: [0x65,0x84,0xff,0x4d]
# CHECK: ld3.b	{ v7, v8, v9 }[13], [c3] // encoding: [0x67,0x34,0x40,0x4d]
# CHECK: ld3.h	{ v7, v8, v9 }[2], [c3] // encoding: [0x67,0x70,0x40,0x0d]
# CHECK: ld3.s	{ v7, v8, v9 }[2], [c3] // encoding: [0x67,0xa0,0x40,0x4d]
# CHECK: ld3.d	{ v7, v8, v9 }[1], [c3] // encoding: [0x67,0xa4,0x40,0x4d]
# CHECK: ld3.b	{ v7, v8, v9 }[13], [c3], x5 // encoding: [0x67,0x34,0xc5,0x4d]
# CHECK: ld3.h	{ v7, v8, v9 }[2], [c3], x5 // encoding: [0x67,0x70,0xc5,0x0d]
# CHECK: ld3.s	{ v7, v8, v9 }[2], [c3], x5 // encoding: [0x67,0xa0,0xc5,0x4d]
# CHECK: ld3.d	{ v7, v8, v9 }[1], [c3], x5 // encoding: [0x67,0xa4,0xc5,0x4d]
# CHECK: ld3.b	{ v7, v8, v9 }[13], [c3], #3 // encoding: [0x67,0x34,0xdf,0x4d]
# CHECK: ld3.h	{ v7, v8, v9 }[2], [c3], #6 // encoding: [0x67,0x70,0xdf,0x0d]
# CHECK: ld3.s	{ v7, v8, v9 }[2], [c3], #12 // encoding: [0x67,0xa0,0xdf,0x4d]
# CHECK: ld3.d	{ v7, v8, v9 }[1], [c3], #24 // encoding: [0x67,0xa4,0xdf,0x4d]
# CHECK: ld4.b	{ v7, v8, v9, v10 }[13], [c3] // encoding: [0x67,0x34,0x60,0x4d]
# CHECK: ld4.h	{ v7, v8, v9, v10 }[2], [c3] // encoding: [0x67,0x70,0x60,0x0d]
# CHECK: ld4.s	{ v7, v8, v9, v10 }[2], [c3] // encoding: [0x67,0xa0,0x60,0x4d]
# CHECK: ld4.d	{ v7, v8, v9, v10 }[1], [c3] // encoding: [0x67,0xa4,0x60,0x4d]
# CHECK: ld4.b	{ v7, v8, v9, v10 }[13], [c3], x5 // encoding: [0x67,0x34,0xe5,0x4d]
# CHECK: ld4.h	{ v7, v8, v9, v10 }[2], [c3], x5 // encoding: [0x67,0x70,0xe5,0x0d]
# CHECK: ld4.s	{ v7, v8, v9, v10 }[2], [c3], x5 // encoding: [0x67,0xa0,0xe5,0x4d]
# CHECK: ld4.d	{ v7, v8, v9, v10 }[1], [c3], x5 // encoding: [0x67,0xa4,0xe5,0x4d]
# CHECK: ld4.b	{ v7, v8, v9, v10 }[13], [c3], #4 // encoding: [0x67,0x34,0xff,0x4d]
# CHECK: ld4.h	{ v7, v8, v9, v10 }[2], [c3], #8 // encoding: [0x67,0x70,0xff,0x0d]
# CHECK: ld4.s	{ v7, v8, v9, v10 }[2], [c3], #16 // encoding: [0x67,0xa0,0xff,0x4d]
# CHECK: ld4.d	{ v7, v8, v9, v10 }[1], [c3], #32 // encoding: [0x67,0xa4,0xff,0x4d]
# CHECK: st1.b	{ v6 }[13], [c3]        // encoding: [0x66,0x14,0x00,0x4d]
# CHECK: st1.h	{ v6 }[2], [c3]         // encoding: [0x66,0x50,0x00,0x0d]
# CHECK: st1.s	{ v6 }[2], [c3]         // encoding: [0x66,0x80,0x00,0x4d]
# CHECK: st1.d	{ v6 }[1], [c3]         // encoding: [0x66,0x84,0x00,0x4d]
# CHECK: st1.b	{ v6 }[13], [c3], x5    // encoding: [0x66,0x14,0x85,0x4d]
# CHECK: st1.h	{ v6 }[2], [c3], x5     // encoding: [0x66,0x50,0x85,0x0d]
# CHECK: st1.s	{ v6 }[2], [c3], x5     // encoding: [0x66,0x80,0x85,0x4d]
# CHECK: st1.d	{ v6 }[1], [c3], x5     // encoding: [0x66,0x84,0x85,0x4d]
# CHECK: st1.b	{ v6 }[13], [c3], #1   // encoding: [0x66,0x14,0x9f,0x4d]
# CHECK: st1.h	{ v6 }[2], [c3], #2    // encoding: [0x66,0x50,0x9f,0x0d]
# CHECK: st1.s	{ v6 }[2], [c3], #4    // encoding: [0x66,0x80,0x9f,0x4d]
# CHECK: st1.d	{ v6 }[1], [c3], #8    // encoding: [0x66,0x84,0x9f,0x4d]
# CHECK: st2.b	{ v5, v6 }[13], [c3]    // encoding: [0x65,0x14,0x20,0x4d]
# CHECK: st2.h	{ v5, v6 }[2], [c3]     // encoding: [0x65,0x50,0x20,0x0d]
# CHECK: st2.s	{ v5, v6 }[2], [c3]     // encoding: [0x65,0x80,0x20,0x4d]
# CHECK: st2.d	{ v5, v6 }[1], [c3]     // encoding: [0x65,0x84,0x20,0x4d]
# CHECK: st2.b	{ v5, v6 }[13], [c3], x5 // encoding: [0x65,0x14,0xa5,0x4d]
# CHECK: st2.h	{ v5, v6 }[2], [c3], x5 // encoding: [0x65,0x50,0xa5,0x0d]
# CHECK: st2.s	{ v5, v6 }[2], [c3], x5 // encoding: [0x65,0x80,0xa5,0x4d]
# CHECK: st2.d	{ v5, v6 }[1], [c3], x5 // encoding: [0x65,0x84,0xa5,0x4d]
# CHECK: st2.b	{ v5, v6 }[13], [c3], #2 // encoding: [0x65,0x14,0xbf,0x4d]
# CHECK: st2.h	{ v5, v6 }[2], [c3], #4 // encoding: [0x65,0x50,0xbf,0x0d]
# CHECK: st2.s	{ v5, v6 }[2], [c3], #8 // encoding: [0x65,0x80,0xbf,0x4d]
# CHECK: st2.d	{ v5, v6 }[1], [c3], #16 // encoding: [0x65,0x84,0xbf,0x4d]
# CHECK: st3.b	{ v7, v8, v9 }[13], [c3] // encoding: [0x67,0x34,0x00,0x4d]
# CHECK: st3.h	{ v7, v8, v9 }[2], [c3] // encoding: [0x67,0x70,0x00,0x0d]
# CHECK: st3.s	{ v7, v8, v9 }[2], [c3] // encoding: [0x67,0xa0,0x00,0x4d]
# CHECK: st3.d	{ v7, v8, v9 }[1], [c3] // encoding: [0x67,0xa4,0x00,0x4d]
# CHECK: st3.b	{ v7, v8, v9 }[13], [c3], x5 // encoding: [0x67,0x34,0x85,0x4d]
# CHECK: st3.h	{ v7, v8, v9 }[2], [c3], x5 // encoding: [0x67,0x70,0x85,0x0d]
# CHECK: st3.s	{ v7, v8, v9 }[2], [c3], x5 // encoding: [0x67,0xa0,0x85,0x4d]
# CHECK: st3.d	{ v7, v8, v9 }[1], [c3], x5 // encoding: [0x67,0xa4,0x85,0x4d]
# CHECK: st3.b	{ v7, v8, v9 }[13], [c3], #3 // encoding: [0x67,0x34,0x9f,0x4d]
# CHECK: st3.h	{ v7, v8, v9 }[2], [c3], #6 // encoding: [0x67,0x70,0x9f,0x0d]
# CHECK: st3.s	{ v7, v8, v9 }[2], [c3], #12 // encoding: [0x67,0xa0,0x9f,0x4d]
# CHECK: st3.d	{ v7, v8, v9 }[1], [c3], #24 // encoding: [0x67,0xa4,0x9f,0x4d]
# CHECK: st4.b	{ v7, v8, v9, v10 }[13], [c3] // encoding: [0x67,0x34,0x20,0x4d]
# CHECK: st4.h	{ v7, v8, v9, v10 }[2], [c3] // encoding: [0x67,0x70,0x20,0x0d]
# CHECK: st4.s	{ v7, v8, v9, v10 }[2], [c3] // encoding: [0x67,0xa0,0x20,0x4d]
# CHECK: st4.d	{ v7, v8, v9, v10 }[1], [c3] // encoding: [0x67,0xa4,0x20,0x4d]
# CHECK: st4.b	{ v7, v8, v9, v10 }[13], [c3], x5 // encoding: [0x67,0x34,0xa5,0x4d]
# CHECK: st4.h	{ v7, v8, v9, v10 }[2], [c3], x5 // encoding: [0x67,0x70,0xa5,0x0d]
# CHECK: st4.s	{ v7, v8, v9, v10 }[2], [c3], x5 // encoding: [0x67,0xa0,0xa5,0x4d]
# CHECK: st4.d	{ v7, v8, v9, v10 }[1], [c3], x5 // encoding: [0x67,0xa4,0xa5,0x4d]
# CHECK: st4.b	{ v7, v8, v9, v10 }[13], [c3], #4 // encoding: [0x67,0x34,0xbf,0x4d]
# CHECK: st4.h	{ v7, v8, v9, v10 }[2], [c3], #8 // encoding: [0x67,0x70,0xbf,0x0d]
# CHECK: st4.s	{ v7, v8, v9, v10 }[2], [c3], #16 // encoding: [0x67,0xa0,0xbf,0x4d]
# CHECK: st4.d	{ v7, v8, v9, v10 }[1], [c3], #32 // encoding: [0x67,0xa4,0xbf,0x4d]
