// REQUIRES: aarch64-registered-target
// RUN: %clang %s -target aarch64-none-linux-gnu -march=morello -S -o - -O0
// RUN: %clang %s -target aarch64-none-linux-gnu -march=morello -S -o - -O2
// RUN: %clang %s -target aarch64-none-linux-gnu -march=morello -S -o - -O3
// Check that this doesn't crash the compiler at any optimisation level.
int foo(__capability void *a)
{
	if (a)
		return 42;
	return 45;
}

int bar(__capability void *a, __capability void *b)
{
	if (a && b)
		return 42;
	return 45;
}

__capability int *
foo2bar(__capability int *afoo)
{
	       if (!afoo)
			                  return((void*)0);
		          return afoo;
}

