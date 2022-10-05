#include <cheriintrin.h>

int main() {
  int i = 0;
  int * __capability cap_ptr = &i;
#ifndef __CHERI_PURE_CAPABILITY__
  cap_ptr = __builtin_cheri_bounds_set(cap_ptr, sizeof(int));
#endif

  // Write outside of i.
  cap_ptr[1] = 2;

  return 0;
}
