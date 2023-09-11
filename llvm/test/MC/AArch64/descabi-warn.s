# RUN: llvm-mc -triple=aarch64 -mattr=+morello,+c64 -target-abi purecap -cheri-cap-table-abi=fn-desc %s -o /dev/null -filetype=obj 2>&1 | FileCheck %s

  .globl	foo
  .p2align	2
  .type	foo,@function
foo:
.Lfunc_begin:
	mov	c27, c29
	mov	w0, #10
	ret

  .globl	bar
  .p2align	2
  .type	bar,@function
bar:
	ldr	x0, [c0]
	mov	w0, #10
	ret

# CHECK: warning: Function should start with mov c28, c29
# CHECK-NEXT:        mov     c27, c29
# CHECK: warning: Function should start with mov c28, c29
# CHECK-NEXT:        ldr     x0, [c0]
