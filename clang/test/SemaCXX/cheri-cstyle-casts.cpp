// RUN: %clang_cc1 -triple cheri-unknown-freebsd -target-abi n64 -fsyntax-only -ast-dump %s | FileCheck %s

int * __capability test1(int *i) {
  // CHECK: CStyleCastExpr {{.*}} {{.*}} 'int * __capability' <PointerToCHERICapability>
  return (__cheri_tocap int * __capability) i;
}

int * test2(int * __capability i) {
  // CHECK: CStyleCastExpr {{.*}} {{.*}} 'int *' <CHERICapabilityToPointer>
  return (__cheri_fromcap int *) i;
}

int *v;
int * __capability vc;

void test3(int * __capability i, int * j) {
  // CHECK: CStyleCastExpr {{.*}} {{.*}} 'int *' <CHERICapabilityToPointer>
  v = (__cheri_fromcap int *)i;
  // CHECK: CStyleCastExpr {{.*}} {{.*}} 'int * __capability' <PointerToCHERICapability>
  vc = (__cheri_tocap int *__capability)j;
}
