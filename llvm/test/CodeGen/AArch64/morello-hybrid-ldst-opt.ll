; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+morello -aarch64-enable-atomic-cfg-tidy=0 -disable-lsr -verify-machineinstrs -mcpu=rainier -o - %s | FileCheck --check-prefix=CHECK %s

; This file contains tests for the AArch64 load/store optimizer, based on ldst-opt.ll.
target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

%padding = type { i8*, i8*, i8*, i8* }
%s.byte = type { i8, i8 }
%s.halfword = type { i16, i16 }
%s.word = type { i32, i32 }
%s.doubleword = type { i64, i32 }
%s.quadword = type { fp128, i32 }
%s.float = type { float, i32 }
%s.double = type { double, i32 }
%s.capability = type { i8 addrspace(200)*, i32 }
%struct.byte = type { %padding, %s.byte }
%struct.halfword = type { %padding, %s.halfword }
%struct.word = type { %padding, %s.word }
%struct.doubleword = type { %padding, %s.doubleword }
%struct.quadword = type { %padding, %s.quadword }
%struct.float = type { %padding, %s.float }
%struct.double = type { %padding, %s.double }
%struct.capability = type { %padding, %s.capability }

; Check the following transform:
;
; (ldr|str) X, [x0, #32]
;  ...
; add x0, x0, #32
;  ->
; (ldr|str) X, [x0, #32]!
;
; with X being either w1, x1, s0, d0 or q0.

declare void @bar_capability(%s.capability*, i8 addrspace(200)*)

define void @load-pre-indexed-capability(%struct.capability* %ptr) nounwind {
; CHECK-LABEL: load-pre-indexed-capability
; CHECK: ldr c{{[0-9]+}}, [x{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.capability, %struct.capability* %ptr, i64 0, i32 1, i32 0
  %add = load i8 addrspace(200)*, i8 addrspace(200)** %a, align 16
  br label %bar
bar:
  %c = getelementptr inbounds %struct.capability, %struct.capability* %ptr, i64 0, i32 1
  tail call void @bar_capability(%s.capability* %c, i8 addrspace(200)* %add)
  ret void
}

define void @store-pre-indexed-capability(%struct.capability* %ptr, i8 addrspace(200)* %val) nounwind {
; CHECK-LABEL: store-pre-indexed-capability
; CHECK: str c{{[0-9]+}}, [x{{[0-9]+}}, #32]!
entry:
  %a = getelementptr inbounds %struct.capability, %struct.capability* %ptr, i64 0, i32 1, i32 0
  store i8 addrspace(200)* %val, i8 addrspace(200)** %a, align 16
  br label %bar
bar:
  %c = getelementptr inbounds %struct.capability, %struct.capability* %ptr, i64 0, i32 1
  tail call void @bar_capability(%s.capability* %c, i8 addrspace(200)* %val)
  ret void
}

; Check the following transform:
;
; add x8, x8, #16
;  ...
; ldr X, [x8]
;  ->
; ldr X, [x8, #16]
;
; with X being either w0, x0, s0, d0 or q0.

%pre.struct.i32 = type { i32, i32, i32, i32, i32}
%pre.struct.i64 = type { i32, i64, i64, i64, i64}
%pre.struct.i128 = type { i32, <2 x i64>, <2 x i64>, <2 x i64>}
%pre.struct.float = type { i32, float, float, float}
%pre.struct.double = type { i32, double, double, double}
%pre.struct.capability = type { i32, i8 addrspace(200)*, i8 addrspace(200)*, i8 addrspace(200)*}

define i8 addrspace(200)* @load-pre-indexed-capability2(%pre.struct.capability** %this, i1 %cond,
                                                        %pre.struct.capability* %load2) nounwind {
; CHECK-LABEL: load-pre-indexed-capability2
; CHECK: ldr c{{[0-9]+}}, [x{{[0-9]+}}, #16]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.capability*, %pre.struct.capability** %this
  %gep1 = getelementptr inbounds %pre.struct.capability, %pre.struct.capability* %load1, i64 0, i32 1
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.capability, %pre.struct.capability* %load2, i64 0, i32 2
  br label %return
return:
  %retptr = phi i8 addrspace(200)** [ %gep1, %if.then ], [ %gep2, %if.end ]
  %ret = load i8 addrspace(200)*, i8 addrspace(200)** %retptr
  ret i8 addrspace(200)* %ret
}

define i8 addrspace(200)* @load-pre-indexed-capability3(%pre.struct.capability** %this, i1 %cond,
                                                        %pre.struct.capability* %load2) nounwind {
; CHECK-LABEL: load-pre-indexed-capability3
; CHECK: ldr c{{[0-9]+}}, [x{{[0-9]+}}, #32]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.capability*, %pre.struct.capability** %this
  %gep1 = getelementptr inbounds %pre.struct.capability, %pre.struct.capability* %load1, i64 0, i32 2
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.capability, %pre.struct.capability* %load2, i64 0, i32 3
  br label %return
return:
  %retptr = phi i8 addrspace(200)** [ %gep1, %if.then ], [ %gep2, %if.end ]
  %ret = load i8 addrspace(200)*, i8 addrspace(200)** %retptr
  ret i8 addrspace(200)* %ret
}

; Check the following transform:
;
; add x8, x8, #16
;  ...
; str X, [x8]
;  ->
; str X, [x8, #16]
;
; with X being either w0, x0, s0, d0 or q0.

define void @store-pre-indexed-capability2(%pre.struct.capability** %this, i1 %cond,
                                           %pre.struct.capability* %load2,
                                           i8 addrspace(200)* %val) nounwind {
; CHECK-LABEL: store-pre-indexed-capability2
; CHECK: str c{{[0-9]+}}, [x{{[0-9]+}}, #16]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.capability*, %pre.struct.capability** %this
  %gep1 = getelementptr inbounds %pre.struct.capability, %pre.struct.capability* %load1, i64 0, i32 1
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.capability, %pre.struct.capability* %load2, i64 0, i32 2
  br label %return
return:
  %retptr = phi i8 addrspace(200)** [ %gep1, %if.then ], [ %gep2, %if.end ]
  store i8 addrspace(200)* %val, i8 addrspace(200)** %retptr
  ret void
}

define void @store-pre-indexed-capability3(%pre.struct.capability** %this, i1 %cond,
                                           %pre.struct.capability* %load2,
                                           i8 addrspace(200)* %val) nounwind {
; CHECK-LABEL: store-pre-indexed-capability3
; CHECK: str c{{[0-9]+}}, [x{{[0-9]+}}, #32]
  br i1 %cond, label %if.then, label %if.end
if.then:
  %load1 = load %pre.struct.capability*, %pre.struct.capability** %this
  %gep1 = getelementptr inbounds %pre.struct.capability, %pre.struct.capability* %load1, i64 0, i32 2
  br label %return
if.end:
  %gep2 = getelementptr inbounds %pre.struct.capability, %pre.struct.capability* %load2, i64 0, i32 3
  br label %return
return:
  %retptr = phi i8 addrspace(200)** [ %gep1, %if.then ], [ %gep2, %if.end ]
  store i8 addrspace(200)* %val, i8 addrspace(200)** %retptr
  ret void
}

; Check the following transform:
;
; ldr X, [x20]
;  ...
; add x20, x20, #32
;  ->
; ldr X, [x20], #32
;
; with X being either w0, x0, s0, d0 or q0.

define void @load-post-indexed-capability(i8 addrspace(200)** %array, i64 %count) nounwind {
; CHECK-LABEL: load-post-indexed-capability
; CHECK: ldr c{{[0-9]+}}, [x{{[0-9]+}}], #64
entry:
  %gep1 = getelementptr i8 addrspace(200)*, i8 addrspace(200)** %array, i64 2
  br label %body

body:
  %iv2 = phi i8 addrspace(200)** [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr i8 addrspace(200)*, i8 addrspace(200)** %iv2, i64 -1
  %load = load i8 addrspace(200)*, i8 addrspace(200)** %gep2
  call void @use-capability(i8 addrspace(200)* %load)
  %load2 = load i8 addrspace(200)*, i8 addrspace(200)** %iv2
  call void @use-capability(i8 addrspace(200)* %load2)
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr i8 addrspace(200)*, i8 addrspace(200)** %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

; Check the following transform:
;
; str X, [x20]
;  ...
; add x20, x20, #32
;  ->
; str X, [x20], #32
;
; with X being either w0, x0, s0, d0 or q0.

define void @store-post-indexed-capability(i8 addrspace(200)** %array, i64 %count, i8 addrspace(200)* %val) nounwind {
; CHECK-LABEL: store-post-indexed-capability
; CHECK: str c{{[0-9]+}}, [x{{[0-9]+}}], #64
entry:
  %gep1 = getelementptr i8 addrspace(200)*, i8 addrspace(200)** %array, i64 2
  br label %body

body:
  %iv2 = phi i8 addrspace(200)** [ %gep3, %body ], [ %gep1, %entry ]
  %iv = phi i64 [ %iv.next, %body ], [ %count, %entry ]
  %gep2 = getelementptr i8 addrspace(200)*, i8 addrspace(200)** %iv2, i64 -1
  %load = load i8 addrspace(200)*, i8 addrspace(200)** %gep2
  call void @use-capability(i8 addrspace(200)* %load)
  store i8 addrspace(200)* %val, i8 addrspace(200)** %iv2
  %iv.next = add i64 %iv, -4
  %gep3 = getelementptr i8 addrspace(200)*, i8 addrspace(200)** %iv2, i64 4
  %cond = icmp eq i64 %iv.next, 0
  br i1 %cond, label %exit, label %body

exit:
  ret void
}

declare void @use-byte(i8)
declare void @use-halfword(i16)
declare void @use-word(i32)
declare void @use-doubleword(i64)
declare void @use-quadword(<2 x i64>)
declare void @use-float(float)
declare void @use-double(double)
declare void @use-capability(i8 addrspace(200)*)

; Check the following transform:
;
; stp w0, [x20]
;  ...
; add x20, x20, #32
;  ->
; stp w0, [x20], #32

define void @store-pair-post-indexed-capability(i8, i8 addrspace(200)*** %dstptr, i8 addrspace(200)* %src.real, i8 addrspace(200)* %src.imag) nounwind {
; CHECK-LABEL: store-pair-post-indexed-capability
; CHECK: stp c{{[0-9]+}}, c{{[0-9]+}}, [x{{[0-9]+}}], #64
  %dst = load i8 addrspace(200)**, i8 addrspace(200)*** %dstptr
  %dst.realp = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)** %dst, i32 0
  %dst.imagp = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)** %dst, i32 1
  store i8 addrspace(200)* %src.real, i8 addrspace(200)** %dst.realp
  store i8 addrspace(200)* %src.imag, i8 addrspace(200)** %dst.imagp
  %dst.next = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)** %dst, i32 4
  store i8 addrspace(200)** %dst.next, i8 addrspace(200)*** %dstptr
  ret void
}

; Check the following transform:
;
; (ldr|str) X, [x20]
;  ...
; sub x20, x20, #16
;  ->
; (ldr|str) X, [x20], #-16
;
; with X being either w0, x0, s0, d0 or q0.

define void @post-indexed-sub-capability(i8 addrspace(200)** %a, i8 addrspace(200)** %b, i64 %count) nounwind {
; CHECK-LABEL: post-indexed-sub-capability
; CHECK: ldr c{{[0-9]+}}, [x{{[0-9]+}}], #-32
; CHECK: str c{{[0-9]+}}, [x{{[0-9]+}}], #-32
  br label %for.body
for.body:
  %phi1 = phi i8 addrspace(200)** [ %gep4, %for.body ], [ %b, %0 ]
  %phi2 = phi i8 addrspace(200)** [ %gep3, %for.body ], [ %a, %0 ]
  %i = phi i64 [ %dec.i, %for.body], [ %count, %0 ]
  %gep1 = getelementptr i8 addrspace(200)*, i8 addrspace(200)** %phi1, i64 -1
  %load1 = load i8 addrspace(200)*, i8 addrspace(200)** %gep1
  %gep2 = getelementptr i8 addrspace(200)*, i8 addrspace(200)** %phi2, i64 -1
  store i8 addrspace(200)* %load1, i8 addrspace(200)** %gep2
  %load2 = load i8 addrspace(200)*, i8 addrspace(200)** %phi1
  store i8 addrspace(200)* %load2, i8 addrspace(200)** %phi2
  %dec.i = add nsw i64 %i, -1
  %gep3 = getelementptr i8 addrspace(200)*, i8 addrspace(200)** %phi2, i64 -2
  %gep4 = getelementptr i8 addrspace(200)*, i8 addrspace(200)** %phi1, i64 -2
  %cond = icmp sgt i64 %dec.i, 0
  br i1 %cond, label %for.body, label %end
end:
  ret void
}

define void @capability-pair-offset-out-of-range(i8 addrspace(200)** %p) {
; CHECK-LABEL: capability-pair-offset-out-of-range
; CHECK: ldr c{{[0-9]+}}, [x0, #1024]
; CHECK: ldr c{{[0-9]+}}, [x0, #1040]
; CHECK: stp c{{[0-9]+}}, c{{[0-9]+}}, [x0, #1008]
entry:
  %off31 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)** %p, i64 63
  %off32 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)** %p, i64 64
  %off33 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)** %p, i64 65
  %x = load i8 addrspace(200)*, i8 addrspace(200)** %off32, align 16
  %y = load i8 addrspace(200)*, i8 addrspace(200)** %off33, align 16
  store i8 addrspace(200)* %x, i8 addrspace(200)** %off31, align 16
  store i8 addrspace(200)* %y, i8 addrspace(200)** %off32, align 16
  ret void
}
