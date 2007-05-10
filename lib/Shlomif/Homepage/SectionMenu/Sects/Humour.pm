package Shlomif::Homepage::SectionMenu::Sects::Humour;

use strict;
use warnings;

use MyNavData;

my $humour_tree_contents =
{
    'host' => "t2",
    'text' => "Shlomi Fish' Stories and Aphorisms",
    'title' => "Shlomi Fish' Stories and Aphorisms",
    'show_always' => 1,
    'subs' =>
    [
        {
            'text' => "Stories and Aphorisms",
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
                            'text' => "Text in Hebrew",
                            'url' => "humour/TheEnemy/TheEnemy.html",
                            'title' => "Text of \"The Enemy\" In Hebrew",
                        },
                        {
                            'text' => "Text in English",
                            'url' => "humour/TheEnemy/The-Enemy-English-rev4.html",
                            'title' => "Text of \"The Enemy\" In English",
                        },
                    ],
                },
                {
                    'text' => "Road to Heaven",
                    'url' => "humour/RoadToHeaven/",
                    'title' => "The Road to Heaven is Paved with Bad Intentions",
                },
                {
                    'text' => "TOW The Fountainhead",
                    'url' => "humour/TOWTF/",
                    'title' => "A Parody on &quot;The Fountainhead&quot;",
                    'subs' =>
                    [
                        {
                            'text' => "Part 1",
                            url => "humour/TOWTF/TOW_Fountainhead_1.html",
                        },
                        {
                            'text' => "Part 2",
                            url => "humour/TOWTF/TOW_Fountainhead_2.html",
                        },
                    ],
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
                {
                    'text' => "Star Trek: We the Living Dead",
                    'url' => "humour/Star-Trek/We-the-Living-Dead/",
                },
            ],
        },
        {
            'text' => "Aphorisms and Quotes",
            'url' => "humour/aphorisms/",
            'subs' =>
            [
                {
                    'text' => "My Aphorisms Collection",
                    'url' => "humour.html",
                    'title' => "Collection of my own Funny (or Insightful) Quotes and Aphorisms",
                },
                {
                    'text' => "Fortune Cookies Collection",
                    'url' => "humour/fortunes/",
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
                {
                    'text' => "Wonderous are the Ways of Microsoft",
                    'url' => "wonderous.html",
                },
                {
                    'text' => "I Like Job Control",
                    'url' => "humour/bits/I-Like-Job-Control/",
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

