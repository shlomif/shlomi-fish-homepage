#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
use IO::All;
use IO::Handle;
use File::Temp qw(tempfile);

my $output_fn;

GetOptions(
    '-o=s' => \$output_fn,
);

if (!defined $output_fn)
{
    die "Output filename not specified";
}

my $buf;

foreach my $fn (@ARGV)
{
    $buf .= (scalar(io->file($fn)->utf8->slurp) =~ s/([^\n])\z/$1\n/mrs);
}

my ($t_fh, $t_fn) = tempfile();
binmode ( $t_fh, ':encoding(utf8)', );

$t_fh->print($buf);
$t_fh->flush();

if (system("yuicompressor", "-o", $output_fn, $t_fn))
{
    die "yuicompressor returned an error - $!";
}
