/*
	Program to read a 256 colors vga PCX file.

*/

#include <graphics.h>
#include <stdio.h>
#include <vgapalet.c>

int return0() {return 0;}

int ReadHeader (unsigned & Xlen, unsigned & Ylen, unsigned & BytesPerLine, FILE * f)
{
	char header[128];
	fseek(f,0,SEEK_SET);
	fread((void*)header,128,1,f);
	if ((header[0]!=10)||(header[2]!=1)) return 1;
	if ((header[1]!=5)||(header[65]!=1)||(header[68]!=1)) return 2;
	Xlen = *((int*)(&header[8]))-*((int*)(&header[4]))+1;
	Ylen = *((int*)(&header[10]))-*((int*)(&header[6]))+1;
	BytesPerLine = *((int*)(&header[66]));
	return 0;
}

/* returns:
	0 - O.K.
	1 - Not a PCX file
	2 - Not a color VGA PCX
*/

int GetPallete(FILE * f)
{
	unsigned a,b;
	DacPalette256 pal;
	fseek(f,-769, SEEK_END);
	if (getc(f) != 12)
		return 2;
	fread(pal,256,3,f);
	for(a=0;a<256;a++)
		for(b=0;b<3;b++)
			pal[a][b]>>=2;
	setvgapalette256(&pal);
	return 0;
}

int DrawImage(int xlen, int ylen, int BpL, FILE * f)
{
	int x=0, y=0, tx,ty,tcol;
	fseek(f,128,SEEK_SET);
	int pbyt;     /* where to place data */
	int pcnt;     /* where to place count */
	int i;
	while(y<ylen)
	{
		pcnt = 1;     /* safety play */
		if(EOF==(i=getc(f)))
			break;
		if(0xc0 == (0xc0 & i))
		{
			pcnt = 0x3f&i;
			if(EOF == (i=getc(f)))
				return(EOF);
		}
		pbyt = i;
		for(i=0;i<pcnt;i++)
		{
			tx=x;ty=y;tcol=pbyt;
			x++;
			if(x==BpL)
			{
				y += (x=0)+1;
				if (BpL%2==0)
					putpixel(tx,ty,tcol);
			}
			else putpixel(tx,ty,tcol);
		}
	}
	return 0;
}



int main()
{
	int gi, gm=SVGA640x480x256, pcx_handle, err1,err2;
	unsigned X,Y,BpL;
	FILE * pcx_file;
	gi = installuserdriver("svga256",&return0);
	initgraph(&gi,&gm,"c:\\tc\\bgi");
	pcx_file=fopen("c:\\opening3.pcx","rb");
	err1=ReadHeader(X,Y,BpL,pcx_file);
	err2=GetPallete(pcx_file);
	if (err1||err2)
	{
		puts("Error!!!");
		_AX =1;asm int 0x16;
	}
	else
	{
		DrawImage(X,Y,BpL,pcx_file);
		setcolor(48);
		setlinestyle(DOTTED_LINE,0,1);
		line(639,0,639,479);
		_AX = 1;asm int 0x16;
	}
	fclose(pcx_file);
	closegraph();
	return 0;
}
