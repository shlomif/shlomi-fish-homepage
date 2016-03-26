
use strict;
use warnings;

my $filename = $ARGV[0];

open my $in, "<", $filename;
open my $out, ">", $filename.".bak";
print {$out} join("",<$in>);
close($in);
close($out);

