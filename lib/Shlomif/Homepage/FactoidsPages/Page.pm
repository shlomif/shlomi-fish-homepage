package Shlomif::Homepage::FactoidsPages::Page;

use strict;
use warnings;

use Moo;

has [
    'abstract',  'id_base',    'img_alt',        'img_attribution',
    'img_class', 'img_src',    'license_method', 'license_year',
    'links_tt2', 'meta_desc',  'nav_blocks_tt2', 'see_also',
    'short_id',  'tabs_title', 'title',          'url_base',
] => ( is => 'ro', required => 1 );

sub img_src_tt2
{
    my ($self) = @_;

    return '[% base_path %]' . $self->img_src;
}

=begin foo

has ['entry_id', 'entry_text', 'href',
] => (is => 'ro', isa => 'Str',);

has ['entry_extra_html',
] => (is => 'ro', isa => 'Str', default => q{},);

=end foo

=cut

1;
