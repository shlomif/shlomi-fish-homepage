#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;
use autodie;

use Getopt::Long qw( GetOptions );

my $output_filename;
GetOptions( 'o=s' => \$output_filename, );

if ( !$output_filename )
{
    die "Output filename not specified.";
}

my @basenames = @ARGV;

open my $o, '>', $output_filename;

$o->print("AddType text/plain .txt\n");
$o->print("AddDefaultCharset utf-8\n");
foreach my $base (@basenames)
{
    foreach my $ext ( '', '.xml', '.xhtml' )
    {
        my $type = ( ( $ext eq '' ) ? "ForceType text/plain\n" : '' );
        $o->print(<<"EOF");
<Files "$base$ext">
${type}Header add Link "<http://www.shlomifish.org/humour/fortunes/$base.html>; rel=\\"canonical\\""
</Files>
EOF
    }
}
