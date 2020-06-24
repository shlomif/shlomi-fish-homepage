use strict;
use warnings;

use XML::Grammar::Fortune         ();
use XML::Grammar::Fortune::ToText ();

my ( $xml_fn, $out_fn ) = @ARGV;

XML::Grammar::Fortune->new( { mode => "validate" } )
    ->run( { input => $xml_fn } );

{
    open my $out, ">:encoding(UTF-8)", $out_fn;
    XML::Grammar::Fortune::ToText->new( { input => $xml_fn, output => $out } )
        ->run();
    close($out);
    my $time  = 120 + ( stat($xml_fn) )[9];
    my $time2 = time();
    if ( $time2 < $time )
    {
        $time = $time2;
    }
    utime( $time, $time, $out_fn );
}
