use strict;
use warnings;

open SEQ1, ">", "seq1.txt";
open SEQ2, ">", "seq2.txt";

for($a=0;$a<100;$a++)
{
    print SEQ1 $a, "\n";
    print SEQ2 $a, "\n";
    print SEQ1 ($a+0.1);
    print SEQ2 ($a+0.5);    
    print SEQ1 "\n";
    print SEQ2 "\n";
}

close(SEQ1);
close(SEQ2);
