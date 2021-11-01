// RUN: %cheri_purecap_cc1 %s -o - -emit-llvm | %cheri_FileCheck %s --check-prefix=nopic
// RUN: %clang %s -target aarch64-none-linux-gnu -march=morello+c64 -mabi=purecap -o - -emit-llvm -S -fPIC | %cheri_FileCheck %s --check-prefix=pic

// nopic: @x = dso_local addrspace(200) global i8 addrspace(200)* getelementptr (i8, i8 addrspace(200)* null, i64 1), align [[#CAP_SIZE]]
// pic: @x = addrspace(200) global i8 addrspace(200)* getelementptr (i8, i8 addrspace(200)* null, i64 1), align [[#CAP_SIZE]]
__intcap_t x = 1;
// nopic: @y = dso_local addrspace(200) global i8 addrspace(200)* getelementptr (i8, i8 addrspace(200)* null, i64 1), align [[#CAP_SIZE]]
// pic: @y = addrspace(200) global i8 addrspace(200)* getelementptr (i8, i8 addrspace(200)* null, i64 1), align [[#CAP_SIZE]]
void *y = (void*)1;
