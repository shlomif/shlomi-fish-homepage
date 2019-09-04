package Shlomif::Homepage::FactoidsPages::Page;

use strict;
use warnings;

use MooX qw/late/;

has [
    'abstract',  'id_base',    'img_alt',        'img_attribution',
    'img_class', 'img_src',    'license_tag',    'license_year',
    'links_wml', 'meta_desc',  'nav_blocks_wml', 'see_also_wml',
    'short_id',  'tabs_title', 'title',          'url_base',
] => ( is => 'ro', isa => 'Str', required => 1 );

=begin foo

has ['entry_id', 'entry_text', 'href',
] => (is => 'ro', isa => 'Str',);

has ['entry_extra_html',
] => (is => 'ro', isa => 'Str', default => q{},);

=end foo

=cut

1;
