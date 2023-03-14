// RUN: %cheri_cc1 -std=c++11 -o - %s -emit-llvm | FileCheck %s
template <typename Element>
long long bar(const void* __capability p) {
  return reinterpret_cast<long long>(p) & (sizeof(Element) - 1);
}
template <typename Element>
long long bar(const void *p) {
  return reinterpret_cast<long long>(p) & (sizeof(Element) - 1);
}

// Make sure that we pick the overload which doesn't change the
// __capability qualifier.
// CHECK-LABEL: _Z3fooU12__capabilityPv
// CHECK: call noundef i64 @_Z3barIu10__intcap_tExU12__capabilityPKv
long long foo(void *__capability dst0) {
 long long call = bar<__intcap_t>(dst0);
 return call;
}

// CHECK-LABEL: _Z7foo_ptrPv
// CHECK: call noundef i64 @_Z3barIu10__intcap_tExPKv
long long foo_ptr(void *dst0) {
 long long call = bar<__intcap_t>(dst0);
 return call;
}
