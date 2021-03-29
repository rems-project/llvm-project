// RUN: %cheri_cc1 %s -O2 -msoft-float -emit-llvm -o - | FileCheck %s --check-prefix=CHECK --check-prefix=cheri
// RUN: %clang -target aarch64-none-linux-gnu -march=morello %s -O2 -S -emit-llvm -o - -fPIC | FileCheck %s --check-prefix=CHECK --check-prefix=morello

#pragma pointer_interpretation capability
struct test
{
	int *a,*b,*c;
};
#pragma pointer_interpretation default
struct test2
{
	int *a,*b,*c;
} t2;
#pragma pointer_interpretation integer
struct test3
{
	int *a,*b,*c;
} t3;
struct test t;

_Pragma("pointer_interpretation integer")
_Pragma("pointer_interpretation capability")
_Pragma("pointer_interpretation default")

//CHECK: %struct.test = type { i32 addrspace(200)*, i32 addrspace(200)*, i32 addrspace(200)* }
//CHECK: %struct.test2 = type { i32*, i32*, i32* }
//CHECK: %struct.test3 = type { i32*, i32*, i32* }

// morello: define dso_local i32 @x()
// cheri: define dso_local signext i32 @x()
int x(void)
{
	// CHECK: load i32 addrspace(200)*, i32 addrspace(200)**
	// CHECK: load i32, i32 addrspace(200)*
	return *t.a;
}

// morello: define dso_local i32 @y()
// cheri: define dso_local signext i32 @y()
int y(void)
{
	// CHECK: load i32*, i32**
	// CHECK: load i32, i32*
	return *t2.a;
}
// morello: define dso_local i32 @z()
// cheri: define dso_local signext i32 @z()
int z(void)
{
	// CHECK: load i32*, i32**
	// CHECK: load i32, i32*
	return *t3.a;
}

