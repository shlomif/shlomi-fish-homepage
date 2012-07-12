#include <complex.h>
#include <graphics.h>
#include <vgapalet.c>
#include <stdio.h>


const unsigned MAX_TEST = 82;

int mandelbrot_val(double r, double i)
{
	complex z(0,0), c(r,i);
	for(int a=1;a<=MAX_TEST;a++)
	{
		z = z*z+c;
		if (norm(z)>=4)
			return a;
	}
	return 0;
}

void mandelbrot_set(int x1, int y1, int x2, int y2)
{
	FILE * f = fopen("c:\\mandel.img","wb");
	if (((x2-x1)%3!=0)||((y2-y1)%2==1)||(x2-x1<10)||(y2-y1<10))
		return;
	double rdelta = 3.0/(x2-x1), idelta = 2.0/(y2-y1);
	unsigned x=x1, y =y1,a;
	for(int i=(y1-y2)/2;i<=(y2-y1)/2;i++)
	{
		for(int r=2*(x1-x2)/3;r<=(x2-x1)/3;r++)
		{
			a = mandelbrot_val(r*rdelta,i*idelta);
			if (a)
			{
				putpixel(x++,y,(a>>2)+32);
				putc((a>>2)+32,f);
			}
			else
			{
				putpixel(x++,y,0);
				putc(0,f);
			}
		}
		y++;x=x1;
	}
	fclose(f);
}

int return0() {return 0;}

int main()
{
	int gi = installuserdriver("Svga256",return0),gm=SVGA1024x768x256;
	initgraph(&gi,&gm,"c:\\tc\\bgi");
	mandelbrot_set(0,0,1023,768);
	_AX=1;asm int 0x16;
	return 0;
}