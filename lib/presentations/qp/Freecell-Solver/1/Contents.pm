package Contents;

use strict;

my $contents =
{
    'title' => "Freecell Solver - Evolution of a C Program",
    'subs' =>
    [
        {
            'url' => "intro",
            'title' => "Introduction",
            'subs' =>
            [
                {
                    'url' => "rules",
                    'title' => "Rules of the Game",
                    'subs' =>
                    [
                        {
                            'url' => "strategies.html",
                            'title' => "Common Strategies",
                        },
                    ],
                },
                {
                    'url' => "disclaimer.html",
                    'title' => "Copyrights and Disclaimer",
                },
            ],
        },
        {
            'url' => "0.2",
            'title' => "Freecell Solver 0.2's Architecture",
            'subs' =>
            [
                {
                    'url' => "scan.html",
                    'title' => "The Scan that was used",
                },
                #{
                #    'url' => "test.html",
                #    'title' => "The Tests used by the Program",
                #},
                #{
                #    'url' => "data_types.html",
                #    'title' => "The Data Types",
                #},
            ],
        },
        {
            'url' => "states_collection",
            'title' => "Evolution of the States' Collection",
            'subs' =>
            [
                {
                    'url' => "list.html",
                    'title' => "Initial Perl Version - Flat List",
                },
                {
                    'url' => "qsorted_sort_margin.html",
                    'title' => "First C Version - Sorted Array",
                },
                {
                    'url' => "b_search_merge.html",
                    'title' => "Binary-Search-Based Merge to Add the Sort Margin",
                },
                {
                    'url' => "array_of_ptrs.html",
                    'title' => "Array of Pointers",
                },
                {
                    'url' => "balanced_binary_tree.html",
                    'title' => "A Balanced Binary Tree",
                },
                {
                    'url' => "hash",
                    'title' => "A Hash Table",
                    'subs' =>
                    [
                        {
                            'url' => "function.html",
                            'title' => "The Choice of a Hash Function",
                        },
                        {
                            'url' => "optimizations.html",
                            'title' => "Hash Optimizations",
                        },
                    ],
                },
                #{
                #    'url' => "benchmarks.html",
                #'title' => "Benchmarks",
                #},
            ],
        },
        {
            'url' => "moves",
            'title' => "Moves Management",
            'subs' =>
            [
                {
                    'url' => "meta.html",
                    'title' => "Meta-Moves (instead of Atomic ones)",
                },
                {
                    'url' => "stack-to-stack.html",
                    'title' => "Stack to Stack Moves",
                },
                {
                    'url' => "generalization.html",
                    'title' => "More Moves Generalization",
                },
                {
                    'url' => "non-solvable-deals.html",
                    'title' => "Non-Solvable Deals",
                },
            ],
        },
        {
            'url' => "scans",
            'title' => "Scanning",
            'subs' =>
            [
                {
                    'url' => "tests_order.html",
                    'title' => "Specifying the Order of Tests",
                },
                {
                    'url' => "befs.html",
                    'title' => "Best-First Search",
                },
                {
                    'url' => "soft_dfs.html",
                    'title' => "Soft DFS",
                },
                {
                    'url' => "brfs_optimization.html",
                    'title' => "The BrFS Optimization Scan",
                },
            ],
        },
        {
            'url' => "state_representation",
            'title' => "The State Representation",
            'subs' =>
            [
                {
                    'url' => "data_type_diet.html",
                    'title' => "Reducing the Data Type Bit-Width",
                },
                {
                    'url' => "ptrs_to_stacks.html",
                    'title' => "Pointers to Stacks",
                },
                {
                    'url' => "original_indices",
                    'title' => "Remembering the Original Stack and Freecell Locations",
                    'subs' =>
                    [
                        {
                            'url' => "solution.html",
                            'title' => "Solution",
                        },
                    ],
                },
            ],
        },
        {
            'url' => "board_gen.html",
            'title' => "Board Auto-Generators",
        },
        {
            'url' => "why_not_cpp.html",
            'title' => "Why not C++?",
        },
        {
            'url' => "flame_war.html",
            'title' => "The fc-solve-discuss flame-war",
        },
        {
            'url' => "api.html",
            'title' => "The story of the user API",
        },
        {
            'url' => "autoconf.html",
            'title' => "Auto-confisication and Friends",
        },
        {
            'url' => "freshmeat_effect.html",
            'title' => "The Freshmeat Effect (and how to avoid it)",
        },
        #{
        #    'url' => "move_stacks.html",
        #'title' => "The Move Stacks",
        #},
        {
            'url' => "finale",
            'title' => "Finale",
            'subs' =>
            [
                {
                    'url' => "links.html",
                    'title' => "Links and References",
                },
                {
                    'url' => "book.html",
                    'title' => "Freecell Solver - EoaCP - The Book",
                },
            ],
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
