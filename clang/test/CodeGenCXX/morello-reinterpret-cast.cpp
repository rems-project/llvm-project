// RUN: %clang_cc1 -triple aarch64-none-elf -target-feature +c64 -target-abi purecap -mllvm -cheri-cap-table-abi=pcrel -o - %s -std=c++11

unsigned long f2() {
  return reinterpret_cast<unsigned long>(nullptr);
}

__intcap_t f3(void *p) {
  return reinterpret_cast<__intcap_t>(p);
}

void f4(int*&);
void f5(void*& u) {
  f4(reinterpret_cast<int*&>(u));
}
