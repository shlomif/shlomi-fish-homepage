#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <common.h>

void * routine(void * arg)
{
	printf("pthread\n");
}

int main()
{
	printf("Demo!\n");
	pthread_t pt;
	pthread_create(&pt, NULL, routine, NULL);
	pthread_join(pt,NULL);
	common_func();
}
