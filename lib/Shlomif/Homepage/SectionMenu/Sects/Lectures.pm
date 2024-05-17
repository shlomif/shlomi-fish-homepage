package Shlomif::Homepage::SectionMenu::Sects::Lectures;

use strict;
use warnings;
use 5.014;
use utf8;
use parent 'Shlomif::Homepage::SectionMenu::BaseSectionClass';
use Carp qw/ cluck confess /;

use MyNavData::Hosts ();

my $_section_navmenu_tree_contents = {
    host        => "t2",
    text        => "Presentations",
    url         => "lecture/",
    title       => "Nav Menu for Shlomi Fish’s Presentations",
    show_always => 1,
    subs        => [
        {
            text  => "Perl for Newbies",
            url   => "lecture/Perl/Newbies/",
            title => "Perl for Perl Newbies - Introducing Perl for Beginners",
        },
        {
            text  => "HTML Tutorial",
            url   => "lecture/HTML-Tutorial/",
            title => "The Hebrew Tutorial for Standard HTML",
        },
        {
            text  => "Web Publishing with LAMP",
            url   => "lecture/LAMP/",
            title => "Web Publishing using Linux/Apache/MySQL/Perl/PHP/Python",
        },
        {
            text  => "Software Management",
            url   => "lecture/cat/software-management/",
            title => "Presentations about Software Management",
            subs  => [
                {
                    text  => "CatB",
                    url   => "lecture/CatB/",
                    title =>
"Presentation about “The Cathedral and the Bazaar” series by Eric Raymond",
                },
                {
                    text => "The Joel Test",
                    url  => "lecture/joel-test/",
                },
            ],
        },
        {
            text => "Programming Languages",
            url  => "lecture/cat/programming-languages/",
            subs => [
                {
                    text => "C and C++ Bad Elements",
                    url  => "lecture/C-and-CPP/bad-elements/",
                },
                {
                    text => "Scheme &amp; Lambda Calculus",
                    url  => "lecture/Lambda-Calculus/",
                    subs => [
                        {
                            text => "Slides",
                            url  => "lecture/Lambda-Calculus/slides/",
                            skip => 1,
                        },
                    ],
                },
                {
                    text  => "Haskell for Perlers",
                    url   => "lecture/Perl/Haskell/",
                    title =>
                        "The Haskell Programming Language for Perl Programmers",
                },
            ],
        },
        {
            text  => "Tools",
            url   => "lecture/cat/various-tools/",
            title => "Various Tools",
            subs  => [
                {
                    text  => "GIMP",
                    url   => "lecture/Gimp/",
                    title => "The GNU Image Manipulation Program",
                },
                {
                    text  => "PostgreSQL",
                    url   => "lecture/PostgreSQL/",
                    title => "The PostgreSQL Database Server",
                },
                {
                    text  => "Lex &amp; Yacc",
                    url   => "lecture/Sys-Call-Track/Lex-Yacc/",
                    title => "Lex and Yacc - for Tokenizing and Parsing",
                },
                {
                    text  => "Autotools",
                    url   => "lecture/Autotools/",
                    title => "GNU Autoconf/Automake/Libtool",
                },
                {
                    text  => "Web Meta Lecture",
                    url   => "lecture/WebMetaLecture/",
                    title => "Presentation about Website Meta Language",
                },
                {
                    text  => "Vim for Beginners",
                    url   => "lecture/Vim/beginners/",
                    title => "The Vim (Vi-Improved) Editor for Beginners",
                },
                {
                    text => "Vim Tips and Tricks",
                    url  => "lecture/Vim/telux-tips-and-tricks/",
                },
                {
                    text  => "Pres Tools",
                    url   => "lecture/cat/pres-tools/",
                    title => "Tools for Preparing Slides for Presentations",
                    subs  => [
                        {
                            text => "Quad-Pres",
                            url  => "lecture/Quad-Pres/",
                        },
                        {
                            text => "PerlPoint",
                            url  => "lecture/Pres-Tools/Perl-Point/",
                        },
                    ],
                },
            ],
        },
        {
            text  => "Welcome to Linux",
            url   => "lecture/W2L/",
            title => "Presentations in the Series for Linux Beginners",
            subs  => [
                {
                    text  => "Basic Use",
                    url   => "lecture/W2L/Basic_Use/",
                    title => "Basic Linux Use",
                },
                {
                    text  => "Development",
                    url   => "lecture/W2L/Development/",
                    title => "Software Development under Linux",
                },
                {
                    text  => "Networking",
                    url   => "lecture/W2L/Network/",
                    title => "Networking in Linux Explanation and Howto",
                },
                {
                    text  => "Blitz",
                    url   => "lecture/W2L/Blitz/",
                    title => "Getting up to speed with Linux (Hebrew)",
                },
                {
                    text  => "Mini-Intro",
                    url   => "lecture/W2L/Mini-Intro/",
                    title => "Getting up to speed with Linux (Hebrew)",
                },
                {
                    text  => "Why Linux",
                    url   => "lecture/W2L/Why_Linux/",
                    title => "What Linux is to me.",
                },
                {
                    text  => "Command Line (Notes)",
                    url   => "lecture/Command-Line/",
                    title => "Topics for the Command Line Lecture for Newbies",
                },
            ],
        },
        {
            text  => "Projects",
            url   => "lecture/cat/projects/",
            title => "Presentations about my Software Projects",
            subs  => [
                {
                    text  => "Freecell Solver",
                    url   => "lecture/Freecell-Solver/",
                    title => "Freecell Solver - Evolution of a C Program",
                    subs  => [
                        {
                            text  => "The Next Presentation",
                            url   => "lecture/Freecell-Solver/The-Next-Pres/",
                            title => "Freecell Solver - The Next Presentation",
                        },
                        {
                            text  => "Project Intro",
                            url   => "lecture/Freecell-Solver/project-intro/",
                            title => "Freecell Solver: Project Introduction",
                        },
                    ],
                },
                {
                    text  => "LM-Solve",
                    url   => "lecture/LM-Solve/",
                    title => "LM-Solve - a Logic Mazes Solver",
                },
            ],
        },
        {
            text  => "Lightning Talks",
            url   => "lecture/cat/lightning-talks/",
            title => "Short Presentations",
            subs  => [
                {
                    text => "Meta-Data Database Access",
                    url  => "lecture/mini/mdda/",
                },
                {
                    text  => "Graham Function",
                    url   => "lecture/Perl/Graham-Function/",
                    title => "Presentation about Finding the Graham Function",

                },
                {
                    text  => "The Template Toolkit",
                    url   => "lecture/Perl/Template-Toolkit/",
                    title => "A Powerful Templating System for Perl",
                },
                {
                    text => "Optimising Multitasking in PDL",
                    url  => "lecture/Perl/Lightning/Opt-Multi-Task-in-PDL/",
                },
                {
                    text  => "Test::Run",
                    url   => "lecture/Perl/Lightning/Test-Run/",
                    title => "Test::Run - a New and Improved Test Harness",
                },
                {
                    text => "Too Many Ways to do it",
                    url  => "lecture/Perl/Lightning/Too-Many-Ways/",
                },
                {
                    text => "Mojolicious and Mojolicious::Lite",
                    url  => "lecture/Perl/Lightning/Mojolicious/",
                },
            ],
        },
        {
            text  => "Non-alcoholic cocktails",
            title =>
                "Improvised, pseudo-“original”, non-Alcoholic, cocktails",
            url => "lecture/shlomif-cocktails/",
        },
    ],
};

my $section_navmenu_tree_contents_by_lang =
    __PACKAGE__->_calc_lang_trees_hash($_section_navmenu_tree_contents);

sub get_params
{
    my ( $self, $args ) = @_;

    my $lang = $args->{lang}
        or confess("lang was not specified.");

    my @keys = sort keys %$lang;
    if ( @keys == 1 )
    {
        $lang = shift @keys;
    }
    else
    {
        $lang = 'en';
    }
    my $tree_contents = $section_navmenu_tree_contents_by_lang->{$lang};
    if (0)    # ( $lang ne 'en' )
    {
        cluck "lang=$lang";
        say Data::Dumper->new( [ $tree_contents, ] )->Dump();
    }
    return (
        hosts         => scalar( MyNavData::Hosts::get_hosts() ),
        tree_contents => $tree_contents,
    );
}
1;
