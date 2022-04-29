;; -ffunction-sections previously resulted in call relocations against the .text.foo section symbol.
;; However, that results in a relocation against a symbol without the LSB set, so ld.lld thinks it
;; needs to insert a C64->A64 thunk. Check that we use a relocation against the symbol for calls to
;; functions marked as dso_local (foo$local)
;; Do not autogen:
; UTC-ARGS: --disable
; RUN: llc -mtriple=aarch64 -target-abi purecap -mattr=+c64 --function-sections -o - --relocation-model=pic %s | FileCheck %s
; RUN: llc -mtriple=aarch64 -target-abi purecap -mattr=+c64 --function-sections --filetype=obj -o - \
; RUN:   --relocation-model=pic %s | llvm-readobj -r - --symbols | FileCheck %s --check-prefix=RELOCS

; RELOCS: Relocations [
; RELOCS-NEXT: Section ({{.+}}) .rela.text.test {
; FIXME: this relocation should not be against the section!
; RELOCS-NEXT:   R_MORELLO_CALL26 .text._ZdlPv 0x0
; RELOCS-NEXT: }
; RELOCS-NEXT:]
; RELOCS: Symbol {
; FIXME: we should have the symbol in the symbol table!
; RELOCS-NOT:        Name: .L_ZdlPv$local
; RELOCS-TODO:   Name: .L_ZdlPv$local
; RELOCS-TODO:   Value: 0x1
; RELOCS-TODO:   Size: 4
; RELOCS-TODO:   Binding: Local (0x0)
; RELOCS-TODO:   Type: Function (0x2)
; RELOCS-TODO:   Other: 0
; RELOCS-TODO:   Section: .text._ZdlPv (0x3)
; RELOCS-TODO: }

; CHECK-LABEL:  .globl	_ZdlPv
; CHECK-NEXT:   .p2align	2
; CHECK-NEXT:   .type	_ZdlPv,@function
; CHECK-NEXT: _ZdlPv:
; CHECK-NEXT: .L_ZdlPv$local:
; CHECK-NEXT: .Lfunc_begin0:
; CHECK-NEXT: // %bb.0:
; CHECK-NEXT:   ret c30
; CHECK-NEXT: .Lfunc_end0:
; CHECK-NEXT: 	.size	_ZdlPv, .Lfunc_end0-.Lfunc_begin0

define dso_local void @_ZdlPv(i8 addrspace(200)* %ptr) local_unnamed_addr nounwind {
entry:
  ret void
}

define void @test(i8 addrspace(200)* %ptr) nounwind {
; CHECK-LABEL: test:
; CHECK-NEXT:  .Lfunc_begin1:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    str c30, [csp, #-16]!
; CHECK-NEXT:    bl .L_ZdlPv$local{{$}}
; CHECK-NEXT:    ldr c30, [csp], #16
; CHECK-NEXT:    ret c30
; CHECK-NEXT:  .Lfunc_end1:
; CHECK-NEXT:   .size	test, .Lfunc_end1-.Lfunc_begin1
entry:
  call void @_ZdlPv(i8 addrspace(200)* %ptr)
  ret void
}
