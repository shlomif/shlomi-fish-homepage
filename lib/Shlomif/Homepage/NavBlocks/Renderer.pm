package Shlomif::Homepage::NavBlocks::Renderer;

use strict;
use warnings;
use MooX qw( late );

has 'fn'          => ( is => 'rw', );
has 'host'        => ( is => 'ro', isa => 'Str', required => 1 );
has 'count_bolds' => ( is => 'rw', isa => 'Int', default  => 0 );

sub _non_cached_render
{
    my ( $self, $args ) = @_;

    return $args->{'obj'}->render( { renderer => $self, %$args } );
}

sub flush_found
{
    my $self = shift;

    my $ret = ( $self->count_bolds() == 0 );
    $self->count_bolds(0);

    return $ret;
}

*render = \&_non_cached_render;

1;
