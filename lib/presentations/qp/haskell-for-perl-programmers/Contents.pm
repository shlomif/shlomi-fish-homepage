package Contents;

use strict;

my $contents =
{
    'title' => "Haskell for Perl Programmers",
    'subs' =>
    [
        {
            'url' => "intro.html",
            'title' => "Introduction",
        },
        {
            'url' => "basic",
            'title' => "Basic Examples",
            'subs' =>
            [
                {
                    'url' => "recursion.html",
                    'title' => "Recursion",
                },
                {
                    'url' => "lists.html",
                    'title' => "Lists",
                },
            ],
        },
        {
            'url' => "infinite_lists",
            'title' => "Infinite Lists",
            'subs' =>
            [
                {
                    'url' => "fibonacci.html",
                    'title' => "Fibonacci with Lists",
                },
                {
                    'url' => "primes1.html",
                    'title' => "Primes (with low efficiency)",
                },
                {
                    'url' => "primes2.html",
                    'title' => "Primes (with better efficiency)",
                },
            ],
        },
        {
            'url' => "list_manip",
            'title' => "List and String Manipulation Routines",
            'subs' =>
            [
                {
                    'url' => "examples.html",
                    'title' => "Examples",
                },
                {
                    'url' => "multimap.html",
                    'title' => "Multi-map Function",
                },
            ],
        },
        {
            'url' => "arrays",
            'title' => "Arrays",
            'subs' =>
            [
                {
                    'url' => "histogram.html",
                    'title' => "Histogram",
                },
                {
                    'url' => "hash.html",
                    'title' => "Hash",
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
