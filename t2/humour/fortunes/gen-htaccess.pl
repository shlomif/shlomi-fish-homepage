#!/usr/bin/perl

use strict;
use warnings;

use IO::Handle;
use Getopt::Long qw(GetOptions);

my $output_filename;
GetOptions
(
    'o=s' => \$output_filename,
);

if (! $output_filename )
{
    die "Output filename not specified.";
}

my @basenames = @ARGV;

open my $o, '>', $output_filename;

$o->print("AddType text/plain .txt\n");
foreach my $base (@basenames)
{
    foreach my $ext ('', '.xml', '.xhtml')
    {
    $o->print(<<"EOF");
<Files "$base$ext">
        Header add Link "<http://www.shlomifish.org/humour/fortunes/$base.html>; rel=\\"canonical\\""
</Files>
EOF
    }
}
