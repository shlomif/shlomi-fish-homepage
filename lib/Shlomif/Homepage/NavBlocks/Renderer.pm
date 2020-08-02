package Shlomif::Homepage::NavBlocks::Renderer;

use strict;
use warnings;
use MooX qw( late );

has 'host' => ( is => 'ro', isa => 'Str', required => 1 );

sub _non_cached_render
{
    my ( $self, $args ) = @_;

    return $args->{'obj'}->render( { renderer => $self, %$args } );
}

*render = \&_non_cached_render;

1;
