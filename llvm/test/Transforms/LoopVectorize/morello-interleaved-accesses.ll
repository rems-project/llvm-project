; RUN: opt -mattr=+morello -S -loop-vectorize -instcombine %s -o - | FileCheck %s
target datalayout = "e-m:e-i64:64-i128:128-n32:64-S128-pf200:128:128:128:64"
target triple = "aarch64-none--elf"

; CHECK-LABEL: @test
define i8* @test(i8* noalias %dst, i8* noalias nocapture readonly %src, i64 %len) {
; CHECK-NOT: shufflevector
entry:
  %tmp = bitcast i8* %dst to i8 addrspace(200)**
  %cmp.18 = icmp ugt i64 %len, 63
  br i1 %cmp.18, label %preheader, label %theEnd

preheader:
  %tmp1 = bitcast i8* %src to i8 addrspace(200)**
  %tmp2 = and i64 %len, -64
  %scevgep = getelementptr i8, i8* %dst, i64 %tmp2
  br label %body

body:
  %aligned_dst.021 = phi i8 addrspace(200)** [ %incdec.ptr7, %body ], [ %tmp, %preheader ]
  %aligned_src.020 = phi i8 addrspace(200)** [ %incdec.ptr6, %body ], [ %tmp1, %preheader ]
  %len.addr.019 = phi i64 [ %sub, %body ], [ %len, %preheader ]
  %incdec.ptr = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)** %aligned_src.020, i64 1
  %tmp3 = load i8 addrspace(200)*, i8 addrspace(200)** %aligned_src.020, align 16
  %incdec.ptr1 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)** %aligned_dst.021, i64 1
  store i8 addrspace(200)* %tmp3, i8 addrspace(200)** %aligned_dst.021, align 16
  %incdec.ptr2 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)** %aligned_src.020, i64 2
  %tmp4 = load i8 addrspace(200)*, i8 addrspace(200)** %incdec.ptr, align 16
  %incdec.ptr3 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)** %aligned_dst.021, i64 2
  store i8 addrspace(200)* %tmp4, i8 addrspace(200)** %incdec.ptr1, align 16
  %incdec.ptr4 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)** %aligned_src.020, i64 3
  %tmp5 = load i8 addrspace(200)*, i8 addrspace(200)** %incdec.ptr2, align 16
  %incdec.ptr5 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)** %aligned_dst.021, i64 3
  store i8 addrspace(200)* %tmp5, i8 addrspace(200)** %incdec.ptr3, align 16
  %incdec.ptr6 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)** %aligned_src.020, i64 4
  %tmp6 = load i8 addrspace(200)*, i8 addrspace(200)** %incdec.ptr4, align 16
  %incdec.ptr7 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)** %aligned_dst.021, i64 4
  store i8 addrspace(200)* %tmp6, i8 addrspace(200)** %incdec.ptr5, align 16
  %sub = add i64 %len.addr.019, -64
  %cmp = icmp ugt i64 %sub, 63
  br i1 %cmp, label %body, label %loopexit

loopexit:
  %scevgep22 = bitcast i8* %scevgep to i8 addrspace(200)**
  br label %theEnd

theEnd:
  %aligned_dst.0.lcssa = phi i8 addrspace(200)** [ %tmp, %entry ], [ %scevgep22, %loopexit ]
  %tmp7 = bitcast i8 addrspace(200)** %aligned_dst.0.lcssa to i8*
  ret i8* %tmp7
}
