#!/usr/bin/perl -w

use strict;
use warnings;


my $h = q{Hello There};
print qq|$h, world!\n|;

my $t = q#Router#;
my $y = qq($h $h $h $t);
$y =~ s!Hello!Hi!;
print qq#$y\n#;

my @a = qw{one two three};
for my $i (0 .. $#a)
{
    print "$i: $a[$i]\n";
}
