// RUN: %clang -target aarch64-none-elf -march=morello+c64 -mabi=purecap -Xclang -morello-vararg=legacy -emit-llvm -o - -c -S %s -fPIC | FileCheck %s

#include <stdarg.h>

va_list the_list;

int simple_int(void) {
// CHECK-LABEL: define i32 @simple_int
  return va_arg(the_list, int);

// CHECK: [[GR_OFFS:%[a-z_0-9]+]] = load i32, i32 addrspace(200)* getelementptr inbounds (%struct.__va_list, %struct.__va_list addrspace(200)* @the_list, i32 0, i32 3)
// CHECK: [[EARLY_ONSTACK:%[a-z_0-9]+]] = icmp sge i32 [[GR_OFFS]], 0
// CHECK: br i1 [[EARLY_ONSTACK]], label %[[VAARG_ON_STACK:[a-z_.0-9]+]], label %[[VAARG_MAYBE_REG:[a-z_.0-9]+]]

// CHECK: [[VAARG_MAYBE_REG]]
// CHECK: [[NEW_REG_OFFS:%[a-z_0-9]+]] = add i32 [[GR_OFFS]], 8
// CHECK: store i32 [[NEW_REG_OFFS]], i32 addrspace(200)* getelementptr inbounds (%struct.__va_list, %struct.__va_list addrspace(200)* @the_list, i32 0, i32 3)
// CHECK: [[INREG:%[a-z_0-9]+]] = icmp sle i32 [[NEW_REG_OFFS]], 0
// CHECK: br i1 [[INREG]], label %[[VAARG_IN_REG:[a-z_.0-9]+]], label %[[VAARG_ON_STACK]]

// CHECK: [[VAARG_IN_REG]]
// CHECK:[[REG_TOP:%[a-z_0-9]+]] = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* getelementptr inbounds (%struct.__va_list, %struct.__va_list addrspace(200)* @the_list, i32 0, i32 1)
// CHECK: [[REG_ADDR:%[a-z_0-9]+]] = getelementptr inbounds i8, i8 addrspace(200)* [[REG_TOP]], i32 [[GR_OFFS]]
// CHECK: [[FROMREG_ADDR:%[a-z_0-9]+]] = bitcast i8 addrspace(200)* [[REG_ADDR]] to i32 addrspace(200)*
// CHECK: br label %[[VAARG_END:[a-z._0-9]+]]

// CHECK: [[VAARG_ON_STACK]]
// CHECK: [[STACK:%[a-z_0-9]+]] = load i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* getelementptr inbounds (%struct.__va_list, %struct.__va_list addrspace(200)* @the_list, i32 0, i32 0)
// CHECK: [[NEW_STACK:%[a-z_0-9]+]] =  getelementptr inbounds i8, i8 addrspace(200)* [[STACK]], i64 8
// CHECK: i8 addrspace(200)* [[NEW_STACK]], i8 addrspace(200)* addrspace(200)* getelementptr inbounds (%struct.__va_list, %struct.__va_list addrspace(200)* @the_list, i32 0, i32 0)
// CHECK: [[FROMSTACK_ADDR:%[a-z_0-9]+]] =  bitcast i8 addrspace(200)* [[STACK]] to i32 addrspace(200)*
// CHECK: br label %[[VAARG_END]]

// CHECK: [[VAARG_END]]
// CHECK: [[ADDR:%[a-z._0-9]+]] = phi i32 addrspace(200)* [ [[FROMREG_ADDR]], %[[VAARG_IN_REG]] ], [ [[FROMSTACK_ADDR]], %[[VAARG_ON_STACK]] ]
// CHECK: [[RESULT:%[a-z_0-9]+]] = load i32, i32 addrspace(200)* [[ADDR]]
// CHECK: ret i32 [[RESULT]]
}
