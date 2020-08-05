// RUN: %cheri_purecap_cc1 -emit-llvm -o - %s | FileCheck %s
// RUN: %clang_cc1 -triple aarch64-none-elf -target-feature +c64 -target-abi purecap -mllvm -cheri-cap-table-abi=pcrel -emit-llvm -o - %s | FileCheck %s

class time_point {
  public:
    // CHECK: call void @_ZN10time_pointC1Ev(%class.time_point addrspace(200)* @t1)
    time_point() { }
};

time_point t1;
