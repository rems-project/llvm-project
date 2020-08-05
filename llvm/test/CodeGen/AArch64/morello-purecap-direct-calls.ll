; RUN: llc -mtriple=aarch64-none-elf -mattr=+c64,+morello -target-abi purecap -o - %s | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none--elf"

; Since functions are capabilities in the pure ABI, we have custom instruction selection
; for returning via tail calls and branch and link calls.


define dso_local i32 @bar(i32 %x, i32 %y) local_unnamed_addr addrspace(200) #0 {
entry:
; CHECK-LABEL: bar
; CHECK: b foo
  %call = tail call i32 @foo(i32 %y, i32 %x) #2
  ret i32 %call
}

declare dso_local i32 @foo(i32, i32) local_unnamed_addr addrspace(200) #1

define dso_local i32 @baz(i32 %x, i32 %y) local_unnamed_addr addrspace(200) #0 {
entry:
; CHECK-LABEL: baz
; CHECK: bl bar
  %call = tail call i32 @bar(i32 %x, i32 %y)
  %add = add nsw i32 %call, 3
  ret i32 %add
}

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic"  "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind }
