package Shlomif::Homepage::NavBlocks::FacebookLink;

use strict;
use warnings;
use MooX qw/ late /;

extends('Shlomif::Homepage::NavBlocks::ExternalLink');

has css_class => (
    is      => 'ro',
    isa     => 'Str',
    default => 'facebook',
);

has inner_html => (
    is      => 'ro',
    isa     => 'Str',
    default => 'Facebook Page',
);

1;
