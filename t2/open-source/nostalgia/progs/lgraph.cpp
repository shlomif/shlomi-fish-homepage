/* LGraph - programmed by Shlomi Fish
	Starting Date - 13th of November, 1993
*/

#include <graphics.h>
#include <fstream.h>
#include <conio.h>

char p[3][86] = {"\0\0\0","\0\0\0","\0\0\0"};

int main()
{
	ofstream of;
	of.open("b:\\prog\\g.dat");
	int a=VGA,b=VGAHI,c,d=0;
	initgraph(&a,&b,"c:\\tc\\bgi");
	cleardevice();
	for(a=0;a<11;a++)
	{
		line(20,20+a*10,120,20+a*10);
		line(20+a*10,20,20+a*10,120);
	}
	while (d<=2)
	{
		a=getch();
		b=getch();
		c=getch();
		if ((a>='0')&&(a<='9'))
		{
			putpixel(200+(a-'0'),200+(b-'0'),(!(c=='0'))*7);
			setfillstyle(1,!(c=='0')*13);
			floodfill(25+(a-'0')*10,25+(b-'0')*10,15);
		}
		else if (a == 's')
		{
			getimage(200,200,209,209,(void*)&p[d][0]);
			putimage(300,300,(void*)&p[d][0],COPY_PUT);
			for (a=0;a<86;a++)
				of.put(p[d][a]);
			d++;
		}
	}
	of.close();
	return 24;
}
