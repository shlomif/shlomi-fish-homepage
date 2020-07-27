package Shlomif::Homepage::CPAN_Links;

use strict;
use warnings;

use Moo;

sub dist
{
    my ( $self, $args ) = @_;
    return
        qq#<a href="http://metacpan.org/release/$args->{d}">$args->{body}</a>#;
}

sub homepage
{
    my ( $self, $args ) = @_;
    return qq#http://metacpan.org/author/\U$args->{who}\E#;
}

sub mod
{
    my ( $self, $args ) = @_;
    return
        qq#<a href="http://metacpan.org/module/$args->{m}">$args->{body}</a>#;
}

sub module
{
    my ( $self, $args ) = @_;
    return $self->mod($args);
}

sub b_self_dist
{
    my ( $self, $args ) = @_;
    return $self->dist( { %$args, body => "<b>$args->{d}</b>", } );
}

sub self_dist
{
    my ( $self, $args ) = @_;
    return $self->dist( { %$args, body => $args->{d} } );
}

sub self_mod
{
    my ( $self, $args ) = @_;
    return $self->mod( { %$args, body => $args->{'m'} } );
}

1;
