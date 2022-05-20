#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';

use HTML::Widgets::NavMenu::JQueryTreeView ();
use MyNavData                              ();
use MyNavData::Hosts                       ();
use NavDataRender                          ();
use NavSectMenuRender                      ();
use Path::Tiny qw/ path /;
use Parallel::Map::Segmented ();
use File::Update qw/ write_on_change /;

my $hosts         = MyNavData::Hosts::get_hosts();
my $host          = 't2';
my $host_base_url = $hosts->{$host}->{base_url};
my $hostp         = "lib/cache/combined/$host";

sub _process_batch
{
    for my $proto_url ( @{ $_[0] } )
    {
        my $url = $proto_url =~ s#(?:\A|/)\Kindex\.x?html\z##r;

        my $filename = "/$url";

        # urlpath.
        my $urlp = path("$hostp/$proto_url");
        $urlp->mkpath;

        # print "start filename=$filename\n";

        my $nav_bar = HTML::Widgets::NavMenu::JQueryTreeView->new(
            coords_stop    => 1,
            'path_info'    => $filename,
            'current_host' => $host,
            MyNavData::get_params(),
            'ul_classes'     => [],
            'no_leading_dot' => 1,
        );
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
        my $rendered_results = $nav_bar->render();

        my $leading_path = $rendered_results->{leading_path};

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
            'main_nav_menu_html',
            \( join( "\n", @{ $rendered_results->{html} } ) ),
        );
        $out->(
            'html_head_nav_links',
            \(
                NavDataRender->get_html_head_nav_links(
                    { nav_links_obj => $nav_links_obj }
                )
            ),
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
                        join(
                            '',
                            $shlomif_nav_links_renderer->get_total_html(
                                @params)
                        ) =~ s%<img src="\K\./%%gr
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
        if ( $filename eq '/site-map/hebrew/' )
        {
            my $hebrew_nav_results = NavDataRender->nav_data_render(
                {
                    filename => $url,
                    host     => $host,
                    ROOT     => $ROOT,
                    lang     => +{ 'he' => 1, },
                }
            );
            my $html = join(
                '',
                map { "$_\n" } @{
                    $hebrew_nav_results->{shlomif_main_expanded_nav_bar}
                        ->gen_site_map() || ( die "hebrew site map" )
                }
            );

            # die "'$html" if $html !~ m#The-Enemy-Hebrew#;
            $out->( 'shlomif_hebrew_expanded_nav_bar', \($html), );
        }
    }
    return;
}

Parallel::Map::Segmented->new()->run(
    {
        items => [ ( split /\n/, path("lib/make/tt2.txt")->slurp_raw() ), ],
        nproc => 4,
        batch_size    => 16,
        process_batch => \&_process_batch,
        (
              ( delete( $ENV{LATEMP_PROFILE} ) || $ENV{TRAVIS} )
            ? ( disable_fork => 1, )
            : ()
        ),
    }
);
