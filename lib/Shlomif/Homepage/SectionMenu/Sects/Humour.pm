package Shlomif::Homepage::SectionMenu::Sects::Humour;

use strict;
use warnings;

use MyNavData;

my $humour_tree_contents =
{
    'host' => "t2",
    'text' => "Shlomi Fish' Stories and Euphorisms",
    'title' => "Shlomi Fish' Stories and Euphorisms",
    'show_always' => 1,
    'subs' =>
    [
        {
            'text' => "Stories and Euphorisms",
            'url' => "humour/",
        },
        {
            'text' => "Stories",
            'url' => "humour/stories/",
            'subs' =>
            [
                {
                    'text' => "The Enemy",
                    'url' => "humour/TheEnemy/",
                    'title' => "The Enemy and How I Helped to Fight it",
                    'subs' =>
                    [
                        {
                            'text' => "Road to Heaven",
                            'url' => "humour/RoadToHeaven/",
                            'title' => "The Road to Heaven is Paved with Bad Intentions",
                        },
                    ],
                },
                {
                    'text' => "TOW The Fountainhead",
                    'url' => "humour/TOWTF/",
                    'title' => "A Parody on &quot;The Fountainhead&quot;",
                },
                {
                    'text' => "The Pope Died on Sunday",
                    'url' => "humour/Pope/",
                    'title' => "An Insane Week in the Life of a Female American Graphics Artist",
                },
                {
                    'text' => "Humanity",
                    'url' => "humour/humanity/",
                    'title' => "A Parody about Humanity and Modern Life in Particular",
                },
                {
                    'text' => "Human Hacking Field Guide",
                    'url' => "humour/human-hacking/",
                    'title' => "Story about Teenage Computer Enthusiasts in 2005's Los Angeles",
                },
            ],
        },
        {
            'text' => "Euphorisms and Quotes",
            'url' => "humour/euphorisms/",
            'subs' =>
            [
                {
                    'text' => "Humour Archive",
                    'url' => "humour.html",
                    'title' => "Archive of my own Funny Quotes and Euphorisms",
                },
                {
                    'text' => "Fortune Cookies Collection",
                    'url' => "humour/fortunes/",
                    'host' => "vipe",
                    'title' => "Collection of Quotes by Me and Others in the UNIX Fortune Format",
                },
           ],
        },
        {
            'text' => "Small Scale",
            'url' => "humour/bits/",
            'title' => "Small Scale Creations",
            'subs' =>
            [
                {
                    'text' => "Ways to Do it",
                    'url' => "humour/ways_to_do_it.html",
                    'title' => "Ways to Do it According to the Programming Languages of the World",
                },
                {
                    'text' => "IRPWUG Announces Project WYSIWYT",
                    'url' => "wysiwyt.html",
                    'title' => "A Project by the International Really Pissed-off Windows User Group",
                },
            ],
        },
    ],
};

sub get_params
{
    return
        (
            'hosts' => MyNavData::get_hosts(),
            'tree_contents' => $humour_tree_contents,
        );
}

1;

