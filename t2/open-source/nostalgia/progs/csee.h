/* CSEE.H - a library of ANSI C graphical functions.
	These functions draw various commonly used images (such as a Facey and
	a table), gives new helpful graphical tools (like the Aziline), or simply
	makes graphical programming easy.
	programed by Shlomi Fish - MCMXCII
	This is a shareware library. Copying is permitted.
	To get a help document, please send 3 NIS (1 dollar) to this adress:
		Shlomi Fish
		4 Drezner St.
		Tel-Aviv 69497
	May you find these functions useful and make a fine use of them!
*/
#ifndef __CSEE_H
#define __CSEE_H

#ifndef __GRAPHICS_H
#include <graphics.h>
#endif
#ifndef __MATH_H
#include <math.h>
#endif
#ifndef __CONIO_H
#include <conio.h>
#endif
#ifndef __STRING_H
#include <string.h>
#endif
#ifndef __STDLIB_H
#include <stdlib.h>
#endif

#define VERT_FLIP 0
#define HORIZ_FLIP 1
#define BOTH_FLIP 2

double rad(double deg)
{
	return ((double)deg/180 * M_PI);
}

void cirrectan ( int StartX, int StartY, int EndX, int EndY, float CirPart)
{
	if ((CirPart > 0.5) || (abs(StartX - EndX) * CirPart * 2 >= abs(StartY - EndY)))
	{
		outtext("Unable to make function \"cirrectan()\"");
	}
	else
	{
	int p, DelX;
	/* making the starting corner the upper-right corner */
	if (StartX < EndX)
	{
		p = EndX - StartX;
		StartX += p;
		EndX -= p;
	}
	if (StartY > EndY)
	{
		p = StartY - EndY;
		StartY -= p;
		EndY += p;
	}
	DelX = (StartX - EndX) * CirPart;
	for (p=1;p<5;p++)
	{
		arc(/* x-value */ (EndX + DelX) * ((p == 2) || (p == 3)) + (StartX - DelX) * ((p == 1) || (p == 4)),/* Y-value*/ (StartY + DelX) * (p < 3) + (EndY - DelX) * (p > 2), /*ST*/p * 90 - 90, /*End*/p * 90, /*rad*/DelX);
		if (p % 2 == 1) /* upper lines */
		{
			line (StartX-DelX, StartY * (p == 1) + EndY * (p == 3), EndX + DelX, StartY * (p == 1) + EndY * (p == 3));
		}
		else /* lower lines */
		{
			line (StartX * (p == 2) + EndX * (p == 4), StartY + DelX,StartX * (p == 2) + EndX * (p == 4), EndY - DelX);
		}
	}
	}
}

void aziline(int X, int Y, int length, int azimot)
{
	int EndX = X+(int)(cos(rad((double)azimot))*length);
	int EndY = Y-(int)(sin(rad((double)azimot))*length);
	line(X, Y, EndX, EndY);
	moveto(X,Y);
}

void azilineto(int length, int azimot)
{
	int OldX = getx(), OldY = gety();
	aziline(OldX, OldY, length, azimot);
	moveto(OldX+(int)(cos(rad((double)azimot))*length), OldY-(int)(sin(rad((double)azimot))*length));
}

void azipixel(int X, int Y, int length, int azimot)
{
	int EndX = X+(int)(cos(rad((double)azimot))*length);
	int EndY = Y-(int)(sin(rad((double)azimot))*length);
	putpixel(EndX, EndY, getcolor());
	moveto(X,Y);
}

void azipixelto(int length, int azimot)
{
	int OldX = getx(), OldY = gety();
	azipixel(OldX, OldY, length, azimot);
	moveto(OldX+(int)(cos(rad((double)azimot))*length), OldY-(int)(sin(rad((double)azimot))*length));
}

void perpolyg (int X, int Y, unsigned int side_num, int side_len, int start_azi)
{
	int a, change, azitri;
	change = 180 - (((side_num-2)*180)/side_num);
	for(a=0;a<side_num;a++)
	{
		azitri = start_azi + change * a;
		aziline(X, Y, side_len, azitri);
		X += (int)(cos(rad((double)azitri))*side_len);
		Y -= (int)(sin(rad((double)azitri))*side_len);
	}
}

enum face_type {happy, sad, puzzled};

void facey(int X1, int Y1, int X2, int Y2, face_type face , int eye_color)
{

	/* Drawing the head and the eyes */
	int p, Xlen,Ylen,CenX,CenY;
	float d;
	if (X1 > X2)
	{
		p = X1 - X2;
		X2 += p;
		X1 -= p;
	}
	if (Y1 > Y2)
	{
		p = Y1 - Y2;
		Y2 += p;
		Y1 -= p;
	}
	Xlen = X2 - X1; /* assigning some values */
	Ylen = Y2 - Y1;
	CenX = (X2 + X1) / 2;
	CenY = (Y2 + Y1) / 2;

	/* Drawing the ellipse */
	ellipse(CenX, CenY,0, 360,Xlen/2, Ylen/2);
	/* drawing the eyes */
	struct fillsettingstype preset;
	getfillsettings(&preset);
	for (p=-1; p<2;p+=2)
	{
		ellipse(CenX + p * Xlen / 5, CenY - Ylen / 6, 0, 360, Xlen/10, Ylen/10);
		setfillstyle(SOLID_FILL, getcolor());
		fillellipse(CenX + p * Xlen / (20/3) , CenY - Ylen / 6 + Ylen / 20, Xlen / 20, Ylen / 20);
		setfillstyle(SOLID_FILL, eye_color);
		floodfill(CenX + p * Xlen / 5, CenY - Ylen / 6, getcolor());
	}
	setfillstyle(preset.pattern, preset.color); /* returning the fill settings to the original */
	switch (face)
	{
		case happy: ellipse(CenX, CenY , 200, 340, Xlen * 4 / 10, Ylen * 4 / 10);break;
		case sad: ellipse(CenX, CenY + Ylen * 11 / 20, 50, 130, Xlen * 4 / 10, Ylen * 4 / 10);break;
		case puzzled: for (d = CenX - Xlen *  3 / 10 ; d <= CenX + Xlen * 3 / 10; d += 0.25) { putpixel((int)d, (int)(CenY + Ylen * 1 / 4 - cos(rad((double)d / (Xlen * 6 / 10) * 900 + 140)) * Ylen / 15), getcolor()); } break;
	}
	/* painting the face */
	floodfill(CenX, CenY - Ylen / 20, getcolor());
}

void table (int StartX, int StartY, int Xnum, int Ynum, int Xsqlen, int Ysqlen)
{
	int x, y;
	for (x = 0;x <= Xnum; x++)
	{
		line(StartX + x * Xsqlen, StartY, StartX + x * Xsqlen, StartY + Ynum * Ysqlen);
	}
	for (y = 0;y <= Ynum; y++)
	{
		line(StartX, StartY + y * Ysqlen, StartX + Xnum * Xsqlen, StartY + y * Ysqlen);
	}
}

enum yes_no {yes = 1, no = 0};

#ifdef __cplusplus
void changecolor(int StartX, int StartY, int EndX, int EndY, int col1, int chn1, yes_no rev = no, int col2 = 0, int chn2 = 0, int col3 = 0, int chn3 = 0, int col4 = 0, int chn4 = 0, int col5 = 0, int chn5 = 0)
{
	int colors[5] = {col1, col2, col3, col4, col5}, changes[5] = {chn1, chn2, chn3, chn4, chn5};
	int a, b, c, col;
	if (StartX > EndX)
	{
		a = StartX - EndX;
		StartX -= a;
		EndX += a;
	}
	if (StartY > EndY)
	{
		a = StartY - EndY;
		StartY -= a;
		EndY += a;
	}
	for (a = StartX; a <= EndY; a++)
	{
		for (b = StartY; b <= EndY; b++)
		{
			col = getpixel(a, b);
			for (c=0; c < 5;c++)
			{
				if (col == colors[c])
				{
					putpixel(a, b, changes[c]);
				}
				if ((col == changes[c]) && (rev == yes))
				{
					putpixel(a, b, colors[c]);
				}
			}
		}
	}
}
#else
void changecolor(int StartX, int StartY, int EndX, int EndY, int col1, int chn1, yes_no rev)
{
	int a, b, c, col;
	if (StartX > EndX)
	{
		a = StartX - EndX;
		StartX -= a;
		EndX += a;
	}
	if (StartY > EndY)
	{
		a = StartY - EndY;
		StartY -= a;
		EndY += a;
	}
	for (a = StartX; a <= EndY; a++)
	{
		for (b = StartY; b <= EndY; b++)
		{
			col = getpixel(a, b);
			if (col == col1)
				{
					putpixel(a, b, chn1);
				}
				if ((col == chn1) && (rev == yes))
				{
					putpixel(a, b, col1);
				}
			}
		}
	}
}
#endif
int draw(char * s, int ang)
{
	char r[300] = "",c , numb[4] = "", func = (char)0;
	int spoint = 0, npoint = 0; /* pointers */
	if (strlen(s) > 300)
	{
		outtext("The size of the input string for the \"draw()\" function is bigger than 300.\nPlease decrease the size");
		goto end;
	}
	strcpy(r, s);
	func = r[0];
	while (spoint <= strlen(r))
	{
		c = r[spoint];
		spoint++;
		if ( (((int)c > 47) && ((int)c < 58)) || (c == '-') || (c == '.') ) /* a number */
		{
			numb[npoint] = c;
			npoint++;
		}
		else /* a letter */
		{
			/* execution of the previous function */
			if (func < 97 )
			{
				func+= 32;
			}
			switch (func)
			{
				case 'f' : azilineto(atoi(numb), ang); break;
				case 'b' : azilineto(atoi(numb), ang + 180 - 360 * (ang >= 180)); break;
				case 'r' : ang -= atoi(numb); ang += 360 * (ang < 0); break;
				case 'l' : ang += atoi(numb); ang -= 360 * (ang > 360); break;
				case 'c' : setcolor(atoi(numb)); break;
				default : outtext("Unknown character in function \"draw()\". Please correct the mistake."); goto end;
			};
			/* getting the new function */
			func = c;
			numb[0] = 0;
			numb[1] = 0;
			numb[2] = 0;
			numb[3] = 0;
			npoint = 0;
		}
	}

	end: return ang;
}

void arrow (int StartX, int StartY, int length, int azi, unsigned int arr_len , yes_no prop )
{
	int PreX = getx(), PreY = gety();
	if (arr_len > 100)
	{
		outtext("Parameter 'arr_len' for function arrow() is out of range");
		goto end;
	}
	moveto(StartX, StartY);
	azilineto(length, azi);
	if (prop == no)
	{
		aziline(getx(), gety(), arr_len, azi - 150);
		aziline(getx(), gety(), arr_len, azi + 150);
	}
	else
	{
		aziline(getx(), gety(), arr_len * length * 0.01, azi - 150);
		aziline(getx(), gety(), arr_len * length * 0.01, azi + 150);
	}
	end: moveto(PreX, PreY);
}

void flipimage(int left, int up, int right, int down, int side)
{
	int a= 0, b, c;
	b = 0;
	c = 0;
	void * image1 = &b;
	void * image2 = &c;
	if (left > right)
	{
		left=a;
		left=right;
		right=a;
	}
	if (up > down)
	{
		down = a;
		down = up;
		up = a;
	}
	if (side != 1)
	{
		for (a=up;a<=(down+up)/2;a++)
		{
			getimage(left,a,right,a,image1);
			getimage(left,down-(a-up),right,down-(a-up),image2);
			putimage(left,a,image2,COPY_PUT);
			putimage(left,down-(a-up),image1, COPY_PUT);
		}
	}
	if (side != 0)
	{
		for (a=left;a<=(right+left)/2;a++)
		{
			getimage(a,up,a,down,image1);
			getimage(right-(a-left),up,right-(a-left),down,image2);
			putimage(a,up,image2,COPY_PUT);
			putimage(right-(a-left),up,image1,COPY_PUT);
		}
	}
}

enum yes_no direct [3] [3] = {{no,no,no},{no,yes,no},{no,no,no}};

void get_direct(int X,int Y) // fills the direct array
{
	int dx, dy;
	for (dx = -1; dx < 2; dx++)
	{
		for (dy = -1; dy < 2; dy++)
		{
			if ((dx == 0) && (dy == 0))
			{     }
			else
			{
				if (getpixel(X+dx,Y+dy) == getpixel(X,Y))
				{
					direct[dx+1][dy+1] = yes;
				}
				else
				{
					direct[dx+1][dy+1] = no;
				}
			}
		}
	}
}

void barfill(int StartX, int StartY, int EndX, int EndY, int barwidth)
{
	if (StartX > EndX)
	{
		StartX -= EndX;
		EndX += StartX;
		StartX = EndX - StartX;
	}
	if (StartY > EndY)
	{
		StartY -= EndY;
		EndY += StartY;
		StartY = EndY - StartY;
	}
	int y,x, l, maxc, maxn = 0, colors[16] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, Pre = getcolor();
	for (x = StartX; x<=EndX; x+=barwidth)
	{
		for (y = StartY; y<=EndY; y++)
		{
			for (l = 0; l<barwidth; l++)
			{
				colors[getpixel(x+l,y)]++;
			}
			for (l = 0; l<16; l++)
			{
				if (colors[l] > maxn)
				{ maxc = l; maxn = colors[l]; }
			}
			if (maxn > (int)((barwidth-1) * 0.75))
			{
				setcolor(maxc);
				line(x,y,x+barwidth-1,y);
			}
			else
			{
				setcolor(getbkcolor());
				line(x,y,x+barwidth-1,y);
			}
			putpixel(x+barwidth,y,getbkcolor());
		}
	}
	setcolor(Pre);
}

#endif // __CSEE_H




