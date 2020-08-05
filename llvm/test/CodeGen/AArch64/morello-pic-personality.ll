; RUN: llc -march=arm64 -mattr=+c64,+morello -target-abi purecap --relocation-model=pic -o - %s | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-unknown-freebsd"

%class.a = type { i8 }
%class.c = type { i8 }

@d = addrspace(200) global i32 0, align 4
@_ZN1a1bE = external addrspace(200) global %class.a, align 1

; Function Attrs: noinline optnone
define void @_Z3fn1v() addrspace(200) #0 personality i8 addrspace(200)* bitcast (i32 (...) addrspace(200)* @__gxx_personality_v0 to i8 addrspace(200)*) {
entry:
  %agg.tmp = alloca %class.a, align 1, addrspace(200)
  %exn.slot = alloca i8 addrspace(200)*, addrspace(200)
  %ehselector.slot = alloca i32, addrspace(200)
  %call = call i8 addrspace(200)* @_Znwm(i64 1) #4
  %0 = bitcast i8 addrspace(200)* %call to %class.c addrspace(200)*
  %coerce.dive = getelementptr inbounds %class.a, %class.a addrspace(200)* %agg.tmp, i32 0, i32 0
  %1 = load i8, i8 addrspace(200)* %coerce.dive, align 1
  invoke void @_ZN1cC1EU3capPi1a(%class.c addrspace(200)* %0, i32 addrspace(200)* @d, i8 %1)
          to label %invoke.cont unwind label %lpad

invoke.cont:                                      ; preds = %entry
  ret void

lpad:                                             ; preds = %entry
  %2 = landingpad { i8 addrspace(200)*, i32 }
          cleanup
  %3 = extractvalue { i8 addrspace(200)*, i32 } %2, 0
  store i8 addrspace(200)* %3, i8 addrspace(200)* addrspace(200)* %exn.slot, align 16
  %4 = extractvalue { i8 addrspace(200)*, i32 } %2, 1
  store i32 %4, i32 addrspace(200)* %ehselector.slot, align 4
  call void @_ZdlU3capPv(i8 addrspace(200)* %call) #5
  br label %eh.resume

eh.resume:                                        ; preds = %lpad
  %exn = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %exn.slot, align 16
  %sel = load i32, i32 addrspace(200)* %ehselector.slot, align 4
  %lpad.val = insertvalue { i8 addrspace(200)*, i32 } undef, i8 addrspace(200)* %exn, 0
  %lpad.val1 = insertvalue { i8 addrspace(200)*, i32 } %lpad.val, i32 %sel, 1
  resume { i8 addrspace(200)*, i32 } %lpad.val1
}

; Function Attrs: nobuiltin
declare noalias i8 addrspace(200)* @_Znwm(i64) addrspace(200) #1

declare void @_ZN1cC1EU3capPi1a(%class.c addrspace(200)*, i32 addrspace(200)*, i8) unnamed_addr addrspace(200) #2

declare i32 @__gxx_personality_v0(...) addrspace(200)

; Function Attrs: nobuiltin nounwind
declare void @_ZdlU3capPv(i8 addrspace(200)*) addrspace(200) #3

attributes #0 = { noinline optnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nobuiltin "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nobuiltin nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { builtin }
attributes #5 = { builtin nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 1, !"wchar_size", i32 4}

; CHECK: DW.ref.__gxx_personality_v0:
; CHECK-NEXT: .capinit __gxx_personality_v0
; CHECK-NEXT: .xword 0
; CHECK-NEXT: .xword 0
