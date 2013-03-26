#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

#include <sys/file.h>
#include <sys/types.h>
#include <sys/stat.h>

int seeds[2000];

#define dprint(msg) \
    {        \
        printf("%s %i: %s!\n", (is_writer ? "Writer" : "Reader"), idx, (msg));   \
        fflush(stdout);      \
    }

void myloop(int idx, int is_writer)
{
    int lock;
    srand(seeds[is_writer * 1000 + idx]);

    lock = open("mylockfile", O_RDONLY);

    while (1)
    {
        dprint("Want Lock");
        flock(lock, (is_writer ? LOCK_EX : LOCK_SH));
        dprint("Lock");

        usleep(rand()%300000);

        dprint("Unlock");

        flock(lock, LOCK_UN);

        usleep(rand()%300000);
    }

    close(lock);
}

int main(int argc, char * argv[])
{
    int num_readers = 4;
    int num_writers = 2;
    int a;

    if (argc > 1)
    {
        num_readers = atoi(argv[1]);
        if (argc > 2)
        {
            num_writers = atoi(argv[1]);
        }
    }

    srand(24);
    for(a=0;a<(sizeof(seeds)/sizeof(seeds[0]));a++)
    {
        seeds[a] = (rand()%100000);
    }

    for(a=0;a<num_writers;a++)
    {
        if (!fork())
        {
            myloop(a,1);
        }
    }
    for(a=0;a<num_readers;a++)
    {
        if (!fork())
        {
            myloop(a,0);
        }
    }

    while(1)
    {
        sleep(1);
    }

    return 0;
}

