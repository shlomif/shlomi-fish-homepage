package Shlomif::Homepage::NavBlocks::FacebookLink;

use strict;
use warnings;

use MooX (qw( late ));

extends ('Shlomif::Homepage::NavBlocks::ExternalLink');

sub render
{
    my ($self, $r) = @_;

    return sprintf(q#<li><p><a class="ext facebook" href="%s">%s</a></p></li>#,
        CGI::escapeHTML(
            $self->url,
        ),
        'Facebook Page',
    );
}

1;

