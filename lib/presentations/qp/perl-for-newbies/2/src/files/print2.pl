use strict;
use warnings;

open my $seq1, ">", "seq1.txt";
open my $seq2, ">", "seq2.txt";

for($a=0;$a<100;$a++)
{
    print {$seq1} $a, "\n";
    print {$seq2} $a, "\n";
    print {$seq1} ($a+0.1);
    print {$seq2} ($a+0.5);
    print {$seq1} "\n";
    print {$seq2} "\n";
}

close($seq1);
close($seq2);
