package Shlomif::Homepage::SectionMenu::Sects::Humour;

use strict;
use warnings;

use utf8;

use MyNavData;

use Shlomif::Homepage::FortuneCollections;

my $humour_tree_contents =
{
    host => "t2",
    text => "Shlomi Fish’s Stories and Aphorisms",
    title => "Shlomi Fish’s Stories and Aphorisms",
    show_always => 1,
    subs =>
    [
        {
            text => "Humour",
            url => "humour/",
        },
        {
            text => "Stories",
            url => "humour/stories/",
            subs =>
            [
                {
                    text => "The Enemy",
                    url => "humour/TheEnemy/",
                    title => "The Enemy and How I Helped to Fight it",
                    subs =>
                    [
                        {
                            text => "Text in Hebrew",
                            url => "humour/TheEnemy/The-Enemy-Hebrew-v7.html",
                            title => "Text of “The Enemy” In Hebrew",
                        },
                        {
                            text => "Text in English",
                            url => "humour/TheEnemy/The-Enemy-English-v7.html",
                            title => "Text of “The Enemy” In English",
                        },
                    ],
                },
                {
                    text => "TOW The Fountainhead",
                    url => "humour/TOWTF/",
                    title => "A Parody on “The Fountainhead” by Ayn Rand",
                    subs =>
                    [
                        {
                            text => "Part 1",
                            url => "humour/TOWTF/TOW_Fountainhead_1.html",
                        },
                        {
                            text => "Part 2",
                            url => "humour/TOWTF/TOW_Fountainhead_2.html",
                        },
                    ],
                },
                {
                    text => "Humanity",
                    url => "humour/humanity/",
                    title => "A Parody about Humanity and Modern Life in Particular",
                    subs =>
                    [
                        {
                            text => "Ongoing Text",
                            url => "humour/humanity/ongoing-text.html",
                            title => "Ongoing Text of the Screenplay",
                        },
                        {
                            text => "Hebrew Translation",
                            url => "humour/humanity/ongoing-text-hebrew.html",
                            title => "Hebrew translation of the screenplay.",
                        },
                        {
                            text => "“Buy the Fish” Song in Hebrew",
                            url => "humour/humanity/buy-the-fish-in-hebrew.html",
                        },
                    ],
                },
                {
                    text => "Human Hacking Field Guide",
                    url => "humour/human-hacking/",
                    title => "Story about Teenage Computer Enthusiasts in 2005’s Los Angeles",
                    subs =>
                    [
                        {
                            text => "Conclusions and Reviews",
                            url => "humour/human-hacking/conclusions/",
                        },
                        {
                            text => "Arabic Translation",
                            url => "humour/human-hacking/arabic-v2.html",
                            title => "Translation to Literary Arabic by Vieq",
                        },
                        {
                            text => "Hebrew Translation",
                            url => "humour/human-hacking/hebrew-v2.html",
                        },
                    ],
                },
                {
                    text => "Star Trek: We the Living Dead",
                    url => "humour/Star-Trek/We-the-Living-Dead/",
                    subs =>
                    [
                        {
                            text => "Ongoing Text",
                            url => "humour/Star-Trek/We-the-Living-Dead/ongoing-text.html",
                            title => "Ongoing Text of the Screenplay",
                        },
                    ],
                },
                {
                    text => "Selina Mandrake - The Slayer (Buffy Parody)",
                    url => "humour/Selina-Mandrake/",
                    title => "Parody and Reflection of Buffy the Vampire Slayer along with other sources of inspiration.",
                    subs =>
                    [
                        {
                            text => "Ongoing Text",
                            url => "humour/Selina-Mandrake/ongoing-text.html",
                            title => "Ongoing Text of the Screenplay",
                        },
                        {
                            text => "Cast",
                            url => "humour/Selina-Mandrake/cast.html",
                            title => "Who I want to play each character?",
                        },
                    ],
                },
                {
                    text => "Summerschool at the NSA",
                    url => "humour/Summerschool-at-the-NSA/",
                    title => "Sarah Michelle Gellar and Summer Glau conspire to take the the NSA out of the equation",
                    subs =>
                    [
                        {
                            text => "Ongoing Text",
                            url => "humour/Summerschool-at-the-NSA/ongoing-text.html",
                            title => "Ongoing Text of the Screenplay",
                        },
                    ],
                },
                {
                    text => "The Pope Died on Sunday",
                    url => "humour/Pope/",
                    title => "An Insane Week in the Life of a Female American Graphics Artist",
                    subs =>
                    [
                        {
                            text => "Hebrew Text",
                            url => "humour/Pope/The-Pope-Died-on-Sunday--Hebrew-Text.html",
                        },
                        {
                            text => "English Text",
                            url => "humour/Pope/The-Pope-Died-on-Sunday--English-Text.html",
                        },
                    ],
                },
                {
                    text => "The Blue Rabbit’s Log",
                    url => "humour/Blue-Rabbit-Log/",
                    title => "Movies that Parody Role-Playing Games",
                    subs =>
                    [
                        {
                            text => "Part I",
                            url => "humour/Blue-Rabbit-Log/part-1.html",
                            title => "Ongoing Text of the First Part",
                        },
                        {
                            text => "Random Ideas",
                            url => "humour/Blue-Rabbit-Log/ideas.xhtml",
                            title => "Random ideas and future excerpts",
                        },
                    ],
                },
                {
                    text => "Road to Heaven",
                    url => "humour/RoadToHeaven/",
                    title => "The Road to Heaven is Paved with Bad Intentions",
                    subs =>
                    [
                        {
                            text => "Abstract in Hebrew",
                            url => "humour/RoadToHeaven/abstract.xhtml",
                        },
                    ],
                },
            ],
        },
        {
            text => "Aphorisms and Quotes",
            url => "humour/aphorisms/",
            subs =>
            [
                {
                    text => "My Aphorisms Collection",
                    url => "humour.html",
                    title => "Collection of my own Funny (or Insightful) Quotes and Aphorisms",
                    subs =>
                    [
                        {
                            text => "Hebrew Versions of the Aphorisms",
                            url => "humour-heb.html",
                            title => "The Aphorisms in Hebrew",
                        },
                    ],
                },
                {
                    text => "Fortune Cookies Collection",
                    url => "humour/fortunes/",
                    title => "Collection of Quotes by Me and Others in the UNIX Fortune Format",
                    subs => Shlomif::Homepage::FortuneCollections->nav_data(),
                },
                {
                    text => "Collections of Facts",
                    url => "humour/bits/facts/",
                    title => "Collections of funny factoids about various people and things",
                    subs =>
                    [
                        {
                            url => "humour/bits/facts/Chuck-Norris/",
                            text => "Chuck Norris",
                        },
                        {
                            url => "humour/bits/facts/In-Soviet-Russia/",
                            text => "In Soviet Russia…",
                            title => "Additions to “In Soviet Russia…” or Soviet reversal",
                        },
                        {
                            url => "humour/bits/facts/Buffy/",
                            text => "Buffy",
                            title => "Facts about Buffy Summers from the Television show, Buffy the Vampire Slayer",
                        },
                        {
                            url => "humour/bits/facts/Clarissa/",
                            text => "Clarissa",
                            title => "Facts about Clarissa Darling from the Television show, Clarissa Explains It All",
                        },
                        {
                            url => "humour/bits/facts/Knuth/",
                            text => "Knuth",
                        },
                        {
                            url => "humour/bits/facts/Larry-Wall/",
                            text => "Larry Wall",
                        },
                        {
                            url => "humour/bits/facts/NSA/",
                            text => "NSA",
                        },
                        {
                            url => "humour/bits/facts/Xena/",
                            text => "Xena",
                            title => "Factoids about Xena, the Warrior Princess",
                        },
                        {
                            url => "humour/bits/facts/XSLT/",
                            text => "XSLT",
                        },
                    ],
                },
           ],
        },
        {
            text => "Small Scale",
            url => "humour/bits/",
            title => "Small Scale Creations",
            subs =>
            [
                {
                    text => "Ways to Do it",
                    url => "humour/ways_to_do_it.html",
                    title => "Ways to Do it According to the Programming Languages of the World",
                    subs =>
                    [
                        {
                            text => "Hebrew Translation",
                            url => "humour/ways_to_do_it-heb.html",
                        },
                    ],
                },
                {
                    text => "IRPWUG Announces Project WYSIWYT",
                    url => "wysiwyt.html",
                    title => "A Project by the International Really Pissed-off Windows User Group",
                },
                {
                    text => "Wonderous are the Ways of Microsoft",
                    url => "wonderous.html",
                },
                {
                    text => "Spam for Everyone",
                    url => "humour/bits/Spam-for-Everyone/",
                    title => "The Campaign for Accessible Spam",
                },
                {
                    text => "I Like Job Control",
                    url => "humour/bits/I-Like-Job-Control/",
                },
                {
                    text => "The GPL is not Compatible with Itself",
                    url => "humour/bits/GPL-is-not-Compatible-with-Itself/",
                },
                {
                    text => "Introducing RMS-Lint",
                    url => "humour/bits/RMS-Lint/",
                },
                {
                    text => "Cracka’s Paradise",
                    url => "humour/bits/Crackas-Paradise/",
                },
                {
                    text => "Mastering cat",
                    url => "humour/bits/Mastering-Cat/",
                },
                {
                    text => "Programs Every Programmer Has Written",
                    url => "humour/bits/Programs-Every-Programmer-has-Written/",
                },
                {
                    text => "How many Wikipedia Editors does it take to Change a Lightbulb?",
                    url => "humour/bits/How-many-Wikipedia-Editors/",
                },
                {
                    text => "Announcing Freecell Solver™ Enterprise Edition",
                    url => "humour/bits/Freecell-Solver-Enterprise-Edition/",
                },
                {
                    text => "COBOL, the New Age Programming Language",
                    url => "humour/bits/COBOL-the-New-Age-Programming-Language/",
                },
                {
                    text => "Copying Ubuntu Bug No. 1",
                    url => "humour/bits/Copying-Ubuntu-Bug-No-1/",
                },
                {
                    text => "It’s not a Fooware - It’s an Operating System",
                    url => "humour/bits/It-s-not-a-Fooware-It-s-an-Operating-System/",
                    title => "Software Applications that Transcend Their Original Purpose",
                },
                {
                    text => "I’m The Real Tim Toady",
                    url => "humour/bits/Im-The-Real-Tim-Toady/",
                    title => "Incomplete Perl Geek Song",
                },
                {
                    text => "Can I SCO Now?",
                    url => "humour/bits/Can-I-SCO-Now/",
                    title => "Another Incomplete Geek Song",
                },
                {
                    text => "Freecell Solver™ Goes Webscale",
                    url => "humour/bits/Freecell-Solver-Goes-Webscale/",
                },
            ],
        },
        {
            text => "By Others",
            url => "humour/by-others/",
            subs =>
            [
                {
                    text => "English is a Crazy Language",
                    url => "humour/by-others/English-is-a-Crazy-Language.html",
                },
                {
                    text => "GNU Visual Basic",
                    url => "humour/GNU-Visual-Basic/GNU-Visual-Basic.html",
                    title => "Richard Stallman Switches to Basic",
                },
                {
                    text => "Darien - Everybody’s Free (to Ping Timeout)",
                    url => "humour/by-others/darien--everybody-is-free.html",
                    title => "The IRC Version of “Everybody’s Free to Wear Sunscreen”",
                },
                {
                    text => "Technion Bit #1",
                    url => "humour/by-others/technion-bit-1.html",
                    title => "A bit I found at the Technion",
                },
                {
                    text => "Hitchhiker’s Guide to Star Trek TNG",
                    url => "humour/by-others/hitchhiker-guide-to-star-trek-tng.html",
                    title => "A Cross of the Douglas Adams Book and the T.V. Series",
                    subs =>
                    [
                        {
                            text => "HTMLised Version",
                            url => "humour/by-others/hitchhiker-guide-to-star-trek-tng-htmlised.html",
                            title => "Nicely formatted version after converted to HTML",
                        },
                    ],
                },
                {
                    text => "How Many Usenet Readers does it Take to Change a Lightbulb?",
                    url => "humour/by-others/how-many-newsgroup-readers-does-it-take-to-change-a-lightbulb.html",
                },
                {
                    text => "Top 12 things likely to be overheard if you had a Klingon Programmer",
                    url => "humour/by-others/top-12-things-likely-to-be-overheard-if-you-had-a-klingon-programmer.html",
                },
                {
                    text => "SOAP - The S stands for Simple",
                    url => "humour/by-others/s-stands-for-simple/",
                },
                {
                    text => "Was the Death Star Attack an Inside Job?",
                    url => "humour/by-others/was-the-death-star-attack-an-inside-job/",
                    title => "A conspiracy theory set in the Star Wars World. Via “Debunking 911” via “Websurdity”",
                },
                {
                    text => "Graduate Student Humour",
                    url => "humour/by-others/grad-student-jokes-from-jnoakes/",
                },
                {
                    text => "The Fountainhead - Starring Skull Force",
                    url => "humour/by-others/the-fountainhead-starring-skull-force/",
                    title => "A short parody of Ayn Rand’s novel The Fountainhead",
                },
                {
                    text => "Division Two Magazine",
                    url => "humour/by-others/division-two/",
                    title => "A mirror of a hilarious parodical site that went offline",
                },
                {
                    text => "Oded C.’s Stories",
                    url => "humour/by-others/oded-c/",
                    title => "Humorous stories by Oded C. in Hebrew",
                },
            ],
        },
        {
            text => "Recommendations",
            url => "humour/recommendations/",
            subs =>
            [
                {
                    text => "Films",
                    url => "humour/recommendations/films/",
                    title => "Recommendations of Films",
                },
            ],
        },
    ],
};

sub get_params
{
    return
        (
            hosts => MyNavData::get_hosts(),
            tree_contents => $humour_tree_contents,
        );
}

1;

