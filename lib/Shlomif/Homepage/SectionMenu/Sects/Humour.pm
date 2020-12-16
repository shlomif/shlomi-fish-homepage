package Shlomif::Homepage::SectionMenu::Sects::Humour;

use strict;
use warnings;

use Shlomif::FindLib ();
use utf8;

use MyNavData::Hosts ();

use Shlomif::Homepage::FortuneCollections ();
use JSON::MaybeXS                         (qw( decode_json ));
use Path::Tiny qw( path );

my $json_data_fn =
    Shlomif::FindLib->rel_path( [qw(Shlomif factoids-nav.json)] );

my $humour_tree_contents = {
    host        => "t2",
    text        => "Shlomi Fish’s Stories and Aphorisms",
    title       => "Shlomi Fish’s Stories and Aphorisms",
    show_always => 1,
    subs        => [
        {
            text => "Humour",
            url  => "humour/",
        },
        {
            text => "Stories",
            url  => "humour/stories/",
            subs => [
                {
                    text  => "The Enemy",
                    url   => "humour/TheEnemy/",
                    title => "The Enemy and How I Helped to Fight it",
                    subs  => [
                        {
                            text  => "Text in Hebrew",
                            url   => "humour/TheEnemy/The-Enemy-Hebrew-v7.html",
                            title => "Text of “The Enemy” In Hebrew",
                        },
                        {
                            text => "Text in English",
                            url  => "humour/TheEnemy/The-Enemy-English-v7.html",
                            title => "Text of “The Enemy” In English",
                        },
                    ],
                },
                {
                    text  => "TOW The Fountainhead",
                    url   => "humour/TOneW-the-Fountainhead/",
                    title => "A Parody on “The Fountainhead” by Ayn Rand",
                    subs  => [
                        {
                            text => "Part 1",
                            url  =>
"humour/TOneW-the-Fountainhead/TOW_Fountainhead_1.html",
                        },
                        {
                            text => "Part 2",
                            url  =>
"humour/TOneW-the-Fountainhead/TOW_Fountainhead_2.html",
                        },
                    ],
                },
                {
                    text  => "Humanity",
                    url   => "humour/humanity/",
                    title =>
                        "A Parody about Humanity and Modern Life in Particular",
                    subs => [
                        {
                            text  => "Ongoing Text",
                            url   => "humour/humanity/ongoing-text.html",
                            title => "Ongoing Text of the Screenplay",
                        },
                        {
                            text  => "Hebrew Translation",
                            url   => "humour/humanity/ongoing-text-hebrew.html",
                            title => "Hebrew translation of the screenplay.",
                        },
                        {
                            text  => "Recordings of Songs",
                            url   => "humour/humanity/songs/",
                            title => "Recordings of Songs from the Screenplay",
                        },
                    ],
                },
                {
                    text  => "Human Hacking Field Guide",
                    url   => "humour/human-hacking/",
                    title =>
"Story about Teenage Computer Enthusiasts in 2005’s Los Angeles",
                    subs => [
                        {
                            text  => "English Text",
                            url   => "humour/human-hacking/english-v2.html",
                            title => "Text of the English original",
                        },
                        {
                            text => "Conclusions and Reviews",
                            url  => "humour/human-hacking/conclusions/",
                        },
                        {
                            text  => "Arabic Translation",
                            url   => "humour/human-hacking/arabic-v2.html",
                            title => "Translation to Literary Arabic by Vieq",
                        },
                        {
                            text => "Hebrew Translation",
                            url  => "humour/human-hacking/hebrew-v2.html",
                        },
                    ],
                },
                {
                    text => "Star Trek: We the Living Dead",
                    url  => "humour/Star-Trek/We-the-Living-Dead/",
                    subs => [
                        {
                            text => "Ongoing Text",
                            url  =>
"humour/Star-Trek/We-the-Living-Dead/ongoing-text.html",
                            title => "Ongoing Text of the Screenplay",
                        },
                    ],
                },
                {
                    text  => "Selina Mandrake - The Slayer (Buffy Parody)",
                    url   => "humour/Selina-Mandrake/",
                    title =>
"Parody and Reflection of Buffy the Vampire Slayer along with other sources of inspiration.",
                    subs => [
                        {
                            text  => "Ongoing Text",
                            url   => "humour/Selina-Mandrake/ongoing-text.html",
                            title => "Ongoing Text of the Screenplay",
                        },
                        {
                            text  => "Cast",
                            url   => "humour/Selina-Mandrake/cast.html",
                            title => "Who I want to play each character",
                        },
                        {
                            text => "Image Macros (“Memes”)",
                            url  => "humour/Selina-Mandrake/image-macros/",
                        },
                    ],
                },
                {
                    text  => "Summerschool at the NSA",
                    url   => "humour/Summerschool-at-the-NSA/",
                    title =>
"Sarah Michelle Gellar and Summer Glau conspire to take the the NSA out of the equation",
                    subs => [
                        {
                            text => "Ongoing Text",
                            url  =>
"humour/Summerschool-at-the-NSA/ongoing-text.html",
                            title => "Ongoing Text of the Screenplay",
                        },
                        {
                            text => "Cast",
                            url  => "humour/Summerschool-at-the-NSA/cast.html",
                        },
                        {
                            text => "Conclusions and Reflection",
                            url  =>
"humour/Summerschool-at-the-NSA/conclusions-and-reflection.html",
                        },
                    ],
                },
                {
                    text  => "Buffy: a Few Good Slayers",
                    url   => "humour/Buffy/A-Few-Good-Slayers/",
                    title =>
"Everyone is happier and more powerful and empowered in a forked version of the Buffy universe, but a crisis emerges",
                    subs => [
                        {
                            text => "Ongoing Text",
                            url  =>
"humour/Buffy/A-Few-Good-Slayers/ongoing-text.html",
                            title => "Ongoing Text of the Screenplay",
                        },
                    ],
                },
                {
                    text  => "Muppets Fan Fiction",
                    url   => "humour/Muppets-Show-TNI/",
                    title => "The Muppets Show / Sesame Street Fan Fiction",
                    subs  => [
                        {
                            text => "Harry Potter",
                            url  => "humour/Muppets-Show-TNI/Harry-Potter.html",
                        },
                        {
                            text => "Summer Glau and Chuck Norris",
                            url  =>
"humour/Muppets-Show-TNI/Summer-Glau-and-Chuck-Norris.html",
                            title =>
"Summer Glau &amp; Chuck Norris as Grammar Nazis",
                        },
                        {
                            text => "Jennifer Lawrence",
                            url  =>
"humour/Muppets-Show-TNI/Jennifer-Lawrence.html",
                        },
                    ],
                },
                {
                    text  => "“So, who the hell is Qoheleth?”",
                    url   => "humour/So-Who-The-Hell-Is-Qoheleth/",
                    title =>
"Contemplating what happened to the author of the Scroll of Ecclesiastes shortly after he wrote it.",
                    subs => [
                        {
                            text => "Ongoing Text",
                            url  =>
"humour/So-Who-The-Hell-Is-Qoheleth/ongoing-text.html",
                            title => "Ongoing Text of the Screenplay",
                        },
                    ],
                },
                {
                    text =>
                        "Terminator: Liberation - A Self-Referential Parody",
                    url  => "humour/Terminator/Liberation/",
                    subs => [
                        {
                            text => "Ongoing Text",
                            url  =>
"humour/Terminator/Liberation/ongoing-text.html",
                            title => "Ongoing Text of the Screenplay",
                        },
                    ],
                },
                {
                    text  => "Queen Padmé Tales",
                    url   => "humour/Queen-Padme-Tales/",
                    title => "Pizza slice with all my favourite topings",
                    subs  => [
                        {
                            text => "Episodes",
                            url  => "humour/Queen-Padme-Tales/episodes/",
                            subs => [
                                {
                                    text =>
"Queen Amidala vs. the Klingon Warriors",
                                    url =>
"humour/Queen-Padme-Tales/Queen-Amidala-vs-the-Klingon-Warriors.html",
                                },
                            ],
                        },
                    ],
                },
                {
                    text  => "The Pope Died on Sunday",
                    url   => "humour/Pope/",
                    title =>
"An Insane Week in the Life of a Female American Graphics Artist",
                    subs => [
                        {
                            text => "English Text",
                            url  =>
"humour/Pope/The-Pope-Died-on-Sunday--English-Text.html",
                        },
                        {
                            text => "Hebrew Text",
                            url  =>
"humour/Pope/The-Pope-Died-on-Sunday--Hebrew-Text.html",
                        },
                    ],
                },
                {
                    text  => "The Blue Rabbit’s Log",
                    url   => "humour/Blue-Rabbit-Log/",
                    title => "Movies that Parody Role-Playing Games",
                    subs  => [
                        {
                            text  => "Part I",
                            url   => "humour/Blue-Rabbit-Log/part-1.html",
                            title => "Ongoing Text of the First Part",
                        },
                        {
                            text  => "Random Ideas",
                            url   => "humour/Blue-Rabbit-Log/ideas.xhtml",
                            title => "Random ideas and future excerpts",
                        },
                    ],
                },
                {
                    text  => "The Earth Angel",
                    url   => "humour/The-Earth-Angel/",
                    title => "TODO: FILL IN",
                    subs  => [
                        {
                            text => "Ongoing Text",
                            url  =>
"humour/The-Earth-Angel/The-Earth-Angel--English-Text.html",
                        },
                    ],
                },
                {
                    text  => "Road to Heaven",
                    url   => "humour/RoadToHeaven/",
                    title => "The Road to Heaven is Paved with Bad Intentions",
                    subs  => [
                        {
                            skip => 1,
                            text => "Abstract",
                            url  => "humour/RoadToHeaven/abstract.xhtml",
                        },
                    ],
                },
            ],
        },
        {
            text => "Aphorisms and Quotes",
            url  => "humour/aphorisms/",
            subs => [
                {
                    text  => "My Aphorisms Collection",
                    url   => "humour.html",
                    title =>
"Collection of my own Funny (or Insightful) Quotes and Aphorisms",
                    subs => [
                        {
                            text  => "Hebrew Versions of the Aphorisms",
                            url   => "humour-heb.html",
                            title => "The Aphorisms in Hebrew",
                        },
                    ],
                },
                {
                    text  => "Fortune Cookies Collection",
                    url   => "humour/fortunes/",
                    title =>
"Collection of Quotes by Me and Others in the UNIX Fortune Format",
                    subs =>
                        Shlomif::Homepage::FortuneCollections->new->nav_data,
                },
                {
                    text  => "Collections of Facts",
                    url   => "humour/bits/facts/",
                    title =>
"Collections of funny factoids about various people and things",
                    subs => decode_json( path($json_data_fn)->slurp_raw ),
                },
                {
                    text  => "Image Macros",
                    url   => "humour/image-macros/",
                    title => "Captioned Images (a.k.a “Memes”)",
                },
            ],
        },
        {
            text  => "Small Scale",
            url   => "humour/bits/",
            title => "Small Scale Creations",
            subs  => [
                {
                    text  => "Ways to Do it",
                    url   => "humour/ways_to_do_it.html",
                    title =>
"Ways to Do it According to the Programming Languages of the World",
                    subs => [
                        {
                            text => "Hebrew Translation",
                            url  => "humour/ways_to_do_it-heb.html",
                        },
                    ],
                },
                {
                    text  => "IRPWUG Announces Project WYSIWYT",
                    url   => "wysiwyt.html",
                    title =>
"A Project by the International Really Pissed-off Windows User Group",
                },
                {
                    text => "Wonderous are the Ways of Microsoft",
                    url  => "wonderous.html",
                },
                {
                    text  => "Spam for Everyone",
                    url   => "humour/bits/Spam-for-Everyone/",
                    title => "The Campaign for Accessible Spam",
                },
                {
                    text => "I Like Job Control",
                    url  => "humour/bits/I-Like-Job-Control/",
                },
                {
                    text => "The GPL is not Compatible with Itself",
                    url  => "humour/bits/GPL-is-not-Compatible-with-Itself/",
                },
                {
                    text => "Introducing RMS-Lint",
                    url  => "humour/bits/RMS-Lint/",
                },
                {
                    text => "Cracka’s Paradise",
                    url  => "humour/bits/Crackas-Paradise/",
                },
                {
                    text => "Mastering cat",
                    url  => "humour/bits/Mastering-Cat/",
                },
                {
                    text => "Programs Every Programmer Has Written",
                    url => "humour/bits/Programs-Every-Programmer-has-Written/",
                },
                {
                    text =>
"How many Wikipedia Editors does it take to Change a Lightbulb?",
                    url => "humour/bits/How-many-Wikipedia-Editors/",
                },
                {
                    text => "Announcing Freecell Solver™ Enterprise Edition",
                    url  => "humour/bits/Freecell-Solver-Enterprise-Edition/",
                },
                {
                    text => "COBOL, the New Age Programming Language",
                    url  =>
                        "humour/bits/COBOL-the-New-Age-Programming-Language/",
                },
                {
                    text => "Copying Ubuntu Bug No. 1",
                    url  => "humour/bits/Copying-Ubuntu-Bug-No-1/",
                },
                {
                    text => "It’s not a Fooware - It’s an Operating System",
                    url  =>
"humour/bits/It-s-not-a-Fooware-It-s-an-Operating-System/",
                    title =>
"Software Applications that Transcend Their Original Purpose",
                },
                {
                    text  => "I’m The Real Tim Toady",
                    url   => "humour/bits/Im-The-Real-Tim-Toady/",
                    title => "Incomplete Perl Geek Song",
                },
                {
                    text  => "Can I SCO Now?",
                    url   => "humour/bits/Can-I-SCO-Now/",
                    title => "Another Incomplete Geek Song",
                },
                {
                    text => "Freecell Solver™ Goes Webscale",
                    url  => "humour/bits/Freecell-Solver-Goes-Webscale/",
                },
                {
                    text =>
                        "Freecell Solver Enterprises™ Acquires Google Inc.",
                    url =>
"humour/bits/Freecell-Solver-Enterprises-Acquires-Google-Inc/",
                },
                {
                    text => "New Israeli Tech Usergroups",
                    url  => "humour/bits/New-Israeli-Tech-Usergroups/",
                },
                {
                    text => "GNU Will Integrate Guile into Coreutils",
                    url  =>
"humour/bits/GNU-Project-Will-Integrate-Guile-into-coreutils/",
                },
                {
                    text  => "The FSF Announces New Versions of the GPL",
                    url   => "humour/bits/New-versions-of-the-GPL/",
                    title =>
"The Free Software Foundation (FSF) Announces New Versions of the GNU General Public License (GPL)",
                },
                {
                    text => "Google Discontinues Services",
                    url  => "humour/bits/Google-Discontinues-Services/",
                },
                {
                    text => "Emma Watson Getting Interviewed for a Tech Job",
                    url  =>
"humour/bits/Emma-Watson-applying-for-a-software-dev-job/",
                    title =>
"Emma Watson Getting Interviewed for a Software Developer Job",
                },
                {
                    text => "“HTML 6”, the new version of the Web",
                    url  => "humour/bits/HTML-6/",
                },
                {
                    text => "The Song “Wide Awake” by Katy Perry is Evil!",
                    url  => "humour/bits/The-Song-Wide-Awake-is-Evil/",
                },
                {
                    text => "The Atom text editor edits a 2,000,001 bytes file",
                    url  =>
                        "humour/bits/Atom-Text-Editor-edits-2_000_001-bytes/",
                },
                {
                    text => "Announcing Python 4",
                    url  => "humour/bits/Python4-Announcement/",
                },
                {
                    text  => "Who gets the final say?",
                    url   => "humour/bits/who-gets-the-final-say/",
                    title =>
"True story about asking people by the road about relationships",
                },
                {
                    text => "Emma Watson’s Visit to Israel and Gaza",
                    url  => "humour/bits/Emma-Watson-Visit-to-Israel-and-Gaza/",
                    title =>
"Emma Watson visiting the Gaza envelope and the Gaza strip",
                },
            ],
        },
        {
            text => "By Others",
            url  => "humour/by-others/",
            subs => [
                {
                    text => "English is a Crazy Language",
                    url  => "humour/by-others/English-is-a-Crazy-Language.html",
                },
                {
                    text  => "GNU Visual Basic",
                    url   => "humour/GNU-Visual-Basic/GNU-Visual-Basic.html",
                    title => "Richard Stallman Switches to Basic",
                },
                {
                    text  => "Darien - Everybody’s Free (to Ping Timeout)",
                    url   => "humour/by-others/darien--everybody-is-free.html",
                    title =>
"The IRC Version of “Everybody’s Free to Wear Sunscreen”",
                },
                {
                    text  => "Technion Bit #1",
                    url   => "humour/by-others/technion-bit-1.html",
                    title => "A bit I found at the Technion",
                },
                {
                    text => "Hitchhiker’s Guide to Star Trek TNG",
                    url  =>
"humour/by-others/hitchhiker-guide-to-star-trek-tng.html",
                    title =>
"A Cross of the Douglas Adams’ book and the T.V. series",
                    subs => [
                        {
                            text => "HTMLised Version",
                            url  =>
"humour/by-others/hitchhiker-guide-to-star-trek-tng-htmlised.html",
                            title =>
"Nicely formatted version after converted to HTML",
                        },
                    ],
                },
                {
                    text =>
"How Many Usenet Readers does it Take to Change a Lightbulb?",
                    url =>
"humour/by-others/how-many-newsgroup-readers-does-it-take-to-change-a-lightbulb.html",
                },
                {
                    text =>
"Top 12 things likely to be overheard if you had a Klingon Programmer",
                    url =>
"humour/by-others/top-12-things-likely-to-be-overheard-if-you-had-a-klingon-programmer.html",
                },
                {
                    text => "SOAP - The S stands for Simple",
                    url  => "humour/by-others/s-stands-for-simple/",
                },
                {
                    text => "Was the Death Star Attack an Inside Job?",
                    url  =>
"humour/by-others/was-the-death-star-attack-an-inside-job/",
                    title =>
"A conspiracy theory set in the Star Wars World. Via “Debunking 911” via “Websurdity”",
                },
                {
                    text => "Graduate Student Humour",
                    url  => "humour/by-others/grad-student-jokes-from-jnoakes/",
                },
                {
                    text => "The Fountainhead - Starring Skull Force",
                    url  =>
"humour/by-others/the-fountainhead-starring-skull-force/",
                    title =>
                        "A short parody of Ayn Rand’s novel The Fountainhead",
                },
                {
                    text  => "Division Two Magazine",
                    url   => "humour/by-others/division-two/",
                    title =>
"A mirror of a hilarious parodical site that went offline",
                },
                {
                    text  => "Oded C.’s Stories",
                    url   => "humour/by-others/oded-c/",
                    title => "Humorous stories by Oded C. in Hebrew",
                },
                {
                    text  => "Mirror of funroll-loops.info",
                    url   => "humour/by-others/funroll-loops/",
                    title =>
"A mirror of the site funroll-loops.info - “Gentoo is Rice”",
                },
                {
                    text => "How to Make Square Corners with CSS",
                    url  =>
                        "humour/by-others/how-to-make-square-corners-with-CSS/",
                },
                {
                    text =>
"What if People Bought Cars Like they Bought Computers?",
                    url =>
"humour/by-others/if-people-bought-cars-like-computers/",
                },
                {
                    text => "What if drivers were hired like programmers",
                    url  =>
"humour/by-others/what-if-drivers-were-hired-like-programmers/",
                },
                {
                    text => "The Toaster vs Computer Science",
                    url  => "humour/by-others/the-toaster-vs-CS/",
                },
                {
                    text => "The 12 Days of Christmas Letters",
                    url  => "humour/by-others/12-Days-of-Christmas-Letters/",
                },
            ],
        },
        {
            text => "Recommendations",
            url  => "humour/recommendations/",
            subs => [
                {
                    text  => "Films",
                    url   => "humour/recommendations/films/",
                    title => "Recommendations of Films",
                },
            ],
        },
    ],
};

sub get_params
{
    return (
        hosts         => scalar( MyNavData::Hosts::get_hosts() ),
        tree_contents => $humour_tree_contents,
    );
}

1;
