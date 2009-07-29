/* ASSOC.CPP - a program to make wild associations.
switches - '?' - help
			  'h' - in hebrew

*/
#include <conio.h>
#include <stdlib.h>
#include <time.h>
enum yes_no {yes, no};

int main(int argc, char * argv[])
{
	randomize();
	char c='j',l;
	yes_no heb = no;
	if (argc > 2)
	{
		cprintf("\n\rToo many or unknown arguments.\n\rType \"ASSOC ?\" for help");
		goto end;
	}
	if (argv[1][0] == '?')
	{
		cprintf("\n\rWelcome to ASSOCiation - the useful program to bring you fast realy wild associations. \
		\n\rIn order to use it type \"ASSOC\" or \"ASSOC h\" for associations in hebrew. The program will then type \
		one letter. If you want to type more letters one by one press any key except the following: RETURN that ends \
		the program or backspace that replaces the last letter.\n\rHave fun!!!\n\n\r");
		goto end;
	}
	else if (argv[1][0] == 'h')
	{
		heb = yes;
	}
	cputs("\n\n\rYour association is: ");
	while (c != 13)
	{
		l = (random(25) + 65) * (heb == no) + (random(26)+128) * (heb == yes);
		if ((l == 'ä') || (l == 'ç') || (l == 'è') || (l == 'ì') || (l == 'ï')) {l++;}
		putch(l);
		c = getch();
		if (c == 8) { gotoxy(wherex()-1,wherey()); putch(' '); gotoxy(wherex()-1,wherey());}
	}
	end: return 0;
}
