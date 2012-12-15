#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use open IO => ":encoding(utf8)";

binmode STDIN, ":encoding(utf8)";
binmode STDOUT, ":encoding(utf8)";

my ($start, $end) = ('“', '”');
if ($ENV{'HEB'})
{
    my ($start, $end) = ('„', '“');
}

sub _slurp
{
    my $filename = shift;

    my $in = *ARGV;

    local $/;
    my $contents = <$in>;

    close($in);

    return $contents;
}

sub _process
{
    my $s = shift;

    my $count = () = ($s =~ m{"}g);

    if ($count % 2 != 0)
    {
        return $s;
    }

    my $i = 0;
    $s =~ s/"/(($i++) % 2 == 0) ? $start: $end/ge;

    if ($i != $count)
    {
        Carp::confess("Error in paragraph '$s'");
    }

    return $s;
}

my $fn = shift(@ARGV);

my $contents = _slurp($fn);

$contents =~ s{(<a href="[^"]+">)([^<]+)(</a>)}{ $1 . _process($2) . $3 }egms;


print $contents;
