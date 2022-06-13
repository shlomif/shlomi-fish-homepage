package Shlomif::Homepage::Amazon::Obj;

use strict;
use warnings;

use MooX qw( late );

use Path::Tiny    qw(path);
use JSON::MaybeXS qw(decode_json);

use XML::Grammar::ProductsSyndication ();
use XML::LibXML::XPathContext         ();

has 'src_dir'      => ( isa => 'Str', is => 'ro', required => 1, );
has 'lib_dir'      => ( isa => 'Str', is => 'ro', required => 1, );
has 'xml_basename' => ( isa => 'Str', is => 'ro', required => 1, );
has 'ps' => (
    isa     => 'XML::Grammar::ProductsSyndication',
    is      => 'rw',
    lazy    => 1,
    default =>

        sub {
        my $self = shift;

        return XML::Grammar::ProductsSyndication->new(
            {
                'source' => {
                    'file' =>
                        sprintf( "%s/%s", $self->src_dir, $self->xml_basename ),
                }
            },
        );
        },
);

sub process
{
    my ($self) = @_;

    my $config =
        decode_json(
        path( $ENV{HOME} . '/.shlomifish-amazon-sak.json' )->slurp_utf8 );

    if ( !$self->ps->is_valid() )
    {
        die "Not valid.";
    }
    my $xml = $self->ps->transform_into_html( { 'output' => "xml" } );

    my $xc = XML::LibXML::XPathContext->new($xml);
    $xc->registerNs( 'html' => "http://www.w3.org/1999/xhtml" );

    path( $self->lib_dir() . "/include-me.html" )
        ->spew_utf8(
        $xc->findnodes('/html:html/html:body/html:div')->[0]->toString(0) );

    $self->ps->update_cover_images(
        {
            'size'      => "l",
            'resize_to' => { 'width' => 150, 'height' => 250 },
            'name_cb'   => sub {
                my $args = shift;
                return $self->src_dir() . "/images/$args->{id}.jpg";
            },
            'amazon_token'     => "0VRRHTFJECHSKYNYD282",
            'amazon_associate' => "shlomifishhom-20",
            'amazon_sak'       => $config->{'amazon_sak'},
        }
    );

    return;
}

1;
