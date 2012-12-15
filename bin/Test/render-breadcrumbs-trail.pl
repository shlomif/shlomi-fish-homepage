#!/usr/bin/perl

use strict;
use warnings;
use MyNavData;
use HTML::Widgets::NavMenu;
use CGI qw();
use MyNavLinks;

my $my_THE_filename = "puzzles/situation/book-under-rock.html";
{
my $filename = $my_THE_filename;
$filename =~ s{index\.html$}{};
$filename = "/$filename";

use vars qw($nav_bar);

$nav_bar = HTML::Widgets::NavMenu->new(
    'path_info' => $filename,
    'current_host' => "t2",
    MyNavData::get_params(),
    'ul_classes' => [ "navbarmain", ("navbarnested") x 10 ],
    );

my $rendered_results = $nav_bar->render();

use vars qw($nav_links);

$nav_links = $rendered_results->{nav_links};

use vars qw($nav_links_obj);

$nav_links_obj = $rendered_results->{nav_links_obj};

use vars qw($nav_html);

$nav_html = $rendered_results->{html};

use vars qw($leading_path);
$leading_path = $rendered_results->{leading_path};

my $render_leading_path_component = sub {
    my $component = shift;
    my $title = $component->title();
    my $title_attr = defined($title) ? " title=\"$title\"" : "";
    return "<a href=\"" . CGI::escapeHTML($component->direct_url()) .
        "\"$title_attr>" .
        $component->label() . "</a>";
};

use vars qw($leading_path_string);

$leading_path_string =
    join(" &rarr; ",
        (map
        { $render_leading_path_component->($_) }
        @$leading_path
        ));

use vars qw($nav_links_renderer);

$nav_links_renderer = MyNavLinks->new(
        'nav_links' => $nav_links,
        'nav_links_obj' => $nav_links_obj,
        'root' => "../..",
        );
    }

    use MySectNavData;

    use vars (qw($section_nav_menu));

    sub init_section_nav_menu
    {
        if (defined($section_nav_menu))
        {
            return;
        }
    my $filename = $my_THE_filename;
    $filename =~ s{index\.html$}{};
    $filename = "/$filename";

    $section_nav_menu = MySectNavData::get_nav_menu(
        'path_info' => $filename,
        'current_host' => "t2",
        'root' => "../..",
        );

return;
    }

    init_section_nav_menu();
    my $total_leading_path = $section_nav_menu->total_leading_path(
        {
            main_leading_path => $leading_path,
        }
    );

    my $render_leading_path_component = sub {
        my $component = shift;
        my $title = $component->title();
        my $title_attr = defined($title) ? " title=\"$title\"" : "";
        return "<a href=\"" . CGI::escapeHTML($component->direct_url()) .
            "\"$title_attr>" .
            $component->label() . "</a>";
    };

    print join(" &rarr; ",
        (map
        { $render_leading_path_component->($_) }
        @$total_leading_path
        ));
