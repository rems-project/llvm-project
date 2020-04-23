// RUN: %cheri_purecap_cc1 -fsyntax-only -ast-dump %s | FileCheck %s
// RUN: %clang_cc1 -triple aarch64-none-elf -target-feature +c64 -target-abi purecap -mllvm -cheri-cap-table-abi=pcrel -fsyntax-only -ast-dump %s | FileCheck %s
void snprintf (char * s) { }

template<typename P >
void as_string(P sprintf_like) { }

void to_string() {
  // CHECK: ParmVarDecl {{.*}} {{.*}} {{.*}} sprintf_like 'void (*)(char *)':'void (*)(char *)'
  as_string(snprintf);
}
