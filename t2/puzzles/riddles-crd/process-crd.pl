#!/usr/bin/perl

use strict;
use warnings;

use File::Format::CRD::Reader;

my $filename = shift;

my $reader = File::Format::CRD::Reader->new({ filename => $filename });

binmode STDOUT, ":encoding(utf-8)";

while (my $card = $reader->get_next_card({encoding => "windows-1255"}))
{
    print "Title = " , $card->{'title'}, "\nBody = <<<\n",
        $card->{'body'}, "\n>>>\n\n";
}

