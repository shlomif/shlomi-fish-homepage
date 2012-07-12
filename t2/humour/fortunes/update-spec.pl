#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;

my ($in_fn, $out_fn, $ver);

GetOptions(
    "i|input=s" => \$in_fn,
    "o|output=s" => \$out_fn,
    "ver=s" => \$ver,
);

foreach my $param ($in_fn, $out_fn, $ver)
{
    if (!defined($param))
    {
        die "One parameter is not defined!";
    }
}

my $buffer = "";
open my $in, "<", $in_fn
    or die "Foo!";

LINES_LOOP:
while (my $line = <$in>)
{
    chomp($line);
    if ($line =~ m{\A%define version [\d\.]+\s*\z})
    {
        $buffer .= "%define version $ver\n";
        last LINES_LOOP;
    }
    else
    {
        $buffer .= "$line\n";
    }
}

while (my $line = <$in>)
{
    $buffer .= $line;
}

close($in);

open my $out, ">", $out_fn
    or die "Bar!";
print {$out} $buffer;
close($out);
