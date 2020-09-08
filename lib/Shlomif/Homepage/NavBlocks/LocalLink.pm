package Shlomif::Homepage::NavBlocks::LocalLink;

use strict;
use warnings;

use HTML::Widgets::NavMenu::EscapeHtml qw(escape_html);
use Shlomif::Homepage::RelUrl qw/ _path_info _rel_url /;
use MooX (qw( late ));

extends('Shlomif::Homepage::NavBlocks::Thingy');

has [
    qw(
        inner_html
        path
        )
] => ( is => 'ro', isa => 'Str', required => 1 );

has 'title' => ( is => 'ro', isa => 'Str' );
has 'no_wrap' => ( is => 'ro', isa => 'Bool', defualt => '', );

sub collect_local_links
{
    my ($self) = @_;

    return [ $self->path ];
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
    my $normalize = sub { return shift =~ s#/index\.x?html\z#/#gr };

    if ( $normalize->( $self->path ) eq $normalize->( _path_info() ) )
    {
        return sprintf( q#<strong class="current">%s</strong>#,
            $self->inner_html(), );
    }
    else
    {
        return sprintf(
            q#<a href="%s">%s</a>#,
            escape_html( _rel_url( $self->path ) ),
            $self->inner_html(),
        );
    }
}

1;
