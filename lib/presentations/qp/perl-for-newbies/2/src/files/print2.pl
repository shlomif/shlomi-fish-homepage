use strict;
use warnings;

open my $seq1, ">", "seq1.txt";
open my $seq2, ">", "seq2.txt";

for (my $x=0 ; $x < 100 ; $x++)
{
    print {$seq1} $x, "\n";
    print {$seq2} $x, "\n";
    print {$seq1} ($x+0.1);
    print {$seq2} ($x+0.5);
    print {$seq1} "\n";
    print {$seq2} "\n";
}

close($seq1);
close($seq2);
