#include "shared.h"

void call_into_shared_lib(int x) {
  func_from_shared_lib(x); // Break here
}

int main() {
  call_into_shared_lib(3);
  return 0;
}
