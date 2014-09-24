#!/usr/bin/perl

use strict;
use warnings;

use XML::LibXML;
use XML::Grammar::Fortune;

my $p = XML::LibXML->new;

my $xslt_path = XML::Grammar::Fortune->new->dist_path_slot("to_html_xslt_transform_basename");

my $facts_xml_path = './lib/factoids/shlomif-factoids-lists.xml';

my $dom = $p->parse_file($facts_xml_path);

# print map { $_->value , "\n" } $dom->findnodes("//list/\@xml:id");

foreach my $list_node ( $dom->findnodes("//list/\@xml:id") )
{
    my $list_id = $list_node->value;

    system(
        "xsltproc", "--output", "./lib/factoids/indiv-lists-xhtmls/$list_id.xhtml",
        "--stringparam", 'filter-facts-list.id', $list_id,
        $xslt_path, $facts_xml_path,
    );
}

