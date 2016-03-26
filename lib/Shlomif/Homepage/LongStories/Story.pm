package Shlomif::Homepage::LongStories::Story;

use strict;
use warnings;

use MooX qw/late/;

has [
    'abstract', 'id', 'logo_alt', 'logo_class', 'logo_id', 'logo_src',
    'logo_svg', 'tagline',
] => (is => 'ro', isa => 'Str', required => 1);

has ['entry_id', 'entry_text', 'href',
] => (is => 'ro', isa => 'Str',);

has ['entry_extra_html',
] => (is => 'ro', isa => 'Str', default => q{},);

1;
