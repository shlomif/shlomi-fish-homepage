#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
  int data;
  struct Node *next;
}node;

int main()
{
  int arr[20];
  int i;
  node *base,*runner;
  for (i=0,base=malloc(sizeof(*base)),runner=base;i<20;++i)
    {
      runner->data=i;
      runner->next=malloc(sizeof(node));
      runner=runner->next;
    }
  for (i=0;i<20;++i)
    arr[i]=i*i;
  runner=base;
  while(1)
    {
      printf("%d",runner->data);
      runner=runner->next;
    }
  return 0;
}
