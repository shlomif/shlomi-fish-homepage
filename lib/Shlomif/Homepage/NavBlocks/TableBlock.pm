package Shlomif::Homepage::NavBlocks::TableBlock;

use strict;
use warnings;
use MooX (qw( late ));

extends('Shlomif::Homepage::NavBlocks::Thingy');

has 'tr_s' => ( is => 'ro', isa => 'ArrayRef', required => 1 );
has 'id'   => ( is => 'ro', isa => "Str",      required => 1 );

sub collect_local_links
{
    my $self = shift;

    return [ map { @{ $_->collect_local_links } } @{ $self->tr_s } ];
}

sub render
{
    my ( $self, $r ) = @_;

    return join '',
        map { "$_\n" }
        sprintf( q{<div class="topical_nav_block" id="%s">}, $self->id ),
        "<table>",
        ( map { $r->render($_); } @{ $self->tr_s } ),
        "</table>",
        "</div>",
        ;
}

1;
