#!/usr/bin/perl

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

    return (("../" x ($url =~ y#/#/#)) =~ s#/\z##r);
}

foreach my $host (qw(t2 vipe))
{
    foreach my $proto_url (($host eq 't2')
        ? @ARGV
        : (qw(index.html lecture/index.html))
    )
    {

        my $url = $proto_url =~ s#/index\.html\z#/#r;

        my $filename = "/$url";
        my $u = $url =~ s#/$#/index.html#r;

        my $nav_bar = HTML::Widgets::NavMenu->new(
            'path_info' => $filename,
            'current_host' => $host,
            MyNavData::get_params(),
            'ul_classes' => [ "navbarmain", ("navbarnested") x 10 ],
            'no_leading_dot' => 1,
        );

        my $results = NavSectMenuRender->init_section_nav_menu(
            {
                filename => ('/' . $url),
                host => $host,
                'ROOT' => get_root($url),
            }
        );

        my $section_nav_menu = $results->{section_nav_menu};
        my $rendered_results = $nav_bar->render();

        my $leading_path = $rendered_results->{leading_path};

        {
            my $path = "lib/cache/sect-navmenu/$host/$u";
            io->dir(dirname($path))->mkpath;
            io->file($path)->encoding('UTF-8')->print($section_nav_menu->get_html);
        }
        {
            my $path = "lib/cache/breadcrumbs-trail/$host/$u";
            io->dir(dirname($path))->mkpath;
            io->file($path)->encoding('UTF-8')->print(
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
            );
        }
    }
}
