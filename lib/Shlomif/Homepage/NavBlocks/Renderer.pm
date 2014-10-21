package Shlomif::Homepage::NavBlocks::Renderer;

use strict;
use warnings;

use utf8;

use Carp ();

use MooX (qw( late ));

extends ('Exporter');

has 'host' => (is => 'ro', isa => 'Str', required => 1);

has [qw(
    nav_menu
)] => (is => 'ro', required => 1);

sub render
{
    my ($self, $thingy) = @_;

    return $thingy->cached_render(
        sub {
            return $self->_non_cached_render($thingy);
        }
    );
}

sub _non_cached_render
{
    my ($self, $thingy) = @_;

    return $thingy->render($self);
}

1;

