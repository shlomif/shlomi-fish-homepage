#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use Getopt::Long qw/ GetOptions /;
use XML::Grammar::Screenplay::ToHTML ();
use XML::LibXML::XPathContext        ();

sub run
{
    my $output_fn;

    GetOptions( "output|o=s" => \$output_fn, );

    if ( !defined($output_fn) )
    {
        die "Output filename not specified! Use the -o|--output flag!";
    }
    my $translator = XML::Grammar::Screenplay::ToHTML->new;
    my $output_dom = $translator->translate_to_html(
        {
            source => { file => shift(@ARGV), },
            output => "dom",
        }
    );
    my $xc      = XML::LibXML::XPathContext->new($output_dom);
    my $XHTMLNS = "http://www.w3.org/1999/xhtml";
    $xc->registerNs( 'html' => $XHTMLNS, );

    # print($output_dom);
    my @list = $xc->findnodes(
        q#descendant::html:figure[contains(@class, 'asciiart')]#,
        ($output_dom) );

    foreach my $el (@list)
    {
        my $parent  = $el->parentNode;
        my $wrapper = $output_dom->createElementNS( $XHTMLNS, 'div' );
        $wrapper->setAttribute( 'class', 'asciiart_wrapper' );
        $wrapper->appendChild( $el->cloneNode(1) );
        $parent->replaceChild( $wrapper, $el );
    }

    my $chars =
        $translator->_to_html_stylesheet()->output_as_chars($output_dom);

    $chars =~ s/[ \t]+$//gms;
    open my $out, ">:encoding(UTF-8)", $output_fn;
    print {$out} $chars;
    close($out);

    exit(0);
}

run;

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
