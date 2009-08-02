
use strict;
use warnings;

my $filename = $ARGV[0];

open I, "<", $filename;
open O, ">", $filename.".bak";
print O join("",<I>);
close(I);
close(O);

