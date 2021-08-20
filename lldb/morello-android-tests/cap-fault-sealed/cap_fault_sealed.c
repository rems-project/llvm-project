#include <cheriintrin.h>

int * __capability cap_ptr;

int main ()
{
  int i = 0;

  /* Create a valid capability and narrow it down to an int boundary.  */
  cap_ptr = __builtin_cheri_cap_from_pointer (cheri_ddc_get (),
					      (unsigned long) &i);
  cap_ptr = __builtin_cheri_bounds_set_exact (cap_ptr, 4);
  /* Seal the capability.  */
  cap_ptr = __builtin_cheri_seal_entry (cap_ptr);
  /* Run into a sealed fault.  */
  cap_ptr[0] = 2;

  return 0;
}
