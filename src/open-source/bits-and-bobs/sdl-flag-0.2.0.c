#include <stdio.h>
#include <math.h>
#include <signal.h>

#ifndef SDLVER
#define SDLVER 1
#endif

#include <SDL.h>


#define PI 3.14159265358

#if 0
/* This putpixel definition was ripped from the SDL doc project */

/*
 * Set the pixel at (x, y) to the given value
 * NOTE: The surface must be locked before calling this!
 */
void putpixel(SDL_Surface *surface, int x, int y, Uint32 pixel)
{
    int bpp = surface->format->BytesPerPixel;
    /* Here p is the address to the pixel we want to set */
    Uint8 *p = (Uint8 *)surface->pixels + y * surface->pitch + x * bpp;

    switch(bpp) {
    case 1:
        *p = pixel;
        break;

    case 2:
        *(Uint16 *)p = pixel;
        break;

    case 3:
        if(SDL_BYTEORDER == SDL_BIG_ENDIAN) {
            p[0] = (pixel >> 16) & 0xff;
            p[1] = (pixel >> 8) & 0xff;
            p[2] = pixel & 0xff;
        } else {
            p[0] = pixel & 0xff;
            p[1] = (pixel >> 8) & 0xff;
            p[2] = (pixel >> 16) & 0xff;
        }
        break;

    case 4:
        *(Uint32 *)p = pixel;
        break;
    }
}

#else
#define putpixel(surface, x, y, pixel)  \
    {   \
        *(Uint8 *)(surface->pixels + (y) * surface->pitch + x) = pixel; \
    }
#endif

/*
 * Linus Torvalds would kill me if he saw this, but who is John Galt?
 * (at least not Linus, I hope)
 * */
#define min(a,b) (((a)<(b))?(a):(b))
#define max(a,b) (((a)>(b))?(a):(b))

int mycont = 1;

void my_stop_program(int signal_number)
{
    mycont = 0;
}

#define LOG2_DEGREES_RANGE 9
#define DEGREES_RANGE (1 << (LOG2_DEGREES_RANGE))
#define DEG_MOD(x) ((x)&(DEGREES_RANGE-1))

int main(int argc, char * argv[])
{
    int x_num_points = 20;
    int y_num_points = 10;
    int x_x_offset = 20;
    int x_y_offset = 0;
    int y_x_offset = 3;
    int y_y_offset = 10;
    double y_amplitude = 10.0;
    int y_amp_delta = 50;
    int x_amp_delta = 20;
    /* This is so it won't get out of the end of the screen */
    int y_abs_offset = 20;
    int x_abs_offset = 10;
    int sin_lookup[DEGREES_RANGE];

    int x,y,t, prev_t;
    int prev_y_height;
    int this_y_height;
    int x_pos, y_pos;

    int y_acc_degree, y_x_acc_degree;
    int prev_y_acc_degree, prev_y_x_acc_degree;
    int y_acc_y_pos, y_acc_x_pos;

    Uint8 fill_color, pen_color;

#if SDLVER == 1
    SDL_Surface *screen;
#endif
    SDL_Rect * rects;
    SDL_Rect * the_rect;
    SDL_Event event;

    int a;

    for(a=0 ; a < DEGREES_RANGE  ;a++)
    {
        sin_lookup[a] = (int)(sin((2*PI/DEGREES_RANGE)*a)*y_amplitude);
    }

    /* Initialize the SDL library */
    if( SDL_Init(SDL_INIT_VIDEO) < 0 ) {
        fprintf(stderr,
                "Couldn't initialize SDL: %s\n", SDL_GetError());
        exit(1);
    }

    /* Clean up on exit */
    atexit(SDL_Quit);

#if 0
    signal(SIGQUIT, my_stop_program);
    signal(SIGINT, my_stop_program);
#endif

    /*
     * Initialize the display in a 640x480 8-bit palettized mode,
     * requesting a software surface
     */
#if SDLVER == 2
SDL_Window *screen = SDL_CreateWindow("My Game Window",
                          SDL_WINDOWPOS_UNDEFINED,
                          SDL_WINDOWPOS_UNDEFINED,
                          640, 480,
                          SDL_WINDOW_FULLSCREEN | SDL_WINDOW_OPENGL);
#else
    screen = SDL_SetVideoMode(640, 480, 8, SDL_SWSURFACE);
#endif
    if ( screen == NULL ) {
        fprintf(stderr, "Couldn't set 640x480x8 video mode: %s\n",
                        SDL_GetError());
        exit(1);
    }

#if SDLVER == 2
SDL_Renderer *renderer = SDL_CreateRenderer(screen, -1, 0);
#endif
#if 0
    fill_color = (Uint8)SDL_MapRGB(screen->format, 0x00, 0x00, 0x00);
    pen_color = (Uint8)SDL_MapRGB(screen->format, 0xFF, 0xFF, 0xFF);
#else
    fill_color = (Uint8)SDL_MapRGB(screen->format, 0xFF, 0xFF, 0xFF);
    pen_color = (Uint8)SDL_MapRGB(screen->format, 0x00, 0x00, 0x00);
#endif

    rects = (SDL_Rect *)malloc(sizeof(rects[0]) * x_num_points*y_num_points);
    for(a=0;a<x_num_points*y_num_points;a++)
    {
        rects[a].w = 1;
        rects[a].h = 2;
    }

    printf("%i\n", SDL_MUSTLOCK(screen));

    /*
     * Calculate all the x positions of the rects in advance
     * */
    the_rect = rects;
    y_acc_x_pos = x_abs_offset;
    for(y=0;y<y_num_points;y++)
    {
        x_pos = y_acc_x_pos;
        for(x=0;x<x_num_points;x++)
        {
            the_rect->x = x_pos;
            the_rect++;
            x_pos += x_x_offset;
        }
        y_acc_x_pos += y_x_offset;
    }

    {
        SDL_Rect whole_screen_rect;
        whole_screen_rect.x = whole_screen_rect.y = 0;
        whole_screen_rect.w = 640;
        whole_screen_rect.h = 480;
        SDL_FillRect(screen,&whole_screen_rect, fill_color);
        /* The 0's indicate that the whole screen needs to be updated */
        SDL_UpdateRect(screen,0,0,0,0);
    }
    prev_t = 0;
    for(t=1 ; mycont ; t = ((t+1)&(DEGREES_RANGE-1)))
    {
        the_rect = rects;

        y_acc_degree = t;
        prev_y_acc_degree = prev_t;
        y_acc_y_pos = y_abs_offset;
        y_acc_x_pos = x_abs_offset;
        for(y=0;y<y_num_points;y++)
        {
            y_x_acc_degree = y_acc_degree;
            prev_y_x_acc_degree = prev_y_acc_degree;

            x_pos = y_acc_x_pos;
            y_pos = y_acc_y_pos;
            for(x=0;x<x_num_points;x++)
            {
                prev_y_height =
                    y_pos +
                    sin_lookup[prev_y_x_acc_degree]
                    ;
                this_y_height =
                    y_pos +
                    sin_lookup[y_x_acc_degree]
                    ;

                the_rect->y = min(prev_y_height,this_y_height);
                the_rect++;

                /* I don't need to lock the screen, so I'm omitting it */

                putpixel(
                    screen,
                    x_pos,
                    prev_y_height,
                    fill_color
                    );

                putpixel(
                    screen,
                    x_pos,
                    this_y_height,
                    pen_color
                    );


                y_x_acc_degree = DEG_MOD(y_x_acc_degree+x_amp_delta);
                prev_y_x_acc_degree = DEG_MOD(prev_y_x_acc_degree+x_amp_delta);
                x_pos += x_x_offset;
                y_pos += x_y_offset;
            }
            y_acc_degree = DEG_MOD(y_acc_degree+y_amp_delta);
            prev_y_acc_degree = DEG_MOD(prev_y_acc_degree+y_amp_delta);
            y_acc_y_pos += y_y_offset;
            y_acc_x_pos += y_x_offset;
        }

        SDL_UpdateRects(screen, x_num_points*y_num_points, rects);

        prev_t = t;

        while (SDL_PollEvent(&event))
        {
            switch(event.type)
            {
                case SDL_QUIT:
                    mycont = 0;
                    break;

            }
        }
    }

    return 0;
}
