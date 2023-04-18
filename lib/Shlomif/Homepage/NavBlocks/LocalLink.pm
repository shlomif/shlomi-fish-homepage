package Shlomif::Homepage::NavBlocks::LocalLink;

use 5.014;
use strict;
use warnings;

use HTML::Widgets::NavMenu::EscapeHtml qw( escape_html );
use MooX (qw( late ));

extends('Shlomif::Homepage::NavBlocks::Thingy');

has [
    qw(
        inner_html
        path
    )
] => ( is => 'ro', isa => 'Str', required => 1 );

has 'css_class' => ( is => 'ro', isa => 'Str', default => '' );
has 'title'     => ( is => 'ro', isa => 'Str' );
has 'no_wrap'   => ( is => 'ro', isa => 'Bool', defualt => '', );
has 'skip_bold' => ( is => 'ro', isa => 'Bool', defualt => '', );

sub collect_local_links
{
    my ($self) = @_;

    return ( $self->skip_bold ? [] : [ $self->path ] );
}

sub _li_p_wrap
{
    my ( $self, $text ) = @_;

    return $self->no_wrap ? $text : "<li><p>$text</p></li>";
}

sub render
{
    my ( $self, $args ) = @_;

    return $self->_li_p_wrap( $self->_render_helper($args) );
}

sub _render_helper
{
    my ( $self, $args ) = @_;

    my $r         = $args->{renderer};
    my $normalize = sub { return shift =~ s#/index\.x?html\z#/#r; };

    if ( $normalize->( $self->path ) eq $normalize->( $r->fn->filename() ) )
    {
        if ( !$self->skip_bold )
        {
            $r->count_bolds( $r->count_bolds() + 1 );
        }
        return sprintf( q#<strong class="current">%s</strong>#,
            $self->inner_html(), );
    }
    else
    {
        return sprintf(
            q#<a%s href="%s">%s</a>#,
            (
                $self->css_class
                ? sprintf( q# class="%s"#, $self->css_class )
                : ''
            ),
            escape_html( $r->fn->get_relative_url( $self->path, 1, ) ),
            $self->inner_html(),
        );
    }
}

1;
