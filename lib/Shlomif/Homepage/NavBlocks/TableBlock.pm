package Shlomif::Homepage::NavBlocks::TableBlock;

use strict;
use warnings;
use MooX (qw( late ));

extends('Shlomif::Homepage::NavBlocks::Thingy');

has 'tr_s'         => ( is => 'ro', isa => 'ArrayRef', required => 1 );
has 'id'           => ( is => 'ro', isa => "Str",      required => 1 );
has 'text_title'   => ( is => 'ro', isa => "Str",      required => 1 );
has '_local_links' => ( is => 'ro', isa => "HashRef",  is       => 'lazy', );

sub _build__local_links
{
    my ( $self, ) = @_;

    return +{
        map { $_ => 1 }
        map { @{ $_->collect_local_links } } @{ $self->tr_s }
    };
}

sub collect_local_links
{
    my $self = shift;

    #return [ map { @{ $_->collect_local_links } } @{ $self->tr_s } ];
    return [ sort keys %{ $self->_local_links } ];
}

sub render
{
    my ( $self, $args ) = @_;
    my $renderer = $args->{renderer};
    return join '', sprintf( q{<table id="%s">}, $self->id ),
        ( map { $renderer->render( { table => $self, %$args, obj => $_, } ); }
            @{ $self->tr_s } ),
        "</table>",
        ;
}

1;
