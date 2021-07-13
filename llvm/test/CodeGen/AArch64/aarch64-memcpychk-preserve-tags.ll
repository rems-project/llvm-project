; RUN: opt -S -instcombine -mtriple=arm64 -o - %s | FileCheck %s

; CHECK-NOT: must_preserve_cheri_tags

define void @baz(i8 * %dst, i8 * %src)  {
entry:
  %call.i = tail call i8 * @__memcpy_chk(i8 * %dst, i8 * %src, i64 32, i64 32)
  ret void
}

define void @foo(i8 * %dst, i8 * %src, i32 %size)  {
entry:
  %call.i = tail call i8 * @__memcpy_chk(i8 * %dst, i8 * %src, i64 32, i64 32)
  ret void
}

define void @bazmove(i8 * %dst, i8 * %src)  {
entry:
  %call.i = tail call i8 * @__memmove_chk(i8 * %dst, i8 * %src, i64 32, i64 32)
  ret void
}

define void @foomove(i8 * %dst, i8 * %src, i32 %size)  {
entry:
  %call.i = tail call i8 * @__memmove_chk(i8 * %dst, i8 * %src, i64 32, i64 32)
  ret void
}

declare i8 * @__memcpy_chk(i8 *, i8 *, i64, i64)
declare i8 * @__memmove_chk(i8 *, i8 *, i64, i64)
declare i64 @llvm.objectsize.i64.p0i8(i8 *, i1)
