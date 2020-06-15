package Shlomif::Homepage::NavBlocks::GitHubLink;

use strict;
use warnings;

use Moo;

use HTML::Widgets::NavMenu::EscapeHtml qw(escape_html);

extends('Shlomif::Homepage::NavBlocks::ExternalLink');

sub render
{
    my ( $self, $r ) = @_;

    return sprintf(
        q#<li><p><a class="ext github" href="%s">%s</a></p></li>#,
        escape_html( $self->url, ),
        'GitHub Repo',
    );
}

1;
