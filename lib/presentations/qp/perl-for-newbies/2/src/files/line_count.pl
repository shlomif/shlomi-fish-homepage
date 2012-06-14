use strict;
use warnings;

my ($filename, $lines_num, $line, $c);

$lines_num = 0;
$filename = "input.txt";
open my $in,  "<", $filename;
while ($line = <$in>)
{
    $c = substr($line, 0, 1);
    if (lc($c) eq "a")
    {
        $lines_num++;
    }
}
close($in);

print "In " , $filename, " there are ",
    $lines_num, " lines that start with \"A\".\n";

