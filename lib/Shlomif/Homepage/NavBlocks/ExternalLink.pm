package Shlomif::Homepage::NavBlocks::ExternalLink;

use strict;
use warnings;
use MooX qw/ late /;

extends('Shlomif::Homepage::NavBlocks::Thingy');

has [
    qw(
        url
        )
] => ( is => 'ro', isa => 'Str', required => 1 );

sub collect_local_links
{
    my ($self) = @_;

    return [];
}

1;
