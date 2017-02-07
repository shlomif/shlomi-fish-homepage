package Shlomif::Homepage::NavBlocks::Title_Tr;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

extends('Shlomif::Homepage::NavBlocks::Thingy');

has 'title' => ( is => 'ro', isa => "Str", required => 1 );

sub collect_local_links
{
    my $self = shift;

    return [];
}

sub render
{
    my ( $self, $r ) = @_;

    return join '',
        map { "$_\n" } sprintf( q{<tr class="%s">}, $self->css_class ),
        sprintf( qq{<th colspan="3">%s</th>}, $self->title ),
        "</tr>",
        ;
}

1;

