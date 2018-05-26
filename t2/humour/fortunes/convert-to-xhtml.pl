use strict;
use warnings;
use utf8;

use File::Spec;
use XML::Grammar::Fortune;
use XML::LibXML;
use URI::Find ();
use Encode qw/ decode /;

my $xml_fn = shift(@ARGV);
my $out_fn = shift(@ARGV);

my $html_fn = $xml_fn;

my $abs_xml_fn = File::Spec->rel2abs($xml_fn);

my $abs_out_fn = File::Spec->rel2abs($out_fn);

XML::Grammar::Fortune->new(
    { mode => "convert_to_html", output_mode => "filename" } )
    ->run( { input => $abs_xml_fn, output => $abs_out_fn } );
my $contents;

my $PREF = '«⋄⋄אבג«';
my $SUF  = '»גבא⋄⋄»';
{
    use XML::LibXML::XPathContext;
    my $doc = XML::LibXML->load_xml( location => $abs_out_fn );
    my $xc = XML::LibXML::XPathContext->new($doc);
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
}
$contents =~ s# xmlns:xsi="[^"]*"##gms;
$contents =~ s/[ \t]+$//gms;

$contents =~ s#\Q$PREF\E(.*?)\Q$SUF\E#<a href="$1" rel="nofollow">$1</a>#gms;

open my $back_fh, '>:encoding(UTF-8)', $abs_out_fn
    or die "Cannot open '$abs_out_fn' for writing - $!";
print {$back_fh} $contents;
close($back_fh);
