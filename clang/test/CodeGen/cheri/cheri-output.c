// RUN: %cheri_cc1 -o - %s -emit-llvm | FileCheck %s
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +morello -o - %s -emit-llvm | FileCheck %s --check-prefix=A64

int write_only(__capability __cheri_output int *x);
int read_only(__capability __cheri_input int *x);

int caller(__capability int *x)
{
	// Ensure that the read and read capability flags are cleared.
	// CHECK: llvm.cheri.cap.perms.and.i64(
	// CHECK: i64 65515)
	// CHECK: write_only(
	// A64: llvm.cheri.cap.perms.and.i64(
	// A64: i64 114687)
	// A64: write_only(
	write_only(x);
	// Ensure that the write and write-capability flags are cleared.
	// CHECK: llvm.cheri.cap.perms.and.i64(
	// CHECK: i64 65495)
	// CHECK: read_only(
	// A64: llvm.cheri.cap.perms.and.i64(
	// A64: i64 188415)
	// A64: read_only(
	return read_only(x);
}

