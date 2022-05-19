; RUN: llc -verify-machineinstrs -mtriple=aarch64-none-elf -mattr=+c64,+morello,+legacy-morello-vararg -target-abi purecap -pre-RA-sched=linearize -enable-misched=false -disable-post-ra -aarch64-enable-ldst-opt=false < %s | FileCheck %s

%va_list = type {i8 addrspace(200)*, i8 addrspace(200)*, i8 addrspace(200)*, i32, i32}

; CHECK-LABEL: test_va_copy:
define void @test_va_copy(%va_list addrspace(200)* %var, %va_list addrspace(200) *%second_list) {
  %srcaddr = bitcast %va_list addrspace(200)* %var to i8 addrspace(200)*
  %dstaddr = bitcast %va_list addrspace(200)* %second_list to i8 addrspace(200)*
  call void @llvm.va_copy.p200i8.p200i8(i8 addrspace(200)* %dstaddr, i8 addrspace(200)* %srcaddr)

; CHECK-DAG: ldr [[BLOCK1:c[0-9]+]], [c[[VAR:[0-9]+]], #0]
; CHECK-DAG: str [[BLOCK1]], [c[[DST:[0-9]+]], #0]
; CHECK-DAG: ldr [[BLOCK2:c[0-9]+]], [c[[VAR]], #16]
; CHECK-DAG: str [[BLOCK2]], [c[[DST]], #16]
; CHECK-DAG: ldr [[BLOCK:c[0-9]+]], [c[[VAR]], #32]
; CHECK-DAG: str [[BLOCK]], [c[[DST]], #32]
; CHECK-DAG: ldr [[BLOCK:x[0-9]+]], [c[[VAR]], #48]
; CHECK-DAG: str [[BLOCK]], [c[[DST]], #48]

  ret void
; CHECK: ret
}


declare void @llvm.va_copy.p200i8.p200i8(i8 addrspace(200)* %dest, i8 addrspace(200)* %src)
