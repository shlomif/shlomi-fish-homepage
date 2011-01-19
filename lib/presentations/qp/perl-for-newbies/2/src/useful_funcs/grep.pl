use strict;
use warnings;

my (@lines, $l);

my $filename = shift;

open my $in, "<", $filename;
while ($l = <$in>)
{
    chomp($l);
    push @lines, $l;
}
close($in);

# Filter the comments
my @comments = grep(/^#/, @lines);
# Filter out the long comments
my @short_comments = (grep { length($_) <= 80 ; } @comments);

print join("\n", @short_comments), "\n";

