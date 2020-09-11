// RUN: %clang %s -target aarch64-none-linux-gnu -march=morello -S -emit-llvm -o - | FileCheck %s

void* __capability results[16];

long long test(void* __capability foo, void* __capability bar) {
  long long x = 42;
  int i = 0;

// CHECK: call i1 @llvm.cheri.cap.equal.exact
// CHECK: call i1 @llvm.cheri.cap.subset.test
// CHECK: call i8 addrspace(200)* @llvm.morello.subset.test.unseal
// CHECK: call i64 @llvm.morello.convert.to.ptr
// CHECK: call i8 addrspace(200)* @llvm.morello.convert.to.offset.null.cap.zero.semantics

  if (__builtin_cheri_equal_exact(foo, bar) || __builtin_cheri_subset_test(foo, bar))
    results[i++] = __builtin_morello_chkssu(foo, bar);

  x &= __builtin_morello_cvt(foo, bar);
  results[i++] = __builtin_morello_cvtz(foo, x);

  return x;
}

