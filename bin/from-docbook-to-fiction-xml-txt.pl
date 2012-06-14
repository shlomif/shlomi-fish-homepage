#!/usr/bin/perl

use strict;
use warnings;

use XML::LibXML;

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


my $xml_uri = q{http://www.w3.org/XML/1998/namespace};
my $xpc = XML::LibXML::XPathContext->new();
# $xpc->registerNs('x', q{http://www.w3.org/1999/xhtml});
$xpc->registerNs('db', q{http://docbook.org/ns/docbook});
$xpc->registerNs('xlink', q{http://www.w3.org/1999/xlink});
$xpc->registerNs('xml', $xml_uri);

my $parser = XML::LibXML->new();

$parser->load_ext_dtd(0);

my $output_file;
GetOptions(
    "o|output=s" => \$output_file,
);

my $input_file = shift(@ARGV);

my $doc = $parser->parse_file($input_file);

my ($main_title) = $xpc->findnodes(q{/db:article/db:info/db:title}, $doc);
my $main_title_text = $main_title->textContent();
my ($main_article) = $xpc->findnodes(q{/db:article}, $doc);
my $main_id_text = $main_article->getAttributeNS($xml_uri, "id");


my @sections = $xpc->findnodes(q{/db:article/db:section}, $doc);

sub _out_section
{
    my $sect_elem = shift;

    my $id = $sect_elem->getAttributeNS($xml_uri, "id");

    my ($title_elem) = $xpc->findnodes(q{./db:info/db:title}, $sect_elem);

    my $title_text = $title_elem->textContent();

    my @paras = $xpc->findnodes(q{./db:para}, $sect_elem);

    my @subs = $xpc->findnodes(q{./db:section}, $sect_elem);

    return
          qq{<s id="} . _esc_for_attr($id) . qq{">\n\n}
        . qq{<title>} . _esc($title_text) . qq{</title>\n\n}
        .  join("\n\n", map { _esc($_->textContent()) } @paras)
        . join("\n\n", map { _out_section($_) } @subs)
        . qq{</s>\n\n}
        ;
}

my $total =
      qq{<body id="} . _esc_for_attr($main_id_text) . qq{">\n\n}
    . qq{<title>} . _esc($main_title_text) . qq{</title>\n\n}
    . join("\n\n", map { _out_section($_) } @sections)
    . qq{</body>\n\n}
    ;

open my $out_fh, ">", $output_file
    or die "Could not open '$output_file' for output!";
binmode $out_fh, ":encoding(utf-8)";
print {$out_fh} $total;
close($out_fh);
