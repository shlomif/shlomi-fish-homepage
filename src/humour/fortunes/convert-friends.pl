#!/usr/bin/env perl

use strict;
use warnings;

use XML::LibXML;
use Path::Tiny qw/ path /;

my $filename = "friends.xml";

my $parser = XML::LibXML->new();

my $doc = $parser->parse_file($filename);

my @fortunes = $doc->findnodes("//fortune");

my $cont = 0;
foreach my $fort (@fortunes)
{
    my $id = $fort->getAttribute("id");
    print "$id\n";

=begin Hello

    if ($id =~ m{-120} || $cont)
    {
        $cont = 1;
    }
    else
    {
        next;
    }

=end Hello

=cut

    my $txt_fn = "$id.fortune.txt";
    my $xml_fn = "$id.fortune.xml";

    my ($raw) = $fort->findnodes("raw");

    my $convert_to_xml = sub {
        my ($text) = $raw->findnodes("descendant::text");

        my @text_childs = $text->childNodes();

        if ( @text_childs != 1 )
        {
            die '@cdata is not 1';
        }

        my $cdata = $text_childs[0];

        if ( $cdata->nodeType() != XML_CDATA_SECTION_NODE() )
        {
            die "Not a cdata";
        }

        my $content = $cdata->nodeValue();

        if ( $content =~ s{Excerpt from the TV Show "Friends"[\s\n]*\z}{}ms )
        {
            # Everything is OK.
            print "OK\n";
        }
        else
        {
            die "Could not remote trailing from '$id'";
        }

        $content =~ s{[\s\n]+\z}{}ms;

        path($txt_fn)
            ->spew_utf8("<scene id=\"$id\">\n\n$content\n\n</scene>\n");
        if (
            system(
                "perl", "-MXML::Grammar::Screenplay::App::FromProto",
                "-e",   'run()', "--", "-o", $xml_fn, $txt_fn
            )
            )
        {
            die "Conversion of '$id' failed.";
        }
    };

    my $screenplay_xml = $parser->parse_file($xml_fn);

    my ($scene_elem) = $screenplay_xml->findnodes("descendant::scene");

    my $scp_elem = XML::LibXML::Element->new("screenplay");
    my $body     = XML::LibXML::Element->new("body");
    $scp_elem->appendChild($body);

    foreach my $node ( $scene_elem->childNodes() )
    {
        $body->appendChild($node);
    }
    my ($info) = $raw->findnodes("descendant::info");
    $scp_elem->appendChild($info);
    $raw->replaceNode($scp_elem);
}
$doc->toFile( $filename . ".new" );
