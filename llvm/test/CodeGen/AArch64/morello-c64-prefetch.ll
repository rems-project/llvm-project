; RUN: llc < %s -mtriple=arm64-eabi -mattr=+c64,+morello -target-abi purecap | FileCheck %s

@a = common addrspace(200) global i32 addrspace(200)* null, align 8

%struct.S = type { i32, i32, i32, i32, i32, i32 }

define void @test(i32 %i, i32 %j) nounwind ssp {
entry:
  ; CHECK: @test
  %j.addr = alloca %struct.S, align 4, addrspace(200)
  %j.addr.i32 = bitcast %struct.S addrspace(200)* %j.addr to i32 addrspace(200)*
  %j.addr1 = getelementptr inbounds i32, i32 addrspace(200)* %j.addr.i32, i64 1
  %tmp = bitcast i32 addrspace(200)* %j.addr1 to i8 addrspace(200)*
  ; CHECK: prfum pldl1strm, [c{{.*}}, #4]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp, i32 0, i32 0, i32 1)
  ; CHECK: prfum pldl3keep, [c{{.*}}, #4]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp, i32 0, i32 1, i32 1)
  ; CHECK: prfum pldl2keep, [c{{.*}}, #4]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp, i32 0, i32 2, i32 1)
  ; CHECK: prfum pldl1keep, [c{{.*}}, #4]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp, i32 0, i32 3, i32 1)

  ; CHECK: prfum plil1strm, [c{{.*}}, #4]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp, i32 0, i32 0, i32 0)
  ; CHECK: prfum plil3keep, [c{{.*}}, #4]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp, i32 0, i32 1, i32 0)
  ; CHECK: prfum plil2keep, [c{{.*}}, #4]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp, i32 0, i32 2, i32 0)
  ; CHECK: prfum plil1keep, [c{{.*}}, #4]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp, i32 0, i32 3, i32 0)

  ; CHECK: prfum pstl1strm, [c{{.*}}, #4]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp, i32 1, i32 0, i32 1)
  ; CHECK: prfum pstl3keep, [c{{.*}}, #4]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp, i32 1, i32 1, i32 1)
  ; CHECK: prfum pstl2keep, [c{{.*}}, #4]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp, i32 1, i32 2, i32 1)
  ; CHECK: prfum pstl1keep, [c{{.*}}, #4]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp, i32 1, i32 3, i32 1)

  %tmp1 = load i32, i32 addrspace(200)* %j.addr1, align 4, !tbaa !0
  %add = add nsw i32 %tmp1, %i
  %idxprom = sext i32 %add to i64
  %tmp2 = load i32 addrspace(200)*, i32 addrspace(200)* addrspace(200)* @a, align 8, !tbaa !3
  %arrayidx = getelementptr inbounds i32, i32 addrspace(200)* %tmp2, i64 %idxprom
  %tmp3 = bitcast i32 addrspace(200)* %arrayidx to i8 addrspace(200)*

  ; CHECK: prfm pldl1strm, [c{{.*}}]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp3, i32 0, i32 0, i32 1)
  %tmp4 = load i32 addrspace(200)*, i32 addrspace(200)* addrspace(200)* @a, align 8, !tbaa !3
  %arrayidx3 = getelementptr inbounds i32, i32 addrspace(200)* %tmp4, i64 %idxprom
  %tmp5 = bitcast i32 addrspace(200)* %arrayidx3 to i8 addrspace(200)*

  ; CHECK: prfm pldl3keep, [c{{.*}}]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp5, i32 0, i32 1, i32 1)
  %tmp6 = load i32 addrspace(200)*, i32 addrspace(200)* addrspace(200)* @a, align 8, !tbaa !3
  %arrayidx6 = getelementptr inbounds i32, i32 addrspace(200)* %tmp6, i64 %idxprom
  %tmp7 = bitcast i32 addrspace(200)* %arrayidx6 to i8 addrspace(200)*

  ; CHECK: prfm pldl2keep, [c{{.*}}]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp7, i32 0, i32 2, i32 1)
  %tmp8 = load i32 addrspace(200)*, i32 addrspace(200)* addrspace(200)* @a, align 8, !tbaa !3
  %arrayidx9 = getelementptr inbounds i32, i32 addrspace(200)* %tmp8, i64 %idxprom
  %tmp9 = bitcast i32 addrspace(200)* %arrayidx9 to i8 addrspace(200)*

  ; CHECK: prfm pldl1keep, [c{{.*}}]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp9, i32 0, i32 3, i32 1)
  %tmp10 = load i32 addrspace(200)*, i32 addrspace(200)* addrspace(200)* @a, align 8, !tbaa !3
  %arrayidx12 = getelementptr inbounds i32, i32 addrspace(200)* %tmp10, i64 %idxprom
  %tmp11 = bitcast i32 addrspace(200)* %arrayidx12 to i8 addrspace(200)*

  ; CHECK: prfm plil1strm, [c{{.*}}]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp11, i32 0, i32 0, i32 0)
  %tmp12 = load i32 addrspace(200)*, i32 addrspace(200)* addrspace(200)* @a, align 8, !tbaa !3
  %arrayidx15 = getelementptr inbounds i32, i32 addrspace(200)* %tmp12, i64 %idxprom
  %tmp13 = bitcast i32 addrspace(200)* %arrayidx3 to i8 addrspace(200)*

  ; CHECK: prfm plil3keep, [c{{.*}}]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp13, i32 0, i32 1, i32 0)
  %tmp14 = load i32 addrspace(200)*, i32 addrspace(200)* addrspace(200)* @a, align 8, !tbaa !3
  %arrayidx18 = getelementptr inbounds i32, i32 addrspace(200)* %tmp14, i64 %idxprom
  %tmp15 = bitcast i32 addrspace(200)* %arrayidx6 to i8 addrspace(200)*

  ; CHECK: prfm plil2keep, [c{{.*}}]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp15, i32 0, i32 2, i32 0)
  %tmp16 = load i32 addrspace(200)*, i32 addrspace(200)* addrspace(200)* @a, align 8, !tbaa !3
  %arrayidx21 = getelementptr inbounds i32, i32 addrspace(200)* %tmp16, i64 %idxprom
  %tmp17 = bitcast i32 addrspace(200)* %arrayidx9 to i8 addrspace(200)*

  ; CHECK: prfm plil1keep, [c{{.*}}]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp17, i32 0, i32 3, i32 0)
  %tmp18 = load i32 addrspace(200)*, i32 addrspace(200)* addrspace(200)* @a, align 8, !tbaa !3
  %arrayidx24 = getelementptr inbounds i32, i32 addrspace(200)* %tmp18, i64 %idxprom
  %tmp19 = bitcast i32 addrspace(200)* %arrayidx12 to i8 addrspace(200)*

  ; CHECK: prfm pstl1strm, [c{{.*}}]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp19, i32 1, i32 0, i32 1)
  %tmp20 = load i32 addrspace(200)*, i32 addrspace(200)* addrspace(200)* @a, align 8, !tbaa !3
  %arrayidx27 = getelementptr inbounds i32, i32 addrspace(200)* %tmp20, i64 %idxprom
  %tmp21 = bitcast i32 addrspace(200)* %arrayidx15 to i8 addrspace(200)*

  ; CHECK: prfm pstl3keep, [c{{.*}}]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp21, i32 1, i32 1, i32 1)
  %tmp22 = load i32 addrspace(200)*, i32 addrspace(200)* addrspace(200)* @a, align 8, !tbaa !3
  %arrayidx30 = getelementptr inbounds i32, i32 addrspace(200)* %tmp22, i64 %idxprom
  %tmp23 = bitcast i32 addrspace(200)* %arrayidx18 to i8 addrspace(200)*

  ; CHECK: prfm pstl2keep, [c{{.*}}]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp23, i32 1, i32 2, i32 1)
  %tmp24 = load i32 addrspace(200)*, i32 addrspace(200)* addrspace(200)* @a, align 8, !tbaa !3
  %arrayidx33 = getelementptr inbounds i32, i32 addrspace(200)* %tmp24, i64 %idxprom
  %tmp25 = bitcast i32 addrspace(200)* %arrayidx21 to i8 addrspace(200)*

  ; CHECK: prfm pstl1keep, [c{{.*}}]
  call void @llvm.prefetch.p200i8(i8 addrspace(200)* %tmp25, i32 1, i32 3, i32 1)
  ret void
}

declare void @llvm.prefetch.p200i8(i8 addrspace(200)* nocapture, i32, i32, i32) nounwind

!0 = !{!"int", !1}
!1 = !{!"omnipotent char", !2}
!2 = !{!"Simple C/C++ TBAA"}
!3 = !{!"any pointer", !1}
