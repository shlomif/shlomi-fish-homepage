#!/usr/bin/perl

use strict;
use warnings;

use XML::LibXML;

my ($id) = @ARGV;

my $filename = "shlomif-fav.xml";

my $parser = XML::LibXML->new();

my $doc = $parser->parse_file($filename);

my ($fortune) = $doc->findnodes("//fortune[\@id='$id']");

my ($raw) = $fortune->findnodes("raw");

my ($text) = $raw->findnodes("descendant::text");

my @cdata = $text->childNodes();

if (@cdata != 1)
{
    die '@cdata is not 1';
}

my $content = $cdata[0]->nodeValue();

my @paras = split(/\n{2,}/, $content);

my $new_quote = XML::LibXML::Element->new("quote");
my $new_body = XML::LibXML::Element->new("body");

foreach my $p (@paras)
{
    my $p_elem = XML::LibXML::Element->new("p");
    $p_elem->appendChild(XML::LibXML::Text->new($p));

    $new_body->appendChild($p_elem);
}
$new_quote->appendChild($new_body);

my $info_text = <<"EOF";
<info>
    <author>Shlomi Fish</author>
    <work href="http://www.shlomifish.org/humour.html">Shlomi Fish's Aphorisms Collection</work>
</info>
EOF

my $new_info = $parser->parse_string($info_text);

$new_quote->appendChild($new_info->documentElement());

$raw->replaceNode($new_quote);

$doc->toFile($filename);
