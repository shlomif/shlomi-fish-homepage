#include <stdio.h>
#include "common.h"

void common_func()
{
	printf("%s %i\n",__func__,DEFINE);
}
