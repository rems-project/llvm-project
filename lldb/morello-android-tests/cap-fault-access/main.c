#include <cheriintrin.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>

int *__capability cap_ptr;
__uintcap_t *ucap_ptr;

int main() {
  int i = 0;
  unsigned long page_sz = sysconf(_SC_PAGESIZE);

  /* A shared mapping is required to trigger an access fault, because it is the
     only kind of mapping where capability tags are not accessible.  */
  ucap_ptr = mmap(0, page_sz, PROT_READ | PROT_WRITE,
                  MAP_SHARED | MAP_ANONYMOUS, -1, 0);

  if (ucap_ptr == MAP_FAILED) {
    perror("mmap() failed");
    return EXIT_FAILURE;
  }

  cap_ptr = &i;
  /* Make sure we have a valid capability.  */
  cap_ptr[0] = 2;

  /* Attempt to write to the shared mapping memory and cause an
     access fault.  */
  *ucap_ptr = (__uintcap_t)cap_ptr;

  return 0;
}
