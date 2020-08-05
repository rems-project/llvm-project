// RUN: %clang -target cheri-unknown-freebsd -mabi=purecap  %s -O0 -S -emit-llvm -o - | FileCheck %s
// XFAIL: *

// CHECK: @some_global = common addrspace(200) global i8 addrspace(200)* null, align 16
// CHECK: llvm.global.annotations = appending global [1 x { i8*, i8 addrspace(200)*, i8 addrspace(200)*, i32 }] [{ i8*, i8 addrspace(200)*, i8 addrspace(200)*, i32 } { i8* addrspacecast (i8 addrspace(200)* bitcast (i8 addrspace(200)* addrspace(200)* @some_global to i8 addrspace(200)*) to i8*), i8 addrspace(200)* getelementptr inbounds ([17 x i8], [17 x i8] addrspace(200)* @.str, i32 {{[0-9]+}}, i32 {{[0-9]+}}), i8 addrspace(200)* getelementptr inbounds ([89 x i8], [89 x i8] addrspace(200)* @.str.1, i32 {{[0-9]+}}, i32 {{[0-9]+}}), i32 {{[0-9]+}} }], section "llvm.metadata"

#define __INTRODUCED_IN(api_level)  __attribute__((annotate("introduced_in=" #api_level)))

void *some_global __INTRODUCED_IN(23);

