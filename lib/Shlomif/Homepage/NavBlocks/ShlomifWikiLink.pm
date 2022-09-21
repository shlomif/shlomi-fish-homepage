package Shlomif::Homepage::NavBlocks::ShlomifWikiLink;

use strict;
use warnings;
use MooX qw/ late /;

extends('Shlomif::Homepage::NavBlocks::ExternalLink');

has css_class => (
    is      => 'ro',
    isa     => 'Str',
    default => 'wiki shlomif',
);

has inner_html => (
    is      => 'ro',
    isa     => 'Str',
    default => 'Shlomif Wiki Page',
);

1;
