; RUN: llc -march=arm64 -mattr=+morello,+c64 -target-abi purecap -o - %s | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none-unknown-elf"

; CHECK-LABEL: addimm
define dso_local i8 addrspace(200)* @addimm(i8 addrspace(200) *%tmp) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, #2
  %tmp1 = getelementptr inbounds i8, i8 addrspace(200)* %tmp, i32 2
  ret i8 addrspace(200)* %tmp1
}
define dso_local i8 addrspace(200)* @addimm2(i8 addrspace(200) *%tmp) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, #2, lsl #12
  %tmp1 = getelementptr inbounds i8, i8 addrspace(200)* %tmp, i32 8192
  ret i8 addrspace(200)* %tmp1
}
define dso_local i8 addrspace(200)* @addimm3(i8 addrspace(200) *%tmp) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, #4095
  %tmp1 = getelementptr inbounds i8, i8 addrspace(200)* %tmp, i32 4095
  ret i8 addrspace(200)* %tmp1
}
define dso_local i8 addrspace(200)* @addimm4(i8 addrspace(200) *%tmp) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: mov     w8, #4097
; CHECK: add     c0, c0, x8, uxtx
  %tmp1 = getelementptr inbounds i8, i8 addrspace(200)* %tmp, i32 4097
  ret i8 addrspace(200)* %tmp1
}
; CHECK-LABEL: subimm
define dso_local i8 addrspace(200)* @subimm(i8 addrspace(200) *%tmp) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: sub     c0, c0, #2
  %tmp1 = getelementptr inbounds i8, i8 addrspace(200)* %tmp, i32 -2
  ret i8 addrspace(200)* %tmp1
}
; CHECK-LABEL: add8s0
define dso_local i8 addrspace(200)* @add8s0(i8 addrspace(200) *%tmp, i8 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, sxtb
  %tmp1 = getelementptr inbounds i8, i8 addrspace(200)* %tmp, i8 %idx
  ret i8 addrspace(200)* %tmp1
}
; CHECK-LABEL: add8s1
define dso_local i16 addrspace(200)* @add8s1(i16 addrspace(200) *%tmp, i8 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, sxtb #1
  %tmp1 = getelementptr inbounds i16, i16 addrspace(200)* %tmp, i8 %idx
  ret i16 addrspace(200)* %tmp1
}
; CHECK-LABEL: add8s2
define dso_local i32 addrspace(200)* @add8s2(i32 addrspace(200) *%tmp, i8 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, sxtb #2
  %tmp1 = getelementptr inbounds i32, i32 addrspace(200)* %tmp, i8 %idx
  ret i32 addrspace(200)* %tmp1
}
; CHECK-LABEL: add8s3
define dso_local i64 addrspace(200)* @add8s3(i64 addrspace(200) *%tmp, i8 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, sxtb #3
  %tmp1 = getelementptr inbounds i64, i64 addrspace(200)* %tmp, i8 %idx
  ret i64 addrspace(200)* %tmp1
}
; CHECK-LABEL: add8s4
define dso_local i8 addrspace(200)* addrspace(200)* @add8s4(i8 addrspace(200)* addrspace(200) *%tmp, i8 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, sxtb #4
  %tmp1 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %tmp, i8 %idx
  ret i8 addrspace(200)* addrspace(200)* %tmp1
}
; CHECK-LABEL: add8z0
define dso_local i8 addrspace(200)* @add8z0(i8 addrspace(200) *%tmp, i8 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, uxtb
  %nidx = zext i8 %idx to i64
  %tmp1 = getelementptr inbounds i8, i8 addrspace(200)* %tmp, i64 %nidx
  ret i8 addrspace(200)* %tmp1
}
; CHECK-LABEL: add8z1
define dso_local i16 addrspace(200)* @add8z1(i16 addrspace(200) *%tmp, i8 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, uxtb #1
  %nidx = zext i8 %idx to i64
  %tmp1 = getelementptr inbounds i16, i16 addrspace(200)* %tmp, i64 %nidx
  ret i16 addrspace(200)* %tmp1
}
; CHECK-LABEL: add8z2
define dso_local i32 addrspace(200)* @add8z2(i32 addrspace(200) *%tmp, i8 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, uxtb #2
  %nidx = zext i8 %idx to i64
  %tmp1 = getelementptr inbounds i32, i32 addrspace(200)* %tmp, i64 %nidx
  ret i32 addrspace(200)* %tmp1
}
; CHECK-LABEL: add8z3
define dso_local i64 addrspace(200)* @add8z3(i64 addrspace(200) *%tmp, i8 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, uxtb #3
  %nidx = zext i8 %idx to i64
  %tmp1 = getelementptr inbounds i64, i64 addrspace(200)* %tmp, i64 %nidx
  ret i64 addrspace(200)* %tmp1
}
; CHECK-LABEL: add8z4
define dso_local i8 addrspace(200)* addrspace(200)* @add8z4(i8 addrspace(200)* addrspace(200) *%tmp, i8 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, uxtb #4
  %nidx = zext i8 %idx to i64
  %tmp1 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %tmp, i64 %nidx
  ret i8 addrspace(200)* addrspace(200)* %tmp1
}
; CHECK-LABEL: add16s0
define dso_local i8 addrspace(200)* @add16s0(i8 addrspace(200) *%tmp, i16 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, sxth
  %tmp1 = getelementptr inbounds i8, i8 addrspace(200)* %tmp, i16 %idx
  ret i8 addrspace(200)* %tmp1
}
; CHECK-LABEL: add16s1
define dso_local i16 addrspace(200)* @add16s1(i16 addrspace(200) *%tmp, i16 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, sxth #1
  %tmp1 = getelementptr inbounds i16, i16 addrspace(200)* %tmp, i16 %idx
  ret i16 addrspace(200)* %tmp1
}
; CHECK-LABEL: add16s2
define dso_local i32 addrspace(200)* @add16s2(i32 addrspace(200) *%tmp, i16 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, sxth #2
  %tmp1 = getelementptr inbounds i32, i32 addrspace(200)* %tmp, i16 %idx
  ret i32 addrspace(200)* %tmp1
}
; CHECK-LABEL: add16s3
define dso_local i64 addrspace(200)* @add16s3(i64 addrspace(200) *%tmp, i16 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, sxth #3
  %tmp1 = getelementptr inbounds i64, i64 addrspace(200)* %tmp, i16 %idx
  ret i64 addrspace(200)* %tmp1
}
; CHECK-LABEL: add16s4
define dso_local i8 addrspace(200)* addrspace(200)* @add16s4(i8 addrspace(200)* addrspace(200) *%tmp, i16 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, sxth #4
  %tmp1 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %tmp, i16 %idx
  ret i8 addrspace(200)* addrspace(200)* %tmp1
}
; CHECK-LABEL: add16z0
define dso_local i8 addrspace(200)* @add16z0(i8 addrspace(200) *%tmp, i16 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, uxth
  %nidx = zext i16 %idx to i64
  %tmp1 = getelementptr inbounds i8, i8 addrspace(200)* %tmp, i64 %nidx
  ret i8 addrspace(200)* %tmp1
}
; CHECK-LABEL: add16z1
define dso_local i16 addrspace(200)* @add16z1(i16 addrspace(200) *%tmp, i16 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, uxth #1
  %nidx = zext i16 %idx to i64
  %tmp1 = getelementptr inbounds i16, i16 addrspace(200)* %tmp, i64 %nidx
  ret i16 addrspace(200)* %tmp1
}
; CHECK-LABEL: add16z2
define dso_local i32 addrspace(200)* @add16z2(i32 addrspace(200) *%tmp, i16 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, uxth #2
  %nidx = zext i16 %idx to i64
  %tmp1 = getelementptr inbounds i32, i32 addrspace(200)* %tmp, i64 %nidx
  ret i32 addrspace(200)* %tmp1
}
; CHECK-LABEL: add16z3
define dso_local i64 addrspace(200)* @add16z3(i64 addrspace(200) *%tmp, i16 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, uxth #3
  %nidx = zext i16 %idx to i64
  %tmp1 = getelementptr inbounds i64, i64 addrspace(200)* %tmp, i64 %nidx
  ret i64 addrspace(200)* %tmp1
}
; CHECK-LABEL: add16z4
define dso_local i8 addrspace(200)* addrspace(200)* @add16z4(i8 addrspace(200)* addrspace(200) *%tmp, i16 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, uxth #4
  %nidx = zext i16 %idx to i64
  %tmp1 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %tmp, i64 %nidx
  ret i8 addrspace(200)* addrspace(200)* %tmp1
}
; CHECK-LABEL: add32s0
define dso_local i8 addrspace(200)* @add32s0(i8 addrspace(200) *%tmp, i32 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, sxtw
  %tmp1 = getelementptr inbounds i8, i8 addrspace(200)* %tmp, i32 %idx
  ret i8 addrspace(200)* %tmp1
}
; CHECK-LABEL: add32s1
define dso_local i16 addrspace(200)* @add32s1(i16 addrspace(200) *%tmp, i32 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, sxtw #1
  %tmp1 = getelementptr inbounds i16, i16 addrspace(200)* %tmp, i32 %idx
  ret i16 addrspace(200)* %tmp1
}
; CHECK-LABEL: add32s2
define dso_local i32 addrspace(200)* @add32s2(i32 addrspace(200) *%tmp, i32 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, sxtw #2
  %tmp1 = getelementptr inbounds i32, i32 addrspace(200)* %tmp, i32 %idx
  ret i32 addrspace(200)* %tmp1
}
; CHECK-LABEL: add32s3
define dso_local i64 addrspace(200)* @add32s3(i64 addrspace(200) *%tmp, i32 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, sxtw #3
  %tmp1 = getelementptr inbounds i64, i64 addrspace(200)* %tmp, i32 %idx
  ret i64 addrspace(200)* %tmp1
}
; CHECK-LABEL: add32s4
define dso_local i8 addrspace(200)* addrspace(200)* @add32s4(i8 addrspace(200)* addrspace(200) *%tmp, i32 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, sxtw #4
  %tmp1 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %tmp, i32 %idx
  ret i8 addrspace(200)* addrspace(200)* %tmp1
}
; CHECK-LABEL: add32z0
define dso_local i8 addrspace(200)* @add32z0(i8 addrspace(200) *%tmp, i32 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, uxtw
  %nidx = zext i32 %idx to i64
  %tmp1 = getelementptr inbounds i8, i8 addrspace(200)* %tmp, i64 %nidx
  ret i8 addrspace(200)* %tmp1
}
; CHECK-LABEL: add32z1
define dso_local i16 addrspace(200)* @add32z1(i16 addrspace(200) *%tmp, i32 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, uxtw #1
  %nidx = zext i32 %idx to i64
  %tmp1 = getelementptr inbounds i16, i16 addrspace(200)* %tmp, i64 %nidx
  ret i16 addrspace(200)* %tmp1
}
; CHECK-LABEL: add32z2
define dso_local i32 addrspace(200)* @add32z2(i32 addrspace(200) *%tmp, i32 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, uxtw #2
  %nidx = zext i32 %idx to i64
  %tmp1 = getelementptr inbounds i32, i32 addrspace(200)* %tmp, i64 %nidx
  ret i32 addrspace(200)* %tmp1
}
; CHECK-LABEL: add32z3
define dso_local i64 addrspace(200)* @add32z3(i64 addrspace(200) *%tmp, i32 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, uxtw #3
  %nidx = zext i32 %idx to i64
  %tmp1 = getelementptr inbounds i64, i64 addrspace(200)* %tmp, i64 %nidx
  ret i64 addrspace(200)* %tmp1
}
; CHECK-LABEL: add32z4
define dso_local i8 addrspace(200)* addrspace(200)* @add32z4(i8 addrspace(200)* addrspace(200) *%tmp, i32 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, w1, uxtw #4
  %nidx = zext i32 %idx to i64
  %tmp1 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %tmp, i64 %nidx
  ret i8 addrspace(200)* addrspace(200)* %tmp1
}
; CHECK-LABEL: add64z0
define dso_local i8 addrspace(200)* @add64z0(i8 addrspace(200) *%tmp, i64 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, x1, uxtx
  %tmp1 = getelementptr inbounds i8, i8 addrspace(200)*  %tmp, i64 %idx
  ret i8 addrspace(200)* %tmp1
}
; CHECK-LABEL: add64z1
define dso_local i16 addrspace(200)* @add64z1(i16 addrspace(200) *%tmp, i64 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, x1, uxtx #1
  %tmp1 = getelementptr inbounds i16, i16 addrspace(200)*  %tmp, i64 %idx
  ret i16 addrspace(200)* %tmp1
}
; CHECK-LABEL: add64z2
define dso_local i32 addrspace(200)* @add64z2(i32 addrspace(200) *%tmp, i64 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, x1, uxtx #2
  %tmp1 = getelementptr inbounds i32, i32 addrspace(200)*  %tmp, i64 %idx
  ret i32 addrspace(200)* %tmp1
}
; CHECK-LABEL: add64z3
define dso_local i64 addrspace(200)* @add64z3(i64 addrspace(200) *%tmp, i64 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, x1, uxtx #3
  %tmp1 = getelementptr inbounds i64, i64 addrspace(200)*  %tmp, i64 %idx
  ret i64 addrspace(200)* %tmp1
}
; CHECK-LABEL: add64z4
define dso_local i8 addrspace(200)* addrspace(200)* @add64z4(i8 addrspace(200)* addrspace(200) *%tmp, i64 %idx) local_unnamed_addr addrspace(200)  {
entry:
; CHECK: add     c0, c0, x1, uxtx #4
  %tmp1 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %tmp, i64 %idx
  ret i8 addrspace(200)* addrspace(200)* %tmp1
}
