#include <graphics.h>
#include <math.h>

void rect2poly(int left, int top, int right, int bottom, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4)
{
	int x,y,stepx=300,stepy=300;
	float lsx,lsy,lex,ley;
	if (left>right)
	{
		x=left;
		left=right;
		right=x;
	}
	if (top>bottom)
	{
		x=top;
		top=bottom;
		bottom=x;
	}
	for(x=0;x<=stepx;x++)
	{
		for(y=0;y<=stepy;y++)
		{
			lsx=x1+(x2-x1)*(x/(float)stepx);
			lsy=y1+(y2-y1)*(x/(float)stepx);
			lex=x4+(x3-x4)*(x/(float)stepx);
			ley=y4+(y3-y4)*(x/(float)stepx);
			putpixel((int)(lsx+(lex-lsx)*(y/(float)stepy)), (int)(lsy+(ley-lsy)*(y/(float)stepy)), getpixel((int)(left+(right-left)*(x/(float)stepx)),(int)(top+(bottom-top)*(y/(float)stepy))));
}	}	}

int main()
{
	int a = DETECT, b;
	initgraph(&a,&b,"c:\\tc\\bgi");
	cleardevice();
	setcolor(5);
	setfillstyle(1,8);
	bar(5,5,55,105);
	setcolor(9);
	setfillstyle(1,13);
	fillellipse(30,55,25,50);
	rect2poly(5,5,55,105,100,100,230,150,200,200,120,170);
	_AX=1;asm int 0x16;
	closegraph();
	return 0;
}