// RUN: %cheri_cc1 -o - %s -fsyntax-only
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +morello -o - %s -fsyntax-only

int move_clobber(void * __capability x)
{
#ifdef __aarch64__
	__asm__ __volatile__ (
		"mov c1, %0" :: "C"(x) : "memory", "c1"
	);
#else
	__asm__ __volatile__ (
		"cmove $c16, %0" :: "C"(x) : "memory", "$c16", "$idc", "$cnull", "$ddc"
	);
#endif
	return 0;
}
