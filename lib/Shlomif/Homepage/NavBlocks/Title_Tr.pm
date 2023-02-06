package Shlomif::Homepage::NavBlocks::Title_Tr;

use strict;
use warnings;
use MooX (qw( late ));

extends('Shlomif::Homepage::NavBlocks::Thingy');

has 'title' => ( is => 'ro', isa => "Str", required => 1 );

sub title_html
{
    my ( $self, $args ) = @_;

    return $self->title;
}

sub collect_local_links
{
    my $self = shift;

    return [];
}

sub render
{
    my ( $self, $args ) = @_;

    return join '',
        sprintf( q{<tr class="%s">},          $self->css_class ),
        sprintf( qq{<th colspan="2">%s</th>}, $self->title_html($args) ),
        "</tr>",
        ;
}

1;
