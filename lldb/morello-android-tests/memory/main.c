int function_using_address(int **address) {
  return *address[1];
}

int main() {
  int data = 133;
  int *addresses[4] = { &data, &data, &data, &data };
  int **an_address = addresses + 2;
  return function_using_address(an_address); // Break here.
}
