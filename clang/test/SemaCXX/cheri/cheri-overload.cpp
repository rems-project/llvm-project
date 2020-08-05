// RUN: %cheri_cc1 -std=c++11 -o - %s -fsyntax-only -verify

// expected-no-diagnostics

template <typename Element>
long long bar(const void* __capability p) {
  return reinterpret_cast<long long>(p) & (sizeof(Element) - 1);
}
template <typename Element>
long long bar(const void *p) {
  return reinterpret_cast<long long>(p) & (sizeof(Element) - 1);
}

// Implicit conversion from capabilities to pointers is invalid, so we
// shouldn't diagnose the calls to bar as ambiguous.
long long foo(void *__capability dst0) {
 long long call = bar<__intcap_t>(dst0); // ok
 return call;
}

long long foo_ptr(void *dst0) {
 long long call = bar<__intcap_t>(dst0); // ok
 return call;
}
