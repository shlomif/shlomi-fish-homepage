#include <graphics.h>
#include <svga256.h>
#include <conio.h>
#include <fstream.h>
#include <stdlib.h>


int huge return0(void) {return 0;}

const unsigned SVGA_RED = 39;
const unsigned cell_x = 14;
const unsigned cell_y = 13;
const unsigned cell_mem_size = 214;
// for 320*200:
// const unsigned cell_x = 7;
// const unsigned cell_y = 7;

char pixel[cell_x][cell_y], cursx, cursy;
char dc[20];


void draw_table()
{
	int a, b,c;
	cleardevice();
	setcolor(7);
	for(a=0;a<=cell_x;a++)
		line(a*10,0,a*10,130);
	for(a=0;a<=cell_y;a++)
		line(0,a*10,140,a*10);
	for(a=0;a<cell_x;a++)
		for(b=0;b<cell_y;b++)
		{
			setcolor(pixel[a][b]);
			for(c=1;c<10;c++)
				line(a*10+1,b*10+c,a*10+9,b*10+c);
			putpixel(200+a,50+b,pixel[a][b]);
	}
	cursx=0;cursy=0;
	putimage(4,4,(void*)dc, XOR_PUT);
}

void put_cell(int color)
{
	setcolor(color);
	for(int a=1;a<10;a++)
		line(cursx*10+1,cursy*10+a,cursx*10+9,cursy*10+a);
	putpixel(200+cursx, 50+cursy, color);
	putimage(10*cursx+4,10*cursy+4,(void*)dc, XOR_PUT);
	pixel[cursx][cursy] = color;
}

int main()
{
	char c='*', n1,n2,n3, cursor[214], blank[1000], thispict[214], s[20];
	int gi, gm = SVGA640x400x256, color,a,b,dx,dy;
	ofstream out_file;
	gi = installuserdriver("svga256",return0);
	initgraph(&gi,&gm,"c:\\tc\\bgi");
	// the cursor
	setcolor(SVGA_RED);
	rectangle(0,0,13,12);
	getimage(0,0,13,12, (void*)cursor);
	setcolor(200);
	// the diagram's cursor
	rectangle(10,10,12,12);
	getimage(10,10,12,12, (void*)dc);
	// the blank (to erase the color's number from the screen).
	getimage(100,100,123,107,(void*)blank);
	for(a=0;a<cell_x;a++)
		for(b=0;b<cell_y;b++)
			pixel[a][b] = 0;
	draw_table();dx = dy = 0;color=0;
	setcolor(8);moveto(200,0);outtext("0");
	while (c != 24)
	{
		c = getch();
		switch(c)
		{
			case 0:
			c = getch();
			switch(c)
			{
				case 72: if (cursy>0) dy = -1;break;
				case 80: if (cursy<cell_y-1) dy = 1;break;
				case 75: if (cursx>0) dx = -1;break;
				case 77: if (cursx<cell_x-1) dx = 1;
			}
			break;
			case 13:
			put_cell(color);
			break;
			case '+':
			if (color<246) color+=10;
			putimage(200,0,(void*)blank,COPY_PUT);
			setcolor(color);outtextxy(200,0,itoa(color,s,10));
			break;
			case '-':
			if (color>9) color-=10;
			putimage(200,0,(void*)blank,COPY_PUT);
			setcolor(color);outtextxy(200,0,itoa(color,s,10));
			break;
			case '.':
			if (color<255) color++;
			putimage(200,0,(void*)blank,COPY_PUT);
			setcolor(color);outtextxy(200,0,itoa(color,s,10));
			break;
			case ',':
			if (color>0) color--;
			putimage(200,0,(void*)blank,COPY_PUT);
			setcolor(color);outtextxy(200,0,itoa(color,s,10));
			break;
			case 'c':
			n1=getch();n2=getch();n3=getch();
			if((n1>='0')&&(n1<='9')&&(n2>='0')&&(n2<='9')&&(n3>='0')&&(n3<='9'))
			{
				color = (n1-'0')*100+(n2-'0')*10+n1-'0';
				setcolor(color);
				putimage(200,0,(void*)blank,COPY_PUT);
				outtextxy(200,0,itoa(color,s,10));
			}
			break;
			case 's':
			getimage(200,50,213,62,(void*)thispict);
			closegraph();
			cout << "\nPlease type the file name - \n";
			cin.getline(s,100);
			out_file.open(s);
			for(a=0;a<214;a++)
				out_file.put(thispict[a]);
			out_file.close();
			initgraph(&gi,&gm,"c:\\tc\\bgi");
			draw_table();
		}
		putimage(cursx*10+4,cursy*10+4,(void*)dc,XOR_PUT);
		cursx+= dx; cursy+=dy; dx=dy=0;
		putimage(cursx*10+4,cursy*10+4,(void*)dc,XOR_PUT);
	}
	closegraph();
	return 0;
}

/*while((c = getch()) != 13)
	{
		if (c == '+') color++;
		if (c == '-') color--;
		setcolor(color);
		rectangle(10,10,22,21);
	}*/