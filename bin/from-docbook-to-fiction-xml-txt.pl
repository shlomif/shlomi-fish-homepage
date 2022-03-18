#!/usr/bin/env perl

use strict;
use warnings;

use XML::LibXML ();

use Path::Tiny qw/ path /;

use Getopt::Long;

sub _esc
{
    my $s = shift;

    $s =~ s{&}{&amp;}g;
    $s =~ s{<}{&lt;}g;
    $s =~ s{>}{&gt;}g;

    $s =~ s{^[ \t]+}{}gms;
    $s =~ s{[ \t]+$}{}gms;

    return $s;
}

sub _esc_for_attr
{
    my $s = shift;

    my $ret = _esc($s);

    $ret =~ s{"}{&quot;};

    return $ret;
}

my $XML_URI = q{http://www.w3.org/XML/1998/namespace};
my $xpc     = XML::LibXML::XPathContext->new();

$xpc->registerNs( 'db',    q{http://docbook.org/ns/docbook} );
$xpc->registerNs( 'xlink', q{http://www.w3.org/1999/xlink} );
$xpc->registerNs( 'xml',   $XML_URI );

my $parser = XML::LibXML->new();

$parser->load_ext_dtd(0);

my $output_fn;
GetOptions( "o|output=s" => \$output_fn, );

my $input_fn = shift(@ARGV);

my $doc = $parser->parse_file($input_fn);

my ($main_title)    = $xpc->findnodes( q{/db:article/db:info/db:title}, $doc );
my $main_title_text = $main_title->textContent();
my ($main_article)  = $xpc->findnodes( q{/db:article}, $doc );
my $main_id_text    = $main_article->getAttributeNS( $XML_URI, "id" );

my @sections = $xpc->findnodes( q{/db:article/db:section}, $doc );

sub _out_section
{
    my $sect_elem = shift;

    my $id = $sect_elem->getAttributeNS( $XML_URI, "id" );

    my ($title_elem) = $xpc->findnodes( q{./db:info/db:title}, $sect_elem );

    my $title_text = $title_elem->textContent();

    my @paras = $xpc->findnodes( q{./db:para}, $sect_elem );

    my @subs = $xpc->findnodes( q{./db:section}, $sect_elem );

    return
          qq{<s id="}
        . _esc_for_attr($id)
        . qq{">\n\n}
        . qq{<title>}
        . _esc($title_text)
        . qq{</title>\n\n}
        . join( "\n\n", map { _esc( $_->textContent() ) } @paras )
        . join( "\n\n", map { _out_section($_) } @subs )
        . qq{</s>\n\n};
}

my $total =
      qq{<body id="}
    . _esc_for_attr($main_id_text)
    . qq{">\n\n}
    . qq{<title>}
    . _esc($main_title_text)
    . qq{</title>\n\n}
    . join( "\n\n", map { _out_section($_) } @sections )
    . qq{</body>\n\n};

path($output_fn)->spew_utf8($total);
