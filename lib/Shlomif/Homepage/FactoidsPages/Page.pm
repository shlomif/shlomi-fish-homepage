package Shlomif::Homepage::FactoidsPages::Page;

use strict;
use warnings;

use Moo;

use List::Util qw/ uniqstr /;

has [
    'abstract',   'id_base',   'img_alt',        'img_attribution',
    'img_class',  'img_src',   'license_method', 'license_year',
    'links_tt2',  'meta_desc', 'see_also',       'short_id',
    'tabs_title', 'title',     'url_base',
] => ( is => 'ro', required => 1 );

has ['override_html_anchor'] => ( is => 'ro', );

sub img_src_tt2
{
    my ($self) = @_;

    return '[% base_path %]' . $self->img_src;
}

sub dashed_short_id
{
    my ( $self, ) = @_;

    return ( ( $self->override_html_anchor // $self->short_id ) =~ tr/_/-/r );
}

sub makefile_deps
{
    my ( $page, $deps ) = @_;

    my $id   = $page->id_base;
    my $path = $page->url_base;
    my $pre_incs_path =
        "dest/pre-incs/t2/humour/bits/facts/${path}/index.xhtml";
    return [
        +{
            'path' => $pre_incs_path,
            line   => (
                "$pre_incs_path: "
                    . join( " ", uniqstr( sort @{ $deps->{$id} } ) ) . "\n"
            ),
        },
    ];
}

=begin foo

has ['entry_id', 'entry_text', 'href',
] => (is => 'ro', isa => 'Str',);

has ['entry_extra_html',
] => (is => 'ro', isa => 'Str', default => q{},);

=end foo

=cut

1;
