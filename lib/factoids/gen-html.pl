#!/usr/bin/perl

use strict;
use warnings;

use IO::All qw/ io /;

use XML::LibXML;
use XML::LibXML::XPathContext;

use XML::Grammar::Fortune;

my $p = XML::LibXML->new;

my $xslt_path = XML::Grammar::Fortune->new->dist_path_slot("to_html_xslt_transform_basename");

my $facts_xml_path = './lib/factoids/shlomif-factoids-lists.xml';

my $dom = $p->parse_file($facts_xml_path);

# print map { $_->value , "\n" } $dom->findnodes("//list/\@xml:id");

foreach my $list_node ( $dom->findnodes("//list/\@xml:id") )
{
    foreach my $lang (qw(en-US he-IL))
    {
        my $list_id = $list_node->value;

        my $basename = "$list_id--$lang";
        my $out_xhtml =  "./lib/factoids/indiv-lists-xhtmls/$basename.xhtml";
        system(
            "xsltproc", "--output", $out_xhtml,
            "--stringparam", 'filter-facts-list.id', $list_id,
            "--stringparam", 'filter.lang', $lang,
            $xslt_path, $facts_xml_path,
        );

        my $indiv_dom = $p->parse_file($out_xhtml);

        my $xpc = XML::LibXML::XPathContext->new($indiv_dom);
        $xpc->registerNs('xhtml', "http://www.w3.org/1999/xhtml" );

        my $node = $xpc->findnodes("//xhtml:div[\@class='main_facts_list']")->[0];

        io->file("$out_xhtml.reduced")->utf8->print(
            $node->toString =~ s/\s+xmlns:xsi="[^"]+"//gr
        );
    }
}

