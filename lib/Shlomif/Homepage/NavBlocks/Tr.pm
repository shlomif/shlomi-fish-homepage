package Shlomif::Homepage::NavBlocks::Tr;

use strict;
use warnings;

use MooX (qw( late ));

extends('Shlomif::Homepage::NavBlocks::Thingy');

has 'items' => ( is => 'ro', isa => 'ArrayRef', required => 1 );
has 'title' => ( is => 'ro', isa => "Str",      required => 1 );

sub collect_local_links
{
    my $self = shift;

    return [ map { @{ $_->collect_local_links } } @{ $self->items } ];
}

sub render
{
    my ( $self, $r ) = @_;

    return join '', map { "$_\n" } "<tr>",
        sprintf( qq{<td><b>%s</b></td>}, $self->title ),
        "<td>",
        "<ul>",
        ( map { $r->render($_) } @{ $self->items } ),
        "</ul>",
        "</td>",
        "</tr>",
        ;

}

1;
