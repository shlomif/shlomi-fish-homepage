
use strict;
use warnings;

do "lol.pl";         # Load the other file

my $cont = get_contents();

print $cont->{'title'}, "\n";
print $cont->{'subs'}->[0]->{'url'}, "\n";
print $cont->{'subs'}->[0]->{'subs'}->[1]->{'title'}, "\n";
