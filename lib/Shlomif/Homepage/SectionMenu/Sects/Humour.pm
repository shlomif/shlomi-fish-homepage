package Shlomif::Homepage::SectionMenu::Sects::Humour;

use strict;
use warnings;

use MyNavData;

my $humour_tree_contents =
{
    'host' => "t2",
    'text' => "Shlomi Fish's Stories and Aphorisms",
    'title' => "Shlomi Fish's Stories and Aphorisms",
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
                            'url' => "humour/TheEnemy/The-Enemy-rev5.html",
                            'title' => "Text of &quot;The Enemy&quot; In Hebrew",
                        },
                        {
                            'text' => "Text in English",
                            'url' => "humour/TheEnemy/The-Enemy-English-rev5.html",
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
                    'subs' =>
                    [
                        {
                            'text' => "Hebrew Text",
                            'url' => "humour/Pope/The-Pope-Died-on-Sunday--Hebrew-Text.html",
                        },
                    ],
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
                    'subs' =>
                    [
                        {
                            'text' => "Conclusions and Reviews",
                            'url' => "humour/human-hacking/conclusions/",
                        },
                    ],
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
                {
                    'text' => "The Blue Rabbit's Log",
                    'url' => "humour/Blue-Rabbit-Log/",
                    'title' => "Movies that Parody Role-Playing Games",
                    'subs' =>
                    [
                        {
                            'text' => "Part I",
                            'url' => "humour/Blue-Rabbit-Log/part-1.html",
                            'title' => "Ongoing Text of the First Part",
                        },
                        {
                            'text' => "Random Ideas",
                            'url' => "humour/Blue-Rabbit-Log/ideas.xhtml",
                            'title' => "Random ideas and future excerpts",
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
                    'subs' =>
                    [
                        {
                            'text' => "friends",
                            'url' => "humour/fortunes/friends.html",
                            'title' => "Excerpts from the T.V. Show &quot;Friends^quot;",
                        },
                        {
                            'text' => "joel-on-software",
                            'url' => "humour/fortunes/joel-on-software.html",
                            'title' => "Quotes from &quot;Joel on Software&quot;",
                        },
                        {
                            'text' => "nyh-sigs",
                            'url' => "humour/fortunes/nyh-sigs.html",
                            'title' => "Nadav Har'El's Signatures",
                        },
                        {
                            'text' => "osp_rules",
                            'url' => "humour/fortunes/osp_rules.html",
                            'title' => "Rules of Open Source Programming",
                        },
                        {
                            'text' => "paul-graham",
                            'url' => "humour/fortunes/paul-graham.html",
                            'title' => "Paul Graham Quotes",
                        },
                        {
                            'text' => "shlomif",
                            'url' => "humour/fortunes/shlomif.html",
                            'title' => "Quotes with my Participation",
                        },
                        {
                            'text' => "shlomif-fav",
                            'url' => "humour/fortunes/shlomif-fav.html",
                            'title' => "Other Favourite Quotes",
                        },
                        {
                            'text' => "subversion",
                            'url' => "humour/fortunes/subversion.html",
                            'title' => "Quotes from the Online Folklore of the Subversion Version Control System",
                        },
                        {
                            'text' => "tinic",
                            'url' => "humour/fortunes/tinic.html",
                            'title' => "Quotes from the online Linux-IL Folklore",
                        },
                        {
                            'text' => "#perl",
                            'url' => "humour/fortunes/sharp-perl.html",
                            'title' => "Quotes from the Freenode #perl channel",
                        },
                        {
                            'text' => "##programming",
                            'url' => "humour/fortunes/sharp-programming.html",
                            'title' => "Quotes from the Freenode ##programming channel",
                        },
                        {
                            'text' => "shlomif-factoids",
                            'url' => "humour/fortunes/shlomif-factoids.html",
                            'title' => "Funny Factoids about People and Things (Chuck Norris, etc.)",
                        },
                    ],
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
                {
                    'text' => "The GPL is not Compatible with Itself",
                    'url' => "humour/bits/GPL-is-not-Compatible-with-Itself/",
                },
                {
                    'text' => "Introducing RMS-Lint",
                    'url' => "humour/bits/RMS-Lint/",
                },
                {
                    'text' => "Cracka's Paradise",
                    'url' => "humour/bits/Crackas-Paradise/",
                },
                {
                    'text' => "Mastering cat",
                    'url' => "humour/bits/Mastering-Cat/",
                },
                {
                    'text' => "Programs Every Programmer Has Written",
                    'url' => "humour/bits/Programs-Every-Programmer-has-Written/",
                },
                {
                    'text' => "How many Wikipedia Editors does it take to Change a Lightbulb?",
                    'url' => "humour/bits/How-many-Wikipedia-Editors/",
                },
                {
                    'text' => "Collections of Facts",
                    'url' => "humour/bits/facts/",
                    'title' => "Collection of funny facts about various people an things",
                    'subs' =>
                    [
                        {
                            'url' => "humour/bits/facts/Chuck-Norris/",
                            'text' => "Chuck Norris",
                        },
                        {
                            'url' => "humour/bits/facts/Knuth/",
                            'text' => "Knuth",
                        },
                        {
                            'url' => "humour/bits/facts/Larry-Wall/",
                            'text' => "Larry Wall",
                        },
                        {
                            'url' => "humour/bits/facts/Xena/",
                            'text' => "Xena",
                            'title' => "Factoids about Xena, the Warrior Princess",
                        },
                        {
                            'url' => "humour/bits/facts/XSLT/",
                            'text' => "XSLT",
                        },
                    ],
                }
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
                {
                    'text' => "Hitchhiker's Guide to Star Trek TNG",
                    'url' => "humour/by-others/hitchhiker-guide-to-star-trek-tng.html",
                    'title' => "A Cross of the Douglas Adams Book and the T.V. Series",
                },
                {
                    'text' => "How Many Usenet Readers does it Take to Change a Lightbulb?",
                    'url' => "humour/by-others/how-many-newsgroup-readers-does-it-take-to-change-a-lightbulb.html",
                },
            ],
        },
        {
            'text' => "Recommendations",
            'url' => "humour/recommendations/",
            'subs' =>
            [
                {
                    'text' => "Films",
                    'url' => "humour/recommendations/films/",
                    'title' => "Recommendations of Films",
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

