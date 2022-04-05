#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';

use XML::LibXML               ();
use XML::LibXML::XPathContext ();
use Getopt::Long qw/ GetOptions /;
use Path::Tiny qw/ path /;

use Shlomif::DocBookClean ();

my $out_fn;

GetOptions( "output|o=s" => \$out_fn, );

# Input the filename
my $filename = shift(@ARGV)
    or die "Give me a filename as a command argument: myscript FILENAME";

# Prepare the objects.
my $xml       = XML::LibXML->new;
my $root_node = $xml->parse_file($filename);
my $xpc       = XML::LibXML::XPathContext->new($root_node);
$xpc->registerNs( "xhtml", "http://www.w3.org/1999/xhtml" );

{
    my ($body_node) = $xpc->findnodes('//xhtml:body');

    my $s = $body_node->toString();

    Shlomif::DocBookClean::cleanup_docbook( \$s, $filename, );

    $s =~ s{\A.*?<body[^>]*>}{}ms;
    $s =~ s{</body>\s*(?:</html>)?\s*\z}{}ms;

    $s =~ s{<h1[^>]*>.*?</h1>}{}sm;

    $s =~ s#<span>\s*</span>##gms;
    $s =~ s#<span style="[^"]*" */>##gms;

    path($out_fn)->spew_utf8($s);
}
