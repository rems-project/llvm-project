#include <cheriintrin.h>

int * __capability cap_ptr;

int main ()
{
  int i = 0;

  /* Create a valid capability and narrow it down to an int boundary.  */
  cap_ptr = __builtin_cheri_cap_from_pointer (cheri_ddc_get (),
					      (unsigned long) &i);
  cap_ptr = __builtin_cheri_bounds_set_exact (cap_ptr, 4);
  /* Remove the STORE permission of the capability.  */
  cap_ptr = cheri_perms_clear (cap_ptr, CHERI_PERM_STORE);
  /* Run into a permissions fault while attempting to store
     data.  */
  cap_ptr[0] = 2;

  return 0;
}
