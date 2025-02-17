; RUN: opt --basic-aa --loop-idiom < %s -S | FileCheck %s
target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64"

%struct.foo = type { i32, i32 }
%struct.foo1 = type { i32, i32, i32 }
%struct.foo2 = type { i32, i16, i16 }

;void bar1(foo_t *f, unsigned n) {
;  for (unsigned i = 0; i < n; ++i) {
;    f[i].a = 0;
;    f[i].b = 0;
;  }
;}
define void @bar1(%struct.foo addrspace(200)* %f, i32 %n) nounwind ssp {
entry:
  %cmp1 = icmp eq i32 %n, 0
  br i1 %cmp1, label %for.end, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %a = getelementptr inbounds %struct.foo, %struct.foo addrspace(200)* %f, i64 %indvars.iv, i32 0
  store i32 0, i32 addrspace(200)* %a, align 4
  %b = getelementptr inbounds %struct.foo, %struct.foo addrspace(200)* %f, i64 %indvars.iv, i32 1
  store i32 0, i32 addrspace(200)* %b, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32
  %exitcond = icmp ne i32 %lftr.wideiv, %n
  br i1 %exitcond, label %for.body, label %for.end.loopexit

for.end.loopexit:                                 ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  ret void
; CHECK-LABEL: @bar1(
; CHECK: call void @llvm.memset
; CHECK-NOT: store
}

;void bar2(foo_t *f, unsigned n) {
;  for (unsigned i = 0; i < n; ++i) {
;    f[i].b = 0;
;    f[i].a = 0;
;  }
;}
define void @bar2(%struct.foo addrspace(200)* %f, i32 %n) nounwind ssp {
entry:
  %cmp1 = icmp eq i32 %n, 0
  br i1 %cmp1, label %for.end, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %b = getelementptr inbounds %struct.foo, %struct.foo addrspace(200)* %f, i64 %indvars.iv, i32 1
  store i32 0, i32 addrspace(200)* %b, align 4
  %a = getelementptr inbounds %struct.foo, %struct.foo addrspace(200)* %f, i64 %indvars.iv, i32 0
  store i32 0, i32 addrspace(200)* %a, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32
  %exitcond = icmp ne i32 %lftr.wideiv, %n
  br i1 %exitcond, label %for.body, label %for.end.loopexit

for.end.loopexit:                                 ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  ret void
; CHECK-LABEL: @bar2(
; CHECK: call void @llvm.memset
; CHECK-NOT: store
}

;void bar3(foo_t *f, unsigned n) {
;  for (unsigned i = n; i > 0; --i) {
;    f[i].a = 0;
;    f[i].b = 0;
;  }
;}
define void @bar3(%struct.foo addrspace(200)* nocapture %f, i32 %n) nounwind ssp {
entry:
  %cmp1 = icmp eq i32 %n, 0
  br i1 %cmp1, label %for.end, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  %0 = zext i32 %n to i64
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ %0, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %a = getelementptr inbounds %struct.foo, %struct.foo addrspace(200)* %f, i64 %indvars.iv, i32 0
  store i32 0, i32 addrspace(200)* %a, align 4
  %b = getelementptr inbounds %struct.foo, %struct.foo addrspace(200)* %f, i64 %indvars.iv, i32 1
  store i32 0, i32 addrspace(200)* %b, align 4
  %1 = trunc i64 %indvars.iv to i32
  %dec = add i32 %1, -1
  %cmp = icmp eq i32 %dec, 0
  %indvars.iv.next = add nsw i64 %indvars.iv, -1
  br i1 %cmp, label %for.end.loopexit, label %for.body

for.end.loopexit:                                 ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  ret void
; CHECK-LABEL: @bar3(
; CHECK: call void @llvm.memset
; CHECK-NOT: store
}

;void bar4(foo_t *f, unsigned n) {
;  for (unsigned i = 0; i < n; ++i) {
;    f[i].a = 0;
;    f[i].b = 1;
;  }
;}
define void @bar4(%struct.foo addrspace(200)* nocapture %f, i32 %n) nounwind ssp {
entry:
  %cmp1 = icmp eq i32 %n, 0
  br i1 %cmp1, label %for.end, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %a = getelementptr inbounds %struct.foo, %struct.foo addrspace(200)* %f, i64 %indvars.iv, i32 0
  store i32 0, i32 addrspace(200)* %a, align 4
  %b = getelementptr inbounds %struct.foo, %struct.foo addrspace(200)* %f, i64 %indvars.iv, i32 1
  store i32 1, i32 addrspace(200)* %b, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32
  %exitcond = icmp ne i32 %lftr.wideiv, %n
  br i1 %exitcond, label %for.body, label %for.end.loopexit

for.end.loopexit:                                 ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  ret void
; CHECK-LABEL: @bar4(
; CHECK-NOT: call void @llvm.memset
}

;void bar5(foo1_t *f, unsigned n) {
;  for (unsigned i = 0; i < n; ++i) {
;    f[i].a = 0;
;    f[i].b = 0;
;  }
;}
define void @bar5(%struct.foo1* nocapture %f, i32 %n) nounwind ssp {
entry:
  %cmp1 = icmp eq i32 %n, 0
  br i1 %cmp1, label %for.end, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %a = getelementptr inbounds %struct.foo1, %struct.foo1* %f, i64 %indvars.iv, i32 0
  store i32 0, i32* %a, align 4
  %b = getelementptr inbounds %struct.foo1, %struct.foo1* %f, i64 %indvars.iv, i32 1
  store i32 0, i32* %b, align 4
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32
  %exitcond = icmp ne i32 %lftr.wideiv, %n
  br i1 %exitcond, label %for.body, label %for.end.loopexit

for.end.loopexit:                                 ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  ret void
; CHECK-LABEL: @bar5(
; CHECK-NOT: call void @llvm.memset 
}

;void bar6(foo2_t *f, unsigned n) {
;  for (unsigned i = 0; i < n; ++i) {
;    f[i].a = 0;
;    f[i].b = 0;
;    f[i].c = 0;
;  }
;}
define void @bar6(%struct.foo2* nocapture %f, i32 %n) nounwind ssp {
entry:
  %cmp1 = icmp eq i32 %n, 0
  br i1 %cmp1, label %for.end, label %for.body.preheader

for.body.preheader:                               ; preds = %entry
  br label %for.body

for.body:                                         ; preds = %for.body.preheader, %for.body
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %a = getelementptr inbounds %struct.foo2, %struct.foo2* %f, i64 %indvars.iv, i32 0
  store i32 0, i32* %a, align 4
  %b = getelementptr inbounds %struct.foo2, %struct.foo2* %f, i64 %indvars.iv, i32 1
  store i16 0, i16* %b, align 4
  %c = getelementptr inbounds %struct.foo2, %struct.foo2* %f, i64 %indvars.iv, i32 2
  store i16 0, i16* %c, align 2
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %lftr.wideiv = trunc i64 %indvars.iv.next to i32
  %exitcond = icmp ne i32 %lftr.wideiv, %n
  br i1 %exitcond, label %for.body, label %for.end.loopexit

for.end.loopexit:                                 ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.end.loopexit, %entry
  ret void
; CHECK-LABEL: @bar6(
; CHECK: call void @llvm.memset
; CHECK-NOT: store
}
