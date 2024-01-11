// RUN: %cheri_purecap_cc1 -emit-llvm -o - %s | FileCheck %s

// CHECK: @_ZL3barv = ifunc i8 addrspace(200)* (), bitcast (i8 addrspace(200)* () addrspace(200)* @bar_ifun to i8 addrspace(200)* () addrspace(200)* () addrspace(200)*)
// CHECK: define dso_local i8 addrspace(200)* @foo() addrspace(200)
// CHECK: define dso_local i8 addrspace(200)* @bar_ifun() addrspace(200)

static const char* bar() __attribute__ ((ifunc("bar_ifun")));
extern "C" const char* foo() {
  return bar();
}

extern "C" void* bar_ifun() {
  return nullptr;
}

