// RUN: %clang_cc1 -fsyntax-only %s -verify=nowarn
// nowarn-no-diagnostics
// RUN: %cheri_purecap_cc1 -Wmips-cheri-prototypes -Wmips-cheri-prototypes-strict -fsyntax-only %s -verify
// RUN: %cheri_cc1 -Wmips-cheri-prototypes -Wmips-cheri-prototypes-strict -fsyntax-only %s -verify
// RUN: %clang_cc1 -Wmips-cheri-prototypes -Wmips-cheri-prototypes-strict -fsyntax-only %s -verify=nowarn
// RUN: %clang_cc1 -Wmips-cheri-prototypes -Wmips-cheri-prototypes-strict -triple aarch64-none-unknown-eabi -fsyntax-only %s -verify=nowarn
// RUN: %clang_cc1 -Wmips-cheri-prototypes -Wmips-cheri-prototypes-strict -triple aarch64-none-unknown-eabi -target-feature -c64 -target-feature +morello -fsyntax-only %s -verify
// RUN: %clang_cc1 -Wmips-cheri-prototypes -Wmips-cheri-prototypes-strict -triple aarch64-none-unknown-eabi -target-feature -a64c -target-feature +morello -fsyntax-only %s -verify


int do_append(); // expected-note {{candidate function declaration needs parameter types}}
extern int store_char();

void pappend(char c) {
	do_append(c); // expected-warning {{call to function 'do_append' with no prototype may lead to run-time stack corruption on CHERI}}
  // expected-note@-1{{will read garbage values from the argument registers}}
}

int do_append(long c) {
  return store_char();
}

static int kr();
static int kr(arg)
  int arg;
{
  return arg + 1;
}

int call_kr(void) {
  return kr(1);
}

static void fn() {
  // expected-note@-1 {{'fn' declared here}}
}

static void take_fn(void (*p)(void)) {
}

static void pass_fn() {
  take_fn(fn); // expected-warning-re {{converting function type without prototype 'void ()' to function pointer 'void (*{{( __capability)?}})(void)' may cause wrong parameters to be passed at run-time.}}
  // expected-note@-1 {{Calling functions without prototypes is dangerous because in the CHERI pure-capability ABI integer and pointer arguments are passed in different registers. If the call includes a parameter that does not match the function definition, the function will read garbage values from the argument registers.}}
}