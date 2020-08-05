// RUN: %clang_cc1 -triple cheri-unknown-freebsd -target-abi n64 -fsyntax-only -verify %s

int * __capability test1(int *i) {
    return reinterpret_cast<int * __capability>(i);
}

int * test2(int * __capability i) {
    return reinterpret_cast<int *>(i); // expected-error {{cast from capability type 'int * __capability' to non-capability type 'int *' is most likely an error; use __cheri_fromcap to convert between pointers and capabilities}}
}
