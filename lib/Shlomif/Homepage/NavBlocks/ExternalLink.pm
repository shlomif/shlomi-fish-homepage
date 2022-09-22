package Shlomif::Homepage::NavBlocks::ExternalLink;

use strict;
use warnings;
use MooX qw/ late /;

use HTML::Widgets::NavMenu::EscapeHtml qw(escape_html);

extends('Shlomif::Homepage::NavBlocks::Thingy');

has [
    qw(
        url
    )
] => ( is => 'ro', isa => 'Str', required => 1 );

sub collect_local_links
{
    my ($self) = @_;

    return [];
}

sub render
{
    my ( $self, $r ) = @_;

    return sprintf(
        q#<li><p><a class="ext %s" href="%s">%s</a></p></li>#,
        $self->css_class(), escape_html( $self->url, ),
        $self->inner_html(),
    );
}

1;
