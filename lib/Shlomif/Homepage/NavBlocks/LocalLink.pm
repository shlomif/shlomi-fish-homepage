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

sub collect_local_links
{
    my ($self) = @_;

    return [ $self->path ];
}

sub render
{
    my ( $self, $r ) = @_;

    my $normalize = sub { return shift =~ s#/index\.html\z#/#gr };

    if ( $normalize->( $self->path ) eq $normalize->( _path_info() ) )
    {
        return sprintf( q#<li><p><strong class="current">%s</strong></p></li>#,
            $self->inner_html(), );
    }
    else
    {
        return sprintf(
            q#<li><p><a href="%s">%s</a></p></li>#,
            escape_html( _rel_url( $self->path ) ),
            $self->inner_html(),
        );
    }
}

1;
