/* GLOGIC.CPP
	Programming Start Day - November 10th, 1993
*/

#include <iostream.h>
#include <logic.h>
#include <graphics.h>
#include <dos.h>
#include <grphinit.cpp>

enum mouse_buttons {left = 0, right = 1, middle = 2};

const unsigned max_n_length = 16;

void scopy(char * & source, char * dest)
{
	unsigned n=0;
	while((n<max_n_length)&&(*source))
	{
		*dest = *source;
		dest++;source++;
	}
	*dest = 0;
	*source++;
}

class GLTable : LTable
{
	protected:
	char names[10][10][max_n_length];
	int ltcpx, ltcpy; // control points coordinates
	public:
	//GLtble(unsigned,unsigned,unsigned,unsigned,char*[][]);
	void clear(unsigned,unsigned,int,int,char*);
	int action(unsigned,unsigned,unsigned);
	int setcon(unsigned,unsigned,unsigned,unsigned,unsigned);
};

/* Note about formation!

			1	2 ... n
		0
		n
		n-1
		.
		.
		.
		2
*/

void GLTable::clear(unsigned i,unsigned t,int cpx,int cpy, char * strary)
{
	LTable::clear(i,t);
	ltcpx=cpx;ltcpy=cpy;
	for(t=0;t<traits;t++)
		for(i=0;i<traits;i++)
			scopy(strary,names[t][i]);
	for(t=0;t<=(traits-1)*itemsnum;t++)
	{
		line(ltcpx-50,ltcpy+t*11,ltcpx+(traits-(t%itemsnum)-1)*itemsnum*11,ltcpy+t*11);
		line(ltcpx+t*11,ltcpy-50,ltcpx+t*11,ltcpy+(traits-(t%itemsnum)-1)*itemsnum*11);
	}
	for(t=0;t<traits-1;t++)
		for(i=0;i<itemsnum;i++)
			outtextxy(ltcpx-50, ltcpx+t*itemsnum*11,names[(t>0)*(traits-t)][i]);
	settextstyle(0,1,1);
	for(t=0;t<traits-1;t++)
		for(i=0;i<itemsnum;i++)
			outtextxy(ltcpx+t*itemsnum*11, ltcpy-50,names[t+1][i]);
	settextstyle(0,0,1);
};

int GLTable::setcon(unsigned t1,unsigned i1,unsigned t2, unsigned i2,unsigned val)
{
	unsigned x,y;
	if (LTable::setcon(t1,i1,t2,i2,val))
	{
		sound(50);
		delay(500);
		nosound();
		return 1;
	}
	else
	{
		if(t1>t2) {x=t1;t1=t2;t2=x;x=i1;i1=i2;i2=x;}
		if (t1 == 0)
		{
			x = ltcpx + (itemsnum*t2 + i2) * 11;
			y = ltcpy + i1 * 11;
		}
		else
		{
			x = ltcpx + ((t1-1)*itemsnum + i1)*11;
			y = ltcpy + ((traits-t2)*itemsnum + i2)*11;
		}
		putimage(x,y,signs[val],COPY_PUT);
		return 0;
	}
}

int GLTable::action(unsigned x, unsigned y, unsigned mouseb)
{
	// Checking if x and y are inside the GTable's area.
	int xx = (x-ltcpx)/(itemsnum*11), yy = (y-ltcpy)/(itemsnum*11);
	if (xx+yy>=traits) return 0;
	setcon(xx+1, ((x-ltcpx)%(itemsnum*11))/11, (traits-yy)*(yy>0), ((y-ltcpy)%(itemsnum*11))/11, (mouseb<middle) + (mouseb==right));
	return 1;
}
//	Returns : 1 if Action was done, 0 if the click was not in its area.

int main()
{
	int gd = VGA, g = VGAHI;
	initgraph(&gd,&g,"c:\\tc\\bin");
	cleardevice();
	GLTable l;
	l.clear(3,3,100,100,"David\0Michael\0Joey\0Red\0Green\0Blue\0Ford\0Saab\0Citroen");
	_AX = 1;asm int 0x16;
	return 0;
}