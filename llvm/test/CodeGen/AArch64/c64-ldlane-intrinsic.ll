; RUN: llc -march=arm64 -mattr=+c64,+morello -target-abi purecap -verify-machineinstrs -o - %s | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none-unknown-elf"

; CHECK-LABEL: foo
define linkonce_odr dso_local void @foo(i32 addrspace(200)*, i32 addrspace(200)*, i32 addrspace(200)* dereferenceable(4), i32 addrspace(200)* dereferenceable(4), i32 addrspace(200)* dereferenceable(4), i32, i32) addrspace(200) #0 {
entry:
; CHECK: ld2 { v0.s, v1.s }[0], [c0]
; CHECK: ushr v0.8h, v0.8h, #8
  %vld2_lane = tail call { <4 x i32>, <4 x i32> } @llvm.aarch64.neon.ld2lane.v4i32.p200i8(<4 x i32> undef, <4 x i32> undef, i64 0, i8 addrspace(200)* null)
  %vld2_lane.elt = extractvalue { <4 x i32>, <4 x i32> } %vld2_lane, 0
  %.cast = bitcast <4 x i32> %vld2_lane.elt to <8 x i16>
  %vshr_n = lshr <8 x i16> %.cast, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  tail call void @bar(<8 x i16> %vshr_n, <8 x i16> undef)
  ret void
}

declare { <4 x i32>, <4 x i32> } @llvm.aarch64.neon.ld2lane.v4i32.p200i8(<4 x i32>, <4 x i32>, i64, i8 addrspace(200)*) addrspace(200) #1

declare dso_local void @bar(<8 x i16>, <8 x i16>) local_unnamed_addr addrspace(200) #2

attributes #0 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="128" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind readonly }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}

!0 = !{i32 1, !"wchar_size", i32 4}
