#!/usr/bin/perl

open I, "<seed.txt";
$seed = <I>;
chomp($seed);
close(I);

for(;;$seed++)
{
    open O, ">seed.txt";
    print O $seed, "\n";
    close (O);

    system("perl gen_graphs.pl $seed");
    if (system("perl Graphs_Equal.pl") == 5)
    {
        exit(5);
    }
}
