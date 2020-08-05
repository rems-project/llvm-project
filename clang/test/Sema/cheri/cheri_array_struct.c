// RUN: %cheri_cc1 "-target-abi" "purecap" -fsyntax-only  %s -verify
// RUN: %clang_cc1 -triple aarch64-none-linux-gnu -target-feature +c64 -target-abi purecap -mllvm -cheri-cap-table-abi=pcrel -fsyntax-only %s -verify
// expected-no-diagnostics
typedef struct foo
{
		int b[42];
} foo_t;

