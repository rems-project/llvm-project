// RUN: %cheri_purecap_cc1 -mllvm -cheri-cap-table-abi=pcrel -std=c++11 -fcxx-exceptions -fexceptions -o - -O0 -emit-llvm %s | FileCheck %s -check-prefixes CHECK

// Also check that we can emit assembly code without asserting:
// RXUN: %cheri_purecap_cc1 -mllvm -cheri-cap-table-abi=pcrel -std=c++11 -fcxx-exceptions -fexceptions -o - -O2 -S %s | %cheri_FileCheck %s -check-prefixes ASM

class a {
public:
  static a b;
};
class c {
public:
  c(int *, a);
};
int d;
// CHECK: define dso_local void @_Z3fn1v() {{.+}} personality i8 addrspace(200)* bitcast (i32 (...) addrspace(200)* @__gxx_personality_v0 to i8 addrspace(200)*)
void fn1() {
  // Invoke c::c(int* cap, a)
  // CHECK:       invoke void @_ZN1cC1EPi1a(%class.c addrspace(200)* noundef nonnull align 1 dereferenceable(1) %0, i32 addrspace(200)* noundef @d, i8 inreg %3)
  // CHECK-NEXT:  to label %[[INVOKE_CONT:.+]] unwind label %lpad
  // CHECK: [[INVOKE_CONT]]
  // CHECK-NEXT: ret void
  new c(&d, a::b);
}

// CHECK: declare i32 @__gxx_personality_v0(...)

// ASM: .type	DW.ref.__gxx_personality_v0,@object
// ASM: .size	DW.ref.__gxx_personality_v0, [[#CAP_SIZE]]
// ASM: DW.ref.__gxx_personality_v0:
// ASM:	.chericap	__gxx_personality_v0
