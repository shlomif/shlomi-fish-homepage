#!/usr/bin/perl

use strict;
use warnings;

use XML::Grammar::ProductsSyndication;

use XML::LibXML::XPathContext;

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

my $xml = $ps->transform_into_html({ 'output' => "xml" });

my $xc = XML::LibXML::XPathContext->new($xml);
$xc->registerNs('html' => "http://www.w3.org/1999/xhtml");

open my $out, ">", "$lib_dir/include-me.html";
print {$out} $xc->findnodes('/html:html/html:body/html:div')->[0]->toString(0);
close ($out);

$ps->update_cover_images(
    {
        'size' => "l",
        'resize_to' => { 'width' => 150, 'height' => 250 },
        'name_cb' => 
            sub 
            {
                my $args = shift;
                return "$wml_dir/images/$args->{id}.jpg";
            },
        'amazon_token' => "0VRRHTFJECHSKYNYD282",
        'amazon_associate' => "shlomifishhom-20",
    }
);

1;

