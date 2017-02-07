package Shlomif::Homepage::NavBlocks::ShlomifWikiLink;

use strict;
use warnings;

use MooX (qw( late ));

use HTML::Widgets::NavMenu::EscapeHtml qw(escape_html);

extends('Shlomif::Homepage::NavBlocks::ExternalLink');

sub render
{
    my ( $self, $r ) = @_;

    return sprintf(
        q#<li><p><a class="ext wiki shlomif" href="%s">%s</a></p></li>#,
        escape_html( $self->url, ),
        'Shlomif Wiki Page',
    );
}

1;

