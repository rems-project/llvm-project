// RUN: %clang_cc1 -triple cheri-unknown-freebsd -fsyntax-only -verify %s

// expected-no-diagnostics
int f() {
   void * __capability c1;
   void * __capability c2;
   if (c1 == c2) return f();
   return 0;
}
