// RUN: %cheri_purecap_cc1 -fsyntax-only -ast-dump %s | FileCheck %s
// RUN: %clang_cc1 -triple aarch64-none-elf -target-feature +c64 -target-abi purecap -mllvm -cheri-cap-table-abi=pcrel -fsyntax-only -ast-dump %s | FileCheck %s

typedef unsigned long size_t;

const char * collatenames[] = { "A" };

template <size_t _Np>
const char** begin(const char * (&__array)[_Np]) {
  // CHECK: FunctionDecl {{.*}} {{.*}} {{.*}} used begin 'const char **(const char *(&)[1])'
  return __array;
}

int main(void) {
  begin(collatenames);
  return 0;
}
