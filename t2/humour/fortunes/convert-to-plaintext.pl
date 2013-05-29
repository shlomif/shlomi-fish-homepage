use strict;
use warnings;

use XML::Grammar::Fortune::ToText;
use File::Spec;

my $xml_fn = shift(@ARGV);
my $out_fn = shift(@ARGV);

my $html_fn = $xml_fn;

my $abs_xml_fn = File::Spec->rel2abs($xml_fn);

my $abs_out_fn = File::Spec->rel2abs($out_fn);

{
    open my $out, ">", $abs_out_fn;
    binmode($out, ":utf8");
    XML::Grammar::Fortune::ToText
        ->new({input => $abs_xml_fn, output => $out})
        ->run();
    close($out);
}
