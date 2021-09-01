#include <stdint.h>

int main() {
  // FIXME: This code isn't interesting at all for testing the descriptor ABI,
  // we should replace it with something more similar to what's in 'frames' to
  // make sure unwinding works. We should do this after support for the
  // descriptor ABI lands in the compiler.
  uint64_t value = 0xdeaddeaddeadbeef;
  asm volatile("\tscvalue c11, c11, %[VALUE]\n"
               "\tscbnds c11, c11, #4\n"
               :
               : [VALUE] "r"(value)
               : "c11");
  return 0; // Break here
}
