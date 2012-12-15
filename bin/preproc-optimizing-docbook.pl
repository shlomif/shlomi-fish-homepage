#!/usr/bin/perl

use strict;
use warnings;

use XML::LibXML;

my $parser = XML::LibXML->new();

my $doc = $parser->parse_file("lib/docbook/from-mediawiki/optimizing-code-for-speed.docbook.xml");

sub empty
{
    my $node = shift;

    $node->removeChildNodes();

    return $node;
}

sub stringify
{
    my $list = shift;

    return
    [
        map { (ref($_) eq "") ? XML::LibXML::Text->new($_) : $_ } @$list
    ];
}

sub replace
{
    my $node = shift;
    my $childs = shift;

    empty($node);

    foreach my $c (@{
            stringify((ref($childs) eq "ARRAY") ? $childs : [$childs])
        }
    )
    {
        $node->appendChild($c);
    }

    return $node;
}

=begin Code

{
    my ($title) = $doc->findnodes("/book/bookinfo/title");
    replace($title, "Optimizing Code for Speed");
}

{
    my ($legal) = $doc->findnodes("/book/bookinfo/legalnotice/para");

    replace($legal, "Permission to use, copy, modify and distribute this document under version 2.5 (or later) of the Creative Commons' Attribution License or version 1.2 (or later) of the GNU Free Documentation License ");
}

=end Code

=cut

my $book = $doc->findnodes("/book");
my $bookinfo = $book->findnodes("bookinfo");

$book->removeChild($bookinfo);

my $article = $book->findnodes("article");
replace($book, [$article->childNodes()]);
$article = $book;
$article->setNodeName("article");




print $doc->toString();
