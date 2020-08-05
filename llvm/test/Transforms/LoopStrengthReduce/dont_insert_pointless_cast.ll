; RUN: opt < %s -loop-reduce -S | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

define i32 @test(i32* %In, i64 %N) {
entry:
  br label %for.preheader

; CHECK-LABEL: for.preheader:
; CHECK-NOT: inttoptr
for.preheader:
  %countup = phi i64 [ 0, %entry ], [ %countup.next, %for.inc ]
  %countdown = phi i64 [ %N, %entry ], [ %countdown.next, %for.inc ]
  %cmp = icmp slt i64 %countup, %N
  br i1 %cmp, label %for.body, label %for.inc

; CHECK-LABEL: for.body:
; CHECK: [[LSR:%[^ ]+]] = phi i32*
; CHECK-NOT: ptrtoint
; CHECK: [[CAST1:%[^ ]+]] = bitcast i32* [[LSR]] to i8*
; CHECK: [[GEP:%[^ ]+]] = getelementptr i8, i8* [[CAST1]]
; CHECK: [[CAST2:%[^ ]+]] = bitcast i8* [[GEP]] to i32*
; CHECK: load i32, i32* [[CAST2]]
for.body:
  %i = phi i64 [ %i.next, %for.body ], [ 0, %for.preheader ]
  %acc.loop = phi i32 [ %add, %for.body ], [ 0, %for.preheader ]
  %off = add i64 %i, %countup
  %arrayidx1 = getelementptr inbounds i32, i32* %In, i64 %i
  %arrayidx2 = getelementptr inbounds i32, i32* %In, i64 %off
  %val1 = load i32, i32* %arrayidx1, align 4
  %val2 = load i32, i32* %arrayidx2, align 4
  %mul = mul i32 %val1, %val2
  %add = add i32 %mul, %acc.loop
  %i.next = add i64 %i, 1
  %exitcond = icmp eq i64 %i.next, %countdown
  br i1 %exitcond, label %for.inc, label %for.body

for.inc:
  %acc = phi i32 [ 0, %for.preheader ], [ %add, %for.body ]
  %countup.next = add i64 %countup, 1
  %countdown.next = add i64 %countdown, -1
  %exitcond36 = icmp eq i64 %countup.next, %N
  br i1 %exitcond36, label %for.end, label %for.preheader

for.end:
  ret i32 %acc
}
