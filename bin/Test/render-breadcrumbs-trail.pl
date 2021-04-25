#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use MyNavData              ();
use HTML::Widgets::NavMenu ();
use MyNavLinks             ();

use HTML::Widgets::NavMenu::EscapeHtml qw(escape_html);

binmode STDOUT, ':encoding(utf8)';

sub _gen_the_string
{
    my $args            = shift;
    my $my_THE_filename = $args->{filename};
    my $leading_path;

    {
        my $filename = $my_THE_filename;
        $filename =~ s{index\.html$}{};
        $filename = "/$filename";

        my $nav_bar;

        $nav_bar = HTML::Widgets::NavMenu->new(
            'path_info'    => $filename,
            'current_host' => "t2",
            MyNavData::get_params(),
            'ul_classes' => [ "navbarmain", ("navbarnested") x 10 ],
        );

        my $rendered_results = $nav_bar->render();

        my $nav_links = $rendered_results->{nav_links};

        my $nav_links_obj = $rendered_results->{nav_links_obj};

        my $nav_html = $rendered_results->{html};

        $leading_path = $rendered_results->{leading_path};

        my $render_leading_path_component = sub {
            my $component  = shift;
            my $title      = $component->title();
            my $title_attr = defined($title) ? " title=\"$title\"" : "";
            return
                  "<a href=\""
                . escape_html( $component->direct_url() )
                . "\"$title_attr>"
                . $component->label() . "</a>";
        };

        my $leading_path_string = join( " → ",
            ( map { $render_leading_path_component->($_) } @$leading_path ) );

        my $nav_links_renderer = MyNavLinks->new(
            'nav_links'     => $nav_links,
            'nav_links_obj' => $nav_links_obj,
            'root'          => "../..",
        );
    }

    use Shlomif::Homepage::SectionMenu::Manager ();

    my $section_nav_menu;

    my $init_section_nav_menu = sub {
        if ( defined($section_nav_menu) )
        {
            return;
        }
        my $filename = $my_THE_filename;
        $filename =~ s{index\.html$}{};
        $filename = "/$filename";

        $section_nav_menu =
            Shlomif::Homepage::SectionMenu::Manager->get_nav_menu(
            {
                lang           => { en => 1, },
                'path_info'    => $filename,
                'current_host' => "t2",
                'root'         => "../..",
                bottom_code    => '',
            },
            );

        return;
    };

    $init_section_nav_menu->();
    my $total_leading_path = $section_nav_menu->total_leading_path(
        {
            main_leading_path => $leading_path,
        }
    );

    my $render_leading_path_component = sub {
        my $component  = shift;
        my $title      = $component->title();
        my $title_attr = defined($title) ? " title=\"$title\"" : "";
        return
              "<a href=\""
            . escape_html( $component->direct_url() )
            . "\"$title_attr>"
            . $component->label() . "</a>";
    };

    my $s = join( " → ",
        ( map { $render_leading_path_component->($_) } @$total_leading_path ) );

    print "$s\n";
    return +{ string => $s, };
}

my $my_THE_filename;

# $my_THE_filename = "puzzles/situation/book-under-rock.html";
# $my_THE_filename = "humour/bits/facts/Buffy/index.html";

# $my_THE_filename = "meta/old-site-snapshots/";
sub _bad_example
{
    $my_THE_filename = "humour/TheEnemy/The-Enemy-English-v7.html";
    _gen_the_string( { filename => $my_THE_filename, } );
    return;
}
_bad_example();

sub _good_example
{
    #body ...
    $my_THE_filename = "humour/bits/facts/Buffy/index.html";
    _gen_the_string( { filename => $my_THE_filename, } );
    return;
}
_good_example();
