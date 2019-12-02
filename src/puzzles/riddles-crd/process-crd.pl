#!/usr/bin/env perl

use strict;
use warnings;

use File::Format::CRD::Reader;

sub _remove_trail_ws
{
    return shift =~ s/[ \t]*(\r?)$//gmrs;
}

my $filename = shift;

my $reader = File::Format::CRD::Reader->new( { filename => $filename } );

binmode STDOUT, ":encoding(utf-8)";

while ( my $card = $reader->get_next_card( { encoding => "windows-1255" } ) )
{
    print "Title = ", _remove_trail_ws( $card->{'title'} ), "\nBody = <<<\n",
        _remove_trail_ws( $card->{'body'} ), "\n>>>\n\n";
}
