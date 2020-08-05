// RUN: %clang -std=c++11 -target arm64 -march=morello -fsyntax-only -ffreestanding %s
// RUN: %clang -std=c++11 -target arm64 -march=morello+c64 -mabi=purecap -fsyntax-only -ffreestanding %s
// RUN: %clang -std=c++11 -target arm64 -fsyntax-only -ffreestanding %s
// expected-no-diagnostics

#include <cheri.h>
