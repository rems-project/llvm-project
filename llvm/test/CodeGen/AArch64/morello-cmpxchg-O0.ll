; RUN: llc -verify-machineinstrs -mtriple=aarch64-linux-gnu -O0 -mattr=+c64,+morello -target-abi purecap -fast-isel=0 -global-isel=false %s -o - | FileCheck %s

define { i8, i1 } @test_cmpxchg_8(i8 addrspace(200)* %addr, i8 %desired, i8 %new) nounwind {
; CHECK-LABEL: test_cmpxchg_8:
; CHECK: [[RETRY:.LBB[0-9]+_[0-9]+]]:
; CHECK:     mov [[STATUS:w[3-9]+]], #0
; CHECK:     ldaxrb [[OLD:w[0-9]+]], [c0]
; CHECK:     cmp [[OLD]], w1, uxtb
; CHECK:     b.ne [[DONE:.LBB[0-9]+_[0-9]+]]
; CHECK:     stlxrb [[STATUS]], w2, [c0]
; CHECK:     cbnz [[STATUS]], [[RETRY]]
; CHECK: [[DONE]]:
; CHECK:     subs {{w[0-9]+}}, [[OLD]], w1
; CHECK:     cset {{w[0-9]+}}, eq
  %res = cmpxchg i8 addrspace(200)* %addr, i8 %desired, i8 %new seq_cst monotonic
  ret { i8, i1 } %res
}

define { i16, i1 } @test_cmpxchg_16(i16 addrspace(200)* %addr, i16 %desired, i16 %new) nounwind {
; CHECK-LABEL: test_cmpxchg_16:
; CHECK: [[RETRY:.LBB[0-9]+_[0-9]+]]:
; CHECK:     mov [[STATUS:w[3-9]+]], #0
; CHECK:     ldaxrh [[OLD:w[0-9]+]], [c0]
; CHECK:     cmp [[OLD]], w1, uxth
; CHECK:     b.ne [[DONE:.LBB[0-9]+_[0-9]+]]
; CHECK:     stlxrh [[STATUS:w[3-9]]], w2, [c0]
; CHECK:     cbnz [[STATUS]], [[RETRY]]
; CHECK: [[DONE]]:
; CHECK:     subs {{w[0-9]+}}, [[OLD]], w1
; CHECK:     cset {{w[0-9]+}}, eq
  %res = cmpxchg i16 addrspace(200)* %addr, i16 %desired, i16 %new seq_cst monotonic
  ret { i16, i1 } %res
}

define { i32, i1 } @test_cmpxchg_32(i32 addrspace(200)* %addr, i32 %desired, i32 %new) nounwind {
; CHECK-LABEL: test_cmpxchg_32:
; CHECK: [[RETRY:.LBB[0-9]+_[0-9]+]]:
; CHECK:     mov [[STATUS:w[3-9]+]], #0
; CHECK:     ldaxr [[OLD:w[0-9]+]], [c0]
; CHECK:     cmp [[OLD]], w1
; CHECK:     b.ne [[DONE:.LBB[0-9]+_[0-9]+]]
; CHECK:     stlxr [[STATUS]], w2, [c0]
; CHECK:     cbnz [[STATUS]], [[RETRY]]
; CHECK: [[DONE]]:
; CHECK:     subs {{w[0-9]+}}, [[OLD]], w1
; CHECK:     cset {{w[0-9]+}}, eq
  %res = cmpxchg i32 addrspace(200)* %addr, i32 %desired, i32 %new seq_cst monotonic
  ret { i32, i1 } %res
}

define { i64, i1 } @test_cmpxchg_64(i64 addrspace(200)* %addr, i64 %desired, i64 %new) nounwind {
; CHECK-LABEL: test_cmpxchg_64:
; CHECK: [[RETRY:.LBB[0-9]+_[0-9]+]]:
; CHECK:     mov [[STATUS:w[3-9]+]], #0
; CHECK:     ldaxr [[OLD:x[0-9]+]], [c0]
; CHECK:     cmp [[OLD]], x1
; CHECK:     b.ne [[DONE:.LBB[0-9]+_[0-9]+]]
; CHECK:     stlxr [[STATUS]], x2, [c0]
; CHECK:     cbnz [[STATUS]], [[RETRY]]
; CHECK: [[DONE]]:
; CHECK:     subs {{x[0-9]+}}, [[OLD]], x1
; CHECK:     cset {{w[0-9]+}}, eq
  %res = cmpxchg i64 addrspace(200)* %addr, i64 %desired, i64 %new seq_cst monotonic
  ret { i64, i1 } %res
}

define { i8 addrspace(200)*, i1 } @test_cmpxchg_fatptr(i8 addrspace(200)* addrspace(200)* %addr, i8 addrspace(200)* %desired, i8 addrspace(200)* %new) nounwind {
; CHECK-LABEL: test_cmpxchg_fatptr:
; CHECK: casal
  %res = cmpxchg i8 addrspace(200)* addrspace(200)* %addr, i8 addrspace(200)* %desired, i8 addrspace(200)* %new seq_cst monotonic
  ret { i8 addrspace(200)*, i1 } %res
}
