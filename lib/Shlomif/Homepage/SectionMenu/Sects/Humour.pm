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
                            'url' => "humour/TheEnemy/The-Enemy-rev4.html",
                            'title' => "Text of &quot;The Enemy&quot; In Hebrew",
                        },
                        {
                            'text' => "Text in English",
                            'url' => "humour/TheEnemy/The-Enemy-English-rev4.html",
                            'title' => "Text of &quot;The Enemy&quot; In English",
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
                    'subs' =>
                    [
                        {
                            'text' => "Ongoing Text",
                            'url' => "humour/humanity/ongoing-text.html",
                            'title' => "Ongoing Text of the Screenplay",
                        },
                    ],
                },
                {
                    'text' => "Human Hacking Field Guide",
                    'url' => "humour/human-hacking/",
                    'title' => "Story about Teenage Computer Enthusiasts in 2005's Los Angeles",
                },
                {
                    'text' => "Star Trek: We the Living Dead",
                    'url' => "humour/Star-Trek/We-the-Living-Dead/",
                    'subs' =>
                    [
                        {
                            'text' => "Ongoing Text",
                            'url' => "humour/Star-Trek/We-the-Living-Dead/ongoing-text.html",
                            'title' => "Ongoing Text of the Screenplay",
                        },
                    ],
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
                    'text' => "Spam for Everyone",
                    'url' => "humour/bits/Spam-for-Everyone/",
                    'title' => "The Campaign for Accessible Spam",
                },
                {
                    'text' => "I Like Job Control",
                    'url' => "humour/bits/I-Like-Job-Control/",
                },

            ],
        },
        {
            'text' => "By Others",
            'url' => "humour/by-others/",
            'subs' =>
            [
                {
                    'text' => "GNU Visual Basic",
                    'url' => "humour/GNU-Visual-Basic/GNU-Visual-Basic.html",
                    'title' => "Richard Stallman Switches to Basic",
                },
                {
                    'text' => "Darien - Everybody's Free (to Ping Timeout)",
                    'url' => "humour/by-others/darien--everybody-is-free.html",
                    'title' => "The IRC Version of &quot;Everybody's Free to Wear Sunscreen&quot;",
                },
                {
                    'text' => "Technion Bit #1",
                    'url' => "humour/by-others/technion-bit-1.html",
                    'title' => "A bit I found at the Technion",
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

