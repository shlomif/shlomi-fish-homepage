#include <dir.h>
#include <stdio.h>

int main(int argc, char * argv[])
{
	if (argc != 2) // wrong number of arguments
		puts("Wrong number of arguments for CDD!\nType CDD h for help on how to use CDD.");
	else if (((*argv[1] == 'h') || (*argv[1] == 'H') || (*argv[1] == '?')))// || ((*argv[1] == '/') && ((*argv[1]+1 == 'h') || (*argv[1]+1 == 'H') || (*argv[1]+1 == '?')))
	{
		puts("CDD (Change Drive And/Or Directory).\n"
		"Syntex: CDD <directory name>\n"
		"<directory name> - the name of the directory (may include drive name in the beginning)\n\n"
		"Uncopyrighted, 1993 - MCMLXIII, Shlomi Fish.");
	}
	else // Directory/Drive change
	{
		if (*(argv[1]+1) == ':')   //drive change
			setdisk(*argv[1]-((*argv[1]<93) ? 65 : 97)); //letter to number
		if (*(argv[1]+2) && chdir(argv[1])) // directory change (in chdir);
			puts("Invalid directory!");
	}
	return 0;
}