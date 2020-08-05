; RUN: llc -verify-machineinstrs -mtriple=aarch64-linux-gnu -O0 -target-abi purecap -mattr=+c64,+morello -fast-isel=0 -global-isel=false %s -o - | FileCheck %s

; Test the i128 cmpxchg here. We don't support the alternate base at this moment.

define { i128, i1 } @test_cmpxchg_128(i128 addrspace(200)* %addr, i128 %desired, i128 %new) nounwind {
; CHECK-LABEL: test_cmpxchg_128:
; CHECK: [[RETRY:.LBB[0-9]+_[0-9]+]]:
; CHECK:     ldaxp [[OLD_LO:x[0-9]+]], [[OLD_HI:x[0-9]+]], [c0]
; CHECK:     cmp [[OLD_LO]], x2
; CHECK:     cset [[CMP_TMP:w[0-9]+]], ne
; CHECK:     cmp [[OLD_HI]], x3
; CHECK:     cinc [[CMP:w[0-9]+]], [[CMP_TMP]], ne
; CHECK:     cbnz [[CMP]], [[DONE:.LBB[0-9]+_[0-9]+]]
; CHECK:     stlxp [[STATUS:w[0-9]+]], x4, x5, [c0]
; CHECK:     cbnz [[STATUS]], [[RETRY]]
; CHECK: [[DONE]]:
  %res = cmpxchg i128 addrspace(200)* %addr, i128 %desired, i128 %new seq_cst monotonic
  ret { i128, i1 } %res
}
