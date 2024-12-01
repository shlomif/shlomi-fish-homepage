package Shlomif::Homepage::TTRender::SetCSS;

use strict;
use warnings;
use utf8;

use parent 'Set::CSS';

sub addClass
{
    my ( $self, @c ) = @_;

    $self->insert(@c);

    return "";
}

1;
