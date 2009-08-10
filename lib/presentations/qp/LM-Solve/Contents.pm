package Contents;

use strict;

my $contents =
{
    'title' => "LM-Solve - A Logic Mazes Solver",
    'subs' =>
    [
        {
            'url' => "history",
            'title' => "History",
            'subs' =>
            [
                {
                    'url' => "first_encounter.html",
                    'title' => "First Encounter with the Logic Mazes",
                },
                {
                    'url' => "two_initial_scripts.html",
                    'title' => "Two Initial Scripts",
                },
                {
                    'url' => "first_version.html",
                    'title' => "First Version of LM-Solve",
                },
                {
                    'url' => "next_versions.html",
                    'title' => "LM-Solve 0.4.0 and 0.6.0",
                },
                {
                    'url' => "no_bitkeeper.html",
                    'title' => "No BitKeeper for you!",
                },
                {
                    'url' => "recent_work.html",
                    'title' => "Recent Work",
                },
            ],
        },
        {
            'url' => "technologies",
            'title' => "Technologies used by LM-Solve",
            'subs' =>
            [
                {
                    'url' => "Makefile-PL.html",
                    'title' => "Makefile.PL",
                },
                {
                    'url' => "Getopt.html",
                    'title' => "Getopt::Long",
                },
                {
                    'url' => "pod.html",
                    'title' => "POD, Pod::Usage and Friends",
                },
                {
                    'url' => "RPM-Spec.html",
                    'title' => "Writing an RPM Spec"
                },
            ],
        },
        {
            'url' => "architecture",
            'title' => "Architecture of LM-Solve",
            'subs' =>
            [
                {
                    'url' => "base-derived.html",
                    'title' => "Multiple Solvers Implmentation",
                },
                {
                    'url' => "registry.html",
                    'title' => "Registry",
                },
                {
                    'url' => "input.html",
                    'title' => "The Input Module",
                },
            ],
        },
        {
            'url' => "exotic-bugs",
            'title' => "Exotic Bugs",
            'subs' =>
            [
                {
                    'url' => "hex_swamps.html",
                    'title' => "The Hex Swamps Conundrum",
                },
                {
                    'url' => "recursion_limit.html",
                    'title' => "Recursion Limit",
                },
            ],
            'images' => [ "hex_swamps_proto_game.png" ],
        },
        {
            'url' => "links.html",
            'title' => "Links and References",
        },
    ],
    'images' =>
    [
        'style.css',
    ],
};

sub get_contents
{
    return $contents;
}

1;
