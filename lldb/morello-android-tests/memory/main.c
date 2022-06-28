int function_using_address(int * __capability *address) {
  return *address[1];
}

int main() {
  int data = 133;
  int * __capability addresses[4] = { &data, &data, &data, &data };
  int * __capability *an_address = addresses + 2;
  return function_using_address(an_address); // Break here.
}
