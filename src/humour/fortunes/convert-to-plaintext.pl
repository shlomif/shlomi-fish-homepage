use strict;
use warnings;

use XML::Grammar::Fortune::ToText();

my ( $xml_fn, $out_fn ) = @ARGV;

open my $out, ">:encoding(UTF-8)", $out_fn;
XML::Grammar::Fortune::ToText->new( { input => $xml_fn, output => $out } )
    ->run();
close($out);
