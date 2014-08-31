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

sub collect_local_links
{
    my ($self) = @_;

    return [$self->path];
}

package Shlomif::Homepage::NavBlocks::ExternalLink;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

has [qw(
    url
)] => (is => 'ro', isa => 'Str', required => 1);

sub collect_local_links
{
    my ($self) = @_;

    return [];
}

package Shlomif::Homepage::NavBlocks::GitHubLink;

use MooX (qw( late ));

extends ('Shlomif::Homepage::NavBlocks::ExternalLink');

package Shlomif::Homepage::NavBlocks::FacebookLink;

use MooX (qw( late ));

extends ('Shlomif::Homepage::NavBlocks::ExternalLink');

package Shlomif::Homepage::NavBlocks::Tr;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

has 'items' => (is => 'ro', isa => 'ArrayRef', required => 1);
has 'title' => (is => 'ro', isa => "Str", required => 1);

sub collect_local_links
{
    my $self = shift;

    return [ map { @{$_->collect_local_links} } @{$self->items}];
}

1;

package Shlomif::Homepage::NavBlocks::Renderer;

use strict;
use warnings;

use utf8;

use Carp ();

use MooX (qw( late ));

use CGI ();

has 'host' => (is => 'ro', isa => 'Str', required => 1);

has [qw(
    nav_menu
)] => (is => 'ro', required => 1);

sub render
{
    my ($self, $thingy) = @_;

    if ($thingy->isa('Shlomif::Homepage::NavBlocks::Tr'))
    {
        return join'',map { "$_\n" }
            "<tr>",
            sprintf(qq{<td colspan="2"><b>%s</b></td>}, $thingy->title),
            "<td>",
            "<ul>",
            (map { $self->render($_) } @{$thingy->items}),
            "</ul>",
            "</td>",
            "</tr>",
            ;
    }
    elsif ($thingy->isa('Shlomif::Homepage::NavBlocks::LocalLink'))
    {
        my $normalize = sub {return shift =~ s#/index\.html\z#/#gr};

        if ($normalize->($thingy->path) eq $normalize->($self->nav_menu->path_info))
        {
            return sprintf(
                q#<li><p><strong class="current">%s</strong></p></li>#,
                $thingy->inner_html(),
            );
        }
        else
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
    }
    elsif ($thingy->isa('Shlomif::Homepage::NavBlocks::GitHubLink'))
    {
        return sprintf(q#<li><p><a class="ext github" href="%s">%s</a></p></li>#,
            CGI::escapeHTML(
                $thingy->url,
            ),
            'GitHub Repo',
        );
    }
    elsif ($thingy->isa('Shlomif::Homepage::NavBlocks::FacebookLink'))
    {
        return sprintf(q#<li><p><a class="ext facebook" href="%s">%s</a></p></li>#,
            CGI::escapeHTML(
                $thingy->url,
            ),
            'Facebook Page',
        );
    }
    else
    {
        Carp::confess('unimplemented');
    }
}


1;

