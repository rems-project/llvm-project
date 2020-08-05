// RUN: %cheri_cc1 -fsyntax-only  %s -verify
// RUN: %clang_cc1 -fsyntax-only -triple aarch64-none-linux-gnu -target-feature +morello %s -verify
#define x(d) _Generic((d), float: 1, double: 2)

// expected-no-diagnostics
int y(float z)
{
	return x(z);
}

