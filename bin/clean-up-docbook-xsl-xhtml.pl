#!/usr/bin/perl 

use strict;
use warnings;

use XML::LibXML;
use XML::LibXML::XPathContext;

# Input the filename
my $filename = shift(@ARGV)
    or die "Give me a filename as a command argument: myscript FILENAME";

# Prepare the objects.
my $xml = XML::LibXML->new;
my $root_node = $xml->parse_file($filename);
my $xpc = XML::LibXML::XPathContext->new($root_node);
$xpc->registerNs("xhtml", "http://www.w3.org/1999/xhtml");


# Find the empty a id="..." elements.
{
    my @nodes = $xpc->findnodes('//xhtml:a[@id and not(@href)]');

    foreach my $anchor (@nodes)
    {
        my $container = $anchor->parentNode();
        $container->setAttribute("id", $anchor->getAttribute("id"));
        $container->removeChild($anchor);
    }
}

# Remove the style attribute
{
    my @nodes = $xpc->findnodes('//*');
    foreach my $node (@nodes)
    {
        $node->removeAttribute("style");
    }
}

# Remove the Author one - they confuse the ToC API.
{
    my @nodes = $xpc->findnodes(q{//xhtml:h3[@class = 'author']});
    foreach my $node (@nodes)
    {
         my $container = $node->parentNode();
         $container->removeChild($node);
    }
}
{
    my ($body_node) = $xpc->findnodes('//xhtml:body');

    my $s = $body_node->toString();

    $s =~ s{\A<body[^>]*>}{}sm;
    $s =~ s{</body>\z}{};

    # It's a kludge
    $s =~ s{ lang="en"}{};
    $s =~ s{ xml:lang="en"}{};

    # Fixed in Perl 6...
    $s =~ s{<(/?)h(\d)}{"<".$1."h".($2+2)}ge;
    binmode STDOUT, ":utf8";
    print $s;
}

