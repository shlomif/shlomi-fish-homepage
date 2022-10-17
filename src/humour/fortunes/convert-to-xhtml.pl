use strict;
use warnings;
use utf8;

use File::Spec::Functions qw( catpath splitpath rel2abs );
use YAML::XS              qw/ LoadFile /;

use XML::Grammar::Fortune     ();
use XML::LibXML               ();
use URI::Find                 ();
use XML::LibXML::XPathContext ();
use Encode                    qw/ decode /;

my ( $xml_fn, $out_fn ) = @ARGV;

# The Directory containing the script.
my $script_dir = catpath( ( splitpath( rel2abs $0 ) )[ 0, 1 ] );
my ($basename) = ( $xml_fn =~ /([a-zA-Z0-9_\-]+)\.xml\z/ms )
    or die;

XML::Grammar::Fortune->new( { mode => "validate", } )
    ->run( { input => $xml_fn, } );
XML::Grammar::Fortune->new(
    { mode => "convert_to_html", output_mode => "filename" } )
    ->run( { input => $xml_fn, output => $out_fn } );

my $PREFIX = '«⋄⋄אבג«';
my $SUFFIX = '»גבא⋄⋄»';
my $ns     = "http://www.w3.org/1999/xhtml";

sub _ns_elem
{
    my $elem = XML::LibXML::Element->new(shift);
    $elem->setNamespace($ns);
    return $elem;
}

sub _ns_xc
{
    my $xc = XML::LibXML::XPathContext->new(shift);
    $xc->registerNs( 'html' => $ns, );
    return $xc;
}
my $doc    = XML::LibXML->load_xml( location => $out_fn );
my $xc     = _ns_xc($doc);
my $finder = URI::Find->new(
    sub {
        my ( $obj, $text ) = @_;
        return qq#$PREFIX$text$SUFFIX#;
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
my $yaml_path = "$script_dir/fortunes-shlomif-ids-data.yaml";

my ( $yaml, ) = LoadFile($yaml_path);
$yaml = ( $yaml->{files} or die );

my $file_yaml = $yaml->{"$basename.xml"};
foreach my $node (
    $xc->findnodes(q#//*[@class='fortune'][html:table[@class='info']]#) )
{
    my $nodexc = _ns_xc($node);
    my $id     = $nodexc->findnodes(q#html:h3/@id#)->[0]->textContent;

    my $date = $file_yaml->{$id}->{'date'}
        or Carp::confess("no date for id = $id ; basename = $basename .");

    my $info = $nodexc->findnodes(q#html:table[@class='info']/html:tbody#)->[0];
    my $tr   = _ns_elem('tr');
    foreach my $p ( [ 'field', 'Published' ],
        [ 'value', scalar( $date =~ s/T.*?\z//mrs ) ] )
    {
        my $td = _ns_elem('td');
        $td->setAttribute( 'class', $p->[0] );
        $td->appendChild( $doc->createTextNode( $p->[1] ) );
        $tr->appendChild($td);
    }

    $info->appendChild($tr);

    # print "<<$id>>\n";
}
my $contents;
$contents = decode( 'UTF-8', $doc->toString() );
$contents =~ s# xmlns:xsi="[^"]*"##gms;
$contents =~ s/[ \t]+$//gms;

$contents =~
    s#\Q$PREFIX\E(.*?)\Q$SUFFIX\E#<a href="$1" rel="nofollow">$1</a>#gms;

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
