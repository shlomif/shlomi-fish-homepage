package Shlomif::Homepage::NavBlocks::GitHubLink;

use strict;
use warnings;

use MooX (qw( late ));

extends ('Shlomif::Homepage::NavBlocks::ExternalLink');

sub render
{
    my ($self, $r) = @_;

    return sprintf(q#<li><p><a class="ext github" href="%s">%s</a></p></li>#,
        CGI::escapeHTML(
            $self->url,
        ),
        'GitHub Repo',
    );
}

1;

