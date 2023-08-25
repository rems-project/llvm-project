// RUN: llvm-mc -triple aarch64-unknown-none-eabi -mattr=+morello -filetype asm -o - %s 2>&1 | FileCheck %s
// RUN: llvm-mc -triple aarch64-unknown-none-eabi -filetype asm -o - %s 2>&1 | FileCheck %s

  .arch armv8-a+a64c
  add   c1, c0, #1
  ldp   c1, c2, [x0], #16
  adr   x0, #1048575

# CHECK: add  c1, c0, #1
# CHECK: ldp  c1, c2, [x0], #16
# CHECK: adr  x0, #1048575

  .code c64

  add   c1, c0, #1
  ldp   c1, c2, [c0], #16
  adrdp c0, #0

# CHECK: add   c1, c0, #1
# CHECK: ldp   c1, c2, [c0], #16
# CHECK: adrdp c0, #0

  .code a64
  .arch armv8-a+a64c

  add     c1, c0, #1
  ldp     c1, c2, [x0], #16
  adr     x0, #1048575

# CHECK: add  c1, c0, #1
# CHECK: ldp  c1, c2, [x0], #16
# CHECK: adr  x0, #1048575

  .code c64
  add     c1, c0, #1
  ldp     c1, c2, [c0], #16
  adrdp   c0, #0

# CHECK: add   c1, c0, #1
# CHECK: ldp   c1, c2, [c0], #16
# CHECK: adrdp c0, #0

  .code a64
  .arch armv8-a+a64c+lse
  .code c64

  swpb w2, w3, [csp]
# CHECK: swpb w2, w3, [csp]

  .code c64

  swpb w2, w3, [csp]
# CHECK: swpb w2, w3, [csp]

  .code a64
  add   c1, c0, #1
  ldp   c1, c2, [x0], #16
  adr   x0, #1048575

# CHECK: add  c1, c0, #1
# CHECK: ldp    c1, c2, [x0], #16
# CHECK: adr    x0, #1048575

  .code c64

  add     c1, c0, #1
  ldp     c1, c2, [c0], #16
  adrdp   c0, #0

# CHECK: add   c1, c0, #1
# CHECK: ldp   c1, c2, [c0], #16
# CHECK: adrdp c0, #0

  .code a64

  add     c1, c0, #1
  ldp     c1, c2, [x0], #16
  adr     x0, #1048575

# CHECK: add    c1, c0, #1
# CHECK: ldp    c1, c2, [x0], #16
# CHECK: adr    x0, #1048575

  .code c64

  add     c1, c0, #1
  ldp     c1, c2, [c0], #16
  adrdp   c0, #0

# CHECK: add   c1, c0, #1
# CHECK: ldp   c1, c2, [c0], #16
# CHECK: adrdp c0, #0

  swpb w2, w3, [csp]
# CHECK: swpb w2, w3, [csp]

  .code a64

  swpb w2, w3, [sp]
# CHECK: swpb w2, w3, [sp]
