/*
	CPCX.H
		This header along with CPCX.LIB enables the programmer to put PCX
		images on screen and/or store them in memory.
	Programmed By Shlomi Fish, Tel-Aviv, Israel.
	Finishing Date:
		July 19th, 1994 - É"êôöÑ ÅÄÅ 'Äâ

	Note:
	Due to technical problems I was not able to check if the 24 bit image
	presentation works properly. If you find any bugs in it please contact
	me at: 03-6424668 (Israel) or ila2027@datasrv.co.il (Internet address) and
	I will try to fix it.

	Coming Soon (Hopefully):
	CBMP, CGIF, CTIFF.
	And following - headers to encode into those popular graphics formats!
	Stay tuned...
*/

#ifndef __CPCX_H
#define __CPCX_H
#endif
#idndef __STDIO_H
#include <stdio.h>
#endif

/*
	A structure containing the information about the pcx file:
	file_ptr - pointer to the file stream.
	Type - The type of the image (monochrome, 16 colors, 256 colors, etc.).
	Xlen - The width (in pixels) ; Ylen - The height (in pixels).
	BytesPerLine - The bytes required to store one line of image in one plane.
	pallete - pointer to the palette information. (Isn't used by the function PCX_GetImage)
*/
struct PCX_FILE
{
	FILE * file_ptr;
	int Type;
	unsigned Xlen, Ylen, BytesPerLine;
	unsigned char * palette;
};

/*
	Enumeration for PCX_FILE.Type:
	Monochrome - G_2 or G_BandW or G_BlackandWhite
	4 colors CGA - G_4 or G_CGA
	16 colors EGA - G_16 or G_EGA
	256 colors VGA - G_256 or G_VGA
	24 Bit Image (16.8 Million colors) - G_24Bit or G_TrueColor
	an Unknown Image type - G_UNKNOWN
	Error reading image - G_ERROR
*/

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

/*
  Enumeration for the graphics target wanted(screen, memory buffer or both)
*/
enum Graphics_Target {
	G_Screen = 0,
	G_Buffer = 1,
	G_Both = 2
};

/*
	Enumeration for the variables EGA_RGB_CON and VGA_RGB_CON:
	G_EGA_Reg_CON - Regular EGA 2 bit values.
	G_Borland_CON - For use with setrgbpalette - 4 bit values.
	G_BIOS_CON - The BIOS form which has 6 bit values, used to define VGA colors.
	G_TrueColor_CON - For 24 Bit scrrens that present EGA or VGA bitmaps.
*/
enum RGB_CON_TYPE {
	G_EGA_Reg_CON = 6,
	G_Borland_CON = 4,
	G_BIOS_CON = 2,
	G_TrueColor_CON = 0
}

unsigned EGA_RGB_CON=G_BIOS_CON;
unsigned VGA_RGB_CON=G_BIOS_CON;



/* The main functions */

struct PCX_FILE PCX_ReadHeader (FILE * f, unsigned char * palette);
int PCX_GetImage(struct PCX_FILE pcx, int xpos, int ypos, unsigned char * buf, int target);

/*
	User-defined macros for presenting the image on screen
*/
#define G_PIXEL_2(x, y, col)        putpixel(x,y,col)
#define G_PIXEL_4(x, y, col)        putpixel(x,y,col)
#define G_PIXEL_16(x, y, col)       putpixel(x,y,col)
#define G_PIXEL_256(x, y, col)      putpixel(x,y,col)
#define G_PIXEL_24Bit(x,y,r,g,b)    putpixel(x,y,r+g+b)

/*
	Assistant functions for reading and writing bits or quarters of a byte (two bits chunks).
*/

void bwrite(unsigned char * c, unsigned place, unsigned value);
unsigned int bread(unsigned char c, unsigned int place);
void qwrite(unsigned char * c, unsigned place, unsigned value);
unsigned int qread(unsigned char c, unsigned int place);
