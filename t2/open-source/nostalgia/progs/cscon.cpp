#include <stdio.h>
#include <dos.h>


int main(int argc, char * argv[])
{
	char c;int a;
	FILE * in, * out;
	if (argc!=3)
		printf("\nError! Incorrect number of arguments!\n"
		"The prompt line should be this:\nCSCON <source-file name> <converted-file name>");
	else
	{
		if ((in=fopen(argv[1],"rt"))==NULL) // opening the source file
			printf("\nError! Unable to open file %s!\nCheck to see if file exists.", argv[1]);
		else if(!_dos_getfileattr(argv[2],(unsigned*)&a)) // checking to see if there is a file in the output file's name
			printf("\nError! File %s exists!\nDelete it if you want to name the output file in this name!", argv[2]);
		else if ((out=fopen(argv[2],"wt"))==NULL) // opening the output file
			printf("\nError! Unable to open file %s!\nName might be invalid.", argv[2]);
		else // The actual conversion
			while ((a = getc(in)) != EOF)
				putc(a%128,out);
	}
	fclose(in);fclose(out);
	return 0;
}


