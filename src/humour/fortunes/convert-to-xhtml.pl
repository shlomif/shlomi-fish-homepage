use strict;
use warnings;
use utf8;

use XML::Grammar::Fortune     ();
use XML::LibXML               ();
use URI::Find                 ();
use XML::LibXML::XPathContext ();
use Encode                    qw/ decode /;

my ( $xml_fn, $out_fn ) = @ARGV;

XML::Grammar::Fortune->new( { mode => "validate", } )
    ->run( { input => $xml_fn, } );
XML::Grammar::Fortune->new(
    { mode => "convert_to_html", output_mode => "filename" } )
    ->run( { input => $xml_fn, output => $out_fn } );
my $contents;

my $PREF = '«⋄⋄אבג«';
my $SUF  = '»גבא⋄⋄»';
my $doc  = XML::LibXML->load_xml( location => $out_fn );
my $xc   = XML::LibXML::XPathContext->new($doc);
$xc->registerNs( 'html' => "http://www.w3.org/1999/xhtml" );
my $finder = URI::Find->new(
    sub {
        my ( $obj, $text ) = @_;
        return qq#$PREF$text$SUF#;
    }
);
foreach my $node (
    $xc->findnodes(
q#//html:table[@class='irc-conversation']/html:tbody/html:tr[@class='saying']/html:td[@class='text']/text()#
    )
    )
{
    my $text_content = $node->data;
    $finder->find( \$text_content );

    $node->setData($text_content);
}
$contents = decode( 'UTF-8', $doc->toString() );
$contents =~ s# xmlns:xsi="[^"]*"##gms;
$contents =~ s/[ \t]+$//gms;

$contents =~ s#\Q$PREF\E(.*?)\Q$SUF\E#<a href="$1" rel="nofollow">$1</a>#gms;

sub _to_xhtml5
{
    $contents =~
s#\Q<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">\E#<!DOCTYPE html>#ms;
    $contents =~
s#<meta\s+http-equiv="Content-Type"\s+content="text/html;\s*charset=utf-8"\s*/>#<meta charset="utf-8"/>#ms;
    return;
}

_to_xhtml5();

open my $back_fh, '>:encoding(UTF-8)', $out_fn
    or die "Cannot open '$out_fn' for writing - $!";
print {$back_fh} $contents;
close($back_fh);
