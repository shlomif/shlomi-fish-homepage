package Shlomif::Homepage::Amazon;

use strict;
use warnings;

sub import
{
    my ($module, $args) = @_; 
    return Shlomif::Homepage::Amazon::Obj->new($args)->process;
}

package Shlomif::Homepage::Amazon::Obj;

use Moose;

use XML::Grammar::ProductsSyndication;
use XML::LibXML::XPathContext;
use Term::ReadPassword;

has 'wml_dir' => (isa => 'Str', is => 'ro');
has 'lib_dir' => (isa => 'Str', is => 'ro');
has 'xml_basename' => (isa => 'Str', is => 'ro');
has 'ps' => (isa => 'XML::Grammar::ProductsSyndication', is => 'rw');

sub BUILD
{
    my $self = shift;

    $self->ps(XML::Grammar::ProductsSyndication->new(
        {
            'source' =>
            {
                'file' => sprintf("%s/%s", $self->wml_dir, $self->xml_basename),
            }
        },
    ));

}

sub process
{
    my ($self) = @_;

    if (!$self->ps->is_valid())
    {
        die "Not valid.";
    }
    my $xml = $self->ps->transform_into_html({ 'output' => "xml" });

    my $xc = XML::LibXML::XPathContext->new($xml);
    $xc->registerNs('html' => "http://www.w3.org/1999/xhtml");

    open my $out, ">", $self->lib_dir() . "/include-me.html";
    binmode $out, ":utf8";
    print {$out} $xc->findnodes('/html:html/html:body/html:div')->[0]->toString(0);
    close ($out);

    $self->ps->update_cover_images(
        {
            'size' => "l",
            'resize_to' => { 'width' => 150, 'height' => 250 },
            'name_cb' =>
            sub
            {
                my $args = shift;
                return $self->wml_dir() . "/images/$args->{id}.jpg";
            },
            'amazon_token' => "0VRRHTFJECHSKYNYD282",
            'amazon_associate' => "shlomifishhom-20",
            'amazon_sak' => read_password('Secret Access Key: '),
        }
    );

    return;
}

1;
