#!/usr/bin/perl

use strict;
use warnings;

use Shlomif::Homepage::Amazon;

use XML::Grammar::ProductsSyndication;

use XML::LibXML::XPathContext;

use Term::ReadPassword;

my $wml_dir = "t2/art/recommendations/music";
my $lib_dir = "lib/prod-synd/music";
my $ps = XML::Grammar::ProductsSyndication->new(
    {
        'source' =>
        {
            'file' => "$wml_dir/shlomi-fish-music-recommendations.xml",
        }
    },
);

if (!$ps->is_valid())
{
    die "Not valid.";
}
my $xml = $ps->transform_into_html({ 'output' => "xml" });

my $xc = XML::LibXML::XPathContext->new($xml);
$xc->registerNs('html' => "http://www.w3.org/1999/xhtml");

open my $out, ">", "$lib_dir/include-me.html";
binmode $out, ":utf8";
print {$out} $xc->findnodes('/html:html/html:body/html:div')->[0]->toString(0);
close ($out);

Shlomif::Homepage::Amazon->new(
    {
        ps => $ps,
        wml_dir => $wml_dir,
    })->process;
