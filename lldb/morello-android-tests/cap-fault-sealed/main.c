#include <cheriintrin.h>

int *__capability cap_ptr;

int main() {
  int i = 0;
  cap_ptr = &i;

  /* Seal the capability.  */
  cap_ptr = __builtin_cheri_seal_entry(cap_ptr);
  /* Run into a sealed fault.  */
  cap_ptr[0] = 2;

  return 0;
}
