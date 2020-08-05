// RUN: %clang -O2 -target aarch64-none-linux-gnu -march=morello -S -o - %s | FileCheck %s
//
// FIXME: Test call thru capability. This is done as a clang test
// because ... the IR parser fails at reading the IR. Once this is
// fixed, this test should be moved to llvm/test/Codegen/AArch64

typedef  int (*__capability cfunc)(int a, int b) ;

// CHECK-LABEL: testCallThruCap
int testCallThruCap(cfunc f, int a, int b, int c) {
  return c + f(a, b);
// CHECK: blr	{{c[0-9]+}}
}

// CHECK-LABEL: testTailCallThruCap
int testTailCallThruCap(cfunc f, int a, int b) {
  return f(a,b);
// CHECK: br	{{c[0-9]+}}
}
