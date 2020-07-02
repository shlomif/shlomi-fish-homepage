#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';

use Carp::Always;
use HTML::Widgets::NavMenu::EscapeHtml qw(escape_html);
use HTML::Widgets::NavMenu::JQueryTreeView ();
use MyNavData                              ();
use MyNavData::Hosts                       ();
use NavDataRender                          ();
use NavSectMenuRender                      ();
use Parallel::ForkManager::Segmented       ();
use Path::Tiny qw/ path /;
use URI::Escape qw(uri_escape);

sub get_root
{
    my $url = shift;

    $url =~ s#\A/##;

    my $ret = ( ( "../" x ( $url =~ y#/#/# ) ) =~ s#/\z##r );

    return ( ( $ret eq '' ) ? '.' : $ret );
}

use File::Update qw/ write_on_change /;

# At least temporarily disable Parallel::ForkManager because it causes
# the main process to exit before all the work is done.
my $hosts         = MyNavData::Hosts::get_hosts();
my $host          = 't2';
my $host_base_url = $hosts->{$host}->{base_url};
my $hostp         = "lib/cache/combined/$host";

sub _process_item
{
    my $proto_url = shift;
    my $url       = $proto_url =~ s#(?:\A|/)\Kindex\.x?html\z##r;

    my $filename = "/$url";

    # urlpath.
    my $urlp = path("$hostp/$proto_url");
    $urlp->mkpath;

    # print "start filename=$filename\n";

    my $nav_bar = HTML::Widgets::NavMenu::JQueryTreeView->new(
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
            ROOT     => $ROOT,
        }
    );

    my $section_nav_menu = $results->{section_nav_menu};
    my $rendered_results = $nav_bar->render();

    my $leading_path = $rendered_results->{leading_path};

    my $nav_results = NavDataRender->nav_data_render(
        {
            filename => $url,
            host     => $host,
            ROOT     => $ROOT,
        }
    );

    # warn Dumper({Results => $results,});

    my $shlomif_nav_links_renderer = $nav_results->{nav_links_renderer};

    my $nav_links_obj = $rendered_results->{nav_links_obj};

    my $out = sub {
        my ( $id, $ref ) = @_;

        return write_on_change( $urlp->child($id), $ref );
    };

    $out->( 'sect-navmenu', \( $section_nav_menu->get_html ), );
    $out->(
        'breadcrumbs-trail',
        \(
            NavDataRender->get_breadcrumbs_trail_unconditionally(
                {
                    total_leading_path =>
                        $section_nav_menu->total_leading_path(
                        {
                            main_leading_path => $leading_path,
                        }
                        ),
                }
            )
        ),
    );
    $out->(
        'main_nav_menu_html', \( join( "\n", @{ $rendered_results->{html} } ) ),
    );
    $out->(
        'html_head_nav_links',
        \(
            NavDataRender->get_html_head_nav_links(
                { nav_links_obj => $nav_links_obj }
            )
        ),
    );

    $out->(
        'page_url', \( escape_html( uri_escape( $host_base_url . $url ) ) ),
    );

    foreach my $with_accesskey ( '', 1 )
    {
        $out->(
            "shlomif_nav_links_renderer-with_accesskey=$with_accesskey",
            do
            {
                my @params;
                if ( $with_accesskey ne "" )
                {
                    push @params, ( 'with_accesskey' => $with_accesskey );
                }
                \(
                    join( '',
                        $shlomif_nav_links_renderer->get_total_html(@params) )
                        =~ s%<img src="\K\./%%gr
                );
            },
        );
    }

    if ( $filename eq '/site-map/' )
    {
        $out->(
            'shlomif_main_expanded_nav_bar',
            \(
                join(
                    '',
                    map { "$_\n" } @{
                        $nav_results->{shlomif_main_expanded_nav_bar}
                            ->gen_site_map()
                    }
                )
            ),
        );
    }
    return;
}

Parallel::ForkManager::Segmented->new->run(
    {
        items => [ ( split /\n/, path("lib/make/tt2.txt")->slurp_raw() ), ],
        nproc => 4,
        batch_size   => 16,
        process_item => \&_process_item,
        ( delete( $ENV{LATEMP_PROFILE} ) ? ( disable_fork => 1, ) : () ),
    }
);
