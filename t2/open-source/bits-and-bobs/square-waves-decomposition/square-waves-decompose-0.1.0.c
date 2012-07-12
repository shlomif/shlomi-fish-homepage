/*
 * square-waves.c : compose a sine wave out of square waves.
 *
 * the results of this program can be plotted using the gnuplot command:
 *
 *      plot "gnuplot.dat" , "sinplot.dat"
 *
 * Written by Shlomi Fish, 2007.
 *
 * Licensed under the MIT X11 license.
 *
 * Compile with:
 * gcc -o square-waves -Wall square-waves.c -lm
 *
 * Version: 0.1.0
 *
 * */
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <unistd.h>

typedef double value_t;

struct wave_struct
{
    /* The length of the wave. */
    int len;
    /* Its amplitude */
    value_t m;
};

typedef struct wave_struct wave_t;

#define CALC_SQUARE_WAVE(len,height,x) \
    ((((int)floor((x) * (len)))%2 == 0) ? (height) : (-(height)))

void square_wave(const value_t len, const value_t height,
        const int num_points, const value_t const * x_s, value_t * y_s
        )
{
    int i;

    for(i=0; i<num_points; i++)
    {
        y_s[i] = CALC_SQUARE_WAVE(len, height, x_s[i]);
    }
}

value_t calc_average(value_t * points, int num_points)
{
    value_t sum = 0;
    int i;

    for(i = 0 ; i < num_points ; i++)
    {
        sum += points[i]*points[i];
    }

    return sum/num_points;
}

int main(int argc, char * argv[])
{
    int num = 100;
    int x_num = 10000;
    int num_points;
    int i;
    int len;
    int x_int;

    value_t * good, * points, * p_ptr, * good_ptr, * base;
    value_t energy;
    wave_t * waves;

    int num_waves = 0, max_num_waves = 0;

    FILE * plot_fh, * sin_fh;

    num_points = num*2+1;

    points = malloc(sizeof(points[0]) * num_points);
    good = malloc(sizeof(good[0]) * num_points);
    base = malloc(sizeof(base[0]) * num_points);

    waves = malloc(sizeof(waves[0]) * max_num_waves);

    /*
     * Initialize points to -num ... num
     * Initialise good to the sinousidial wave.
     * */
    for(i=-num, p_ptr = points, good_ptr = good;
            i<=num;
            i++, p_ptr++, good_ptr++
       )
    {
        *p_ptr = (value_t)i / num;
        *good_ptr = sin(*p_ptr * M_PI);
    }

    len = 1;
    energy = calc_average(good, num_points);
    while (energy > 0.0002)
    {
        value_t numer = 0, denom = 0, m;

        square_wave((value_t)len, 1, num_points, points, base);

        for(i=0;i<num_points;i++)
        {
            numer += good[i] * base[i];
            denom += base[i] * base[i];
        }

        m = numer / denom;

        if (num_waves == max_num_waves)
        {
            max_num_waves += 16;
            waves = realloc(waves, sizeof(waves[0])*max_num_waves);
        }
        waves[num_waves].len = len;
        waves[num_waves].m = m;

        num_waves++;

        for(i=0;i<num_points;i++)
        {
            good[i] -= base[i] * m;
        }

        energy = calc_average(good, num_points);
        printf("%f\n", energy);
        len++;
    }

    free(base);

    plot_fh = fopen("gnuplot.dat", "wt");

    for(x_int=-x_num;x_int<=x_num;x_int++)
    {
        value_t x = ((value_t)x_int) / x_num;
        int wave_idx;
        value_t result;

        result = 0.0;
        for(wave_idx = 0 ; wave_idx < num_waves ; wave_idx++)
        {
            result +=
                CALC_SQUARE_WAVE(waves[wave_idx].len, waves[wave_idx].m, x)
                ;
        }
        fprintf(plot_fh, "%.10f %.10f\n", x, result);
    }
    fclose(plot_fh);

    if (!!access("sinplot.dat", F_OK))
    {
        sin_fh = fopen("sinplot.dat", "wt");
        for(x_int=-x_num;x_int<=x_num;x_int++)
        {
            value_t x = ((value_t)x_int) / x_num;

            fprintf(sin_fh, "%.10f %.10f\n", x, sin(x*M_PI));
        }
        fclose(sin_fh);
    }

    free(points);
    free(good);
    free(waves);

    return 0;
}
