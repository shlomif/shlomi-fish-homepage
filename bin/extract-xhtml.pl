#!/usr/bin/perl

use strict;
use warnings;

use XML::LibXML;
use XML::LibXML::XPathContext;
use Getopt::Long;

my $out_fn;

GetOptions(
    "output|o=s" => \$out_fn,
);

# Input the filename
my $filename = shift(@ARGV)
    or die "Give me a filename as a command argument: myscript FILENAME";

# Prepare the objects.
my $xml = XML::LibXML->new;
my $root_node = $xml->parse_file($filename);
my $xpc = XML::LibXML::XPathContext->new($root_node);
$xpc->registerNs("xhtml", "http://www.w3.org/1999/xhtml");


{
    my ($body_node) = $xpc->findnodes('//xhtml:body');

    my $s = $body_node->toString();

    $s =~ s{\A<body[^>]*>}{}sm;
    $s =~ s{</body>\z}{};

    $s =~ s{<h1[^>]*>.*?</h1>}{}sm;

=begin Hello

    # It's a kludge
    $s =~ s{ lang="en"}{}g;
    $s =~ s{ xml:lang="en"}{}g;
    $s =~ s{ type="(1|disc)"}{}g;
    $s =~ s{<hr[^/]*/>}{<hr />}g;
    $s =~ s{ target="_top"}{}g;

=end Hello

=cut

    open my $out, ">", $out_fn;
    binmode $out, ":utf8";
    print {$out} $s;
    close($out);
}

