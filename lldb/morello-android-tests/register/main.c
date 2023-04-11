#include <stdint.h>

int main() {
  uintcap_t value = 0xdeaddeaddeadbeef;
  asm volatile(
      "scbnds c11, %[VALUE], #4\n"
      :
      : [VALUE] "C"(value)
      : "c11"
      );
  return 0; // Break here
}
