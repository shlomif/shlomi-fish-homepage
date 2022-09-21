package Shlomif::Homepage::NavBlocks::GitHubLink;

use strict;
use warnings;
use MooX qw/ late /;

extends('Shlomif::Homepage::NavBlocks::ExternalLink');

has css_class => (
    is      => 'ro',
    isa     => 'Str',
    default => 'github',
);

has inner_html => (
    is      => 'ro',
    isa     => 'Str',
    default => 'GitHub Repo',
);

1;
