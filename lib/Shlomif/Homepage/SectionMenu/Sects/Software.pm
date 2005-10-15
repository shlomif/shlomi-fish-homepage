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
                    'host' => "vipe",
                    'title' => "A First-Come First-Served Readers/Writers Lock",
                },
                {
                    'text' => "Quad-Pres",
                    'url' => "open-source/projects/quad-pres/",
                    'title' => "A Tool for Generating HTML Presenttions",
                },
                {
                    'text' => "Bits and Bobs",
                    'url' => "open-source/bits.html",
                    'title' => "Small Open Source Programs",
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
                },
                {
                    'url' => "open-source/portability-libs/",
                    'text' => "Portability Libraries",
                    'title' => "Index of Libraries for Portability",
                },
                {
                    'url' => "software-tools/",
                    'host' => "vipe",
                    'text' => "Software Building and Management Tools",
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
            'tree_contents' => $software_tree_contents,
        );
}

1;

