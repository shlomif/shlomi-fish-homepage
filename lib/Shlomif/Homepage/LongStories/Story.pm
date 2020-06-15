package Shlomif::Homepage::LongStories::Story;

use strict;
use warnings;

use Moo;

has [
    'abstract', 'id',       'logo_alt', 'logo_class',
    'logo_id',  'logo_src', 'logo_svg', 'tagline',
] => ( is => 'ro', required => 1 );

has [ 'entry_id', 'entry_text', 'href', ] => ( is => 'ro', );

has [ 'entry_extra_html', ] => ( is => 'ro', default => q{}, );

1;
