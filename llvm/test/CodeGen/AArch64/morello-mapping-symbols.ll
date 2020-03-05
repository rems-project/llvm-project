; RUN: llc < %s -mtriple=aarch64-none-elf -filetype=obj -function-sections | \
; RUN:   llvm-objdump -t - | FileCheck %s

; Check that mapping symbol "$c" is used for functions with "+c64" and "$x"
; for other code.

define void @c64_fn() #0 {
; CHECK: 0000000000000000 l        .text.c64_fn            0000000000000000 $c.0
  ret void
}

define void @c64_fn2() #1 {
; CHECK: 0000000000000000 l        .text.c64_fn2           0000000000000000 $c.1
  ret void
}

define void @a64_fn() #2 {
; CHECK: 0000000000000000 l        .text.a64_fn            0000000000000000 $x.2
  ret void
}

define void @a64c_fn() #3 {
; CHECK: 0000000000000000 l        .text.a64c_fn           0000000000000000 $x.3
  ret void
}

attributes #0 = { "target-cpu"="generic" "target-features"="+c64" }
attributes #1 = { "target-cpu"="generic" "target-features"="+c64" }
attributes #2 = { "target-cpu"="generic" "target-features"="" }
attributes #3 = { "target-cpu"="generic" "target-features"="+morello" }
