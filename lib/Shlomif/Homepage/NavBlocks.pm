package Shlomif::Homepage::NavBlocks::LocalLink;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

has [qw(
    inner_html
    path
)] => (is => 'ro', isa => 'Str', required => 1);

has 'title' => (is => 'ro', isa => 'Str');

package Shlomif::Homepage::NavBlocks::GitHubLink;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

has [qw(
    url
)] => (is => 'ro', isa => 'Str', required => 1);

package Shlomif::Homepage::NavBlocks::Renderer;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

use CGI ();

has 'host' => (is => 'ro', isa => 'Str', required => 1);

has [qw(
    nav_menu
)] => (is => 'ro', required => 1);

sub render
{
    my ($self, $thingy) = @_;

    if ($thingy->isa('Shlomif::Homepage::NavBlocks::LocalLink'))
    {
        return sprintf(q#<li><p><a href="%s">%s</a></p></li>#,
            CGI::escapeHTML(
                $self->nav_menu->get_cross_host_rel_url_ref(
                    {
                        host => $self->host,
                        host_url => $thingy->path,
                        url_type => 'rel',
                        url_is_abs => 0,
                    },
                ),
            ),
            $thingy->inner_html(),
        );
    }
    else
    {
        Carp::confess('unimplemented');
    }
}

1;


