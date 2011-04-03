use strict;
use warnings;

use File::Spec;
use XML::Grammar::Fortune;

my $xml_fn = shift(@ARGV);
my $out_fn = shift(@ARGV);

my $html_fn = $xml_fn;

my $abs_xml_fn = File::Spec->rel2abs($xml_fn);

my $abs_out_fn = File::Spec->rel2abs($out_fn);

XML::Grammar::Fortune
    ->new({mode => "convert_to_html", output_mode => "filename"})
    ->run({input => $abs_xml_fn, output => $abs_out_fn})
    ;

open my $text_fh, "<", $abs_out_fn;
binmode ($text_fh, ":utf8");
my $contents;
{
    local $/;
    $contents = <$text_fh>;
}
close($text_fh);

$contents =~ s{\A(.*?)<body>}{}ms;
$contents =~ s{</body>(.*?)\z}{}ms;

$contents =~ s{<h3( id="[^>]+>[^<]+)</h3>}{<fortune_h3$1</fortune_h3>}g;

open my $xhtml_raw_out, ">", "${abs_out_fn}-for-input";
binmode ($xhtml_raw_out, ":utf8");
print {$xhtml_raw_out} $contents;
close($xhtml_raw_out);
