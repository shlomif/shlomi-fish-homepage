package Contents;

use strict;

my $contents =
{
    'title' => "Software Development on Linux",
    'subs' =>
    [
        {
            'url' => "devel-process.html",
            'title' => "The Linux Development process",
        },
        {
            'url' => "text-editing",
            'title' => "Editing Text using Text Editors",
            'subs' =>
            [
                {
                    'url' => "text-nuances.html",
                    'title' => "Text Nuances",
                },
                {
                    'url' => "editors.html",
                    'title' => "Recommended Editors for Beginners",
                },
                {
                    'url' => "advanced-editors.html",
                    'title' => "Advanced Editors",
                },
            ],
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
            'url' => "gdb",
            'title' => "The gdb Debugger",
            'subs' =>
            [
                {
                    'url' => "basics_cmds.html",
                    'title' => "Basic gdb Commands",
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
                },
            ],
        },
        {
            'url' => "valgrind",
            'title' => "valgrind - a Memory Problems Detector",
            'subs' =>
            [
                {
                    'url' => "more.html",
                    'title' => "More Valgrind",
                },
            ],
        },
        {
            'url' => "IDEs",
            'title' => "Integrated Development Environments",
            'subs' =>
            [
                {
                    'url' => "alternatives.html",
                    'title' => "The Various Available Alternatives",
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
