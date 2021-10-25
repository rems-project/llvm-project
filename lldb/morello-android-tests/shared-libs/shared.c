#include "shared.h"

int var_from_shared_lib = 32;

int leaf_from_shared_lib(int x) {
  return x + 2;
}

int func_from_shared_lib(int x) {
  return leaf_from_shared_lib(x) * 4;
}
