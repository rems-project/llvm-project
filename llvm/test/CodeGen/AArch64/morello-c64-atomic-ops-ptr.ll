; RUN: llc < %s -mtriple=aarch64-none-elf -mattr=+c64,+morello -target-abi purecap -verify-machineinstrs | FileCheck  %s
; RUN: llc < %s -mtriple=aarch64-none-elf -mattr=+c64,+lse,+morello -target-abi purecap -verify-machineinstrs | FileCheck %s

target datalayout = "e-m:e-i64:64-i128:128-n32:64-S128-pf200:128:128:128:64"

; CHECK-LABEL: test_atomic_load_add_ptr
define i8 addrspace(200)* @test_atomic_load_add_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) * addrspace(200)* %ptr) nounwind {
; CHECK-NOT: dmb
; CHECK: ldaxr c[[OLD:[0-9]+]], [c1]
; CHECK: add x[[RES:[0-9]+]], x[[OLD]], x0
; CHECK: scvalue  c[[NEW:[0-9]+]], c[[OLD]], x[[RES]]
; CHECK: stlxr   w[[TOK:[0-9]+]], c[[NEW]], [c1]
; CHECK: cbnz    w[[TOK]],
   %old = atomicrmw add i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %offset seq_cst
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_sub_ptr
define i8 addrspace(200)* @test_atomic_load_sub_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) * addrspace(200)* %ptr) nounwind {
; CHECK: ldaxr c[[OLD:[0-9]+]], [c1]
; CHECK: sub x[[RES:[0-9]+]], x[[OLD]], x0
; CHECK: scvalue  c[[NEW:[0-9]+]], c[[OLD]], x[[RES]]
; CHECK: stxr   w[[TOK:[0-9]+]], c[[NEW]], [c1]
; CHECK: cbnz    w[[TOK]],
   %old = atomicrmw sub i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %offset acquire
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_and_ptr
define i8 addrspace(200)* @test_atomic_load_and_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) * addrspace(200)* %ptr) nounwind {
; CHECK: ldxr c[[OLD:[0-9]+]], [c1]
; CHECK: and x[[RES:[0-9]+]], x[[OLD]], x0
; CHECK: scvalue  c[[NEW:[0-9]+]], c[[OLD]], x[[RES]]
; CHECK: stlxr   w[[TOK:[0-9]+]], c[[NEW]], [c1]
; CHECK: cbnz    w[[TOK]],

   %old = atomicrmw and i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %offset release
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_or_ptr
define i8 addrspace(200)* @test_atomic_load_or_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) * addrspace(200)* %ptr) nounwind {
; CHECK: ldxr c[[OLD:[0-9]+]], [c1]
; CHECK: orr x[[RES:[0-9]+]], x[[OLD]], x0
; CHECK: scvalue  c[[NEW:[0-9]+]], c[[OLD]], x[[RES]]
; CHECK: stxr   w[[TOK:[0-9]+]], c[[NEW]], [c1]
; CHECK: cbnz    w[[TOK]],

   %old = atomicrmw or i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %offset monotonic
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_xor_ptr
define i8 addrspace(200)* @test_atomic_load_xor_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) * addrspace(200)* %ptr) nounwind {
; CHECK: ldaxr c[[OLD:[0-9]+]], [c1]
; CHECK: eor x[[RES:[0-9]+]], x[[OLD]], x0
; CHECK: scvalue  c[[NEW:[0-9]+]], c[[OLD]], x[[RES]]
; CHECK: stlxr   w[[TOK:[0-9]+]], c[[NEW]], [c1]
; CHECK: cbnz    w[[TOK]],

   %old = atomicrmw xor i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %offset seq_cst
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_xchg_ptr_monotonic
define i8 addrspace(200)* @test_atomic_load_xchg_ptr_monotonic(i8 addrspace(200)* %offset, i8 addrspace(200) * addrspace(200)* %ptr) nounwind {
; CHECK: swp c0, c0, [c1]
   %old = atomicrmw xchg i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %offset monotonic
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_xchg_ptr_acquire
define i8 addrspace(200)* @test_atomic_load_xchg_ptr_acquire(i8 addrspace(200)* %offset, i8 addrspace(200) * addrspace(200)* %ptr) nounwind {
; CHECK: swpa c0, c0, [c1]
   %old = atomicrmw xchg i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %offset acquire
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_xchg_ptr_release
define i8 addrspace(200)* @test_atomic_load_xchg_ptr_release(i8 addrspace(200)* %offset, i8 addrspace(200) * addrspace(200)* %ptr) nounwind {
; CHECK: swpl c0, c0, [c1]
   %old = atomicrmw xchg i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %offset release
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_xchg_ptr_acq_rel
define i8 addrspace(200)* @test_atomic_load_xchg_ptr_acq_rel(i8 addrspace(200)* %offset, i8 addrspace(200) * addrspace(200)* %ptr) nounwind {
; CHECK: swpal c0, c0, [c1]
   %old = atomicrmw xchg i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %offset acq_rel
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_xchg_ptr_seq_cst
define i8 addrspace(200)* @test_atomic_load_xchg_ptr_seq_cst(i8 addrspace(200)* %offset, i8 addrspace(200) * addrspace(200)* %ptr) nounwind {
; CHECK: swpal c0, c0, [c1]
   %old = atomicrmw xchg i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %offset seq_cst
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_min_ptr
define i8 addrspace(200)* @test_atomic_load_min_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) * addrspace(200)* %ptr) nounwind {
; CHECK: ldaxr c[[OLD:[0-9]+]], [c1]
; CHECK: cmp x[[OLD]], x[[TMP:[0-9]+]]
; CHECK: csel c[[RES:[0-9]+]], c[[OLD]], c[[TMP]], le
; CHECK: stxr   w[[TOK:[0-9]+]], c[[RES]], [c1]
; CHECK: cbnz    w[[TOK]],
   %old = atomicrmw min i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %offset acquire
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_max_ptr
define i8 addrspace(200)* @test_atomic_load_max_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) * addrspace(200)* %ptr) nounwind {
; CHECK: ldxr c[[OLD:[0-9]+]], [c1]
; CHECK: cmp x[[OLD]], x[[TMP:[0-9]+]]
; CHECK: csel c[[RES:[0-9]+]], c[[OLD]], c[[TMP]], gt
; CHECK: stlxr   w[[TOK:[0-9]+]], c[[RES]], [c1]
; CHECK: cbnz    w[[TOK]],
   %old = atomicrmw max i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %offset release
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_umin_ptr
define i8 addrspace(200)* @test_atomic_load_umin_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) * addrspace(200)* %ptr) nounwind {
; CHECK: ldxr c[[OLD:[0-9]+]], [c1]
; CHECK: cmp x[[OLD]], x[[TMP:[0-9]+]]
; CHECK: csel c[[RES:[0-9]+]], c[[OLD]], c[[TMP]], ls
; CHECK: stxr   w[[TOK:[0-9]+]], c[[RES]], [c1]
; CHECK: cbnz    w[[TOK]],
   %old = atomicrmw umin i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %offset monotonic
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_umax_ptr
define i8 addrspace(200)* @test_atomic_load_umax_ptr(i8 addrspace(200)* %offset, i8 addrspace(200) * addrspace(200)* %ptr) nounwind {
; CHECK: ldaxr c[[OLD:[0-9]+]], [c1]
; CHECK: cmp x[[OLD]], x[[TMP:[0-9]+]]
; CHECK: csel c[[RES:[0-9]+]], c[[OLD]], c[[TMP]], hi
; CHECK: stxr   w[[TOK:[0-9]+]], c[[RES]], [c1]
; CHECK: cbnz    w[[TOK]],
   %old = atomicrmw umax i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %offset acquire
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_cmpxchg_ptr_acquire
define i8 addrspace(200)* @test_cmpxchg_ptr_acquire(i8 addrspace(200)* %offset,
         i8 addrspace(200) * addrspace(200)* %ptr,
         i8 addrspace(200) * %wanted, i8 addrspace(200)* %new) nounwind {
   %pair = cmpxchg i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %wanted, i8 addrspace(200)* %new acquire acquire
; CHECK: mov c0, c2
; CHECK: casa c0, c3, [c1]
   %old = extractvalue { i8 addrspace(200)*, i1 } %pair, 0
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_cmpxchg_ptr_monotonic
define i8 addrspace(200)* @test_cmpxchg_ptr_monotonic(i8 addrspace(200)* %offset,
         i8 addrspace(200) * addrspace(200)* %ptr,
         i8 addrspace(200) * %wanted, i8 addrspace(200)* %new) nounwind {
   %pair = cmpxchg i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %wanted, i8 addrspace(200)* %new monotonic monotonic
; CHECK: mov c0, c2
; CHECK: cas c0, c3, [c1]
   %old = extractvalue { i8 addrspace(200)*, i1 } %pair, 0
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_cmpxchg_ptr_release
define i8 addrspace(200)* @test_cmpxchg_ptr_release(i8 addrspace(200)* %offset,
         i8 addrspace(200) * addrspace(200)* %ptr,
         i8 addrspace(200) * %wanted, i8 addrspace(200)* %new) nounwind {
   %pair = cmpxchg i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %wanted, i8 addrspace(200)* %new release monotonic
; CHECK: mov c0, c2
; CHECK: casl c0, c3, [c1]
   %old = extractvalue { i8 addrspace(200)*, i1 } %pair, 0
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_cmpxchg_ptr_acq_rel
define i8 addrspace(200)* @test_cmpxchg_ptr_acq_rel(i8 addrspace(200)* %offset,
         i8 addrspace(200) * addrspace(200)* %ptr,
         i8 addrspace(200) * %wanted, i8 addrspace(200)* %new) nounwind {
   %pair = cmpxchg i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %wanted, i8 addrspace(200)* %new acq_rel monotonic

; CHECK: mov c0, c2
; CHECK: casal c0, c3, [c1]
   %old = extractvalue { i8 addrspace(200)*, i1 } %pair, 0
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_cmpxchg_ptr_seq_cst
define i8 addrspace(200)* @test_cmpxchg_ptr_seq_cst(i8 addrspace(200)* %offset,
         i8 addrspace(200) * addrspace(200)* %ptr,
         i8 addrspace(200) * %wanted, i8 addrspace(200)* %new) nounwind {
   %pair = cmpxchg i8 addrspace(200)* addrspace(200)* %ptr, i8 addrspace(200) * %wanted, i8 addrspace(200)* %new seq_cst monotonic
; CHECK: mov c0, c2
; CHECK: casal c0, c3, [c1]
   %old = extractvalue { i8 addrspace(200)*, i1 } %pair, 0
   ret i8 addrspace(200)* %old
}

; CHECK-LABEL: test_atomic_load_monotonic_ptr
define i8 addrspace(200) * @test_atomic_load_monotonic_ptr(i8 addrspace(200) * addrspace(200)* %ptr) nounwind {
; CHECK:  ldr    c0, [c0, #0]
  %val = load atomic i8 addrspace(200)*, i8 addrspace(200)* addrspace(200) * %ptr monotonic, align 16

  ret i8 addrspace(200) * %val
}

@__cxa_unexpected_handler = external addrspace(200) global void () addrspace(200)*, align 16

; CHECK-LABEL: test_atomic_load_add_ptr_fun
define dso_local void () addrspace(200)* @test_atomic_load_add_ptr_fun(void () addrspace(200)* %ptr) local_unnamed_addr addrspace(200)  {
entry:
; CHECK-NOT: dmb
; CHECK: ldaxr c[[OLD:[0-9]+]], [c2]
; CHECK: add x[[RES:[0-9]+]], x[[OLD]], x0
; CHECK: scvalue  c[[NEW:[0-9]+]], c[[OLD]], x[[RES]]
; CHECK: stlxr   w[[TOK:[0-9]+]], c[[NEW]], [c2]
; CHECK: cbnz    w[[TOK]],

  %0 = atomicrmw add void () addrspace(200)* addrspace(200)* @__cxa_unexpected_handler, void () addrspace(200)* %ptr seq_cst
  ret void () addrspace(200)* %0
}

define void @CapabilityStoreSeqCst(i8 addrspace(200)* %v, i8 addrspace(200) * addrspace(200) * %addr) nounwind {
; CHECK-LABEL: CapabilityStoreSeqCst:
; CHECK: stlr c0, [c1]
  store atomic volatile i8 addrspace(200)* %v, i8 addrspace(200)* addrspace(200)* %addr seq_cst, align 16
  ret void
}

define void @CapabilityStoreMonotonic(i8 addrspace(200)* %v, i8 addrspace(200) * addrspace(200) * %addr) nounwind {
; CHECK-LABEL: CapabilityStoreMonotonic:
; CHECK-NOT: dmb
; CHECK: str c0, [c1, #0]
; CHECK-NOT: dmb
  store atomic volatile i8 addrspace(200)* %v, i8 addrspace(200)* addrspace(200)* %addr monotonic, align 16
  ret void
}

define void @CapabilityStoreRelease(i8 addrspace(200)* %v, i8 addrspace(200) * addrspace(200) * %addr) nounwind {
; CHECK-LABEL: CapabilityStoreRelease:
; CHECK-NOT: dmb
; CHECK: stlr c0, [c1]
  store atomic volatile i8 addrspace(200)* %v, i8 addrspace(200)* addrspace(200)* %addr release, align 16
  ret void
}

define i8 addrspace(200)* @CapabilityLoadSeqCst(i8 addrspace(200) * addrspace(200) * %addr) nounwind {
; CHECK-LABEL: CapabilityLoadSeqCst:
; CHEC-NOT: dmb
; CHECK: ldar c0, [c0]
  %val = load atomic volatile i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %addr seq_cst, align 16
  ret i8 addrspace(200)* %val
}

define i8 addrspace(200)* @CapabilityLoadAcq(i8 addrspace(200) * addrspace(200) * %addr) nounwind {
; CHECK-LABEL: CapabilityLoadAcq:
; CHECK-NOT: dmb
; CHECK: ldar c0, [c0]
  %val = load atomic volatile i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %addr acquire, align 16
  ret i8 addrspace(200)* %val
}

define i8 addrspace(200)* @CapabilityLoadMonotonic(i8 addrspace(200) * addrspace(200) * %addr) nounwind {
; CHECK-LABEL: CapabilityLoadMonotonic:
; CHECK-NOT: dmb
; CHECK: ldr c0, [c0, #0]
; CHECK-NOT: dmb
  %val = load atomic volatile i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %addr monotonic, align 16
  ret i8 addrspace(200)* %val
}
