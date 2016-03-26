#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use XML::LibXML;

my $doc = XML::LibXML->load_xml(location => "lib/docbook/5/xml/human-hacking-field-guide-v2.xml");

my $xc = XML::LibXML::XPathContext->new($doc);
$xc->registerNs("db5", 'http://docbook.org/ns/docbook');
$xc->registerNs('xlink', 'http://www.w3.org/1999/xlink');

my $num_paras;
foreach my $para ($xc->findnodes('//db5:para'))
{
    print STDERR +($num_paras++), "\n";
    foreach my $text_node ($xc->findnodes('//text()', $para))
    {
        my $str = $text_node->nodeValue();
        my $count = () = ($str =~ m{"}g);
        if ($count > 0 and (($count % 2) == 0))
        {
            my $i = 0;
            $str =~ s{"}{(($i++) % 2 == 0) ? '“' : '”'}eg;
            $text_node->setData($str);
        }
    }
}
print $doc->toString();
