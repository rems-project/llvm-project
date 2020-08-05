// RUN: llvm-mc -triple aarch64-unknown-none-eabi -mattr=+morello -filetype asm -o - %s 2>&1 | FileCheck %s
// RUN: llvm-mc -triple aarch64-unknown-none-eabi -filetype asm -o - %s 2>&1 | FileCheck %s

	.arch armv8-a+a64c
	add 	c1, c0, #1
	ldp     c1, c2, [x0], #16
        adr     x0, #1048575

# CHECK: add 	c1, c0, #1
# CHECK: ldp    c1, c2, [x0], #16
# CHECK: adr    x0, #1048575

	.arch armv8-a+c64

	add 	c1, c0, #1
	ldp     c1, c2, [c0], #16
        adrdp   c0, #0

# CHECK: add 	c1, c0, #1
# CHECK: ldp    c1, c2, [c0], #16
# CHECK: adrdp  c0, #0

	.arch armv8-a+a64c+noc64

	add 	c1, c0, #1
	ldp     c1, c2, [x0], #16
        adr     x0, #1048575

# CHECK: add 	c1, c0, #1
# CHECK: ldp    c1, c2, [x0], #16
# CHECK: adr    x0, #1048575


	.arch armv8-a+noa64c+c64+noa64c+c64

	add 	c1, c0, #1
	ldp     c1, c2, [c0], #16
        adrdp   c0, #0

# CHECK: add 	c1, c0, #1
# CHECK: ldp    c1, c2, [c0], #16
# CHECK: adrdp  c0, #0

	.arch armv8-a+c64+lse

        swpb w2, w3, [csp]
# CHECK: swpb w2, w3, [csp]

	.arch armv8.1-a+c64

        swpb w2, w3, [csp]
# CHECK: swpb w2, w3, [csp]

	.arch morello
	add 	c1, c0, #1
	ldp     c1, c2, [x0], #16
        adr     x0, #1048575

# CHECK: add 	c1, c0, #1
# CHECK: ldp    c1, c2, [x0], #16
# CHECK: adr    x0, #1048575

	.arch morello+c64

	add 	c1, c0, #1
	ldp     c1, c2, [c0], #16
        adrdp   c0, #0

# CHECK: add 	c1, c0, #1
# CHECK: ldp    c1, c2, [c0], #16
# CHECK: adrdp  c0, #0

	.arch morello+noc64

	add 	c1, c0, #1
	ldp     c1, c2, [x0], #16
        adr     x0, #1048575

# CHECK: add 	c1, c0, #1
# CHECK: ldp    c1, c2, [x0], #16
# CHECK: adr    x0, #1048575


	.arch morello+noa64c+c64+noa64c+c64

	add 	c1, c0, #1
	ldp     c1, c2, [c0], #16
        adrdp   c0, #0

# CHECK: add 	c1, c0, #1
# CHECK: ldp    c1, c2, [c0], #16
# CHECK: adrdp  c0, #0

	.arch morello+c64

        swpb w2, w3, [csp]
# CHECK: swpb w2, w3, [csp]

	.arch morello

        swpb w2, w3, [sp]
# CHECK: swpb w2, w3, [sp]
