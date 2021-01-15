// RUN: %clang_cc1 -triple cheri-unknown-freebsd -target-abi n64 -fsyntax-only -verify %s

int *gi;
void *v;
void *__capability vc;

void test() {
  int nums[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};

  void *__capability test_void2 = gi; // expected-error{{converting non-capability type 'int *' to capability type 'void * __capability' without an explicit cast; if this is intended use __cheri_tocap}}

  int *__capability test_vc1 = gi; // expected-warning{{converting non-capability type 'int *' to capability type 'int * __capability' without an explicit cast; if this is intended use __cheri_tocap}}
  int *__capability test_vc2 = v; // expected-error{{cannot implicitly or explicitly convert non-capability type 'void *' to unrelated capability type 'int * __capability'}}
  void *__capability test_vc3 = v; // expected-warning{{converting non-capability type 'void *' to capability type 'void * __capability' without an explicit cast; if this is intended use __cheri_tocap}}
  void * test_vc4 = vc; // expected-error{{converting capability type 'void * __capability &' to non-capability type 'void *' without an explicit cast}}
}
