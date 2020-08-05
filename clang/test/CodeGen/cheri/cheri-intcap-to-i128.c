// RUN: %cheri_cc1  %s -emit-llvm -o - -O2 | FileCheck %s

__uint128_t foo(__uintcap_t *x) {
// CHECK-LABEL: foo
// CHECK: zext
  return (__uint128_t)*x;
}

__uint128_t bar(__intcap_t *x) {
// CHECK-LABEL: bar
// CHECK: sext
  return (__uint128_t)*x;
}

__int128_t baz(__uintcap_t *x) {
// CHECK-LABEL: baz
// CHECK: zext
  return (__int128_t)*x;
}

__int128_t qux(__intcap_t *x) {
// CHECK-LABEL: qux
// CHECK: sext
  return (__int128_t)*x;
}
