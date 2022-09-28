int foo(int i)
{
  int j = i + i;
  return j;
}

int main() {
  int k = 42;
  k = foo(k);
  return 0;
}