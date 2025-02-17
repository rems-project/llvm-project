// RUN: %cheri_purecap_cc1 -analyze -analyzer-checker=core,cheri.ProvenanceSource -verify %s
// RUN: %clang_cc1 -triple aarch64-none-elf -target-feature +morello -target-feature +c64 -target-abi purecap \
// RUN:            -analyze -analyzer-checker=core,cheri.ProvenanceSource -verify %s
// RUN: %check_analyzer_fixit %s %t \
// RUN:   -triple aarch64-none-elf -target-feature +morello -target-feature +c64 -target-abi purecap \
// RUN:   -analyzer-checker=core,cheri.ProvenanceSource \
// RUN:   -analyzer-config cheri.ProvenanceSource:ShowFixIts=true \
// RUN:   -verify=non-nested,nested

typedef __intcap_t intptr_t;
typedef __uintcap_t uintptr_t;
typedef long int ptrdiff_t;
typedef __typeof__(sizeof(int)) size_t;

char left_prov(int d, char *p) {
  intptr_t a = d;
  intptr_t b = (intptr_t)p;

  intptr_t s = b + a; // expected-warning{{Result of '+' on capability type '__intcap'; it is unclear which side should be used as the source of provenance; consider indicating the provenance-carrying argument explicitly by casting the other argument to 'ptrdiff_t'. Note: along this path, LHS was derived from pointer, RHS was derived from NULL}}
                      // expected-warning@-1{{binary expression on capability types 'intptr_t' (aka '__intcap') and 'intptr_t'; it is not clear which should be used as the source of provenance; currently provenance is inherited from the left-hand side}}

  // CHECK-FIXES:      intptr_t s = b + (ptrdiff_t)(a);

  return *(char*)s;// expected-warning{{Capability with ambiguous provenance is used as pointer}}
}

char right_prov(unsigned d, char *p) {
  uintptr_t a = d;
  uintptr_t b = (uintptr_t)p;

  uintptr_t s = a + b; // expected-warning{{Result of '+' on capability type 'unsigned __intcap'; it is unclear which side should be used as the source of provenance. Note: along this path, LHS was derived from NULL, RHS was derived from pointer. Currently, provenance is inherited from LHS, therefore result capability will be invalid}}
                      // expected-warning@-1{{binary expression on capability types 'uintptr_t' (aka 'unsigned __intcap') and 'uintptr_t'; it is not clear which should be used as the source of provenance; currently provenance is inherited from the left-hand side}}

  // CHECK-FIXES:      intptr_t s = (ptrdiff_t)(a) + b;

  return *(char*)s;// expected-warning{{Capability with ambiguous provenance is used as pointer}}
}

char both_prov(int* d, char *p) {
  intptr_t a = (intptr_t)d;
  intptr_t b = (intptr_t)p;

  intptr_t s = a + b; // expected-warning{{Result of '+' on capability type '__intcap'; it is unclear which side should be used as the source of provenance. Note: along this path, LHS and RHS were derived from pointers. Result capability will be derived from LHS by default. This code may need to be rewritten for CHERI}}
                      // expected-warning@-1{{binary expression on capability types 'intptr_t' (aka '__intcap') and 'intptr_t'; it is not clear which should be used as the source of provenance; currently provenance is inherited from the left-hand side}}
  return *(char*)s; // expected-warning{{Capability with ambiguous provenance is used as pointer}}
}

char no_prov(int d, char p) {
  intptr_t a = (intptr_t)d;
  intptr_t b = (intptr_t)p;

  intptr_t s = a + b; // expected-warning{{Result of '+' on capability type '__intcap'; it is unclear which side should be used as the source of provenance; consider indicating the provenance-carrying argument explicitly by casting the other argument to 'ptrdiff_t'. Note: along this path, LHS and RHS were derived from NULL}}
                      // expected-warning@-1{{binary expression on capability types 'intptr_t' (aka '__intcap') and 'intptr_t'; it is not clear which should be used as the source of provenance; currently provenance is inherited from the left-hand side}}

  return *(char*)s; // expected-warning{{Capability with ambiguous provenance is used as pointer}}
}

char right_prov_cond(int d, char *p, int x) {
  intptr_t a = d;

  intptr_t b;
  if (d > 42)
    b = (intptr_t)p;
  else
    b = x;

  intptr_t s = a + b; // expected-warning{{Result of '+' on capability type '__intcap'; it is unclear which side should be used as the source of provenance; consider indicating the provenance-carrying argument explicitly by casting the other argument to 'ptrdiff_t'. Note: along this path, LHS and RHS were derived from NULL}}
                      // expected-warning@-1{{Result of '+' on capability type '__intcap'; it is unclear which side should be used as the source of provenance. Note: along this path, LHS was derived from NULL, RHS was derived from pointer. Currently, provenance is inherited from LHS, therefore result capability will be invalid}}
                      // expected-warning@-2{{binary expression on capability types 'intptr_t' (aka '__intcap') and 'intptr_t'; it is not clear which should be used as the source of provenance; currently provenance is inherited from the left-hand side}}

  return *(char*)s;// expected-warning{{Capability with ambiguous provenance is used as pointer}}
}

intptr_t no_bug(int *p, intptr_t *u) {
  int *d = p + 20;

  intptr_t a = (intptr_t)d;
  *u = a;
  intptr_t b = (intptr_t)p;

  a = b;
  return a;
}

char add_const(int *p, int x) {
  intptr_t a = (intptr_t)p + 42;
  intptr_t b = (intptr_t)x;

  intptr_t s =  a | b; // expected-warning{{Result of '|' on capability type '__intcap'; it is unclear which side should be used as the source of provenance; consider indicating the provenance-carrying argument explicitly by casting the other argument to 'ptrdiff_t'. Note: along this path, LHS was derived from pointer, RHS was derived from NULL}}
                       // expected-warning@-1{{binary expression on capability types 'intptr_t' (aka '__intcap') and 'intptr_t'; it is not clear which should be used as the source of provenance; currently provenance is inherited from the left-hand side}}

  // CHECK-FIXES:      intptr_t s =  a | (ptrdiff_t)(b);

  return *(char*)s; // expected-warning{{Capability with ambiguous provenance is used as pointer}}
}

char add_var(int *p, int x, int c) {
  intptr_t a = (intptr_t)p + c;
  intptr_t b = (intptr_t)x;

  intptr_t s =  a | b; // expected-warning{{Result of '|' on capability type '__intcap'; it is unclear which side should be used as the source of provenance; consider indicating the provenance-carrying argument explicitly by casting the other argument to 'ptrdiff_t'. Note: along this path, LHS was derived from pointer, RHS was derived from NULL}}
                       // expected-warning@-1{{binary expression on capability types 'intptr_t' (aka '__intcap') and 'intptr_t'; it is not clear which should be used as the source of provenance; currently provenance is inherited from the left-hand side}}

  // CHECK-FIXES:      intptr_t s =  a | (ptrdiff_t)(b);

  return *(char*)s; // expected-warning{{Capability with ambiguous provenance is used as pointer}}
}

int * null_derived(int x) {
  intptr_t u = (intptr_t)x;
  return (int*)u; // expected-warning{{NULL-derived capability used as pointer}}
}

uintptr_t fn1(char *str, int f) {
    str++;
    intptr_t x = f;
    return ((intptr_t)str & x);
    // expected-warning@-1{{Result of '&' on capability type '__intcap'; it is unclear which side should be used as the source of provenance; consider indicating the provenance-carrying argument explicitly by casting the other argument to 'ptrdiff_t'. Note: along this path, LHS was derived from pointer, RHS was derived from NULL}}
    // expected-warning@-2{{binary expression on capability types 'intptr_t' (aka '__intcap') and 'intptr_t'; it is not clear which should be used as the source of provenance; currently provenance is inherited from the left-hand side}}

    // CHECK-FIXES:     return ((intptr_t)str & (ptrdiff_t)(x));
}

uintptr_t align_down(void *p, size_t alignment) {
    uintptr_t sz = (uintptr_t)p;
    uintptr_t mask = alignment - 1;
    return (sz & ~mask); // expected-warning{{Result of '&' on capability type 'unsigned __intcap'; it is unclear which side should be used as the source of provenance; consider indicating the provenance-carrying argument explicitly by casting the other argument to 'size_t'. Note: along this path, LHS was derived from pointer, RHS was derived from NULL}}
    // expected-warning@-1{{binary expression on capability types 'uintptr_t' (aka 'unsigned __intcap') and 'uintptr_t'; it is not clear which should be used as the source of provenance; currently provenance is inherited from the left-hand side}}

    // CHECK-FIXES:      return (sz & (size_t)(~mask));
}

char* ptr_diff(char *s1, char *s2) {
  intptr_t a = (intptr_t)s1;
  intptr_t b = (intptr_t)s2;
  intptr_t d = a - b;
  return (char*)d; // expected-warning{{NULL-derived capability used as pointer}}
}

char* ptr_diff2(int x, char *s) {
  intptr_t a = (intptr_t)x;
  intptr_t b = (intptr_t)s;
  intptr_t d = a - b;
  return (char*)d; // expected-warning{{NULL-derived capability used as pointer}}
}

void *fp2(char *p) {
  void *a = (void*)(uintptr_t)p;
  return a;
}

intptr_t fp3(char *s1, char *s2) {
  intptr_t a __attribute__((cheri_no_provenance));
  a = (intptr_t)s1;
  intptr_t b = (intptr_t)s2;
  return a + b; // expected-warning{{Result of '+' on capability type '__intcap'; it is unclear which side should be used as the source of provenance. Note: along this path, LHS and RHS were derived from pointers. Result capability will be derived from LHS by default. This code may need to be rewritten for CHERI}} FIXME: expect no warning
}

uintptr_t fp4(char *str, int f) {
  return ((intptr_t)str & (intptr_t)(f));
}

uintptr_t fn2(char *a, char *b) {
  uintptr_t msk = sizeof (long) - 1;

  uintptr_t x = (uintptr_t)a | (uintptr_t)b;
  // expected-warning@-1{{Result of '|' on capability type 'unsigned __intcap'; it is unclear which side should be used as the source of provenance. Note: along this path, LHS and RHS were derived from pointers. Result capability will be derived from LHS by default. This code may need to be rewritten for CHERI}}
  // expected-warning@-2{{binary expression on capability types 'uintptr_t' (aka 'unsigned __intcap') and 'uintptr_t'; it is not clear which should be used as the source of provenance; currently provenance is inherited from the left-hand side}}

  int ma = x & msk;
  // expected-warning@-1{{Result of '&' on capability type 'unsigned __intcap'; it is unclear which side should be used as the source of provenance; consider indicating the provenance-carrying argument explicitly by casting the other argument to 'size_t'. Note: along this path, RHS was derived from NULL}}
  // expected-warning@-2{{binary expression on capability types 'uintptr_t' (aka 'unsigned __intcap') and 'uintptr_t'; it is not clear which should be used as the source of provenance; currently provenance is inherited from the left-hand side}}

  return ma;
}

char *ptrdiff(char *a, unsigned x) {
  intptr_t ip = ((ptrdiff_t)a | (intptr_t)x);
  char *p = (char*) ip; // expected-warning{{NULL-derived capability used as pointer}}
  return p;
}

int fp5(char *a, unsigned x) {
  void *p = (void*)(uintptr_t)a;
  void *q = (void*)(uintptr_t)x; // no warning -- intentional
  return (char*)p - (char*)q;
}

char* const2ptr(void) {
  return (char*)(-1);
}

void *fn3(size_t x, int y) {
  intptr_t a = (intptr_t)x;
  a += y;
  return (void*)a; // expected-warning{{NULL-derived capability used as pointer}}
}

int * loss_of_prov(int *px) {
  long x = (long)px;
  intptr_t u = (intptr_t)x;
  return (int*)u; // expected-warning{{NULL-derived capability: loss of provenance}}
}

//------------------- Inter-procedural warnings ---------------------

static int *p;

intptr_t get_ptr(void) {
  return (intptr_t)p;

}

intptr_t foo(int d) {
  intptr_t a = d;
  intptr_t b = get_ptr();

  return b + a; // expected-warning{{Result of '+' on capability type '__intcap'; it is unclear which side should be used as the source of provenance; consider indicating the provenance-carrying argument explicitly by casting the other argument to 'ptrdiff_t'. Note: along this path, LHS was derived from pointer, RHS was derived from NULL}}
                // expected-warning@-1{{binary expression on capability types 'intptr_t' (aka '__intcap') and 'intptr_t'; it is not clear which should be used as the source of provenance; currently provenance is inherited from the left-hand side}}

  // CHECK-FIXES:     return b + (ptrdiff_t)(a);
}

intptr_t add(intptr_t a, intptr_t b) {
  return a + b; // expected-warning{{Result of '+' on capability type '__intcap'; it is unclear which side should be used as the source of provenance. Note: along this path, LHS was derived from NULL, RHS was derived from pointer. Currently, provenance is inherited from LHS, therefore result capability will be invalid}}
                // expected-warning@-1{{binary expression on capability types 'intptr_t' (aka '__intcap') and 'intptr_t'; it is not clear which should be used as the source of provenance; currently provenance is inherited from the left-hand side}}

  // CHECK-FIXES:     return (ptrdiff_t)(a) + b;
}

intptr_t bar(int d) {
  intptr_t a = d;
  intptr_t b = get_ptr();

  return add(a, b);
}
