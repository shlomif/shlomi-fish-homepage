package Shlomif::Homepage::SectionMenu::Sects::Software;

use strict;
use warnings;

use MyNavData;

my $software_tree_contents =
{
    host => "t2",
    text => "Shlomi Fish's Software",
    title => "Shlomi Fish's Software",
    show_always => 1,
    subs =>
    [
        {
            text => "Open Source Software",
            url => "open-source/",
        },
        {
            text => "Software Projects",
            url => "open-source/projects/",
            subs =>
            [
                {
                    text => "Freecell Solver",
                    url => "open-source/projects/freecell-solver/",
                    title => "A Library and Program to solve Solitaire Games",
                },
                {
                    text => "Latemp",
                    url => "open-source/projects/latemp/",
                    title => "A Content Management System for Static HTML",
                },
                {
                    text => "MikMod for Java",
                    url => "jmikmod/",
                    title => "MOD Music Files Player for Java",
                },
                {
                    text => "Gradient-Fu Patch",
                    url => "grad-fu/",
                    title => "Gradient-Fu Patch for GIMP",
                },
                {
                    text => "FCFS RWLock",
                    url => "rwlock/",
                    title => "A First-Come First-Served Readers/Writers Lock",
                    subs =>
                    [
                        {
                            text => "For the Linux Kernel",
                            url => "rwlock/linux-kernel/",
                            title => "Make Linux's flock/fcntl calls First-come First-served",
                        },
                    ],
                },
                {
                    text => "File-Dir-Dumper",
                    url => "open-source/projects/File-Dir-Dumper/",
                    title => "Dump the Meta-Data of Directory Structures",
                },
                {
                    text => "\"Black Hole\" Solitaire Solver",
                    url => "open-source/projects/black-hole-solitaire-solver/",
                    title => "Solve layouts of the patience card game 'Black Hole'",
                },
                {
                    text => "Japanase Puzzle Games",
                    url => "open-source/projects/japanese-puzzle-games/",
                    subs =>
                    [
                        {
                            text => "ABC Path Solver",
                            url => "open-source/projects/japanese-puzzle-games/abc-path/",
                            title => "Solver for ABC Path as featured on BrainBashers.com",
                        },
                        {
                            text => "Kakurasu Solver",
                            url => "open-source/projects/japanese-puzzle-games/kakurasu/",
                            title => "Automatically Solve the Kakurasu Puzzle Game",
                        },
                    ],
                },
                {
                    text => "File-Find-Object",
                    url => "open-source/projects/File-Find-Object/",
                    title => "An Object-Oriented Alternative to File::Find",
                },
                {
                    text => "Module-Format",
                    url => "open-source/projects/Module-Format/",
                    title => "Perform operations on a number of Perl modules by handling their different stringification formats.",
                },
                {
                    text => "The XML-Grammar Project",
                    url => "open-source/projects/XML-Grammar/",
                    title => "Provides specialised XML grammars, with processors and converters for various tasks",
                    subs =>
                    [
                        {
                            text => "XML-Grammar-Fiction",
                            url => "open-source/projects/XML-Grammar/Fiction/",
                            title => "A lightweight markup language and an XML grammar for writing Prose.",
                        },
                    ],
                },
                {
                    text => "docmake",
                    url => "open-source/projects/docmake/",
                    title => "Automate the conversion of DocBook/XML to different formats",
                },
                {
                    text => "Quad-Pres",
                    url => "open-source/projects/quad-pres/",
                    title => "A Tool for Generating HTML Presenttions",
                },
                {
                    text => "yjobs.co.il on Firefox/Mozilla",
                    url => "open-source/projects/yjobs-on-mozilla/",
                    title => "Workaround to use yjobs.co.il using (cross-platform) Mozilla-based browsers such as Firefox",
                },
                {
                    text => "libtap",
                    url => "open-source/projects/libtap/",
                    title => "Write test programs in C that output to the Test Anything Protocol (TAP)",
                },
                {
                    text => "Spark - A Lisp Dialect",
                    url => "open-source/projects/Spark/",
                    subs =>
                    [
                        {
                            text => "Mission Statement",
                            url => "open-source/projects/Spark/mission/",
                            title => "Spark - Pre-Birth of a Modern Lisp",
                        },
                        {
                            text => "Old Document ( \"Park\" )",
                            url => "open-source/projects/Park-Lisp/",
                            title => "Park - a Dialect of the Lisp Programming Language inspired by Arc",
                        },
                    ],
                },
                {
                    text => "Kernel Configuration Search Enhancement",
                    url => "open-source/projects/linux-kernel/xconfig-search/",
                    title => "Patch to Enhance the Configuration Searching of the Linux Kernel",
                },
                {
                    text => "Bits and Bobs",
                    url => "open-source/bits.html",
                    title => "Small Open Source Programs",
                    subs =>
                    [
                        {
                            text => "Greasemonkey Scripts",
                            url => "open-source/bits-and-bobs/greasemonkey/grease.html",
                            title => "Greasemonkey User Scripts for Firefox and other browsers",
                        },
                    ],
                },
                {
                    text => "Personal Configuration",
                    url => "open-source/projects/conf/",
                    title => "The Personal Configuration of some of the Programs on my Computer",
                    subs =>
                    [
                        {
                            text => "Vim",
                            url => "open-source/projects/conf/vim/",
                            title => "Vim Editor Configuration Files (.vimrc, etc.)",
                        },
                    ],
                },
            ],
        },
        {
            text => "Contributions to Projects",
            url => "open-source/contributions/",
            title => "Contributions to Open Source Projects I did not Initiate",
        },
        {
            text => "Mentoring FOSS Contributors",
            url => "open-source/mentoring/",
            title => "Providing mentoring and guidance to those who want to become open-source contributors",
        },
        {
            text => "Documents and Resources",
            url => "open-source/resources/",
            subs =>
            [
                {
                    text => "Favourite OSS",
                    url => "open-source/favourite/",
                    title => "Favourite Open Source Software of Mine",
                },
                {
                    text => "Interviews",
                    url => "open-source/interviews/",
                    title => "Interviews with Open Source Figures",
                    subs =>
                    [
                        {
                            text => "Adrian Ettlinger",
                            url => "open-source/interviews/adrian-ettlinger.html",
                            title => "Interview with Adrian Ettlinger",
                        },
                        {
                            text => "Ben Collins-Sussman",
                            url => "open-source/interviews/sussman.html",
                            title => "Interview with Ben Collins-Sussman",
                        },
                    ],
                },
                {
                    url => "open-source/portability-libs/",
                    text => "Portability Libraries",
                    title => "Index of Libraries for Portability",
                },
                {
                    url => "open-source/resources/software-tools/",
                    text => "Software Building and Management Tools",
                },
                {
                    url => "open-source/resources/editors-and-IDEs/",
                    text => "Editors and IDEs",
                    title => "Index of Editors and Integrated Development Environments",
                },
                {
                    url => "open-source/resources/numerical-software/",
                    text => "Numerical Software",
                },
                {
                    url => "rindolf/",
                    text => "Rindolf - a Dialect of Perl based on Perl 5",
                },
                {
                    url => "open-source/resources/israel/",
                    text => "Israel-Related",
                    subs =>
                    [
                        {
                            url => "open-source/resources/israel/guide-to-israeli-foss-resources/",
                            text => "Guide to Israeli FOSS Resources",
                            title => "Guide to online Israeli open-source-related resources",
                        },
                        {
                            url => "open-source/resources/israel/list-of-projects/",
                            text => "List of Israeli Projects",
                        },
                    ],
                },
            ],
        },
        {
            text => "Against Bad Software",
            url => "open-source/anti/",
            subs =>
            [
                {
                    text => "Internet Explorer",
                    url => "no-ie/",
                    title => "Stop Using Internet Explorer!",
                },
                {
                    text => "Against qmail",
                    url => "open-source/anti/qmail/",
                    title => "Against using the qmail SMTP Server",
                },
                {
                    text => "Stop Using the C-Shell",
                    url => "open-source/anti/csh/",
                    title => "Stop Using (and Teaching) the C-Shell",
                },
                {
                    text => "Against Apple Inc.",
                    url => "open-source/anti/apple/",
                    title => "Against Apple, Mac OS, etc.",
                },
                {
                    text => "Against Windows Vista",
                    url => "open-source/anti/windows-vista/",
                    title => "A collection of links against Windows Vista",
                },
                {
                    text => "Against MySQL",
                    url => "open-source/anti/mysql/",
                    title => "A collection of links detailing MySQL Problems",
                },
                {
                    text => "PHP Sucks",
                    url => "open-source/anti/php/",
                    title => "&quot;PHP Sucks&quot; - originally by czth",
                },
                {
                    text => "GNU Autohell",
                    url => "open-source/anti/autohell/",
                    title => "Escape from GNU Autohell!",
                },
                {
                    text => "Stop Abusing JavaScript",
                    url => "open-source/anti/javascript/",
                    title => "Why JavaScript Should not be Used Outside Web Browser Scripting",
                },
            ],
        },
        {
            text => "Nostalgia",
            url => "open-source/nostalgia/",
            title => "Software I wrote for DOS back in the prehistoric days",
        },
    ],
};

sub get_params
{
    return
        (
            hosts => MyNavData::get_hosts(),
            tree_contents => $software_tree_contents,
        );
}

1;

