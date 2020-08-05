// RUN: %cheri_cc1 -o - %s -fsyntax-only -verify
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +morello -o - %s -fsyntax-only -verify

int readFail(__cheri_output int * __capability x)
{
	*x = 12;
	(*x)++; // expected-error {{write-only variable is not readable}}
	return *x; // expected-error {{write-only variable is not readable}}
}

int caller(int * __capability x)
{
	return readFail(x);
}

