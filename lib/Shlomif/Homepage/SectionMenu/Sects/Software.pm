package Shlomif::Homepage::SectionMenu::Sects::Software;

use strict;
use warnings;

use MyNavData;

my $software_tree_contents =
{
    'host' => "t2",
    'text' => "Shlomi Fish' Software",
    'title' => "Shlomi Fish' Software",
    'show_always' => 1,
    'subs' =>
    [
        {
            'text' => "Open Source Software",
            'url' => "open-source/",
        },
        {
            'text' => "Software Projects",
            'url' => "open-source/projects/",
            'subs' =>
            [
                {
                    'text' => "Freecell Solver",
                    'url' => "open-source/projects/freecell-solver/",
                    'title' => "A Library and Program to solve Solitaire Games",
                },
                {
                    'text' => "Latemp",
                    'url' => "open-source/projects/latemp/",
                    'title' => "A Content Management System for Static HTML",
                },
                {
                    'text' => "MikMod for Java",
                    'url' => "jmikmod/",
                    'title' => "MOD Music Files Player for Java",
                },
                {
                    'text' => "Gradient-Fu Patch",
                    'url' => "grad-fu/",
                    'title' => "Gradient-Fu Patch for GIMP",
                },
                {
                    'text' => "FCFS RWLock",
                    'url' => "rwlock/",
                    'title' => "A First-Come First-Served Readers/Writers Lock",
                },
                {
                    'text' => "Quad-Pres",
                    'url' => "open-source/projects/quad-pres/",
                    'title' => "A Tool for Generating HTML Presenttions",
                },
                {
                    'text' => "yjobs.co.il on Firefox/Mozilla",
                    'url' => "open-source/projects/yjobs-on-mozilla/",
                    'title' => "Workaround to use yjobs.co.il using (cross-platform) Mozilla-based browsers such as Firefox",
                },
                {
                    'text' => "Park - A Lisp Dialect",
                    'url' => "open-source/projects/Park-Lisp/",
                    'title' => "Park - a Dialect of the Lisp Programming Language inspired by Arc",
                },
                {
                    'text' => "Kernel Configuration Search Enhancement",
                    'url' => "open-source/projects/linux-kernel/xconfig-search/",
                    'title' => "Patch to Enhance the Configuration Searching of the Linux Kernel",
                },
                {
                    'text' => "Bits and Bobs",
                    'url' => "open-source/bits.html",
                    'title' => "Small Open Source Programs",
                },
                {
                    'text' => "Personal Configuration",
                    'url' => "open-source/projects/conf/",
                    'title' => "The Personal Configuration of some of the Programs on my Computer",
                    'subs' =>
                    [
                        {
                            'text' => "Vim",
                            'url' => "open-source/projects/conf/vim/",
                            'title' => "Vim Editor Configuration Files (.vimrc, etc.)",
                        },
                    ],
                },
            ],
        },
        {
            'text' => "Contributions to Projects",
            'url' => "open-source/contributions/",
            'title' => "Contributions to Open Source Projects I did not Initiate",
        },
        {
            'text' => "Documents and Resources",
            'url' => "open-source/resources/",
            'subs' =>
            [
                {
                    'text' => "Favourite OSS",
                    'url' => "open-source/favourite/",
                    'title' => "Favourite Open Source Software of Mine",
                },
                {
                    'text' => "Interviews",
                    'url' => "open-source/interviews/",
                    'title' => "Interviews with Open Source Figures",
                    'subs' =>
                    [
                        {
                            'text' => "Adrian Ettlinger",
                            'url' => "open-source/interviews/adrian-ettlinger.html",
                            'title' => "Interview with Adrian Ettlinger",
                        },
                        {
                            'text' => "Ben Collins-Sussman",
                            'url' => "open-source/interviews/sussman.html",
                            'title' => "Interview with Ben Collins-Sussman",
                        },
                    ],
                },
                {
                    'url' => "open-source/portability-libs/",
                    'text' => "Portability Libraries",
                    'title' => "Index of Libraries for Portability",
                },
                {
                    'url' => "open-source/resources/software-tools/",
                    'text' => "Software Building and Management Tools",
                },
                {
                    'url' => "rindolf/",
                    'text' => "Rindolf - a Dialect of Perl based on Perl 5",
                },
                {
                    'url' => "open-source/resources/israel/",
                    'text' => "Israel-Related",
                    'subs' =>
                    [
                        {
                            'url' => "open-source/resources/israel/guide-to-israeli-foss-resources/",
                            'text' => "Guide to Israeli FOSS Resources",
                            'title' => "Guide to online Israeli open-source-related resources",
                        },
                        {
                            'url' => "open-source/resources/israel/list-of-projects/",
                            'text' => "List of Israeli Projects",
                        },
                    ],
                },
            ],
        },
        {
            'text' => "Against Bad Software",
            'url' => "open-source/anti/",
            'subs' =>
            [
                {
                    'text' => "Internet Explorer",
                    'url' => "no-ie/",
                    'title' => "Stop Using Internet Explorer!",
                },
                {
                    'text' => "Against qmail",
                    'url' => "open-source/anti/qmail/",
                    'title' => "Against using the qmail SMTP Server",
                },
                {
                    'text' => "Stop Using the C-Shell",
                    'url' => "open-source/anti/csh/",
                    'title' => "Stop Using (and Teaching) the C-Shell",
                },
                {
                    'text' => "Against Apple Inc.",
                    'url' => "open-source/anti/apple/",
                    'title' => "Against Apple, Mac OS, etc.",
                },
                {
                    'text' => "Against Windows Vista",
                    'url' => "open-source/anti/windows-vista/",
                    'title' => "A collection of links against Windows Vista",
                },
                {
                    'text' => "Against MySQL",
                    'url' => "open-source/anti/mysql/",
                    'title' => "A collection of links detailing MySQL Problems",
                },
            ],
        },
        {
            'text' => "Nostalgia",
            'url' => "open-source/nostalgia/",
            'title' => "Software I wrote for DOS back in the prehistoric days",
        },
    ],
};

sub get_params
{
    return
        (
            'hosts' => MyNavData::get_hosts(),
            'tree_contents' => $software_tree_contents,
        );
}

1;

