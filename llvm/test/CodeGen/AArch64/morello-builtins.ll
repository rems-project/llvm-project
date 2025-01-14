; RUN: llc -mtriple=arm64 -mattr=+morello -o - %s | FileCheck %s

; CHECK-LABEL: @testBuiltinsWithGPROutput
define i64 @testBuiltinsWithGPROutput(i8 addrspace(200)* %foo, i8 addrspace(200)* %bar) {
entry:
; CHECK-DAG: gclen	{{x[0-9]+}}, c0
  %0 = call i64 @llvm.cheri.cap.length.get(i8 addrspace(200)* %foo)
; CHECK-DAG: gcperm	{{x[0-9]+}}, c0
  %1 = call i64 @llvm.cheri.cap.perms.get(i8 addrspace(200)* %foo)
  %and1 = and i64 %0, %1
; CHECK-DAG: gctype	{{x[0-9]+}}, c0
  %2 = call i64 @llvm.cheri.cap.type.get(i8 addrspace(200)* %foo)
  %and2 = and i64 %and1, %2
; CHECK-DAG: gctag	{{x[0-9]+}}, c0
  %3 = call i1 @llvm.cheri.cap.tag.get(i8 addrspace(200)* %foo)
  %zext3 = zext i1 %3 to i64
  %and3 = and i64 %and2, %zext3
; CHECK-DAG: gcseal	{{x[0-9]+}}, c0
  %4 = call i1 @llvm.cheri.cap.sealed.get(i8 addrspace(200)* %foo)
  %zext4 = zext i1 %4 to i64
  %and4 = and i64 %and3, %zext4
; CHECK-DAG: gcbase	{{x[0-9]+}}, c0
  %5 = call i64 @llvm.cheri.cap.base.get(i8 addrspace(200)* %foo)
  %and7 = and i64 %and4, %5
; CHECK-DAG: gcoff	{{x[0-9]+}}, c0
  %6 = call i64 @llvm.cheri.cap.offset.get(i8 addrspace(200)* %foo)
  %and9 = and i64 %and7, %6
; CHECK-DAG: rrlen	{{x[0-9]+}}, {{x[0-9]+}}
  %7 = call i64 @llvm.morello.round.representable.length.inexact.i64(i64 42)
  %and10 =  and i64 %and9, %7
; CHECK-DAG: rrmask	{{x[0-9]+}}, {{x[0-9]+}}
  %8 = call i64 @llvm.morello.representable.alignment.mask.inexact.i64(i64 42)
  %and11 =  and i64 %and10, %8
; CHECK-DAG: cfhi	{{x[0-9]+}}, c0
  %9 = call i64 @llvm.cheri.cap.copy.from.high.i64(i8 addrspace(200)* %foo)
  %and12 =  and i64 %and11, %9
; CHECK-DAG: cvt       {{x[0-9]+}}, c0, c1
  %10 = call i64 @llvm.morello.convert.to.ptr(i8 addrspace(200)* %foo, i8 addrspace(200)* %bar)
  %and13 = and i64 %and12, %10
  ret i64 %and13
}

; CHECK-LABEL: testRepresentableLength
define i64 @testRepresentableLength(i64 %foo) {
; CHECK:      sub    [[foo_sub_1:x[0-9]+]], x0, #1
; CHECK-NEXT: rrlen  [[rrlen_foo:x[0-9]+]], x0
; CHECK-NEXT: rrlen  [[rrlen_foo_sub_1:x[0-9]+]], [[foo_sub_1]]
; CHECK-NEXT: cmp    [[rrlen_foo_sub_1]], x0
; CHECK-NEXT: csel   x0, x0, [[rrlen_foo]]
  %1 = call i64 @llvm.cheri.round.representable.length.i64(i64 %foo)
  ret i64 %1
}

; CHECK-LABEL: testRepresentableMask
define i64 @testRepresentableMask(i64 %foo) {
; CHECK:      sub    [[foo_sub_1:x[0-9]+]], x0, #1
; CHECK-NEXT: cmp    x0, #0
; CHECK-NEXT: rrlen  [[rrlen_foo_sub_1:x[0-9]+]], [[foo_sub_1]]
; CHECK-NEXT: ccmp   [[rrlen_foo_sub_1]], x0, #0, ne
; CHECK-NEXT: csel   [[selected:x[0-9]+]], [[foo_sub_1]], x0, eq
; CHECK-NEXT: rrmask x0, [[selected]]
  %1 = call i64 @llvm.cheri.representable.alignment.mask.i64(i64 %foo)
  ret i64 %1
}

; CHECK-LABEL: testEqualityCheck
define i32 @testEqualityCheck(i8 addrspace(200)* %foo, i8 addrspace(200)* %bar, i32 %val) {
; CHECK:      chkeq  c0, c1
; CHECK-NEXT: cset   [[reg:w[0-9]+]], eq
; CHECK-NEXT: and    {{w[0-9]+}}, [[reg]], w2
  %1 = call i1 @llvm.cheri.cap.equal.exact(i8 addrspace(200)* %foo, i8 addrspace(200)* %bar)
  %2 = zext i1 %1 to i32
  %3 = and i32 %2, %val
  ret i32 %3
}

; CHECK-LABEL: testSubsetCheck
define i16 @testSubsetCheck(i8 addrspace(200)* %foo, i8 addrspace(200)* %bar, i16 %val) {
; CHECK:      chkss  c0, c1
; CHECK-NEXT: cset   [[reg:w[0-9]+]], mi
; CHECK-NEXT: orr    {{w[0-9]+}}, [[reg]], w2
  %1 = call i1 @llvm.cheri.cap.subset.test(i8 addrspace(200)* %foo, i8 addrspace(200)* %bar)
  %2 = zext i1 %1 to i16
  %3 = or i16 %2, %val
  ret i16 %3
}

declare i64 @llvm.cheri.cap.length.get(i8 addrspace(200)*)
declare i64 @llvm.cheri.cap.perms.get(i8 addrspace(200)*)
declare i64 @llvm.cheri.cap.type.get(i8 addrspace(200)*)
declare i1 @llvm.cheri.cap.tag.get(i8 addrspace(200)*)
declare i1 @llvm.cheri.cap.sealed.get(i8 addrspace(200)*)
declare i64 @llvm.cheri.cap.base.get(i8 addrspace(200)*)
declare i64 @llvm.cheri.cap.offset.get(i8 addrspace(200)*)
declare i64 @llvm.cheri.cap.flags.get(i8 addrspace(200)*)
declare i64 @llvm.cheri.round.representable.length.i64(i64)
declare i64 @llvm.cheri.representable.alignment.mask.i64(i64)
declare i64 @llvm.cheri.cap.copy.from.high.i64(i8 addrspace(200)*)
declare i1 @llvm.cheri.cap.equal.exact(i8 addrspace(200)*, i8 addrspace(200)*)
declare i1 @llvm.cheri.cap.subset.test(i8 addrspace(200)*, i8 addrspace(200)*)
declare i64 @llvm.morello.round.representable.length.inexact.i64(i64)
declare i64 @llvm.morello.representable.alignment.mask.inexact.i64(i64)
declare i64 @llvm.morello.convert.to.ptr(i8 addrspace(200)*, i8 addrspace(200)*)

; CHECK-LABEL: @testBuiltinsWithCapabilityOutput
define i8 addrspace(200)* @testBuiltinsWithCapabilityOutput(i8 addrspace(200)* %foo) {
entry:
; CHECK: clrperm	[[C0:c[0-9]+]], c0, {{x[0-9]+}}
; CHECK: seal	[[C1:c[0-9]+]], c0, [[C0]]
; CHECK: unseal	[[C2:c[0-9]+]], c0, [[C1]]
; CHECK: scbnds	[[C3:c[0-9]+]], [[C2]], #42
; CHECK: clrtag	[[C4:c[0-9]+]], [[C3]]
; CHECK: scoff	[[C5:c[0-9]+]], [[C4]], {{x[0-9]+}}
; CHECK: scbnds	[[C3:c[0-9]+]], [[C2]], #11
; CHECK: cthi	[[C8:c[0-9]+]], [[C3]], {{x[0-9]+}}
; CHECK: chkssu [[C9:c[0-9]+]], [[C8]], c0
; CHECK: cset   [[sealed:w[0-9]+]], mi
; CHECK: cmp    [[sealed]], #0
; CHECK: csel   [[C10:c[0-9]+]], [[C9]], czr, ne
; CHECK: cvtz   [[C11:c[0-9]+]], [[C10]], {{x[0-9]+}}
  %C0 = call i8 addrspace(200)* @llvm.cheri.cap.perms.and(i8 addrspace(200)* %foo, i64 12)
  %C1 = call i8 addrspace(200)* @llvm.cheri.cap.seal(i8 addrspace(200)* %foo, i8 addrspace(200)* %C0)
  %C2 = call i8 addrspace(200)* @llvm.cheri.cap.unseal(i8 addrspace(200)* %foo, i8 addrspace(200)* %C1)
  %C3 = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set(i8 addrspace(200)* %C2, i64 42)
  %C4 = call i8 addrspace(200)* @llvm.cheri.cap.tag.clear(i8 addrspace(200)* %C3)
  %C5 = call i8 addrspace(200)* @llvm.cheri.cap.offset.set(i8 addrspace(200)* %C4, i64 22)
  %C6 = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact(i8 addrspace(200)* %C5, i64 11)
  %C7 = call i8 addrspace(200)* @llvm.cheri.cap.copy.to.high.i64(i8 addrspace(200)* %C6, i64 19)
  %C8 = call {i8 addrspace(200)*, i1} @llvm.morello.subset.test.unseal(i8 addrspace(200)* %C7, i8 addrspace(200)* %foo)
  %C9 = extractvalue {i8 addrspace(200)*, i1} %C8, 0
  %C10 = extractvalue {i8 addrspace(200)*, i1} %C8, 1
  %C11 = select i1 %C10, i8 addrspace(200)* %C9, i8 addrspace(200)* null
  %C12 = call i8 addrspace(200)* @llvm.morello.convert.to.offset.null.cap.zero.semantics(i8 addrspace(200)* %C11, i64 4096)
  ret i8 addrspace(200)* %C12
}

declare i8 addrspace(200)* @llvm.cheri.cap.perms.and(i8 addrspace(200)*, i64)
declare i8 addrspace(200)* @llvm.cheri.cap.seal(i8 addrspace(200)*, i8 addrspace(200)*)
declare i8 addrspace(200)* @llvm.cheri.cap.unseal(i8 addrspace(200)*, i8 addrspace(200)*)
declare i8 addrspace(200)* @llvm.cheri.cap.bounds.set(i8 addrspace(200)*, i64)
declare i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact(i8 addrspace(200)*, i64)
declare i8 addrspace(200)* @llvm.cheri.bounded.stack.cap(i8 addrspace(200)*, i64)
declare i8 addrspace(200)* @llvm.cheri.cap.tag.clear(i8 addrspace(200)*)
declare i8 addrspace(200)* @llvm.cheri.cap.offset.set(i8 addrspace(200)*, i64)
declare i8 addrspace(200)* @llvm.cheri.cap.flags.set(i8 addrspace(200)*, i64)
declare i8 addrspace(200)* @llvm.cheri.cap.copy.to.high.i64(i8 addrspace(200)*, i64)
declare {i8 addrspace(200)*, i1} @llvm.morello.subset.test.unseal(i8 addrspace(200)*, i8 addrspace(200)*)
declare i8 addrspace(200)* @llvm.morello.convert.to.offset.null.cap.zero.semantics(i8 addrspace(200)*, i64)

; CHECK-LABEL: testBoundedStackCapImm
define i8 addrspace(200)* @testBoundedStackCapImm(i8 addrspace(200)* %foo) {
; CHECK: scbnds c0, c0, #11
  %C = call i8 addrspace(200)* @llvm.cheri.bounded.stack.cap(i8 addrspace(200)* %foo, i64 11)
  ret i8 addrspace(200)* %C
}

; CHECK-LABEL: testBoundedStackCapReg
define i8 addrspace(200)* @testBoundedStackCapReg(i8 addrspace(200)* %foo, i64 %val) {
; CHECK: scbnds c0, c0, x1
  %C = call i8 addrspace(200)* @llvm.cheri.bounded.stack.cap(i8 addrspace(200)* %foo, i64 %val)
  ret i8 addrspace(200)* %C
}


; CHECK-LABEL: @testGetProgramCounter
define i8 addrspace(200)* @testGetProgramCounter() {
entry:
; CHECK:      adr       x[[ADDR:[0-9]+]], #0
; CHECK-NEXT: cvtp      c0, x[[ADDR]]
  %PCC = call i8 addrspace(200)* @llvm.cheri.pcc.get()
  ret i8 addrspace(200)* %PCC
}

declare i8 addrspace(200)* @llvm.cheri.pcc.get()

; CHECK-LABEL: @testGetCapFromPointer
define i8 addrspace(200)* @testGetCapFromPointer(i8 addrspace(200)* %gcap, i64 %p) {
entry:
; CHECK: cvt	c0, c0, x1
  %cap = call i8 addrspace(200)* @llvm.cheri.cap.from.pointer.nonnull.zero(i8 addrspace(200)* %gcap, i64 %p);
  ret i8 addrspace(200)* %cap
}

; CHECK-LABEL: @testGetCapFromPointerNullZero
define i8 addrspace(200)* @testGetCapFromPointerNullZero(i8 addrspace(200)* %gcap, i64 %p) {
entry:
; CHECK: cvtz	c0, c0, x1
  %cap = call i8 addrspace(200)* @llvm.cheri.cap.from.pointer(i8 addrspace(200)* %gcap, i64 %p);
  ret i8 addrspace(200)* %cap
}

declare i8 addrspace(200)* @llvm.cheri.cap.from.pointer(i8 addrspace(200)*, i64)
declare i8 addrspace(200)* @llvm.cheri.cap.from.pointer.nonnull.zero(i8 addrspace(200)*, i64)

; CHECK-LABEL: @testGetDDC
define i8 addrspace(200)* @testGetDDC() {
entry:
; CHECK: mrs c0, DDC
  %ddc = tail call i8 addrspace(200)* @llvm.cheri.ddc.get()
  ret i8 addrspace(200)* %ddc
}

declare i8 addrspace(200)* @llvm.cheri.ddc.get()

; CHECK-LABEL: @testCapDiff
define i64 @testCapDiff(i8 addrspace(200)* %a, i8 addrspace(200)* %b) {
entry:
; CHECK-NOT: gcvalue
; CHECK: sub x0, {{x[0-9]+}}, {{x[0-9]+}}
  %diff = tail call i64 @llvm.cheri.cap.diff(i8 addrspace(200)* %a, i8 addrspace(200)* %b)
  ret i64 %diff
}

declare i64 @llvm.cheri.cap.diff(i8 addrspace(200)*, i8 addrspace(200)*)

; CHECK-LABEL: @buildcap
define i8 addrspace(200) *@buildcap(i8 addrspace(200)* %auth, i8 addrspace(200)* %bits) {
entry:
; CHECK: build c1, c1, c0
; CHECK-NEXT: cpytype c1, c1, c0
; CHECK-NEXT: cseal c0, c1, c0
  %newcap = call i8 addrspace(200)* @llvm.cheri.cap.build(i8 addrspace(200)* %auth, i8 addrspace(200)* %bits)
  %newcap1 = call i8 addrspace(200)* @llvm.cheri.cap.type.copy(i8 addrspace(200)* %newcap, i8 addrspace(200)* %auth)
  %newcap2 = call i8 addrspace(200)* @llvm.cheri.cap.conditional.seal(i8 addrspace(200)* %newcap1, i8 addrspace(200)* %auth)
  ret i8 addrspace(200)* %newcap2
}

; CHECK-LABEL: setbounds_imm0
define i8 addrspace(200)* @setbounds_imm0(i8 addrspace(200)* %in) {
; CHECK: scbnds	c0, c0, #63
  %ret = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set(i8 addrspace(200)* %in, i64 63)
  ret i8 addrspace(200)* %ret
}

; CHECK-LABEL: setbounds_imm1
define i8 addrspace(200)* @setbounds_imm1(i8 addrspace(200)* %in) {
; CHECK: scbnds	c0, c0, #4, lsl #4
  %ret = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set(i8 addrspace(200)* %in, i64 64)
  ret i8 addrspace(200)* %ret
}

; CHECK-LABEL: setbounds_imm2
define i8 addrspace(200)* @setbounds_imm2(i8 addrspace(200)* %in) {
; CHECK: mov w[[REG:[0-9]+]], #65
; CHECK: scbnds c0, c0, x[[REG]]
  %ret = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set(i8 addrspace(200)* %in, i64 65)
  ret i8 addrspace(200)* %ret
}

; CHECK-LABEL: setbounds_imm3
define i8 addrspace(200)* @setbounds_imm3(i8 addrspace(200)* %in) {
; CHECK: scbnds	c0, c0, #63, lsl #4
  %ret = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact(i8 addrspace(200)* %in, i64 1008)
  ret i8 addrspace(200)* %ret
}

; CHECK-LABEL: setbounds_imm4
define i8 addrspace(200)* @setbounds_imm4(i8 addrspace(200)* %in) {
; CHECK: mov w[[REG:[0-9]+]], #1024
; CHECK: scbnds c0, c0, x[[REG]]
  %ret = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set(i8 addrspace(200)* %in, i64 1024)
  ret i8 addrspace(200)* %ret
}

; CHECK-LABEL: setbounds_reg
define i8 addrspace(200)* @setbounds_reg(i8 addrspace(200)* %in, i64 %len) {
; CHECK: scbnds c0, c0, x1
  %ret = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set(i8 addrspace(200)* %in, i64 %len)
  ret i8 addrspace(200)* %ret
}

; CHECK-LABEL: setbounds_exact_reg
define i8 addrspace(200)* @setbounds_exact_reg(i8 addrspace(200)* %in, i64 %len) {
; CHECK: scbndse c0, c0, x1
  %ret = call i8 addrspace(200)* @llvm.cheri.cap.bounds.set.exact(i8 addrspace(200)* %in, i64 %len)
  ret i8 addrspace(200)* %ret
}

; CHECK-LABEL: seal_entry
define i8 addrspace(200)* @seal_entry(i8 addrspace(200)* %in) {
; CHECK: seal c0, c0, rb
  %ret = call i8 addrspace(200)* @llvm.cheri.cap.seal.entry(i8 addrspace(200)* %in)
  ret i8 addrspace(200)* %ret
}

; CHECK-LABEL: load_tags64
define i64 @load_tags64(i8* %ptr) {
; CHECK: ldct x0, [x0]
  %ret = call i64 @llvm.cheri.cap.load.tags.i64.p0i8(i8* %ptr)
  ret i64 %ret
}

; CHECK-LABEL: load_tags32
define i32 @load_tags32(i8* %ptr) {
; CHECK: ldct x0, [x0]
  %ret = call i32 @llvm.cheri.cap.load.tags.i32.p0i8(i8* %ptr)
  ret i32 %ret
}

; CHECK-LABEL: load_tags128
define i128 @load_tags128(i8* %ptr) {
; CHECK: ldct x0, [x0]
; CHECK: mov x1, xzr
  %ret = call i128 @llvm.cheri.cap.load.tags.i128.p0i8(i8* %ptr)
  ret i128 %ret
}

; CHECK-LABEL: load_tags16
define i16 @load_tags16(i8* %ptr) {
; CHECK: ldct x0, [x0]
  %ret = call i16 @llvm.cheri.cap.load.tags.i16.p0i8(i8* %ptr)
  ret i16 %ret
}

; CHECK-LABEL: get_flags
define i64 @get_flags(i8 addrspace(200)* %ptr) {
  ; CHECK: mov x0, xzr
  ; CHECK-NEXT: ret
  %ret = call i64 @llvm.cheri.cap.flags.get(i8 addrspace(200)* %ptr)
  ret i64 %ret
}

; CHECK-LABEL: set_flags
define i8 addrspace(200)* @set_flags(i64 %val, i8 addrspace(200)* %ptr) {
  ; CHECK: mov c0, c1
  ; CHECK-NEXT: ret
  %ret = call i8 addrspace(200)* @llvm.cheri.cap.flags.set(i8 addrspace(200)* %ptr, i64 %val)
  ret i8 addrspace(200)* %ret
}

declare i16 @llvm.cheri.cap.load.tags.i16.p0i8(i8*)
declare i128 @llvm.cheri.cap.load.tags.i128.p0i8(i8*)
declare i32 @llvm.cheri.cap.load.tags.i32.p0i8(i8*)
declare i64 @llvm.cheri.cap.load.tags.i64.p0i8(i8*)
declare i8 addrspace(200)* @llvm.cheri.cap.seal.entry(i8 addrspace(200)*)
declare i8 addrspace(200)* @llvm.cheri.cap.build(i8 addrspace(200)*, i8 addrspace(200)*)
declare i8 addrspace(200)* @llvm.cheri.cap.type.copy(i8 addrspace(200)*, i8 addrspace(200)*)
declare i8 addrspace(200)* @llvm.cheri.cap.conditional.seal(i8 addrspace(200)*, i8 addrspace(200)*)
