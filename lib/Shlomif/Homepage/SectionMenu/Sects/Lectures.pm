package Shlomif::Homepage::SectionMenu::Sects::Lectures;

use strict;
use warnings;

use utf8;

use MyNavData;

my $essays_tree_contents =
{
    host => "t2",
    text => "Shlomi Fish’s Presentations",
    title => "Shlomi Fish’s Presentations",
    show_always => 1,
    subs =>
    [
        {
            text => "Presentations",
            url => "lecture/",
            title => "Nav Menu for Shlomi Fish’s Presentations",
        },
        {
            text => "Perl for Newbies",
            url => "lecture/Perl/Newbies/",
            title => "Perl for Perl Newbies - Introducing Perl for Beginners",
        },
        {
            text => "Web Publishing with LAMP",
            url => "lecture/LAMP/",
            title => "Web Publishing using Linux/Apache/MySQL/Perl/PHP/Python",
            host => "t2",
        },
        {
            text => "Software Management",
            url => "lecture/cat/software-management/",
            title => "Presentation about Software Management",
            subs =>
            [
                {
                    text => "CatB",
                    url => "lecture/CatB/",
                    title => "Presentation about “The Cathedral and the Bazaar” series by Eric Raymond",
                },
                {
                    text => "The Joel Test",
                    url => "lecture/joel-test/",
                },
            ],
        },
        {
            text => "Programming Languages",
            url => "lecture/cat/programming-languages/",
            subs =>
            [
                {
                    text => "Scheme &amp; Lambda Calculus",
                    url => "lecture/Lambda-Calculus/",
                },
                {
                    text => "Haskell for Perlers",
                    url => "lecture/Perl/Haskell/",
                    title => "The Haskell Programming Language for Perl Programmers",
                },
            ],
        },
        {
            text => "Tools",
            url => "lecture/cat/various-tools/",
            title => "Various Tools",
            subs =>
            [
                {
                    text => "GIMP",
                    url => "lecture/Gimp/",
                    title => "The GNU Image Manipulation Program",
                },
                {
                    text => "PostgreSQL",
                    url => "lecture/PostgreSQL/",
                    title => "The PostgreSQL Database Server",
                },
                {
                    text => "Lex &amp; Yacc",
                    url => "lecture/Sys-Call-Track/Lex-Yacc/",
                    title => "Lex and Yacc - for Tokenizing and Parsing",
                },
                {
                    text => "Autotools",
                    url =>"lecture/Autotools/",
                    title => "GNU Autoconf/Automake/Libtool",
                },
                {
                    text => "Web Meta Lecture",
                    url => "lecture/WebMetaLecture/",
                    title => "Presentation about Website Meta Language",
                },
                {
                    host => "t2",
                    text => "Vim for Beginners",
                    url => "lecture/Vim/beginners/",
                    title => "The Vim (Vi-Improved) Editor for Beginners",
                },
                {
                    host => "t2",
                    text => "Vim Tips and Tricks",
                    url => "lecture/Vim/telux-tips-and-tricks/",
                },
                {
                    text => "Pres Tools",
                    url => "lecture/cat/pres-tools/",
                    title => "Tools for Preparing Slides for Presentations",
                    subs =>
                    [
                        {
                            text => "Quad-Pres",
                            url => "lecture/Quad-Pres/",
                        },
                        {
                            text => "PerlPoint",
                            url => "lecture/Pres-Tools/Perl-Point/",
                        },
                    ],
                },
            ],
        },
        {
            text => "Welcome to Linux",
            url => "lecture/W2L/",
            title => "Presentations in the Series for Linux Beginners",
            subs =>
            [
                {
                    text => "Basic Use",
                    url => "lecture/W2L/Basic_Use/",
                    title => "Basic Linux Use",
                },
                {
                    text => "Development",
                    url => "lecture/W2L/Development/",
                    title => "Software Development under Linux",
                },
                {
                    text => "Networking",
                    url  => "lecture/W2L/Network/",
                    title => "Networking in Linux Explanation and Howto",
                },
                {
                    text => "Blitz",
                    url => "lecture/W2L/Blitz/",
                    title => "Getting up to speed with Linux (Hebrew)",
                },
                {
                    text => "Mini-Intro",
                    url => "lecture/W2L/Mini-Intro/",
                    title => "Getting up to speed with Linux (Hebrew)",
                },
                {
                    text => "Why Linux",
                    url => "lecture/W2L/Why_Linux/",
                    title => "What Linux is to me.",
                },
                {
                    text => "Command Line (Notes)",
                    url => "lecture/Command-Line/",
                    title => "Topics for the Command Line Lecture for Newbies",
                },
            ],
        },
        {
            text => "Projects",
            url => "lecture/cat/projects/",
            title => "Presentations about my Software Projects",
            subs =>
            [
                {
                    text => "Freecell Solver",
                    url => "lecture/Freecell-Solver/",
                    title => "Freecell Solver - Evolution of a C Program",
                    subs =>
                    [
                        {
                            text => "The Next Presentation",
                            url => "lecture/Freecell-Solver/The-Next-Pres/",
                            title => "Freecell Solver - The Next Presentation",
                        },
                        {
                            text => "Project Intro",
                            url => "lecture/Freecell-Solver/project-intro/",
                            title => "Freecell Solver: Project Introduction",
                        },
                    ],
                },
                {
                    text => "LM-Solve",
                    url => "lecture/LM-Solve/",
                    title => "LM-Solve - a Logic Mazes Solver",
                },
            ],
        },
        {
            text => "Lightning Talks",
            url => "lecture/cat/lightning-talks/",
            title => "Short Presentations",
            subs =>
            [
                {
                    text => "Meta-Data Database Access",
                    url => "lecture/mini/mdda/",
                },
                {
                    text => "Graham Function",
                    url => "lecture/Perl/Graham-Function/",
                    title => "Presentation about Finding the Graham Function",

                },
                {
                    text => "The Template Toolkit",
                    url => "lecture/Perl/Template-Toolkit/",
                    title => "A Powerful Templating System for Perl",
                },
                {
                    text => "Optimising Multitasking in PDL",
                    url => "lecture/Perl/Lightning/Opt-Multi-Task-in-PDL/",
                },
                {
                    text => "Test::Run",
                    url => "lecture/Perl/Lightning/Test-Run/",
                    title => "Test::Run - a New and Improved Test Harness",
                },
                {
                    text => "Too Many Ways to do it",
                    url => "lecture/Perl/Lightning/Too-Many-Ways/",
                },
                {
                    text => "Mojolicious and Mojolicious::Lite",
                    url => "lecture/Perl/Lightning/Mojolicious/",
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
            tree_contents => $essays_tree_contents,
        );
}

1;

