package Shlomif::Homepage::NavBlocks::Thingy;

use strict;
use warnings;

use MooX (qw( late ));

has 'cache'     => ( is => 'rw' );
has 'is_cached' => ( is => 'rw', isa => 'Bool', default => 0 );

sub cached_render
{
    my ( $self, $promise_cb ) = @_;

    if ( !$self->is_cached )
    {
        $self->cache( scalar( $promise_cb->() ), );
        $self->is_cached(1);
    }

    return $self->cache;
}

1;
