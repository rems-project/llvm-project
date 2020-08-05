// RUN: %cheri_cc1 -DNO_ARGS=1  -fsyntax-only -verify %s -target-abi purecap
// RUN: %cheri_cc1 -DPTR_PTR=1  -fsyntax-only -verify %s -target-abi purecap
// RUN: %cheri_cc1 -DCONST_PTR_PTR=1  -fsyntax-only -verify %s -target-abi purecap
// RUN: %cheri_cc1 -DARR_PTR=1  -fsyntax-only -verify %s -target-abi purecap
// RUN: %cheri_cc1 -DCONST_ARR_PTR=1  -fsyntax-only -verify %s -target-abi purecap
// RUN: %clang_cc1 -DNO_ARGS=1 -triple aarch64-none-linux-gnu -fsyntax-only -verify %s -target-feature +c64 -target-abi purecap -mllvm -cheri-cap-table-abi=pcrel
// RUN: %clang_cc1 -DPTR_PTR=1 -triple aarch64-none-linux-gnu -fsyntax-only -verify %s -target-feature +c64 -target-abi purecap -mllvm -cheri-cap-table-abi=pcrel
// RUN: %clang_cc1 -DCONST_PTR_PTR=1 -triple aarch64-none-linux-gnu -fsyntax-only -verify %s -target-feature +c64 -target-abi purecap -mllvm -cheri-cap-table-abi=pcrel
// RUN: %clang_cc1 -DARR_PTR=1 -triple aarch64-none-linux-gnu -fsyntax-only -verify %s -target-feature +c64 -target-abi purecap -mllvm -cheri-cap-table-abi=pcrel
// RUN: %clang_cc1 -DCONST_ARR_PTR=1 -triple aarch64-none-linux-gnu -fsyntax-only -verify %s -target-feature +c64 -target-abi purecap -mllvm -cheri-cap-table-abi=pcrel

// expected-no-diagnostics

// Ensure various legal main function prototypes are accepted.

#ifdef NO_ARGS
int main() {
  return 0;
}
#endif

#ifdef PTR_PTR
int main(int argc, char **argv) {
  return 0;
}
#endif

#ifdef CONST_PTR_PTR
int main(int argc, const char * const *argv) {
  return 0;
}
#endif

#ifdef ARR_PTR
int main(int argc, char* argv[]) {
  return 0;
}
#endif

#ifdef CONST_ARR_PTR
int main(int argc, const char* argv[]) {
  return 0;
}
#endif
