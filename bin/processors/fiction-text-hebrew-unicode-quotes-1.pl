#!/usr/bin/env perl

use strict;
use warnings;

use utf8;

use open IO => ':encoding(utf8)';

use Carp;

binmode STDOUT, ':encoding(utf8)';
local $/;

my ( $start, $end ) = ( '„', '“' );
if ( $ENV{'ENG'} )
{
    ( $start, $end ) = ( '“', '”' );
}

sub _process_paragraph
{
    my $s = shift;

    if ( $s =~ m{<} )
    {
        return $s;
    }

    my $count = () = ( $s =~ m{"}g );

    if ( $count % 2 != 0 )
    {
        return $s;
    }

    my $i = 0;
    $s =~ s/"/(($i++) % 2 == 0) ? $start: $end/ge;

    if ( $i != $count )
    {
        Carp::confess("Error in paragraph '$s'");
    }

    return $s;
}

my $text = <ARGV>;

$text =~ s{(?<=\n\n)((?:(?: *\S+)+ *\n)+)(?=\n)}{_process_paragraph($1)}egms;

print $text;
