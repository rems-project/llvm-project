; RUN: llc -march=arm64 -mattr=+c64,-use-16-cap-regs,+morello -target-abi purecap -O0 -o - %s | FileCheck %s --check-prefix=CHECK-32-CAP-REGS
; RUN: llc -march=arm64 -mattr=+c64,+use-16-cap-regs,+morello -target-abi purecap -O0 -o - %s | FileCheck %s --check-prefix=CHECK-16-CAP-REGS

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-arm-none-eabi"

%struct.Node = type { i32, %struct.Node addrspace(200)*, %struct.Node addrspace(200)* }

$_Z3fooIiEvU3capP4NodeIT_ES3_S1_ = comdat any

; ------
; Make sure that the capability registers C8-C23 are not
; used in codegen when +use-16-cap-regs is specified.
; ------

; CHECK-LABEL: _Z3fooIiEvU3capP4NodeIT_ES3_S1_

define weak_odr dso_local void @_Z3fooIiEvU3capP4NodeIT_ES3_S1_(%struct.Node addrspace(200)* %head, %struct.Node addrspace(200)* %tail, i32 %data) addrspace(200) #0 comdat {
entry:

; CHECK-32-CAP-REGS: str c10, [csp, #16]
; CHECK-16-CAP-REGS: str c26, [csp, #16]
; CHECK-16-CAP-REGS-NOT: c([8,9]|1[0-9]|2[0-3])

  %head.addr = alloca %struct.Node addrspace(200)*, align 16, addrspace(200)
  %tail.addr = alloca %struct.Node addrspace(200)*, align 16, addrspace(200)
  %data.addr = alloca i32, align 4, addrspace(200)
  %fwd = alloca %struct.Node addrspace(200)*, align 16, addrspace(200)
  %bwd = alloca %struct.Node addrspace(200)*, align 16, addrspace(200)
  store %struct.Node addrspace(200)* %head, %struct.Node addrspace(200)* addrspace(200)* %head.addr, align 16
  store %struct.Node addrspace(200)* %tail, %struct.Node addrspace(200)* addrspace(200)* %tail.addr, align 16
  store i32 %data, i32 addrspace(200)* %data.addr, align 4
  %0 = load %struct.Node addrspace(200)*, %struct.Node addrspace(200)* addrspace(200)* %head.addr, align 16
  store %struct.Node addrspace(200)* %0, %struct.Node addrspace(200)* addrspace(200)* %fwd, align 16
  %1 = load %struct.Node addrspace(200)*, %struct.Node addrspace(200)* addrspace(200)* %tail.addr, align 16
  store %struct.Node addrspace(200)* %1, %struct.Node addrspace(200)* addrspace(200)* %bwd, align 16
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %2 = load %struct.Node addrspace(200)*, %struct.Node addrspace(200)* addrspace(200)* %fwd, align 16
  %tobool = icmp ne %struct.Node addrspace(200)* %2, null
  br i1 %tobool, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %while.cond
  %3 = load %struct.Node addrspace(200)*, %struct.Node addrspace(200)* addrspace(200)* %bwd, align 16
  %tobool1 = icmp ne %struct.Node addrspace(200)* %3, null
  br label %land.end

land.end:                                         ; preds = %land.rhs, %while.cond
  %4 = phi i1 [ false, %while.cond ], [ %tobool1, %land.rhs ]
  br i1 %4, label %while.body, label %while.end

while.body:                                       ; preds = %land.end
  %5 = load i32, i32 addrspace(200)* %data.addr, align 4
  %6 = load %struct.Node addrspace(200)*, %struct.Node addrspace(200)* addrspace(200)* %fwd, align 16
  %data2 = getelementptr inbounds %struct.Node, %struct.Node addrspace(200)* %6, i32 0, i32 0
  store i32 %5, i32 addrspace(200)* %data2, align 16
  %7 = load i32, i32 addrspace(200)* %data.addr, align 4
  %8 = load %struct.Node addrspace(200)*, %struct.Node addrspace(200)* addrspace(200)* %bwd, align 16
  %data3 = getelementptr inbounds %struct.Node, %struct.Node addrspace(200)* %8, i32 0, i32 0
  store i32 %7, i32 addrspace(200)* %data3, align 16
  %9 = load %struct.Node addrspace(200)*, %struct.Node addrspace(200)* addrspace(200)* %fwd, align 16
  %next = getelementptr inbounds %struct.Node, %struct.Node addrspace(200)* %9, i32 0, i32 1
  %10 = load %struct.Node addrspace(200)*, %struct.Node addrspace(200)* addrspace(200)* %next, align 16
  store %struct.Node addrspace(200)* %10, %struct.Node addrspace(200)* addrspace(200)* %fwd, align 16
  %11 = load %struct.Node addrspace(200)*, %struct.Node addrspace(200)* addrspace(200)* %bwd, align 16
  %prev = getelementptr inbounds %struct.Node, %struct.Node addrspace(200)* %11, i32 0, i32 2
  %12 = load %struct.Node addrspace(200)*, %struct.Node addrspace(200)* addrspace(200)* %prev, align 16
  store %struct.Node addrspace(200)* %12, %struct.Node addrspace(200)* addrspace(200)* %bwd, align 16
  br label %while.cond

while.end:                                        ; preds = %land.end
  ret void
}

attributes #0 = { noinline nounwind optnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}

!0 = !{i32 1, !"wchar_size", i32 4}
