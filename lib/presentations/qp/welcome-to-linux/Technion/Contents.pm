package Contents;

use strict;

my $contents =
{
    'title' => "Software Development under Linux",
    'subs' =>
    [
        {
            'url' => "why.html",
            'title' => "Why Program under Linux? (Briefly)",
        },
        {
            'url' => "gcc",
            'title' => "Use of gcc/g++",
            'subs' =>
            [
                {
                    'url' => "flags.html",
                    'title' => "Important gcc Flags",
                },
                {
                    'url' => "gpp.html",
                    'title' => "g++",
                },
            ],
        },
        {
            'url' => "makefiles",
            'title' => "Writing Makefiles",
            'subs' =>
            [
                {
                    'url' => "basics.html",
                    'title' => "Makefile Basics",
                },
                {
                    'url' => "variables.html",
                    'title' => "Makefile Variables",
                },
                {
                    'url' => "notes.html",
                    'title' => "Final Notes",
                },
            ],
        },
        {
            'url' => "emacs",
            'title' => "The Almighty Emacs",
            'subs' =>
            [
                {
                    'url' => "more.html",
                    'title' => "More Emacs",
                },
                {
                    'url' => "yet-more.html",
                    'title' => "Yet More Emacs",
                },
                {
                    'url' => "end.html",
                    'title' => "Emacs - The End (Well at Least the Last Slide)",
                },
            ],
            'images' => ['test.c'],
        },
        {
            'url' => "gdb",
            'title' => "The gdb Debugger",
            'subs' =>
            [
                {
                    'url' => "basic.html",
                    'title' => "Basic gdb Commands",
                },
            ],
        },
        {
            'url' => "ddd",
            'title' => "DDD - The Data Display Debugger",
            'subs' =>
            [
                {
                    'url' => "tips.html",
                    'title' => "DDD Debugging Tips",
                },
            ],
            'images' => ['testddd.c'],
        },
        {
            'url' => "valgrind",
            'title' => "valgrind - a Good Tool to Detect Memory Problems",
            'subs' =>
            [
                {
                    'url' => "more.html",
                    'title' => "More Valgrind",
                },
            ],
        },
    ],
    'images' =>
    [
        'style.css'
    ],
};

sub get_contents
{
    return $contents;
}

1;
