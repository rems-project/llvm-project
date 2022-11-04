; RUN: llc -march=aarch64 -mattr=+morello,+c64 -O0 -mcpu=rainier -target-abi purecap %s -o - | \
; RUN:   FileCheck --check-prefix=CHECK-ASM %s
; RUN: llc -march=aarch64 -mattr=+morello,+c64 -O0 -mcpu=rainier -target-abi purecap %s -filetype=obj -o - | \
; RUN:   llvm-objdump --no-leading-addr --no-show-raw-insn -S --mcpu=rainier - | \
; RUN:   FileCheck --check-prefix=CHECK-OBJ %s

; Spilling an X pair to the stack was faulting because we were using
; the A64 opcode (STPXi).
define linkonce_odr hidden i128 @foo(i128 addrspace(200) *%in, i128 %in2) addrspace(200) {
monotonic:
  %0 = atomicrmw xchg i128 addrspace(200)* %in, i128 %in2 monotonic, align 16
  ret i128 %0
}

; CHECK-ASM-LABEL: foo:
; CHECK-ASM: stp	x0, x1, [csp]                   // 16-byte Folded Spill

; CHECK-OBJ-LABEL: <foo>:
; CHECK-OBJ: stp	x0, x1, [csp]
