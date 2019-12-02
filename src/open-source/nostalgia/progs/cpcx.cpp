#include <graphics.h>
#include <stdio.h>
#include <iostream.h>
#include <vgapalet.c>
#include <math.h>
#include <dos.h>

int return0() {return 0;}

struct PCX_FILE
{
	FILE * file_ptr;
	int Type;
	unsigned Xlen, Ylen, BytesPerLine;
	char * pallete;
};

enum Graphics_File_Type {
	G_2 = 0,
	G_BandW = G_2,
	G_BlackandWhite = G_2,
	G_4 = 1,
	G_CGA = G_4,
	G_16 = 2,
	G_EGA = G_16,
	G_256 = 3,
	G_VGA = G_256,
	G_24Bit = 4,
	G_TrueColor = G_24Bit,
	G_UNKNOWN = 100,
	G_ERROR = 200
};

/*int TypeHeader (char * name)
{
	char header[128];
	int handle = open(name,O_RDONLY|O_BINARY);
	read(handle,(void*)header,128);
	cout << "\n" << name << ": \n";
	if(header[0] == 10) cout << "Is a PCX file.\n";
	else cout << "Is not a PCX file.\n";
	if(header[2] != 1) cout << "The file is encoded!\n";
	cout << "Version: ";
	switch(header[1])
	{
		case 0 : cout << "2.5\n";break;
		case 2 : cout << "2.8 (with pallete)\n";break;
		case 3 : cout << "2.8 (without pallete)\n";break;
		case 5 : cout << "3.0\n";break;
		default : cout << "Unknown Version!\n";
	};
	cout << "There are " << (int)header[3] << " bits per pixel.\n";
	cout << "Size :" << *((int*)(&header[8]))-*((int*)(&header[4]))+1 << "*" << *((int*)(&header[10]))-*((int*)(&header[6]))+1 << '\n';
	cout << "There are " << *((int*)(&header[66])) << "Bytes per Line.\n";
	cout << "There are " << (int)header[65] << " planes.\n";
	if (header[68]==1) cout << "The image is color or black&white.\n";
	else cout << "This is a grayscale image.\n";
	close(handle);
	return 0;
}*/

PCX_FILE PCX_ReadHeader (FILE * f, char * palette)
{
	PCX_FILE pcx;
	char header[128];
	int a, ver, bits_per_pix, nplanes;
	pcx.file_ptr = f;
	fseek(f,0,SEEK_SET);
	fread((void*)header,128,1,f);
	if ((header[0] != 10)||(header[2]!=1))
	{
		pcx.Type = G_ERROR;
	}
	else
	{
		ver = header[1];
		bits_per_pix = (int)header[3];
		pcx.Xlen = *((unsigned*)(&header[8]))-*((unsigned*)(&header[4]))+1;
		pcx.Ylen = *((unsigned*)(&header[10]))-*((unsigned*)(&header[6]))+1;
		pcx.BytesPerLine = *((unsigned*)(&header[66]));
		nplanes = (int)header[65];
		switch(bits_per_pix)
		{
			case 1 :
			switch(nplanes)
			{
				case 1 : pcx.Type = G_BlackandWhite;break;
				case 4 : pcx.Type = G_EGA;
				for(a=0;a<48;a++)
					palette[a] = header[16+a]>>2;
				break;
				default : pcx.Type = G_UNKNOWN;
			}
			break;
			case 2 :
			if (nplanes == 1)
			{
				pcx.Type = G_CGA;
				palette[0] = header[19]>>5;
				palette[1] = header[16]>>4;
			}
			else
				pcx.Type = G_UNKNOWN;
			break;
			case 8 :
			switch(nplanes)
			{
				case 1 : pcx.Type = G_VGA;
				fseek(f,-769,SEEK_END);
				if ((getc(f) != 12)||(ver!=5))
					pcx.Type = G_UNKNOWN;
				else
					for(a=0;a<768;a++)
						palette[a] = getc(f)>>2;
				break;
				case 3 : pcx.Type = G_24Bit;break;
				default : pcx.Type = G_UNKNOWN;
			}
			break;
			default:
			pcx.Type = G_UNKNOWN;
		}
	}
	return pcx;
}

/* Functions to read and write bits or byte-quarters (two bit chunks)

*/

void bwrite(unsigned char * c, unsigned place, unsigned value)
{
	if (value) *c |= 1 << place;
	else *c &= 255 - (1 << place);
}

unsigned int bread(unsigned char c, unsigned int place)
{
	return (c & (1<<place))>>place;
}

void qwrite(unsigned char * c, unsigned place, unsigned value)
{
	bwrite(c,place<<1,value-(value>>2)*2);
	bwrite(c,place<<1+1,value>>2);
}

unsigned int qread(unsigned char c, unsigned int place)
{
	return (c & (3<<(place<<1)))>>(place<<1);
}

void put24bit(int x, int y, int r, int g, int b)
{
	x+=y;r+=g;b++;
}

char palinfo[256][3];
#define G_PIXEL_2(x, y, col)			putpixel(x,y,col)
#define G_PIXEL_4(x, y, col)			putpixel(x,y,col)
#define G_PIXEL_16(x, y, col)			putpixel(x,y,col)
#define G_PIXEL_256(x, y, col)		putpixel(x,y,col)
#define G_PIXEL_24Bit(x,y,r,g,b)		rgbput(x,y,r>>2,g>>2,b>>2)

void rgbput(int x, int y, int r, int g, int b)
{
	unsigned dmin=800, clos_col,d;
	for(unsigned a=0;a<256;a++)
	{
		d=abs(palinfo[a][0]-r)+abs(palinfo[a][1]-g)+abs(palinfo[a][2]-b);
		if (d<dmin)
		{
			clos_col = a;dmin = d;
		}
	}
	putpixel(x,y,clos_col);
}


enum Graphics_Target {
	G_Screen = 0,
	G_Buffer = 1,
	G_Both = 2
};



int PCX_GetImage(PCX_FILE pcx, int xpos, int ypos, char * buf, int target, int whole_bytes)
{
	unsigned x=0, y=0, bytesnum=0, pcnt, pbyt, a,b, col, p;
	int i;
	FILE * f = pcx.file_ptr;
	fseek(f,128,SEEK_SET);
	switch(pcx.Type)
	{
		case G_BlackandWhite :
		for(y=0;y<pcx.Ylen;y++)
		{
			while (bytesnum<pcx.BytesPerLine)
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
				for(a=0;a<pcnt;a++)
					buf[bytesnum++] = pbyt;
			}
			if (target%2==0)
				for(x=0;x<pcx.Xlen;x++)
					G_PIXEL_2(x+xpos,y+ypos,bread(buf[x>>3],7-x%8)*30);
			if (target>1)
				buf += x>>3+(x%8!=0);
			bytesnum = 0;//x=0;
		}
		break;
		case G_CGA :
		for(y=0;y<pcx.Ylen;y++)
		{
			while (bytesnum<pcx.BytesPerLine)
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
				for(a=0;a<pcnt;a++)
					buf[bytesnum++] = pbyt;
			}
			if (target%2==0)
				for(x=0;x<pcx.Xlen;x++)
					G_PIXEL_4(x+xpos,y+ypos,qread(buf[x>>2],3-x%4));
			if (target > 1)
				buf += x>>2 + (x%4!=0);
			bytesnum = 0;//x=0;
		}
		break;
		case G_EGA:
		for(y=0;y<pcx.Ylen;y++)
		{
			for(p=0;p<4;p++)
			{
				while (bytesnum<pcx.BytesPerLine*4)
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
					for(a=0;a<pcnt;a++)
						for(b=0;b<8;b++)
						{
							bwrite(buf+bytesnum,4*(b%2)+p,bread(pbyt,7-b));
							if (b%2) bytesnum++;
						}
				}
				bytesnum=0;
			}
			if (target%2==0)
				for(x=0;x<pcx.Xlen;x++)
					G_PIXEL_16(x+xpos,y+ypos,(x%2)?((buf[x>>1]&240)>>4):(buf[x>>1]&15));
			if (target>1)
				buf += x>>1+(x%2==1);
			bytesnum = 0;//x=0;
		}
		break;
		case G_VGA:
		for(y=0;y<pcx.Ylen;y++)
		{
			while (bytesnum<pcx.BytesPerLine)
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
				for(a=0;a<pcnt;a++)
					buf[bytesnum++] = pbyt;
			}
			if (pcnt==1)
			{
				sound(440);delay(100);nosound();
			}
			getch();
			if(target%2==0)
				for(x=0;x<pcx.Xlen;x++)
					G_PIXEL_256(x+xpos,y+ypos,buf[x]);
			if(target>1)
				buf+=x;
			bytesnum = 0;//x=0;
		}
		break;
		case G_24Bit:
		for(y=0;y<pcx.Ylen;y++)
		{
			for(p=0;p<3;p++)
			{
				bytesnum=p;
				while (bytesnum<pcx.BytesPerLine)
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
					for(a=0;a<pcnt;a++)
						buf[(bytesnum+=3)-3] = pbyt;
				}
			}
			if(target%2==0)
				for(x=0;x<pcx.Xlen;x++)
					G_PIXEL_24Bit(x+xpos,y+ypos,buf[x*3],buf[x*3+1],buf[x*3+2]);
			if(target>1)
				buf+=x*3;
			bytesnum = 0;//x=0;
		}
		default:
		return 0;
	}
	return 1;
}

void pcx_reverse(PCX_FILE pcx, unsigned char * buf)
{
	unsigned byte,line,part,width;
	unsigned char temp;
	switch(pcx.Type)
	{
		case G_BlackandWhite:
		width = pcx.Xlen>>3+(pcx.Xlen%8!=0);
		for(line=0;line<pcx.Ylen;line++)
			for(byte=0;byte<width;byte++)
				for(part=0;part<4;part++)
				{
					temp = bread(buf[line*width+byte],part);
					bwrite(*buf+(line*width+byte),part,bread(buf[line*width+byte],7-part));
					bwrite(*buf+(line*width+byte),7-part,temp);
				}
		break;
		case G_CGA:
		width = pcx.Xlen>>2+(pcx.Xlen%4!=0);
		for(line=0;line<pcx.Ylen;line++)
			for(byte=0;byte<width;byte++)
				for(part=0;part<2;part++)
				{
					temp = qread(buf[line*width+byte],part);
					qwrite(*buf+(line*width+byte),part,bread(buf[line*width+byte],3-part));
					qwrite(*buf+(line*width+byte),3-part,temp);
				}
		break;
		case G_EGA:
		width = pcx.Xlen>>1+pcx.Xlen%2;
		for(line=0;line<pcx.Ylen;line++)
			for(byte=0;byte<width;byte++)
				buf[line*width+byte]= (buf[line*width+byte]&0xf)>>4+(buf[line*width+byte]&0xf0)<<4;
}

int main()
{
	FILE * f;
	PCX_FILE pcx;
	char name[30], buf[1000];
	int gi=installuserdriver("Svga256",return0), gm = SVGA640x400x256,a,b,c;
	do {
		cin >> name;
		f = fopen(name,"rb");
		pcx = PCX_ReadHeader(f, &palinfo[0][0]);
		initgraph(&gi,&gm,"c:\\tc\\bgi");
		setvgapalette256(&palinfo);
		PCX_GetImage(pcx,0,0,buf,G_Screen,0);
		_AX = 1; asm int 0x16;
		closegraph();
	} while (name[0]!='~');
	return 0;
}