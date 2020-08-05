// RUN: %cheri_purecap_cc1 -fsyntax-only -verify %s
// RUN: %clang_cc1 -triple aarch64-none-elf -target-feature +c64 -target-abi purecap -mllvm -cheri-cap-table-abi=pcrel -fsyntax-only -verify %s
// expected-no-diagnostics

void* operator new(unsigned long);
void operator delete(void*);
