#include <graphics.h>
#include <time.h>
#include <stdlib.h>
#include <math.h>

unsigned accuracy = 1000;

enum bez_num {S=0, L=1, R=2, E=3};

void bezier(int * x, int * y)
{
	unsigned pf, color = getcolor();
	int xp[4] = {x[S], 3*(x[L]-x[S]), 3*(x[R]+x[S]-2*x[L]), 3*(x[L]-x[R])+x[E]-x[S]};
	int yp[4] = {y[S], 3*(y[L]-y[S]), 3*(y[R]+y[S]-2*y[L]), 3*(y[L]-y[R])+y[E]-y[S]};
	double p, p1 = 1/(double)accuracy;
	for (pf=0;pf<=accuracy;pf++)
	{
		p = p1*pf;
		putpixel(xp[0]+p*(xp[1]+p*(xp[2]+p*xp[3])), yp[0]+p*(yp[1]+p*(yp[2]+p*yp[3])), color);
	}
}

double angle_type_n = 1;

void angle_bezier(double * data)
{
	int x[4], y[4];
	x[0] = (int)data[0];
	y[0] = (int)data[1];
	x[3] = (int)data[6];
	y[3] = (int)data[7];
	x[1] = (int)(x[0]+data[2]*cos(data[3]*angle_type_n));
	y[1] = (int)(y[0]-data[2]*sin(data[3]*angle_type_n));
	x[2] = (int)(x[3]+data[4]*cos(data[5]*angle_type_n));
	y[2] = (int)(y[3]-data[4]*sin(data[5]*angle_type_n));
	bezier(x,y);
}
// The argument is the data field of the positions of the start point and end
// point and the angles and lengthes of the "guide lines".


int main()
{
	angle_type_n = M_PI / 180;
	randomize();
	int a = DETECT,b, x[4] = {10,100,500,600}, y[4] = {10,20,280,300};
//	double d[8] = {10.0,10.0,45.0,280.0,40.0,140.0,300.0,200.0};
	double d[8] = {10,10,40,135,200,90,600,300};
	initgraph(&a,&b,"c:\\tc\\bgi");
	setcolor(2);
	_AX = 1;asm int 0x16;
	angle_bezier(d);
	_AX = 1;asm int 0x16;
	return 0;
}

/*#define prop(x1, x2) (x1+(x2-x1)*a/300)
void bezier(int sx, int sy, int ex, int ey,
				int s_x, int s_y, int e_x, int e_y)
{
	double px[7], py[7];
	for (int a=0;a<300;a++)
	{
		px[1] = prop(sx,s_x);
		py[1] = prop(sy,s_y);
		px[2] = prop(s_x,e_x);
		py[2] = prop(s_y,e_y);
		px[3] = prop(e_x,ex);
		py[3] = prop(e_y,ey);
		px[4] = prop(px[1],px[2]);
		py[4] = prop(py[1],py[2]);
		px[5] = prop(px[2],px[3]);
		py[5] = prop(py[2],py[3]);
		px[6] = prop(px[4],px[5]);
		py[6] = prop(py[4],py[5]);
		putpixel((int)px[6],(int)py[6],getcolor());
	}
}*/