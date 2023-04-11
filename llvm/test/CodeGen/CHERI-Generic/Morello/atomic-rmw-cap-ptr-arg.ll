; DO NOT EDIT -- This file was generated from test/CodeGen/CHERI-Generic/Inputs/atomic-rmw-cap-ptr-arg.ll
; Reported as https://git.morello-project.org/morello/llvm-project/-/issues/35
; UNSUPPORTED: true
; LLVM ERROR: Cannot select: t5: iFATPTR128,ch = AtomicSwap<(load store monotonic 16 on %ir.ptr, addrspace 200)> t0, t2, t4
;   t2: iFATPTR128,ch = CopyFromReg t0, Register:iFATPTR128 %0
;     t1: iFATPTR128 = Register %0
;   t4: iFATPTR128,ch = CopyFromReg t0, Register:iFATPTR128 %1
;     t3: iFATPTR128 = Register %1
; In function: atomic_cap_ptr_xchg_relaxed

; Check that we can generate sensible code for atomic operations using capability pointers on capabilities
; See https://github.com/CTSRD-CHERI/llvm-project/issues/470
; RUN: llc -mtriple=aarch64 --relocation-model=pic -target-abi purecap -mattr=+morello,+c64 %s -o - | FileCheck %s --check-prefix=PURECAP
; RUN: llc -mtriple=aarch64 --relocation-model=pic -target-abi aapcs -mattr=+morello,-c64 %s -o - | FileCheck %s --check-prefix=HYBRID

define i32 addrspace(200)* @atomic_cap_ptr_xchg_sc(i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val) nounwind {
  %tmp = atomicrmw xchg i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val seq_cst
  ret i32 addrspace(200)* %tmp
}

define i32 addrspace(200)* @atomic_cap_ptr_xchg_relaxed(i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val) nounwind {
  %tmp = atomicrmw xchg i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val monotonic
  ret i32 addrspace(200)* %tmp
}

define i32 addrspace(200)* @atomic_cap_ptr_xchg_acquire(i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val) nounwind {
  %tmp = atomicrmw xchg i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val acquire
  ret i32 addrspace(200)* %tmp
}

define i32 addrspace(200)* @atomic_cap_ptr_xchg_rel(i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val) nounwind {
  %tmp = atomicrmw xchg i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val release
  ret i32 addrspace(200)* %tmp
}

define i32 addrspace(200)* @atomic_cap_ptr_xchg_acq_rel(i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val) nounwind {
  %tmp = atomicrmw xchg i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val acq_rel
  ret i32 addrspace(200)* %tmp
}

; Also check non-i8* xchg:
define i32 addrspace(200)* @atomic_cap_ptr_xchg_i32ptr(i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val) nounwind {
  %tmp = atomicrmw xchg i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val acq_rel
  ret i32 addrspace(200)* %tmp
}

define i32 addrspace(200)* @atomic_cap_ptr_add(i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val) nounwind {
  %tmp = atomicrmw add i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val seq_cst
  ret i32 addrspace(200)* %tmp
}

define i32 addrspace(200)* @atomic_cap_ptr_sub(i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val) nounwind {
  %tmp = atomicrmw sub i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val seq_cst
  ret i32 addrspace(200)* %tmp
}

define i32 addrspace(200)* @atomic_cap_ptr_and(i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val) nounwind {
  %tmp = atomicrmw and i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val seq_cst
  ret i32 addrspace(200)* %tmp
}

define i32 addrspace(200)* @atomic_cap_ptr_nand(i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val) nounwind {
  %tmp = atomicrmw nand i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val seq_cst
  ret i32 addrspace(200)* %tmp
}

define i32 addrspace(200)* @atomic_cap_ptr_or(i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val) nounwind {
  %tmp = atomicrmw or i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val seq_cst
  ret i32 addrspace(200)* %tmp
}

define i32 addrspace(200)* @atomic_cap_ptr_xor(i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val) nounwind {
  %tmp = atomicrmw xor i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val seq_cst
  ret i32 addrspace(200)* %tmp
}

define i32 addrspace(200)* @atomic_cap_ptr_max(i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val) nounwind {
  %tmp = atomicrmw max i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val seq_cst
  ret i32 addrspace(200)* %tmp
}

define i32 addrspace(200)* @atomic_cap_ptr_min(i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val) nounwind {
  %tmp = atomicrmw min i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val seq_cst
  ret i32 addrspace(200)* %tmp
}

define i32 addrspace(200)* @atomic_cap_ptr_umax(i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val) nounwind {
  %tmp = atomicrmw umax i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val seq_cst
  ret i32 addrspace(200)* %tmp
}

define i32 addrspace(200)* @atomic_cap_ptr_umin(i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val) nounwind {
  %tmp = atomicrmw umin i32 addrspace(200)* addrspace(200)* %ptr, i32 addrspace(200)* %val seq_cst
  ret i32 addrspace(200)* %tmp
}
