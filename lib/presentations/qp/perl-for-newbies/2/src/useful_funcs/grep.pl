use strict;
use warnings;

my (@lines, $l);

my $filename = shift;

open I, "<", $filename;
while ($l = <I>)
{
    chomp($l);
    push @lines, $l;
}
close(I);

# Filter the comments
my @comments = grep(/^#/, @lines);
# Filter out the long comments
my @short_comments = (grep { length($_) <= 80 ; } @comments);

print join("\n", @short_comments), "\n";

