#include <stdio.h>
#include <stdlib.h>

typedef long long CARD;
#define     BLACK           0               // COLOUR(card)
#define     RED             1

#define     ACE             0               // VALUE(card)
#define     DEUCE           1

#define     CLUB            0               // SUIT(card)
#define     DIAMOND         1
#define     HEART           2
#define     SPADE           3

#define     SUIT(card)      ((card) % 4)
#define     VALUE(card)     ((card) / 4)
#define     COLOUR(card)    (SUIT(card) == DIAMOND || SUIT(card) == HEART)

#define     MAXPOS         21
#define     MAXCOL          9    // includes top row as column 0

long long seed = 0;
long long getSeed(void)
{
    return seed;
}
void setSeed(long long newseed)
{
    seed = newseed;
}
void mysrand(long long newseed)
{
    return setSeed(newseed);
}
         long long myrand(void) {
             setSeed((getSeed() * 214013 + 2531011) & 0x7FFFFFFF);
             return ((getSeed() >> 16) & 0x7fff);
         }

int main(int argc, char *argv[])
{
    int gamenumber = 11982;
    if (argc >= 2)
    {
        gamenumber = atoi(argv[1]);
    }
    CARD    card[MAXCOL][MAXPOS];    // current layout of cards, CARDs are ints

    int  i, j;                // generic counters
    int  col, pos;
    int  wLeft = 52;          // cards left to be chosen in shuffle
    CARD deck[52];            // deck of 52 unique cards

    for (col = 0; col < MAXCOL; col++)          // clear the deck
        for (pos = 0; pos < MAXPOS; pos++)
            card[col][pos] = 0;

    /* shuffle cards */

    for (i = 0; i < 52; i++)      // put unique card in each deck loc.
        deck[i] = i;

    mysrand(gamenumber);            // gamenumber is seed for rand()
    for (i = 0; i < 52; i++)
    {
        j = myrand() % wLeft;
        card[(i%8)+1][i/8] = deck[j];
        deck[j] = deck[--wLeft];
    }


    int mycol = 0;
    int myheight = 0;

    for (mycol = 0; mycol < 8; ++mycol)
    {
        fprintf(stdout, "%s", ":");
        for (myheight = 0; myheight < (mycol < 4? 7:6); ++myheight)
        {
            CARD c = card[mycol+1][myheight];
            const int v = VALUE(c);
            const int suit = SUIT(c);
            fprintf(stdout, " %c%c", "A23456789TJQK"[v], "CDHS"[suit]);
        }
        fprintf(stdout, "%s", "\n");
    }

    if (gamenumber > 11982)
    {
        fprintf(stdout, "\n\n");
        fprintf(stdout, "%s %lld %s\n", "Happy new year ", gamenumber,
" to #TeamGrimmie from Team Grindolfism v2.x.y (Shlomi Fish, Rindolf Hitlower, Emma Watson and co.)! Eat shit and die motherfucker $SATAN! The 10-based d10 rolled \"00\". Yours truly, the Jehovah Monty Python's Flying Circus' Neo-Tech Conspiracy for establishing the Semitic Culture and the whole of Fantastecha™[0, 1, 2, 5, 10]."

            );
    }

    return 0;
}
