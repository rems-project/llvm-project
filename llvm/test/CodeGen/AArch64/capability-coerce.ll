; RUN: opt -S -gvn -o - %s | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none-unknown-elf"

%class.i = type { i8 }
%class.a.0 = type { fp128 }
%struct.A = type { i8 }


; GVN shouldn't try to coerce a fat pointer to a capability or the other way around.

; CHECK-LABEL: foo
define dso_local void @foo(i64 %h.coerce, [1 x fp128] %g.coerce) local_unnamed_addr addrspace(200) #0 {
entry:
; CHECK: store fp128
; CHECK: load i8 addrspace(200)*
; CHECK: store i8 addrspace(200)*
  %ref.tmp.i = alloca %class.a.0, align 16, addrspace(200)
  %g.sroa.0 = alloca fp128, align 16, addrspace(200)
  %g.coerce.fca.0.extract = extractvalue [1 x fp128] %g.coerce, 0
  store fp128 %g.coerce.fca.0.extract, fp128 addrspace(200)* %g.sroa.0, align 16
  %0 = bitcast %class.a.0 addrspace(200)* %ref.tmp.i to i8 addrspace(200)*
  %1 = bitcast %class.a.0 addrspace(200)* %ref.tmp.i to i8 addrspace(200)* addrspace(200)*
  %g.sroa.0.0..sroa_cast3 = bitcast fp128 addrspace(200)* %g.sroa.0 to i8 addrspace(200)* addrspace(200)*
  %2 = bitcast fp128 %g.coerce.fca.0.extract to i128
  %g.sroa.0.0.g.sroa.0.0. = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %g.sroa.0.0..sroa_cast3, align 16, !tbaa !2
  store i8 addrspace(200)* %g.sroa.0.0.g.sroa.0.0., i8 addrspace(200)* addrspace(200)* %1, align 16, !tbaa !2
  ret void
}

attributes #0 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+c64,+neon" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+c64,+neon" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0}

!0 = !{i32 1, !"wchar_size", i32 4}
!2 = !{!3, !3, i64 0}
!3 = !{!"long double", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C++ TBAA"}
