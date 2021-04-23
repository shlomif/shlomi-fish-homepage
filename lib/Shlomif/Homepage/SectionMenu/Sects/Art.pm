package Shlomif::Homepage::SectionMenu::Sects::Art;

use strict;
use warnings;
use utf8;
use Carp qw/ confess /;

use MyNavData::Hosts ();

my $art_tree_contents = {
    host        => "t2",
    text        => "Art",
    url         => "art/",
    title       => "Computer art I created while explaining how.",
    show_always => 1,
    subs        => [
        {
            text => "Original Graphics",
            url  => "art/original-graphics/",
            subs => [
                {
                    text  => "Back to my Homepage - 2nd Version",
                    url   => "art/back-to-my-homepage-2nd-ver/",
                    title =>
"New Version of the Back to my Homepage logo done using Inkscape",
                },
                {
                    skip  => 1,
                    text  => "Back to my Homepage",
                    url   => "art/bk2hp/",
                    title =>
"A Back to my Homepage logo not unlike the one from the movie “Back to the Future”",
                },
                {
                    text  => "Linux Banner",
                    url   => "art/linux_banner/",
                    title =>
"Linux - Because Software Problems should not Cost Money",
                },
                {
                    text  => "Made with Latemp",
                    url   => "art/made-with-latemp/",
                    title => "“Made with Latemp” Button",
                },
                {
                    text  => "HHFG Background",
                    url   => "art/hhfg-background/",
                    title =>
"Background Image for the “Human Hacking Field Guide” Story",
                },
                {
                    text  => "Better SCM Logo",
                    url   => "art/better-scm/",
                    title => "Logo for the “Better SCM” Site",
                },
                {
                    text => "D&amp;D Cartoon: Comparing Lances",
                    url  => "art/d-and-d-cartoon--comparing-lances/",
                },
                {
                    text  => "Slogans’ Designs",
                    url   => "art/slogans/",
                    title =>
"The design of my aphorism - useful for T-shirts and other merchandise",
                },
            ],
        },
        {
            text => "By others",
            url  => "art/by-others/",
            subs => [
                {
                    text  => "Yachar’s Music",
                    url   => "art/by-others/Yachar/",
                    title => "Fresh Neoclassical Music",
                },
                {
                    text  => "BertycoX’s Music",
                    url   => "art/by-others/BertycoX/",
                    title => "Electronic Music (Dance/etc.)",
                },
            ],
        },

        {
            text => "Recommendations",
            url  => "art/recommendations/",
            subs => [
                {
                    text => "Music",
                    url  => "art/recommendations/music/",
                    subs => [
                        {
                            text => "Online Artists",
                            url  => "art/recommendations/music/online-artists/",
                            title => "Some of my favourite online musicians",
                        },
                    ],
                },
            ],
        },

    ],
};

sub get_params
{
    my ( $self, $args ) = @_;

    my $lang = $args->{lang}
        or confess("lang was not specified.");
    return (
        hosts         => scalar( MyNavData::Hosts::get_hosts() ),
        tree_contents => $art_tree_contents,
    );
}

1;
