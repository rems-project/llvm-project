; RUN: %cheri_llc -mtriple=cheri-unknown-freebsd %s -o - | FileCheck %s
define i32 @test_combine_i16_to_i32(i16 addrspace(200)* %ptr)
{
; CHECK-LABEL: test_combine_i16_to_i32:
; CHECK:      clw
; CHECK-NEXT: jr
entry:
  %gep = getelementptr i16, i16 addrspace(200)* %ptr, i16 1
  %a = load i16, i16 addrspace(200)* %ptr, align 2
  %b = load i16, i16 addrspace(200)* %gep, align 2
  %a.zext = zext i16 %a to i32
  %b.zext = zext i16 %b to i32
  %a.shl = shl i32 %a.zext, 16
  %or = or i32 %a.shl, %b.zext
  ret i32 %or
}

define i32 @test_combine_i8_to_i32(i8 addrspace(200)* %ptr)
{
; CHECK-LABEL: test_combine_i8_to_i32:
; CHECK:      clw
; CHECK-NEXT: jr
entry:
  %gep1 = getelementptr i8, i8 addrspace(200)* %ptr, i8 1
  %gep2 = getelementptr i8, i8 addrspace(200)* %ptr, i8 2
  %gep3 = getelementptr i8, i8 addrspace(200)* %ptr, i8 3
  %a = load i8, i8 addrspace(200)* %ptr, align 1
  %b = load i8, i8 addrspace(200)* %gep1, align 1
  %c = load i8, i8 addrspace(200)* %gep2, align 1
  %d = load i8, i8 addrspace(200)* %gep3, align 1
  %a.zext = zext i8 %a to i32
  %b.zext = zext i8 %b to i32
  %c.zext = zext i8 %c to i32
  %d.zext = zext i8 %d to i32
  %a.shl = shl i32 %a.zext, 24
  %b.shl = shl i32 %b.zext, 16
  %c.shl = shl i32 %c.zext, 8
  %or1 = or i32 %a.shl, %b.shl
  %or2 = or i32 %or1, %c.shl
  %or3 = or i32 %or2, %d.zext
  ret i32 %or3
}
