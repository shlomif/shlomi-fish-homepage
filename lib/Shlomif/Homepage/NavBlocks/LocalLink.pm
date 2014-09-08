package Shlomif::Homepage::NavBlocks::LocalLink;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

extends ('Shlomif::Homepage::NavBlocks::Thingy');

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

sub render
{
    my ($self, $r) = @_;

    my $normalize = sub {return shift =~ s#/index\.html\z#/#gr};

    if ($normalize->($self->path) eq $normalize->($r->nav_menu->path_info))
    {
        return sprintf(
            q#<li><p><strong class="current">%s</strong></p></li>#,
            $self->inner_html(),
        );
    }
    else
    {
        return sprintf(q#<li><p><a href="%s">%s</a></p></li>#,
            CGI::escapeHTML(
                $r->nav_menu->get_cross_host_rel_url_ref(
                    {
                        host => $r->host,
                        host_url => $self->path,
                        url_type => 'rel',
                        url_is_abs => 0,
                    },
                ),
            ),
            $self->inner_html(),
        );
    }
}

1;
