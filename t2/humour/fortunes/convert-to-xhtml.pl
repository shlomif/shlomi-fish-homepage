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

open my $text_fh, "<", $abs_out_fn
    or die "Cannot open '$abs_out_fn' for reading - $!";
binmode ($text_fh, ":utf8");
my $contents;
{
    local $/;
    $contents = <$text_fh>;
}
close($text_fh);

$contents =~ s/[ \t]+$//gms;

open my $back_fh, '>', $abs_out_fn
    or die "Cannot open '$abs_out_fn' for writing - $!";
binmode ($back_fh, ":utf8");
print {$back_fh} $contents;
close($back_fh);

