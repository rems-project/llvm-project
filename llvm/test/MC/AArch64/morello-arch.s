// RUN: llvm-mc -triple aarch64-none-elf < %s -o - | FileCheck %s  --check-prefix=CHECK

.arch morello

  // Test for dotprod
  // CHECK: udot  v0.2s, v1.8b, v2.8b
  udot v0.2s, v1.8b, v2.8b

  // Test for fp-armv8
  // CHECK: fminnm d0, d0, d1
  fminnm d0, d0, d1

  // Test for fullfp16
  // CHECK: fabd v0.4h, v1.4h, v2.4h
  fabd v0.4h, v1.4h, v2.4h

  // Test for spe
  // CHECK: psb csync
  psb csync

  // Test for ssbs
  // CHECK: msr SSBS, x3
  msr SSBS, x3

  // Test for rcpc
  // CHECK: ldaprb w0, [x0]
  ldaprb w0, [x0, #0]

  // Test for crypto
  // CHECK: sha1c q0, s1, v2.4s
  // CHECK: abs  v0.8b, v0.8b
  sha1c.4s q0, s1, v2
  abs.8b  v0, v0

.arch morello+c64

  // Test for dotprod
  // CHECK: udot  v0.2s, v1.8b, v2.8b
  udot v0.2s, v1.8b, v2.8b

  // Test for fp-armv8
  // CHECK: fminnm d0, d0, d1
  fminnm d0, d0, d1

  // Test for fullfp16
  // CHECK: fabd v0.4h, v1.4h, v2.4h
  fabd v0.4h, v1.4h, v2.4h

  // Test for spe
  // CHECK: psb csync
  psb csync

  // Test for ssbs
  // CHECK: msr SSBS, x3
  msr SSBS, x3

  // Test for rcpc
  // CHECK: ldaprb w0, [c0]
  ldaprb w0, [c0, #0]

  // Test for crypto
  // CHECK: sha1c q0, s1, v2.4s
  // CHECK: abs  v0.8b, v0.8b
  sha1c.4s q0, s1, v2
  abs.8b  v0, v0
