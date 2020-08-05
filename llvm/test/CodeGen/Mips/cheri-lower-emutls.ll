; RUN: %cheri_llc -mtriple=cheri-unknown-freebsd -emulated-tls %s -o - | FileCheck %s
target datalayout = "E-m:e-pf200:128:128-i8:8:32-i16:16:32-i64:64-n32:64-S128-A200"

@tls_noaddrspace_var = thread_local global i32 10, align 4
@tls_addrspace_var = thread_local addrspace(200) global i32 10, align 4

; Check that thread local variables in the capability address space are lowered
; to __emutls variables in the same address space.

; CHECK-LABEL: __emutls_v.tls_noaddrspace_var:
; CHECK-NEXT: .8byte 4
; CHECK-NEXT: .8byte 4
; CHECK-NEXT: .space 8
; CHECK-NEXT: .8byte __emutls_t.tls_noaddrspace_var

; CHECK-LABEL: __emutls_t.tls_noaddrspace_var:
; CHECK-NEXT: .4byte 10

; CHECK-LABEL: __emutls_v.tls_addrspace_var:
; CHECK-NEXT: .8byte 4
; CHECK-NEXT: .8byte 4
; CHECK-NEXT: .space 16
; CHECK-NEXT: [[LABEL:\.Ltmp[0-9]+]]:
; CHECK-NEXT: .space 16

; CHECK-LABEL: __emutls_t.tls_addrspace_var:
; CHECK-NEXT: .4byte 10

; CHECK: .section __cap_relocs
; CHECK: .8byte [[LABEL]]
; CHECK-NEXT: .8byte __emutls_t.tls_addrspace_var
