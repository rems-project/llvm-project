#include <cheriintrin.h>

int *__capability cap_ptr;

int main() {
  int i = 0;
  cap_ptr = &i;

  /* Remove the STORE permission of the capability.  */
  cap_ptr = cheri_perms_clear(cap_ptr, CHERI_PERM_STORE);
  /* Run into a permissions fault while attempting to store
     data.  */
  cap_ptr[0] = 2;

  return 0;
}
