package MyNavData;

use autodie;
use strict;
use warnings;
use utf8;

use Carp ();

use Shlomif::Homepage::SectionMenu           ();
use Shlomif::Homepage::SectionMenu::IsHumour (qw/ get_is_humour_re /);
use MyNavData::Hosts                         ();

my @personal_expand = ( expand => { bool => 1, capt => 0, }, );
my @humour_expand   = ( re     => qr#\A@{[ get_is_humour_re()]}#, );
my @humour_aphorisms_expand =
    ( re =>
        qr{^(?:humour/(?:aphorisms/|fortunes/|bits/facts/)|(?:humour\.html$))}
    );

my %reduced_sub_trees = (
    'Shlomif::Homepage::SectionMenu::Sects::Art' => {
        text   => "Art",
        url    => "art/",
        expand => { re => "^art/", },
        title  => "Computer art I created while explaining how.",
        subs   => [
            {
                text => "Original Graphics",
                url  => "art/original-graphics/",
            },
            {
                text => "By others",
                url  => "art/by-others/",
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
                                url  =>
                                    "art/recommendations/music/online-artists/",
                                title =>
                                    "Some of my favourite online musicians",
                            },
                        ],
                    },
                ],
            },
        ],
    },
    'Shlomif::Homepage::SectionMenu::Sects::Humour' => {
        text   => "Humour",
        url    => "humour/",
        expand => {@humour_expand},
        title  => "My Humorous Creations",
        subs   => [
            {
                text   => "Stories",
                url    => "humour/stories/",
                title  => "Large-Scale Stories I Wrote",
                expand => { @humour_expand, capt => 0, },
                subs   => [
                    {
                        text  => "The Enemy",
                        url   => "humour/TheEnemy/",
                        title => "The Enemy and How I Helped to Fight It",
                    },
                    {
                        text  => "TOW The Fountainhead",
                        url   => "humour/TOneW-the-Fountainhead/",
                        title => "The One with the Fountainhead",
                    },
                    {
                        text  => "Human Hacking Field Guide",
                        url   => "humour/human-hacking/",
                        title => "The Human Hacking Field Guide",
                    },
                    {
                        text => "We, the Living Dead",
                        url  => "humour/Star-Trek/We-the-Living-Dead/",
                    },
                    {
                        text  => "Humanity - The Movie",
                        url   => "humour/humanity/",
                        title =>
                            "Parody of Humanity and Modern Life in Particular",
                    },
                ],
            },
            {
                text   => "Aphorisms and Quotes",
                url    => "humour/aphorisms/",
                expand => { @humour_aphorisms_expand, capt => 0, },
                subs   => [
                    {
                        text  => "My Quotes Collection",
                        title => (
                                  "Collection of Funny or Insightful "
                                . "Quotes or Aphorisms I came up with"
                        ),
                        url => "humour.html",
                    },
                    {
                        text  => "Fortune Cookies Collection",
                        title =>
"Collection of Files for Input to the UNIX ‘fortune’ Program",
                        url => "humour/fortunes/",
                    },
                    {
                        text  => "Factoids",
                        title =>
                            "“Facts” about Chuck Norris and other things",
                        url    => "humour/bits/facts/",
                        expand => { re => "^humour/bits/facts/", },
                    },
                ],
            },
            {
                text   => "Small Scale",
                url    => "humour/bits/",
                expand => { re => "^humour/bits/(?!facts/)", },
                title  => "Small Scale Funny Works of Mine",
            },
            {
                text   => "By Others",
                url    => "humour/by-others/",
                expand => { re => "^humour/(?:by-others|GNU-Visual-Basic)/", },
                title  => "Humorous Works by Other People",
            },
        ],
    },
    'Shlomif::Homepage::SectionMenu::Sects::Puzzles' => {
        text   => "Puzzles",
        url    => "puzzles/",
        expand => { re => q{^(?:MathVentures/|puzzles/|(?:toggle\.html$))}, },
        title  => "Puzzles, Riddles and Brain-teasers",
        subs   => [
            {
                text   => "Math-Ventures",
                url    => "MathVentures/",
                expand => { re => "^MathVentures/", },
                title  => "Mathematical Riddles and their Solutions",
            },
            {
                text   => "Logic Puzzles",
                url    => "puzzles/logic/",
                expand => { re => "^puzzles/logic/", },
            },
        ],
    },

    'Shlomif::Homepage::SectionMenu::Sects::Software' => {
        text   => "Software",
        url    => "open-source/",
        expand => { re => "^(?:no-ie/|open-source/|rindolf/)", },
        title  => "Pages related to Software (mostly Open-Source)",
        subs   => [
            {
                text   => "Projects",
                url    => "open-source/projects/",
                expand => {
                    re => "^(?:open-source/projects|jmikmod|rwlock|grad-fu)/",
                },
                subs => [
                    {
                        text => "Freecell Solver",
                        url  => "open-source/projects/freecell-solver/",
                    },
                    {
                        text  => "PySol FC",
                        url   => "open-source/projects/pysol/",
                        title => "A suite of Solitaire games",
                    },
                ],
            },
            {
                text   => "Resources Pages",
                title  => "Various Software Resources Pages",
                url    => "open-source/resources/",
                expand => {
                    re =>
"^open-source/(?:resources/|favourite/|interviews/|portability-libs/)",
                },
                subs => [
                    {
                        text  => "Favourite OSS",
                        title => "Favourite Open-Source Software",
                        url   => "open-source/favourite/",
                    },
                    {
                        text  => "Interviews",
                        title => "Interviews with Open-Source People",
                        url   => "open-source/interviews/",
                    },
                    {
                        text  => "Portability Libraries",
                        title => "Cross-Platform Abstraction Libraries",
                        url   => "open-source/portability-libs/",
                    },
                    {
                        text  => "Text Editors and IDEs",
                        title =>
"List of Text Editors and Integrated Development Environments (IDEs)",
                        url => "open-source/resources/editors-and-IDEs/",
                    },
                    {
                        text  => "Software Management Tools",
                        title => "Software Constructions and Management Tools",
                        url   => "open-source/resources/software-tools/",
                    },
                    {
                        text  => "Israel-Related",
                        title => "Israel-Related FOSS Resources",
                        url   => "open-source/resources/israel/",
                    },
                ],
            },
            {
                text  => "Contributions",
                title =>
                    "Contributions to Other Projects, that I did not Start",
                url => "open-source/contributions/",
            },
        ],
    },
    'Shlomif::Homepage::SectionMenu::Sects::Lectures' => {
        text   => "Lectures",
        url    => "lecture/",
        expand => { re => "^lecture/", },
        title  => "Presentations I Wrote (Mostly Technical)",
        subs   => [
            {
                text => "Perl for Newbies",
                url  => "lecture/Perl/Newbies/",
            },
            {
                text  => "Web Publishing using LAMP",
                url   => "lecture/LAMP/",
                host  => "t2",
                title =>
"Web Publishing using Linux, Apache, MySQL, and Perl/PHP/Python (or equivalents)",
            },
            {
                text => "The Cathedral and the Bazaar",
                url  => "lecture/CatB/",
            },
            {
                text  => "Prog. Languages",
                url   => "lecture/cat/programming-languages/",
                title => "Presentations about Programming Languages",
            },
            {
                text  => "Various Tools",
                url   => "lecture/cat/various-tools/",
                title => "Presentations about Various Tools",
            },
            {
                text  => "Welcome to Linux",
                url   => "lecture/W2L/",
                title =>
                    "Presentations for the Israeli series for Linux Newcomers",
            },
            {
                text  => "About My Projects",
                url   => "lecture/cat/projects/",
                title => "Presentations about my Open Source Projects",
            },
            {
                text  => "Lightning Talks",
                url   => "lecture/cat/lightning-talks/",
                title => "Short (5-15 minutes) Presentations",
            },
        ],
    },

    'Shlomif::Homepage::SectionMenu::Sects::Essays' => {
        text   => "Essays",
        url    => "philosophy/",
        expand => { re => "^(?:philosophy|prog-evolution|DeCSS)/", },
        title  =>
"Various Essays and Articles about Technology and Philosophy in General",
        subs => [
            {
                text   => "General Philosophy",
                url    => "philosophy/philosophy/",
                expand => {
                    re => "^philosophy/(?:philosophy/|the-eternal-jew/)"
                },
            },
            {
                text   => "Computing",
                url    => "philosophy/computers/",
                title  => "Computing-related Essays and Articles",
                expand =>
                    { re => "^(?:philosophy/computers|prog-evolution)/", },
                subs => [
                    {
                        text  => "Open Source",
                        url   => "philosophy/computers/open-source/",
                        title =>
                            "Essays about Free and Open Source Software (FOSS)",
                    },
                    {
                        text  => "Software Management",
                        url   => "philosophy/computers/software-management/",
                        title =>
"Essays about how to manage software workplaces, projects and teams",
                    },
                    {
                        text  => "Perl",
                        url   => "philosophy/computers/perl/",
                        title => "Essays about the Perl programming language",
                    },
                    {
                        text  => "The Web (WWW)",
                        url   => "philosophy/computers/web/",
                        title => "About the World-Wide-Web",
                    },
                    {
                        text  => "Education",
                        url   => "philosophy/computers/education/",
                        title => "About Computer and Technical Education",
                    },
                ],
            },
            {
                text  => "Political Essays",
                url   => "philosophy/politics/",
                title => "Essays about Politics and "
                    . "Philosophical Politics",
                expand => { re => "^philosophy/politics/", },
            },
            {
                text  => "Index to Essays",
                url   => "philosophy/Index/",
                title => "Index to Essays and Articles I wrote.",
            },
        ],
    },
    'Shlomif::Homepage::SectionMenu::Sects::Meta' => {
        expand      => { re => "^meta/", },
        url         => "meta/",
        text        => "Meta Info",
        title       => "Information about this Site",
        show_always => 1,
        subs        => [
            {
                url   => "meta/FAQ/",
                text  => "FAQ",
                title => "Frequently Asked Questions and Answers List (FAQ)",
            },
            {
                url  => "meta/privacy-policy/",
                text => "Privacy Policy",
            },
            {
                url   => "meta/site-source/",
                text  => "Site’s Source",
                title => "The source code used to generate this site",
            },
            {
                url   => "meta/how-to-help/",
                text  => "How to Help",
                title => "How you can help promote this site",
                subs  => [
                    {
                        url  => "meta/donate/",
                        text => "Please Donate",
                    },
                ],
            },
            {
                url   => "meta/hosting/",
                text  => "Hosting",
                title => "About this site’s hosting provider.",
            },
            {
                text  => "Old Site Snapshots (Nostalgia)",
                url   => "meta/old-site-snapshots/",
                title => "The site as it looked like many years ago.",
            },
        ],
    },
);

sub generic_get_params
{
    my ( undef, $args ) = @_;

    my $is_fully_expanded = (
        exists( $args->{fully_expanded} )
        ? $args->{fully_expanded}
        : 1
    );

    if ($is_fully_expanded)
    {
        require Shlomif::Homepage::SectionMenu::AllSects;
    }

    my $get_sub_tree = sub {
        my ($sect_name) = @_;

        if ($is_fully_expanded)
        {
            my $sect_to_ret =
                Shlomif::Homepage::SectionMenu->get_modified_sub_tree(
                $sect_name, { lang => $lang, },
                );
            if ( !defined($sect_to_ret) )
            {
                $DB::single = 1;
                Carp::confess("No section '$sect_name' to return.");
            }
            return $sect_to_ret;
        }
        else
        {
            my $sect_to_ret = $reduced_sub_trees{$sect_name};

            if ( !defined($sect_to_ret) )
            {
                Carp::confess("No section '$sect_name' to return.");
            }
            return $sect_to_ret;
        }
    };

    my $tree_contents = {
        host  => "t2",
        text  => "Shlomi Fish",
        title => "Shlomi Fish’s Homepage",
        subs  => [
            {
                text => "Shlomi Fish’s Homepage",
                url  => "",
            },
            {
                text => "About Myself",
                url  => "me/",
                @personal_expand,
                subs => [
                    {
                        text   => "Bio",
                        url    => "personal.html",
                        title  => "A Short Biography of Myself",
                        expand => { re => "^(?:me/|personal/)", },
                        subs   => [
                            {
                                text  => "Intros",
                                url   => "me/intros/",
                                title =>
                                    "Introductions of Me to Various Forums",
                                subs => [
                                    {
                                        text  => "MIT Writers",
                                        url   => "me/intros/writers/",
                                        title =>
"My Intro to the MIT Writers Mailing List",
                                    },
                                ],
                            },
                        ],
                    },
                    {
                        text  => "Contact Me",
                        url   => "me/contact-me/",
                        title => "How to Contact Me",
                    },
                    {
                        text => "My Résumés",
                        url  => "me/resumes/",
                        subs => [
                            {
                                text => "Résumé as a Software Dev",
                                url  =>
"me/resumes/Shlomi-Fish-Resume-as-Software-Dev.html",
                            },
                            {
                                text => "English Résumé",
                                url  => "SFresume.html",
                                skip => 1,
                            },
                            {
                                text => "Detailed English Résumé",
                                url  => "SFresume_detailed.html",
                                skip => 1,
                            },
                            {
                                text => "Résumé as a Writer and Entertainer",
                                url  =>
"me/resumes/Shlomi-Fish-Resume-as-Writer-Entertainer.html",
                            },
                        ],
                    },
                    {
                        text  => "Personal Ad",
                        url   => "me/personal-ad.html",
                        title =>
"My Personal Ad: what I’m looking for in a prospective girlfriend and what I can add to the relationship.",
                    },
                    {
                        text  => "My Weblogs",
                        url   => "me/blogs/",
                        title => "Links to my online journals.",
                    },
                    {
                        text  => "Interviews",
                        url   => "me/interviews/",
                        title => "Interviews that were conducted with me",
                        subs  => [
                            {
                                text => "Reddit “Ask Me Anything”",
                                url  => "me/interviews/reddit-AMA/",
                                skip => 1,
                            },
                        ],
                    },
                    {
                        text  => "“Rindolf” - my nickname",
                        url   => "me/rindolf/",
                        title =>
"The history and etymology of “Rindolf”, Shlomi Fish’s Nickname",
                        subs => [
                            {
                                text =>
"“Rindolfism” - my personal, dynamic, philosophy",
                                url   => "me/rindolfism/",
                                title =>
"Shlomi Fish’s Personal, dynamic, open / free / geeky / share / hacky philosophy",
                            },
                        ],
                    },
                    {
                        text => "Relicensing my Creative Works Portfolio",
                        url  =>
                            "me/relicensing-my-entire-portfolio-under-cc-by/",
                        title =>
"Offer to relicense my whole body of creative works under CC-by if I get enough money",
                    },
                ],
            },
            $get_sub_tree->('Shlomif::Homepage::SectionMenu::Sects::Humour'),
            $get_sub_tree->('Shlomif::Homepage::SectionMenu::Sects::Essays'),
            $get_sub_tree->('Shlomif::Homepage::SectionMenu::Sects::Puzzles'),
            $get_sub_tree->('Shlomif::Homepage::SectionMenu::Sects::Art'),
            $get_sub_tree->('Shlomif::Homepage::SectionMenu::Sects::Software'),
            $get_sub_tree->('Shlomif::Homepage::SectionMenu::Sects::Lectures'),
            {
                text   => "Work",
                url    => "work/",
                expand => { re => "", capt => 0, },
                title  => "Work-Related Pages",
                subs   => [
                    {
                        text   => "Hire Me!",
                        url    => "work/hire-me/",
                        title  => "I’m a Geek for Hire",
                        expand => { re => "\\Awork/", },
                        subs   => [
                            {
                                text  => "Private Lessons",
                                url   => "work/private-lessons/",
                                title =>
"I’m Giving Private Lessons for High School Subjects and Computing.",
                            },
                        ],
                    },
                ],
            },
            {
                separator => 1,
                skip      => 1,
            },
            {
                text  => "Cool Links",
                url   => "links.html",
                title =>
                    "An incomplete list of links I find cool and/or useful.",
            },
            {
                text  => "Recommendations",
                url   => "recommendations/",
                title =>
                    "Recommendations of Books, Compact Discs, Movies, etc.",
            },
            {
                separator => 1,
                skip      => 1,
            },
            {
                url   => "site-map/",
                text  => "Site Map",
                title => "A site map showing all of the main pages.",
            },
            {
                separator => 1,
                skip      => 1,
            },
            $get_sub_tree->('Shlomif::Homepage::SectionMenu::Sects::Meta'),
        ],
    };

    # $DB::single = 1;

    return (
        hosts         => scalar( MyNavData::Hosts::get_hosts() ),
        tree_contents => $tree_contents,
    );
}

sub get_params
{
    return __PACKAGE__->generic_get_params(
        {
            fully_expanded => 0,
            lang           => +{ ar => 1, en => 1, he => 1, },
        }
    );
}

1;
