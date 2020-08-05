// RUN: %cheri_cc1 "-target-abi" "purecap" -fsyntax-only  %s -verify
// RUN: %clang_cc1 -fsyntax-only -triple aarch64-none-linux-gnu -target-feature +c64 -target-abi purecap -mllvm -cheri-cap-table-abi=pcrel %s -verify
// expected-no-diagnostics
_Static_assert(_Generic(((float _Complex)1.0i), float _Complex: 1, default: 0),
               "_Complex_I must be of type float _Complex");
#define x(d) _Generic((d), float: 1, double: 2)

int y(float z)
{
  return x(z);
}

