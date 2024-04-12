// RUN: %clang_cc1 -triple aarch64-none-elf -target-feature +morello -target-feature +c64 -target-abi purecap \
// RUN: -analyze -analyzer-checker=core,alpha.cheri.Allocation \
// RUN:     -verify %s

int *p;

void test1(void)
{
  const int x = (p = (int*)&x, 42);  // expected-warning{{Const qualifier discarded}}
  // expected-warning@-1{{Address taken}}
  *p = 22; // UB
  p = 0; // prevent local addr escape
}

int func(int *q)
{
  p = q;
  return 42;
}

void test2(void)
{
  const int x = func((int*)&x); // expected-warning{{Const qualifier discarded}}
  // expected-warning@-1{{Address taken in function call}}
  // expected-warning@-2{{Address taken}}
  *p = 22; // UB
  p = 0; // prevent local addr escape
}

void test3(void)
{
  const char *cP;
  const int x = (cP = (const char *)&x, 42);  // expected-warning{{Address taken}}
}
