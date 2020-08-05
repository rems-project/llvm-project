// RUN: %cheri_cc1 %s -fsyntax-only -verify
// RUN: %clang_cc1 %s -fsyntax-only -verify -triple aarch64-none-linux-gnu -target-feature +morello
// expected-no-diagnostics
#define NULL (void * __capability)0
int func(char * __capability ptr)
{
        if (ptr == NULL)
                return (0);
        return (1);
}

