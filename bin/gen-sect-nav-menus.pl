#!/usr/bin/perl

use Carp::Always;

use strict;
use warnings;

use lib './lib';

use File::Basename qw/ dirname /;
use IO::All qw/ io /;

use NavSectMenuRender;
use NavDataRender;
use MyNavData;
use MyNavLinks;

sub get_page_path
{
    my $filename = "<get-var filename />";
    $filename =~ s{index\.html$}{};

    return $filename;
}

sub get_root
{
    my $url = shift;

    $url =~ s#\A/##;

    my $ret = (("../" x ($url =~ y#/#/#)) =~ s#/\z##r);

    return (($ret eq '') ? '.' : $ret);
}

sub _out
{
    my ($path, $text_cb) = @_;

    io->dir(dirname($path))->mkpath;

    my $text_ref = $text_cb->();

    io->file($path)->encoding('UTF-8')->print(
        $$text_ref,
        ($$text_ref !~ /\n\z/ ? "\n" : ''),
    );

    return;
}

foreach my $host (qw(t2 vipe))
{
    foreach my $proto_url (($host eq 't2')
        ? @ARGV
        : (qw(index.html lecture/index.html))
    )
    {

        my $url = $proto_url =~ s#(\A|/)index\.html\z#$1#r;

        my $filename = "/$url";
        my $u = $url =~ s#(\A|/)$#${1}index.html#r;

        print "start filename=$filename\n";

        my $nav_bar = HTML::Widgets::NavMenu::JQueryTreeView->new(
            'path_info' => $filename,
            'current_host' => $host,
            MyNavData::get_params(),
            'ul_classes' => [ "navbarmain", ("navbarnested") x 10 ],
            'no_leading_dot' => 1,
        );

        my $results = NavSectMenuRender->init_section_nav_menu(
            {
                filename => $filename,
                host => $host,
                'ROOT' => get_root($url),
            }
        );

        my $section_nav_menu = $results->{section_nav_menu};
        my $rendered_results = $nav_bar->render();

        my $leading_path = $rendered_results->{leading_path};

        my $nav_results = NavDataRender->nav_data_render(
            {
                filename => $url,
                host => $host,
                ROOT => get_root($url),
            }
        );

        # warn Dumper({Results => $results,});

        my $shlomif_nav_links_renderer = $nav_results->{nav_links_renderer};

        my $nav_links_obj = $rendered_results->{nav_links_obj};

        my $out = sub {
            my ($id, $cb) = @_;

            my $path = "lib/cache/$id/$host/$u";

            return _out($path, $cb);
        };

        $out->(
            'sect-navmenu',
            sub {
                return \( $section_nav_menu->get_html );
            }
        );
        $out->(
            'breadcrumbs-trail',
            sub {
                return
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
                ) ;
            });
        $out->(
            'main_nav_menu_html',
            sub {
                return \(join ("\n", @{ $rendered_results->{html} }));
            }
        );
        $out->(
            'html_head_nav_links',
            sub {
                return
                \(NavDataRender->get_html_head_nav_links(
                        { nav_links_obj => $nav_links_obj}
                    ));
            }
        );

        foreach my $with_accesskey ('', 1)
        {
            $out->(
                "shlomif_nav_links_renderer-with_accesskey=$with_accesskey",
                sub {
                    my @params;
                    if ($with_accesskey ne "")
                    {
                        push @params, ('with_accesskey' => $with_accesskey);
                    }
                    return \(
                        join('',
                            $shlomif_nav_links_renderer
                            ->get_total_html(@params)
                        )
                    );
                },
            );
        }

        if ($filename eq '/site-map/')
        {
            $out->('shlomif_main_expanded_nav_bar',
                sub {
                    return \(
                        join ('',
                            map { "$_\n" }
                            @{ $nav_results->{shlomif_main_expanded_nav_bar}
                                ->gen_site_map()
                            }
                        )
                    );
                },
            );
        }
        print "filename=$filename\n";
    }
}
