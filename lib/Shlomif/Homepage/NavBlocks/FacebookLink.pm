package Shlomif::Homepage::NavBlocks::FacebookLink;

use strict;
use warnings;

use HTML::Widgets::NavMenu::EscapeHtml qw(escape_html);

use Moo;

extends('Shlomif::Homepage::NavBlocks::ExternalLink');

sub render
{
    my ( $self, $r ) = @_;

    return sprintf(
        q#<li><p><a class="ext facebook" href="%s">%s</a></p></li>#,
        escape_html( $self->url, ),
        'Facebook Page',
    );
}

1;
