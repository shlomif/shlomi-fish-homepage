#include <dos.h>
#include <graphics.h>
#include <conio.h>
#include <math.h>
#include <string.h>

//#define rad(degs) ((degs/180)*M_PI)
#define xy2(xval, yval) (yval*320+xval)

double rad(double degs)
{	return ((degs/180) * M_PI); }

void vcircle(int cenx, int ceny, int radius)
{
	for(float a = 0; a<360; a+= 0.1)
	{
		poke(0xa000, (int)(cenx+cos(rad(a))*radius)*320+(int)(ceny-sin(rad(a))*radius), 3);
}  }

char * combine (char * s1, char * s2, char * s3="", char * s4="", char * s5="", char * s6="", char * s7="", char * s8="")
{
	char * tempy = "";
	strcpy(tempy,s1);
	strcat(tempy,s2);
	strcat(tempy,s3);
	strcat(tempy,s4);
	strcat(tempy,s5);
	strcat(tempy,s6);
	strcat(tempy,s7);
	strcat(tempy,s8);
	return tempy;
}



struct color_def
{
	unsigned int color;
	char * definition;
	color_def(void);
	color_def(int newcolor, char * newdef);
	~color_def(void) {delete definition;};
	void get_all(color_def * source);
	void get_def(char * newdef);
	char * present();
};

color_def::color_def(int newcolor, char * newdef)
{
	color = newcolor;
	get_def(newdef);
}

void color_def::get_def(char * newdef)
{
	newdef = strlwr(newdef);
	newdef[0] -= 32;
	for (int a = 1;a<strlen(newdef);a++)
	{
		if (newdef[a] = " ") { newdef[a] = "_";}
	}
	strcpy(definition, newdef);
}

void color_def::get_all(color_def& * source)
{
	color = source->color;
	strcpy(definition, source->definition);
}

char * color_def::present()
{
	char * tempy, numbey;
	itoa(color, numbey, 10);
	tempy = combine("#define ", definition, " ", numbey, "\n")
	return tempy;
}

enum ColSortBy {Cnumber, Cname};

class col_collection
{
	ColSortBy sorty;
	color_def col[256];
	public:
	col_collection(ColSortBy new_sorty);
	~col_collection() {delete col;};
	int insert(color_def * newcol);
	int search(int number);
	int search(char * defin);
	void replace(int number, color_def * newcol);
	int Howmany();
}

col_collection::col_collection(ColSortBy new_sorty)
{
	sorty = new_sorty;
	for (int a=0;a<256;a++)
	{
		col[a].color = 256;
		col[a].definition = "";
	}
}
};

int col_collection::insert(color_def * newcol) // returns -1 if OK
{                                              // if not returns the number of col to replace
		int a = 0, p = -1;
		while (newcol->color < col[a].color)
		{  a++;};
		if (newcol->color != col[a].color)
		{
			for (int b = 255; b > a; b--)
			{
				col[b-1].get_all(&col[b]);
			}
			replace(a,newcol);
		}
		else
		{
			c = a;
		}
		return c;
}

int search(int number) // returns the number or -1 if not found
{
	int a;
	for (a=0;a<257;a++)
	{
		if (col[a].color == number) { break; }
	}
	return (a - 257*(a > 255));
}

int search(char * defin) // returns the number or -1 if not found
{
	int a;
	for (a=0;a<257;a++)
	{
		if (col[a].definition == defin) { break; }
	}
	return (a - 257*(a > 255));
}

void replace(...)
{
	col[a].get_all(newcol);
}

int Howmany()
{
	int a = 0
	while (col[a].color != 257)
	{	a++; };
	return a;
}

int main()
{
	asm {
		mov ah, 0x00;
		mov al, 0x13;
		int 0x10;
	}

	getch();
	return 0;
}

