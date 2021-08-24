#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use XML::Grammar::Screenplay::App::ToHTML v0.26.0 ();
use XML::LibXML::XPathContext ();

my $xpc     = XML::LibXML::XPathContext->new();
my $XHTMLNS = "http://www.w3.org/1999/xhtml";
$xpc->registerNs( 'x', $XHTMLNS, );

XML::Grammar::Screenplay::App::ToHTML->run(
    +{
        dom_post_proc => sub {
            my $output_dom = shift()->{dom};

            my @list = $xpc->findnodes(
                q#descendant::x:figure[contains(@class, 'asciiart')]#,
                ($$output_dom) );

            foreach my $el (@list)
            {
                my $parent  = $el->parentNode;
                my $wrapper = $$output_dom->createElementNS( $XHTMLNS, 'div' );
                $wrapper->setAttribute( 'class', 'asciiart_wrapper' );
                $wrapper->appendChild( $el->cloneNode(1) );
                $parent->replaceChild( $wrapper, $el );
            }
            return;
        },
    }
);

__END__

=encoding UTF-8

=head1 NAME

XML::Grammar::Screenplay::App::ToHTML

=head1 VERSION

version v0.16.0

=head1 NAME

XML::Grammar::Screenplay::App::ToHTML - module implementing
a command line application to convert a Screenplay XML file to HTML

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2007 by Shlomi Fish.

This is free software, licensed under:

  The MIT (X11) License

=cut
