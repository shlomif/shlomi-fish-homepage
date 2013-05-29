package Contents;

use strict;

my $contents =
{
    'title' => "Freecell Solver - The Next Presentation",
    'subs' =>
    [
        {
            'url' => "multi-tasking",
            'title' => "Multi-Tasking",
            'subs' =>
            [
                {
                    'url' => "ht-st.html",
                    'title' => "Hard Threads and Soft Threads",
                },
                {
                    'url' => "best-meta-scan",
                    'title' => "Generating the Best Meta Scan",
                    'subs' =>
                    [
                        {
                            'url' => "switch.html",
                            'title' => "Naive Approach - Scan Switching",
                        },
                        {
                            'url' => "prelude.html",
                            'title' => "More Sophisticated - Prelude",
                        },
                        {
                            'url' => "opt-algorithm.html",
                            'title' => "Optimization Algorithm",
                        },
                    ],
                },
            ],
        },
        {
            'url' => "indirect-ss-opt",
            'title' => "Indirect Stack States Optimizations",
            'subs' =>
            [
                {
                    'url' => "cow.html",
                    'title' => "Copy on Write Stacks",
                },
                {
                    'url' => "compact-alloc.html",
                    'title' => "Compact Allocation using Memory Pools",
                },
                {
                    'url' => "result.html",
                    'title' => "Result",
                },
            ],
        },
        {
            'url' => 'cmd-line',
            'title' => "Command Line Processing",
            'subs' =>
            [
                {
                    'url' => "generic-func.html",
                    'title' => "Generic Function for CL Processing",
                },
                {
                    'url' => "read-from-file.html",
                    'title' => "--read-from-file",
                },
                {
                    'url' => "presets.html",
                    'title' => "Solver Presets",
                },
                {
                    'url' => "recycle.html",
                    'title' => "Recycling Solver Instances",
                },
            ],
        },
        {
            'url' => "fc-pro",
            'title' => "Freecell Pro Interoperability",
            'subs' =>
            [
                {
                    'url' => "problem.html",
                    'title' => "The Problem",
                },
                {
                    'url' => "solution.html",
                    'title' => "The Solution",
                },
            ],
        },
        {
            'url' => "parent-links.html",
            'title' => "To Parent Links",
        },
        {
            'url' => "michael-mann.html",
            'title' => "The Michael Mann \"Fork\"",
        },
        {
            'url' => "future",
            'title' => "Future Directions",
            'subs' =>
            [
                {
                    'url' => "to-do.html",
                    'title' => "To Do",
                },
                {
                    'url' => "my-involvement.html",
                    'title' => "My Involvement",
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

1;
