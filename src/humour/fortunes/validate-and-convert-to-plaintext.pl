use strict;
use warnings;

use XML::Grammar::Fortune         ();
use XML::Grammar::Fortune::ToText ();
use File::Spec                    ();

my $xml_fn = shift(@ARGV);
my $out_fn = shift(@ARGV);

my $html_fn = $xml_fn;

my $abs_xml_fn = File::Spec->rel2abs($xml_fn);

XML::Grammar::Fortune->new( { mode  => "validate" } )
    ->run(                  { input => $abs_xml_fn } );
my $abs_out_fn = File::Spec->rel2abs($out_fn);

{
    open my $out, ">:encoding(UTF-8)", $abs_out_fn;
    XML::Grammar::Fortune::ToText->new(
        { input => $abs_xml_fn, output => $out } )->run();
    close($out);
}
