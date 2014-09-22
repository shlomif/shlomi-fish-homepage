package Shlomif::Homepage::LongStories::Story;

use strict;
use warnings;

use MooX qw/late/;

has 'id' => (is => 'ro', isa => 'Str', required => 1);
has 'tagline' => (is => 'ro', isa => 'Str', required => 1);

1;
