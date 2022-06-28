#include <cheriintrin.h>

int main() {
  int i = 0;
  int * __capability cap_ptr = &i;

  // Write outside of i.
  cap_ptr[1] = 2;

  return 0;
}
