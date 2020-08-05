; RUN: llc -march=arm64 < %s -mattr=+c64,+morello -target-abi purecap -o - | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none--elf"

; This shold create one global constant pointing to baz. We also shouldn't create a global constant pointing
; to a, since a can be accessed via the GOT.

@a = common dso_local local_unnamed_addr addrspace(200) global [20 x i32] zeroinitializer, align 4
@unused = internal local_unnamed_addr addrspace(200) global [20 x i32] zeroinitializer, align 4
@used_constoff = internal local_unnamed_addr addrspace(200) global [20 x i32] zeroinitializer, align 4

; CHECK-LABEL: bar0:
define dso_local i8 addrspace(200)* @bar0(i32 %x, i32 %y) local_unnamed_addr addrspace(200) #0 {
entry:
; CHECK: adrp {{c|x}}0, .L__cap_baz
; CHECK-NEXT: ldr c0, [c0, :lo12:.L__cap_baz]
  %idxprom = sext i32 %x to i64
  %arrayidx = getelementptr inbounds [20 x i32], [20 x i32] addrspace(200)* @a, i64 0, i64 %idxprom
  %0 = load i32, i32 addrspace(200)* %arrayidx, align 4, !tbaa !2
  %inc = add nsw i32 %0, 1
  store i32 %inc, i32 addrspace(200)* %arrayidx, align 4, !tbaa !2
  ret i8 addrspace(200)* bitcast (i8 addrspace(200)* (i32, i32) addrspace(200)* @baz to i8 addrspace(200)*)
}

; CHECK-LABEL: baz:
define internal i8 addrspace(200)* @baz(i32 %x, i32 %y) addrspace(200) #0 {
entry:
; CHECK: adrp {{c|x}}0, .L__cap_baz
; CHECK-NEXT: ldr c0, [c0, :lo12:.L__cap_baz]
  %idxprom.i = sext i32 %x to i64
  %arrayidx.i = getelementptr inbounds [20 x i32], [20 x i32] addrspace(200)* @a, i64 0, i64 %idxprom.i
  %0 = load i32, i32 addrspace(200)* %arrayidx.i, align 4, !tbaa !2
  %inc.i = add nsw i32 %0, 1
  store i32 %inc.i, i32 addrspace(200)* %arrayidx.i, align 4, !tbaa !2
  ret i8 addrspace(200)* bitcast (i8 addrspace(200)* (i32, i32) addrspace(200)* @baz to i8 addrspace(200)*)
}

; CHECK-LABEL: bar1:
define dso_local i8 addrspace(200)* @bar1(i32 %x, i32 %y) local_unnamed_addr addrspace(200) #0 {
entry:
; CHECK: adrp {{c|x}}0, .L__cap_baz
; CHECK-NEXT: ldr c0, [c0, :lo12:.L__cap_baz]
  %idxprom = sext i32 %y to i64
  %arrayidx = getelementptr inbounds [20 x i32], [20 x i32] addrspace(200)* @a, i64 0, i64 %idxprom
  %0 = load i32, i32 addrspace(200)* %arrayidx, align 4, !tbaa !2
  %add = add nsw i32 %0, 2
  store i32 %add, i32 addrspace(200)* %arrayidx, align 4, !tbaa !2
  ret i8 addrspace(200)* bitcast (i8 addrspace(200)* (i32, i32) addrspace(200)* @baz to i8 addrspace(200)*)
}

; CHECK-LABEL: coff:
define dso_local void  @coff(i32 %x, i32 %y) local_unnamed_addr addrspace(200) #0 {
entry:
; CHECK: adrp {{c|x}}0, .L__cap_used_constoff
; CHECK-NEXT: ldr c0, [c0, :lo12:.L__cap_used_constoff]
  %idxprom = sext i32 %y to i64
  %0 = load i32, i32 addrspace(200)* getelementptr inbounds ([20 x i32], [20 x i32] addrspace(200)* @used_constoff, i64 0, i64 1)
  %add = add nsw i32 %0, 2
  store i32 %add, i32 addrspace(200)* getelementptr inbounds ([20 x i32], [20 x i32] addrspace(200)* @used_constoff, i64 0, i64 1)
  ret void
}

; CHECK-LABEL: fun:
define dso_local i32 @fun() local_unnamed_addr addrspace(200) #1 {
entry:
  %0 = load i32, i32 addrspace(200)* getelementptr inbounds ([20 x i32], [20 x i32] addrspace(200)* @a, i64 0, i64 0), align 4, !tbaa !2
  ret i32 %0
}

; CHECK-LABEL-NOT: .L__cap_unused:
; CHECK-LABEL-NOT: .L__cap_a:
; CHECK-LABEL:.L__cap_used_constoff:
; CHECK-NEXT: .capinit used_constoff
; CHECK-LABEL: .L__cap_baz:
; CHECK-NEXT: .capinit baz

attributes #0 = { norecurse nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { norecurse nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="generic" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}

!0 = !{i32 1, !"wchar_size", i32 4}
!2 = !{!3, !3, i64 0}
!3 = !{!"int", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
