#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;
use Test::More tests => 10;

use lib './lib';

use HTML::Widgets::NavMenu::JQueryTreeView ();
use MyNavData                              ();
use MyNavData::Hosts                       ();
use NavDataRender                          ();
use NavSectMenuRender                      ();

sub get_root
{
    my $url = shift;

    $url =~ s#\A/##;

    my $ret = ( ( "../" x ( $url =~ y#/#/# ) ) =~ s#/\z##r );

    return ( ( $ret eq '' ) ? '.' : $ret );
}

my $hosts         = MyNavData::Hosts::get_hosts();
my $host          = 't2';
my $host_base_url = $hosts->{$host}->{base_url};
my $hostp         = "lib/cache/combined/$host";

my $x = "philosophy/index.xhtml";

for my $proto_url ($x)
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
    my $ROOT    = get_root($url);
    my $results = NavSectMenuRender->init_section_nav_menu(
        {
            filename => $filename,
            host     => $host,
            lang     => +{ ar => 1, en => 1, he => 1, },
            ROOT     => $ROOT,
        }
    );

    my $section_nav_menu = $results->{section_nav_menu};
    my $rendered_results = $nav_bar->render();

    my $nav_results = NavDataRender->nav_data_render(
        {
            filename => $url,
            host     => $host,
            ROOT     => $ROOT,
            lang     => +{ ar => 1, en => 1, he => 1, },
        }
    );

    # warn Dumper({Results => $results,});

    my $shlomif_nav_links_renderer = $nav_results->{nav_links_renderer};

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

$x = "humour/index.xhtml";

for my $proto_url ($x)
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
    my $ROOT    = get_root($url);
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

    my $nav_results = NavDataRender->nav_data_render(
        {
            filename => $url,
            host     => $host,
            ROOT     => $ROOT,
            lang     => +{ ar => 1, en => 1, he => 1, },
        }
    );

    # warn Dumper({Results => $results,});

    my $shlomif_nav_links_renderer = $nav_results->{nav_links_renderer};

    my $nav_links_obj = $rendered_results->{nav_links_obj};
    if (1)
    {
        my $up = $nav_links_obj->{'next'};

        # TEST
        ok( $up, 'next' );
        my $direct_url = $up->direct_url();

        # TEST
        is( $direct_url, "stories/", "next \$direct_url" );
    }
}

$x = "humour/stories/index.xhtml";

for my $proto_url ($x)
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
    my $ROOT    = get_root($url);
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

    my $nav_results = NavDataRender->nav_data_render(
        {
            filename => $url,
            host     => $host,
            ROOT     => $ROOT,
            lang     => +{ ar => 1, en => 1, he => 1, },
        }
    );

    # warn Dumper({Results => $results,});

    my $shlomif_nav_links_renderer = $nav_results->{nav_links_renderer};

    my $nav_links_obj = $rendered_results->{nav_links_obj};
    foreach my $dir (qw/ prev up /)
    {
        my $up = $nav_links_obj->{$dir};

        # TEST*2
        ok( $up, 'up' );
        my $direct_url = $up->direct_url();

        # TEST*2
        is( $direct_url, "../", "next \$direct_url" );
    }
    foreach my $dir (qw/ next /)
    {
        my $up = $nav_links_obj->{$dir};

        # TEST
        ok( $up, 'up' );
        my $direct_url = $up->direct_url();

        # TEST
        is( $direct_url, "../TheEnemy/", "next \$direct_url" );
    }
}
