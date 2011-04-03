#!/usr/bin/perl

use strict;
use warnings;

use Shlomif::Homepage::Amazon;

use XML::Grammar::ProductsSyndication;

use XML::LibXML::XPathContext;

my $wml_dir = "t2/philosophy/books-recommends";
my $lib_dir = "lib/prod-synd/non-fiction-books";
my $xml_basename = "shlomi-fish-non-fiction-books-recommendations.xml";

my $amazon = 
    Shlomif::Homepage::Amazon->new(
    {
        lib_dir => $lib_dir,
        xml_basename => $xml_basename,
        wml_dir => $wml_dir,
    });

$amazon->process;

