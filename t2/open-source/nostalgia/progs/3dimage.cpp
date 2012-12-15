#include <graphics.h>
#include <stdlib.h>

#define WIDTH 500 // width of picture - in pixels
#define HEIGHT 300
//#define EYES 180 // eye seperation (assuming a 72 dpi screen)
#define EYES 108


int randomBlackWhite()
{
	return random(2) * EGA_WHITE;
}

void draw3D (int (*z)(int,int))
{
	int x, y, same[WIDTH], color[WIDTH], sep, i, j, s;
	for(y=0;y<HEIGHT;y++)
	{
		for(x=0;x<WIDTH;x++) same[x] = x;
		for(x=0;x<WIDTH;x++)
		{
			sep = z(x,y); i = x-(sep+(sep&y&1))/2; j = i+sep;
			if ((0 <= i) && (j<WIDTH))
			{
				for (s=same[i]; (s!=i)&&(s!=j); s=same[i])
					if (s>j) {same[i] = j;i=j;j=s;}
					else i = s;
				same[i] = j;
			}
		}
		for (x=WIDTH-1;x>=0;x--)
		{
			if (same[x]==x) color[x] = randomBlackWhite();
			else color[x] = color[same[x]];
			putpixel(x,y,color[x]);
		}
	}
}

#define GROUND (EYES/2) // a dot seperation for distanat object
#define HAT (GROUND-1) // objects near background are easier to see

int topHat(int x, int y)
{
	int brimRadius = 70, headRadius = 30, brimHeight = 25;
	if (y>=HEIGHT/2-brimRadius)
	{
		if ((y<HEIGHT/2+brimRadius-brimHeight) && (x >= WIDTH/2-headRadius) && (x<WIDTH/2+headRadius))
			return HAT;
		else if (y < HEIGHT/2+brimRadius)
			if ((x>=WIDTH/2-brimRadius)&&(x<WIDTH/2+brimRadius))
				return HAT;
	}
	return GROUND;
}

int main()
{
	randomize();
	int a= DETECT, b;
	initgraph(&a,&b,"c:\\tc\\bgi");
	cleardevice();
	draw3D(topHat);
	_AX = 1; asm int 0x16;
	_AX = 1; asm int 0x16;
	_AX = 1; asm int 0x16;
	_AX = 1; asm int 0x16;
	return 0;
}
