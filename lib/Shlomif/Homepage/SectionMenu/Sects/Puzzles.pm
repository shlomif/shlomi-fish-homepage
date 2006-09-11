package Shlomif::Homepage::SectionMenu::Sects::Puzzles;

use strict;
use warnings;

use MyNavData;

my $puzzles_tree_contents =
{
    'host' => "t2",
    'text' => "Shlomi Fish' Essays",
    'title' => "Shlomi Fish' Essays",
    'show_always' => 1,
    'subs' =>
    [
        {
            'text' => "Puzzles",
            'url' => "puzzles/",
            'title' => "Puzzles and Riddles",
        },
        {
            'text' => "Math-Ventures",
            'url' => "MathVentures/",
            'title' => "Adventures in Mathematics, usually with some real-life application",
            'subs' =>
            [
                {
                    'text' => "Combinatorics and the Art of D&amp;D",
                    'url' => "MathVentures/3d_outof_4d.html",
                    'title' => "The 3 Maximal Dice out of 4 Dice",
                },
                {
                    'text' => "On and on it Seems to go",
                    'url' => "MathVentures/repeating_code.html",
                    'title' => "How many Combinations are for a Repeating Code",
                },
                {
                    'text' => "Dodecahedron Volume",
                    'url' => "MathVentures/dodeca.html",
                },
                {
                    'text' => "A Solidarian Disco Circle",
                    'url' => "MathVentures/disco_circle.html",
                },
                {
                    'text' => "Toggling Squares is not that Trivial",
                    'url' => "MathVentures/toggle_squares.html",
                },
                {
                    'text' => "Bugs in a Square",
                    'url' => "MathVentures/bugs-in-square-mathml.xhtml",
                },
            ],
        },
        {
            'text' => "Logic Puzzles",
            'url' => "puzzles/logic/",
            'title' => "Various Logic Puzzles I came up with.",
            'subs' =>
            [
                {
                    'text' => "Between the Screws",
                    'url' => "puzzles/logic/between-the-screws/",
                    'title' => "Which are the 4 different Screws Used to build an Airplane?",
                },
                {
                    'text' => "Ravensborg's Guild",
                    'url' => "puzzles/logic/ravensborgs-guild/",
                    'title' => "5 members of a guild with different profession, one of them is the leader.",
                },
                {
                    'text' => "On the Tip of the Sword",
                    'url' => "puzzles/logic/tip-of-the-sword/",
                    'title' => "5 swords of different types. Which is which?",
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
            'tree_contents' => $puzzles_tree_contents,
        );
}

1;

