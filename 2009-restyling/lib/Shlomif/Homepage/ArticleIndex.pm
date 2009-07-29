package Shlomif::Homepage::ArticleIndex;

use strict;
use warnings;

use XML::LibXSLT;
use XML::LibXML;

my $parser = XML::LibXML->new();
my $xslt = XML::LibXSLT->new();

my $base_path="../lib/article-index/";
my $source = $parser->parse_file("$base_path/article-index.xml");
my $style_doc = $parser->parse_file("$base_path/article-index.xsl");

my $stylesheet = $xslt->parse_stylesheet($style_doc);

my $results = $stylesheet->transform($source);

my $out_string = $stylesheet->output_string($results);

$out_string =~ s{\A.*?<body>}{}s;
$out_string =~ s{</body>.*\z}{}s;

print $out_string;

1;
