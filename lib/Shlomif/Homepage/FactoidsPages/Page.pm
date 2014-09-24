package Shlomif::Homepage::FactoidsPages::Page;

use strict;
use warnings;

use MooX qw/late/;

has [
    'id_base',
    'license_wml',
    'links_wml',
    'meta_desc',
    'nav_blocks_wml',
    'see_also_wml',
    'short_id',
    'tabs_title',
    'title',
] => (is => 'ro', isa => 'Str', required => 1);

=begin foo

has ['entry_id', 'entry_text', 'href',
] => (is => 'ro', isa => 'Str',);

has ['entry_extra_html',
] => (is => 'ro', isa => 'Str', default => q{},);

=end foo

=cut

1;
