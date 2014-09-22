package Shlomif::Homepage::LongStories::Story;

use strict;
use warnings;

use MooX qw/late/;

has ['id', 'logo_alt', 'logo_class', 'logo_id', 'logo_src', 'tagline'], => (is => 'ro', isa => 'Str', required => 1);

1;
