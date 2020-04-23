// RUN: %clang_cc1 -triple cheri-unknown-freebsd -target-abi n64 -fsyntax-only -verify %s

int *testReturnValue11(int * __capability i) {
    return i; // expected-error{{cannot initialize return object of type 'int *' with an lvalue of type 'int * __capability'}}
}

int * __capability testReturnValue2(int *i) {
    return i; // expected-warning{{converting non-capability type 'int *' to capability type 'int * __capability' without an explicit cast; if this is intended use __cheri_tocap}}
}

int *v;
int * __capability vc;

void testAssignments(int * __capability i, int * j) {
    v = i; // expected-error{{converting capability type 'int * __capability' to non-capability type 'int *' without an explicit cast; if this is intended use __cheri_fromcap}}
    vc = j; // expected-warning{{converting non-capability type 'int *' to capability type 'int * __capability' without an explicit cast; if this is intended use __cheri_tocap}}
}

typedef int *__capability (*fun_c)(int *__capability p);

extern int *ff1(int *p);
extern int *ff2(int *__capability p);
extern int *__capability ff3(int *p);

void funp_bug(void) {
  fun_c fc1;
  fc1 = ff1; // expected-error{{assigning to 'fun_c' (aka 'int * __capability (*)(int * __capability)') from incompatible type 'int *(int *)': type mismatch at 1st parameter}}

  fun_c fc2;
  fc2 = ff2; // expected-error{{assigning to 'fun_c' (aka 'int * __capability (*)(int * __capability)') from incompatible type 'int *(int * __capability)': different return type}}

  fun_c fc3;
  fc3 = ff3; // expected-error{{assigning to 'fun_c' (aka 'int * __capability (*)(int * __capability)') from incompatible type 'int * __capability (int *)': type mismatch at 1st parameter}}
}

