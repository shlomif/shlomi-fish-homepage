use strict;
use warnings;

my $index = 0;
sub put_index
{
    $index++;
    return $index;
}

my $string = shift;

$string =~ s/hello/put_index()/gei;

print $string, "\n";
