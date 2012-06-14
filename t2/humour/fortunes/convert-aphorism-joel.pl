#!/usr/bin/perl

use strict;
use warnings;

use XML::LibXML;

my ($id) = @ARGV;

my $filename = "joel-on-software.xml";

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

my $last_para = $paras[-1];

my $new_quote = XML::LibXML::Element->new("quote");
my $new_body = XML::LibXML::Element->new("body");

foreach my $p (@paras)
{
    my $p_elem = XML::LibXML::Element->new("p");
    $p_elem->appendChild(XML::LibXML::Text->new($p));

    $new_body->appendChild($p_elem);
}
$new_quote->appendChild($new_body);

my ($title, $url);
chomp($last_para);
if (0)
{
}
elsif ($last_para =~ m{^\s*Joel Spolsky\s*,?\s*$^\s*(\*?)\s*(http://[^\n]+)}ms)
{
    ($title, $url) = ($1, $2);
}
elsif ($last_para =~ m{^\s*Joel Spolsky\s*,?\s*$^\s*(.*)}ms)
{
    $title = $1
}

my $info_text =
"<info>\n" .
(" " x 4) . "<author>Joel Spolsky</author>\n" .
(" " x 4) . ($url ? "<work href=\"$url\"" : "<work" ) .
">$title</work>\n" .
"</info>"
;


my $new_info = $parser->parse_string($info_text);

$new_quote->appendChild($new_info->documentElement());

$raw->replaceNode($new_quote);

$doc->toFile($filename);
