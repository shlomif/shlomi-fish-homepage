
use strict;
use warnings;

my ($line_num, $line);

$line_num = 0;
open I, "<", "input.txt";
open O, ">", "output.txt";

while ($line = <I>)
{
    # We aren't chomping it so we won't lose the newline.
    print O $line_num, ": ", $line;
    $line_num++;
}

close (I);
close (O);
