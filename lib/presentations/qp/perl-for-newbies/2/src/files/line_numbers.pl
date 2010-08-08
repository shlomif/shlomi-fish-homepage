
use strict;
use warnings;

my ($line_num, $line);

$line_num = 0;
open my $in, "<", "input.txt";
open my $out, ">", "output.txt";

while ($line = <$in>)
{
    # We aren't chomping it so we won't lose the newline.
    print {$out} $line_num, ": ", $line;
    $line_num++;
}

close ($in);
close ($out);
