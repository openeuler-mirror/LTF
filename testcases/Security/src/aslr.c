#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <malloc.h>

extern int errno;

typedef struct rec
{
	int i;
	float PI;
	char A;
}RECORD;


int main()
{
    	RECORD *ptr_one;
	int * buffer;
	int *temp;
	size_t ntem;
	

	buffer = (int *)malloc(sizeof(int));
	
	if (buffer == 0)
	{
		printf("ERROR: Out of memory\n");
		return 1;
	}
	*buffer = 25;
	printf("%p\n", buffer);
	free(buffer);
	printf("\n");
	
	return 0;
}

