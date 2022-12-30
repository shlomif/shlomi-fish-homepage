#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;
use Test::More tests => 12;

use lib './lib';

use HTML::Widgets::NavMenu::JQueryTreeView ();
use MyNavData                              ();
use NavDataRender                          ();
use NavSectMenuRender                      ();

my $host = 't2';

sub _calc_nav_links
{
    my ( $proto_url, ) = @_;
    my $url = $proto_url =~ s#(?:\A|/)\Kindex\.x?html\z##r;

    my $filename = "/$url";

    # print "start filename=$filename\n";
    my $ROOT    = NavDataRender::get_root($url);
    my $results = NavSectMenuRender->init_section_nav_menu(
        {
            filename => $filename,
            host     => $host,
            lang     => +{ ar => 1, en => 1, he => 1, },
            ROOT     => $ROOT,
        }
    );

    my $section_nav_menu = $results->{section_nav_menu};
    my $rendered_results = $section_nav_menu->results();

    my $nav_links_obj = $rendered_results->{nav_links_obj};

    return ( $nav_links_obj, );
}

for my $proto_url ("philosophy/index.xhtml")
{
    my $url = $proto_url =~ s#(?:\A|/)\Kindex\.x?html\z##r;

    my $filename = "/$url";

    # print "start filename=$filename\n";

    my $nav_bar = HTML::Widgets::NavMenu::JQueryTreeView->new(
        coords_stop    => 1,
        'path_info'    => $filename,
        'current_host' => $host,
        MyNavData::get_params(),
        'ul_classes'     => [],
        'no_leading_dot' => 1,
    );
    my $rendered_results = $nav_bar->render();

    my $nav_links_obj = $rendered_results->{nav_links_obj};
    if (1)    # ( $filename eq '/philosophy/' )
    {
        my $up = $nav_links_obj->{up};

        # TEST
        ok( $up, 'up' );
        my $direct_url = $up->direct_url();

        # TEST
        is( $direct_url, "../", "\$direct_url" );
    }
}

for my $proto_url ("humour/index.xhtml")
{
    my ( $nav_links_obj, ) = _calc_nav_links( $proto_url, );
    foreach my $dir (qw/ next /)
    {
        my $up = $nav_links_obj->{$dir};

        # TEST
        ok( $up, $dir );
        my $direct_url = $up->direct_url();

        # TEST
        is( $direct_url, "stories/", "$dir \$direct_url" );
    }
}

for my $proto_url ("humour/stories/index.xhtml")
{
    my ( $nav_links_obj, ) = _calc_nav_links( $proto_url, );
    foreach my $dir (qw/ prev up /)
    {
        my $up = $nav_links_obj->{$dir};

        # TEST*2
        ok( $up, "dir=$dir truthy" );
        my $direct_url = $up->direct_url();

        # TEST*2
        is( $direct_url, "../", "$dir \$direct_url" );
    }
    foreach my $dir (qw/ next /)
    {
        my $up = $nav_links_obj->{$dir};

        # TEST
        ok( $up, "dir=$dir truthy" );
        my $direct_url = $up->direct_url();

        # TEST
        is( $direct_url, "../TheEnemy/", "$dir \$direct_url" );
    }
}

for my $proto_url ("humour/Blue-Rabbit-Log/index.xhtml")
{
    my ( $nav_links_obj, ) = _calc_nav_links( $proto_url, );

    foreach my $dir (qw/ next /)
    {
        my $up = $nav_links_obj->{$dir};

        # TEST
        ok( $up, "dir=$dir truthy" );
        my $direct_url = $up->direct_url();

        # TEST
        is( $direct_url, "part-1.html", "$dir \$direct_url" );
    }
}
