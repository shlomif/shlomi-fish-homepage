#include <stdio.h>
/*#include <stdlib.h>*/

char *get_sum_mem(int i)
{
  return malloc(i);
}

int main()
{
  char *a=get_sum_mem(10);

  a[20]='c';
  printf("%c\n",a[1]);
  a="Where"
  printf("%s"\n,a);
  return 0;
}
