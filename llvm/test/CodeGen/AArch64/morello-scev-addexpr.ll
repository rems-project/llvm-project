; RUN: opt -S -loop-reduce -target-abi purecap -march=arm64 -mattr=+c64 -o -  %s | FileCheck %s

target datalayout = "e-m:e-pf200:128:128-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none--elf"

; Expand the integer part of a capability instead of constructing GEPs in the outer loops.
; This avoids the case where the GEPs would clear the tag of the capability.

; CHECK-LABEL: foo
define void @foo(i32 %x, i32 %y, i64 %z, i32 %u, i32 %v, i64 %end) addrspace(200) {
entry:
; CHECK: [[CALL:%.*]] = call double addrspace(200)* @bar()
; CHECK: [[BCALL:%.*]] = bitcast double addrspace(200)* [[CALL]] to i8 addrspace(200)*
; CHECK: [[GEP_OFFSET:%.*]] = shl i64 %z, 3
  %call68 = call double addrspace(200)* @bar()
  %0 = sext i32 %x to i64
  br label %for.cond930.preheader.us.us

for.cond930.preheader.us.us:
; CHECK: [[UGLYGEP:%.*]] = getelementptr i8, i8 addrspace(200)* [[BCALL]], i64 {{.*}} 
; CHECK: [[UGLYGEP2:%.*]] = bitcast i8 addrspace(200)* [[UGLYGEP]] to double addrspace(200)*
  %iA.11463.us.us = phi i32 [ %add960.us.us, %for.cond930.for.end_crit_edge.us.us ], [ %y, %entry ]
  %1 = sext i32 %iA.11463.us.us to i64
  br label %for.body932.us.us

for.cond930.for.end_crit_edge.us.us:
  %add960.us.us = add nsw i32 %u, %v
  br label %for.cond930.preheader.us.us

for.body932.us.us:
; CHECK: [[PHIGEP:%.*]] = phi double addrspace(200)* [ {{%.*}}, %for.body932.us.us ], [ [[UGLYGEP2]], %for.cond930.preheader.us.us ]
; CHECK: [[BC_PHIGEP:%.*]] = bitcast double addrspace(200)* [[PHIGEP]] to i1 addrspace(200)*
; CHECK: {{%.*}} = load double, double addrspace(200)* [[PHIGEP]] 
; CHECK: getelementptr i1, i1 addrspace(200)* [[BC_PHIGEP]], i64 [[GEP_OFFSET]] 
  %indvars.iv1537 = phi i64 [ %indvars.iv.next1538, %for.body932.us.us ], [ %1, %for.cond930.preheader.us.us ]
  %2 = sub nsw i64 %indvars.iv1537, %0
  %arrayidx940.us.us = getelementptr inbounds double, double addrspace(200)* %call68, i64 %2
  %3 = load double, double addrspace(200)* %arrayidx940.us.us, align 8
  %indvars.iv.next1538 = add i64 %indvars.iv1537, %z
  %cmp = icmp eq i64 %indvars.iv.next1538, %end
  br i1 %cmp, label %for.cond930.for.end_crit_edge.us.us, label %for.body932.us.us
}

declare double addrspace(200)* @bar() addrspace(200)
