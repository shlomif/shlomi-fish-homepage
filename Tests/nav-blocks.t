#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use lib './lib';

use NavDataRender;

use Shlomif::Homepage::NavBlocks;

use IO::All;

{
    my $nav_bar = HTML::Widgets::NavMenu->new(
        path_info => "/philosophy/the-eternal-jew/",
        current_host => 't2',
        MyNavData::get_params(),
        'no_leading_dot' => 1,
    );

    my $r = Shlomif::Homepage::NavBlocks::Renderer->new(
        {
            host => 't2',
            nav_menu => $nav_bar,
        }
    );

    {
        my $link = Shlomif::Homepage::NavBlocks::LocalLink->new(
            {
                inner_html => "Ongoing Text",
                path => "humour/Selina-Mandrake/ongoing-text.html",
            },
        );

        # TEST
        is (
            $r->render($link),
            q{<li><p><a href="../../humour/Selina-Mandrake/ongoing-text.html">Ongoing Text</a></p></li>},
            "Render Local Link.",
        );
    }
}
