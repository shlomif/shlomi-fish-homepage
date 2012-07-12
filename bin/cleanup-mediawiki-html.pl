#!/usr/bin/perl

use strict;
use warnings;

use XML::LibXML;
use List::MoreUtils qw(firstidx);

my $parser = XML::LibXML->new();

sub remove
{
    my $node = shift;

    my $parent = $node->parentNode;

    $parent->removeChild($node);

    return;
}


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

sub xhtml_con
{
    my $node = shift;

    my $xc = XML::LibXML::XPathContext->new($node);
    $xc->registerNs('xhtml', 'http://www.w3.org/1999/xhtml');

    return $xc;
}

my $doc = $parser->parse_file(
    "./lib/htmls/from-mediawiki/orig/Optimizing_Code_for_Speed-rev1.html"
);

sub is_empty_or_comment
{
    my $node = shift;

    if ($node->nodeType() == XML_COMMENT_NODE)
    {
        return 1;
    }

    if ($node->nodeType() == XML_TEXT_NODE)
    {
        if ($node->data() !~ /\S/)
        {
            return 1;
        }
    }

    return;
}

my $xc = XML::LibXML::XPathContext->new($doc);
$xc->registerNs('xhtml', 'http://www.w3.org/1999/xhtml');

# Remove the table-of-contents because we generate our own.
my ($toc) =  $xc->findnodes("//xhtml:table[\@id='toc']");
remove($toc);

{
    my ($el) = $xc->findnodes("//xhtml:div[\@class='printfooter']");

    my $parent = $el->parentNode;

    my $innermost = 1;

    while ($parent)
    {
        my $start = $el;
        # In subsequent iterations - we want to remove the node only
        # after the parent
        if ($innermost)
        {
            my $next_el = $start->previousSibling();
            while ($next_el && is_empty_or_comment($next_el))
            {
                $start = $next_el;
                $next_el = $start->previousSibling();
            }
            # $start is now OK.
        }
        else
        {
            $start = $start->nextSibling();
        }

        my $to_del = $start;
        my $next_to_del;
        while ($to_del)
        {
            # Once removed - $to_del won't have a nextSibling().
            # Elementary, my dear Watson!
            $next_to_del = $to_del->nextSibling();
            $parent->removeChild($to_del);
        }
        continue
        {
            $to_del = $next_to_del;
        }
    }
    continue
    {
        $el = $parent;
        $parent = $el->parentNode();
        $innermost = 0;
    }
}

foreach my $el ($xc->findnodes("//xhtml:script"))
{
    remove($el);
}

foreach my $attr (qw(rel class title))
{
    foreach my $el ($xc->findnodes("//*[\@$attr]"))
    {
        $el->removeAttribute($attr);
    }
}

foreach my $a_el ($xc->findnodes("//xhtml:p/xhtml:a[\@id]"))
{
    my $id = $a_el->getAttribute("id");

    my $p = $a_el->parentNode();

    my $h_tag = $p->nextSibling();

    while(   $h_tag->nodeType() != XML_ELEMENT_NODE
          || $h_tag->nodeName() !~ m{\Ah}
      )
    {
        $h_tag = $h_tag->nextSibling();
    }

    remove($p);

    $h_tag->setAttribute("id", $id);

    my ($span) = xhtml_con($h_tag)->findnodes("xhtml:span/xhtml:a");

    $span = $span->parentNode;

    remove($span);

    ($span) = xhtml_con($h_tag)->findnodes("xhtml:span");

    replace($h_tag, $span->textContent());
}

foreach my $a_el ($xc->findnodes("//xhtml:a[\@href]"))
{
    my $href = $a_el->getAttribute("href");
    if ($href =~ m{\A/})
    {
        $a_el->setAttribute("href", "http://en.wikibooks.org$href");
    }
}

print $doc->toString();

