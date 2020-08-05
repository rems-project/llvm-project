// RUN: %cheri_purecap_cc1 -emit-llvm -o - %s | FileCheck %s

// CHECK: @_ZL3barv = ifunc i8 addrspace(200)* (), i8 addrspace(200)* () addrspace(200)* @bar_ifun
// CHECK: define i8 addrspace(200)* @bar_ifun() addrspace(200)
// CHECK: define i8 addrspace(200)* @foo() addrspace(200)


static const char* bar() __attribute__ ((ifunc("bar_ifun")));
extern "C" const char* foo() {
  return bar();
}

extern "C" void* bar_ifun() {
  return nullptr;
}

