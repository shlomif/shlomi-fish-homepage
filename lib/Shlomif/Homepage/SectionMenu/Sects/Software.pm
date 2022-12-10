package Shlomif::Homepage::SectionMenu::Sects::Software;

use strict;
use warnings;
use 5.014;
use parent 'Shlomif::Homepage::SectionMenu::BaseSectionClass';
use utf8;
use Carp qw/ cluck confess /;

use MyNavData::Hosts ();

my $_section_navmenu_tree_contents = {
    host        => "t2",
    show_always => 1,
    text        => "Open Source Software",
    title       => "Shlomi Fish's Software",
    url         => "open-source/",
    subs        => [
        {
            text => "Software Projects",
            url  => "open-source/projects/",
            subs => [
                {
                    text  => "Freecell Solver",
                    url   => "open-source/projects/freecell-solver/",
                    title => "A Library and Program to solve Solitaire Games",
                },
                {
                    text  => "PySol FC",
                    url   => "open-source/projects/pysol/",
                    title => "A suite of Solitaire games",
                },
                {
                    text  => "Latemp",
                    url   => "open-source/projects/latemp/",
                    title => "A static site generator",
                },
                {
                    text  => "Website META Language",
                    url   => "open-source/projects/website-meta-language/",
                    title => "A Preprocessor for HTML",
                },
                {
                    text  => "fortune-mod",
                    url   => "open-source/projects/fortune-mod/",
                    title => "Display a random quote on the command line",
                },
                {
                    text  => "Gradient-Fu Patch",
                    url   => "grad-fu/",
                    title => "Gradient-Fu Patch for GIMP",
                },
                {
                    text  => "FCFS RWLock",
                    url   => "rwlock/",
                    title => "A First-Come First-Served Readers/Writers Lock",
                    subs  => [
                        {
                            text  => "For the Linux Kernel",
                            url   => "rwlock/linux-kernel/",
                            title =>
"Make Linux's flock/fcntl calls First-come First-served",
                        },
                    ],
                },
                {
                    text  => "File-Dir-Dumper",
                    url   => "open-source/projects/File-Dir-Dumper/",
                    title => "Dump the Meta-Data of Directory Structures",
                },
                {
                    text => "“Black Hole” Solitaire Solver",
                    url  => "open-source/projects/black-hole-solitaire-solver/",
                    title =>
                        "Solve layouts of the patience card game 'Black Hole'",
                },
                {
                    text => "Japanese Puzzle Games",
                    url  => "open-source/projects/japanese-puzzle-games/",
                    subs => [
                        {
                            text => "ABC Path Solver",
                            url  =>
"open-source/projects/japanese-puzzle-games/abc-path/",
                            title =>
"Solver for ABC Path as featured on BrainBashers.com",
                        },
                        {
                            text => "Binary Puzzle Solver",
                            url  =>
"open-source/projects/japanese-puzzle-games/binary-puzzle/",
                            title =>
"Solver for logic puzzles as featured on www.binarypuzzle.com",
                        },
                        {
                            text => "Kakurasu Solver",
                            url  =>
"open-source/projects/japanese-puzzle-games/kakurasu/",
                            title =>
                                "Automatically Solve the Kakurasu Puzzle Game",
                        },
                    ],
                },
                {
                    text  => "File-Find-Object",
                    url   => "open-source/projects/File-Find-Object/",
                    title => "An Object-Oriented Alternative to File::Find",
                },
                {
                    text  => "Module-Format",
                    url   => "open-source/projects/Module-Format/",
                    title =>
"Perform operations on a number of Perl modules by handling their different stringification formats.",
                },
                {
                    text  => "Convert From Test.pm",
                    url   => "open-source/projects/Test.pm-Converter/",
                    title =>
"Script to partially convert Perl test programs that use Test.pm to Test::More.",
                },
                {
                    text  => "The XML-Grammar Project",
                    url   => "open-source/projects/XML-Grammar/",
                    title =>
"Provides specialised XML grammars, with processors and converters for various tasks",
                    subs => [
                        {
                            text => "XML-Grammar-Fiction",
                            url  => "open-source/projects/XML-Grammar/Fiction/",
                            title =>
"A lightweight markup language and an XML grammar for writing Prose.",
                        },
                        {
                            text  => "XML-GrammarBase",
                            url   => "open-source/projects/XML-Grammar/Base/",
                            title =>
"Base classes and roles for XML grammar processors",
                        },
                    ],
                },
                {
                    text  => "docmake",
                    url   => "open-source/projects/docmake/",
                    title =>
"Automate the conversion of DocBook/XML to different formats",
                },
                {
                    text  => "Quad-Pres",
                    url   => "open-source/projects/quad-pres/",
                    title => "A Tool for Generating HTML Presentations",
                },
                {
                    skip  => 1,
                    text  => "yjobs.co.il on Firefox/Mozilla",
                    url   => "open-source/projects/yjobs-on-mozilla/",
                    title =>
"Workaround to use yjobs.co.il using (cross-platform) Mozilla-based browsers such as Firefox",
                },
                {
                    text  => "libtap",
                    url   => "open-source/projects/libtap/",
                    title =>
"Write test programs in C that output to the Test Anything Protocol (TAP)",
                },
                {
                    text  => "countdown",
                    url   => "open-source/projects/countdown/",
                    title =>
"Delay for a certain seconds, while displaying the remaining time",
                },
                {
                    text  => "Notifier-Apps",
                    url   => "open-source/projects/notifier-apps/",
                    title =>
"A simple client/server HTTP-based applications for desktop notifications",
                },
                {
                    text  => "sky",
                    url   => "open-source/projects/sky/",
                    title => "Upload a file and get a URL back.",
                },
                {
                    text  => "Maniac Downloader",
                    url   => "open-source/projects/maniac-downloader/",
                    title => "A download accelerator with a key improvement.",
                },
                {
                    text  => "Docker-CLI-Wrapper",
                    url   => "open-source/projects/Docker-CLI-Wrapper/",
                    title =>
"A wrapper to the Docker (or podman) command-line interfaces",
                },
                {
                    text  => "KSokoban Maintenance",
                    url   => "open-source/projects/ksokoban/",
                    title =>
                        "A KDE implementation of Sokoban - maintenance branch",
                },
                {
                    skip => 1,
                    text => "Spark - A Lisp Dialect",
                    url  => "open-source/projects/Spark/",
                    subs => [
                        {
                            skip  => 1,
                            text  => "Mission Statement",
                            url   => "open-source/projects/Spark/mission/",
                            title => "Spark - Pre-Birth of a Modern Lisp",
                        },
                        {
                            skip  => 1,
                            text  => "Old Document ( “Park” )",
                            url   => "open-source/projects/Park-Lisp/",
                            title =>
"Park - a Dialect of the Lisp Programming Language inspired by Arc",
                        },
                    ],
                },
                {
                    text => "Kernel Configuration Search Enhancement",
                    url  => "open-source/projects/linux-kernel/xconfig-search/",
                    title =>
"Patch to Enhance the Configuration Searching of the Linux Kernel",
                },
                {
                    text  => "MikMod",
                    url   => "open-source/projects/mikmod/",
                    title =>
                        "A library and player for playing music module files",
                    subs => [
                        {
                            text  => "MikMod for Java",
                            url   => "jmikmod/",
                            title => "MOD Music Files Player for Java",
                        },
                    ],
                },
                {
                    text => "Problem Sets and Competitive Programming Sites",
                    url  => "open-source/projects/problem-sets-and-cp/",
                    subs => [
                        {
                            text => "Project Euler",
                            url  =>
"open-source/projects/problem-sets-and-cp/project-euler/",
                        },
                    ],
                },
                {
                    text  => "Bits and Bobs",
                    url   => "open-source/bits.html",
                    title => "Small Open Source Programs",
                    subs  => [
                        {
                            text => "Greasemonkey Scripts",
                            url  =>
"open-source/bits-and-bobs/greasemonkey/grease.html",
                            title =>
"Greasemonkey User Scripts for Firefox and other browsers",
                        },
                    ],
                },
                {
                    text  => "Personal Configuration",
                    url   => "open-source/projects/conf/",
                    title =>
"The Personal Configuration of some of the Programs on my Computer",
                    subs => [
                        {
                            skip  => 1,
                            text  => "Vim",
                            url   => "open-source/projects/conf/vim/",
                            title =>
                                "Vim Editor Configuration Files (.vimrc, etc.)",
                        },
                    ],
                },
            ],
        },
        {
            text  => "Contributions to Projects",
            url   => "open-source/contributions/",
            title => "Contributions to Open Source Projects I did not Initiate",
        },
        {
            text  => "Mentoring FOSS Contributors",
            url   => "open-source/mentoring/",
            title =>
"Providing mentoring and guidance to those who want to become open-source contributors",
        },
        {
            text => "Documents and Resources",
            url  => "open-source/resources/",
            subs => [
                {
                    text => "Curated Lists",
                    url  => "open-source/resources/sw-lists/",
                    subs => [

                        {
                            url   => "open-source/portability-libs/",
                            text  => "Portability Libraries",
                            title => "Index of Libraries for Portability",
                        },
                        {
                            url  => "open-source/resources/software-tools/",
                            text => "Software Building and Management Tools",
                        },
                        {
                            url   => "open-source/resources/editors-and-IDEs/",
                            text  => "Editors and IDEs",
                            title =>
"Index of Text Editors and Integrated Development Environments",
                        },
                        {
                            url  => "open-source/resources/numerical-software/",
                            text => "Numerical Software",
                        },
                        {
                            url =>
                                "open-source/resources/text-processing-tools/",
                            text => "Text Processing Tools",
                        },
                        {
                            url  => "open-source/resources/networking-clients/",
                            text => "Networking Clients",
                            title =>
"Web browsers, FTP clients, Instant Messaging (IM) clients, File sharing applications and more",
                        },
                        {
                            url => "open-source/resources/multimedia-programs/",
                            text => "List of Multimedia Applications",
                        },
                        {
                            url   => "open-source/resources/graphics-programs/",
                            text  => "List of Computer Graphics Applications",
                            title =>
"Raster editors, vector editors, image viewers and organisers, 3-D applications and more",
                        },
                        {
                            url  => "open-source/resources/databases-list/",
                            text => "List of Database Implementations",
                        },
                        {
                            url =>
"open-source/resources/software-quality-enhancement/",
                            text =>
                                "List of Software quality-enhancement tools",
                        },
                    ],
                },
                {
                    text  => "Favourite OSS",
                    url   => "open-source/favourite/",
                    title => "Favourite Open Source Software of Mine",
                },
                {
                    text  => "Interviews",
                    url   => "open-source/interviews/",
                    title => "Interviews with Open Source Figures",
                    subs  => [
                        {
                            text => "Adrian Ettlinger",
                            url  =>
                                "open-source/interviews/adrian-ettlinger.html",
                            title => "Interview with Adrian Ettlinger",
                        },
                        {
                            text  => "Ben Collins-Sussman",
                            url   => "open-source/interviews/sussman.html",
                            title => "Interview with Ben Collins-Sussman",
                        },
                    ],
                },
                {
                    url  => "open-source/resources/tech-tips/",
                    text => "Tech Tips’ Collection",
                },
                {
                    url =>
"open-source/resources/how-to-contribute-to-my-projects/",
                    text => "How to Contribute to My Projects",
                },
                {
                    skip => 1,
                    url  => "rindolf/",
                    text => "Rindolf - a Dialect of Perl based on Perl 5",
                },
                {
                    url  => "open-source/resources/israel/",
                    text => "Israel-Related",
                    subs => [
                        {
                            url =>
"open-source/resources/israel/guide-to-israeli-foss-resources/",
                            text  => "Guide to Israeli FOSS Resources",
                            title =>
"Guide to online Israeli open-source-related resources",
                        },
                        {
                            url =>
"open-source/resources/israel/list-of-projects/",
                            text => "List of Israeli Projects",
                        },
                    ],
                },
            ],
        },
        {
            text => "Against Bad Software",
            url  => "open-source/anti/",
            subs => [
                {
                    text  => "Internet Explorer",
                    url   => "no-ie/",
                    title => "Stop Using Internet Explorer!",
                    subs  => [
                        {
                            text  => "Feb 2014 Update",
                            url   => "no-ie/update-2014-02/",
                            title =>
                                "February 2014 Update for the Anti-MSIE Page",
                        },
                    ],
                },
                {
                    text  => "Against qmail",
                    url   => "open-source/anti/qmail/",
                    title => "Against using the qmail SMTP Server",
                },
                {
                    text  => "Stop Using the C-Shell",
                    url   => "open-source/anti/csh/",
                    title => "Stop Using (and Teaching) the C-Shell",
                },
                {
                    text  => "Against Apple Inc.",
                    url   => "open-source/anti/apple/",
                    title => "Against Apple, Mac OS, etc.",
                },
                {
                    text  => "Against Adobe Flash",
                    url   => "open-source/anti/Adobe-Flash/",
                    title => "Against Adobe Flash",
                },
                {
                    text  => "Against Windows Vista",
                    url   => "open-source/anti/windows-vista/",
                    title => "A collection of links against Windows Vista",
                },
                {
                    text  => "Against MySQL",
                    url   => "open-source/anti/mysql/",
                    title => "A collection of links detailing MySQL Problems",
                },
                {
                    text  => "PHP Sucks",
                    url   => "open-source/anti/php/",
                    title => "“PHP Sucks” - originally by czth",
                },
                {
                    text  => "GNU Autohell",
                    url   => "open-source/anti/autohell/",
                    title => "Escape from GNU Autohell!",
                },
                {
                    text  => "Stop Abusing JavaScript",
                    url   => "open-source/anti/javascript/",
                    title =>
"Why JavaScript Should not be Used Outside Web Browser Scripting",
                },
                {
                    text  => "Links against Java",
                    url   => "open-source/anti/java/",
                    title => "Some links against Java",
                },
                {
                    text  => "Links against SOAP",
                    url   => "open-source/anti/SOAP/",
                    title =>
"Some links against SOAP (the so-called “Simple Object Access Protocol”)",
                },
                {
                    text  => "Links against TIOBE",
                    url   => "open-source/anti/TIOBE/",
                    title =>
"Some links against the TIOBE index, which aims to measure programming languages’ popularity",
                },
            ],
        },
        {
            text  => "Nostalgia",
            url   => "open-source/nostalgia/",
            title => "Software I wrote for DOS back in the prehistoric days",
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
