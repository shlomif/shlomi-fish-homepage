package Contents;

use strict;

my $contents =
{
    'title' => "Perl for Newbies - Part 3 - Modules and Objects",
    'subs' =>
    [
        {
            'title' => "Introduction",
            'url' => "intro",
            'subs' =>
            [
                {
                    'title' => "References to Functions",
                    'url' => "refs_to_funcs.html",
                },
                {
                    'title' => "Modules and Packages",
                    'url' => "modules.html",
                },
                {
                    'title' => "Objects",
                    'url' => "objects.html",
                },
                {
                    'title' => "A Note about Source Files",
                    'url' => "note_about_files.html",
                },
            ],
        },
        {
            'title' => "References to Functions",
            'url' => "refs_to_funcs",
            'subs' =>
            [
                {
                    'title' => "Taking the Reference of a Function",
                    'url' => "taking.html",
                },
                {
                    'title' => "Calling a Function by its Reference",
                    'url' => "calling.html",
                },
                {
                    'title' => "Dynamic References to Functions",
                    'url' => "dynamic",
                    'subs' =>
                    [
                        {
                            'title' => "Behaviour of Functions inside Functions",
                            'url' => "behaviour.html",
                        },
                        {
                            'title' => "Demo: A Dispatch Function",
                            'url' => "dispatch.html",
                        },
                        {
                            'title' => "Lambda Calculus",
                            'url' => "lambda-calculus.html",
                        }
                    ],
                },
            ],
        },
        {
            'url' => "modules",
            'title' => "Perl Modules",
            'subs' =>
            [
                {
                    'url' => "declaring",
                    'title' => "Declaring a Package",
                    'subs' =>
                    [
                        {
                            'url' => "where.html",
                            'title' => "Where to find a module",
                        },
                    ],
                },
                {
                    'url' => "loading",
                    'title' => "Loading Modules and Importing their Functions",
                    # Tell about use My::Module;
                    'subs' =>
                    [
                        {
                            'url' => "accessing.html",
                            'title' => "Accessing Functions from a Different Module",
                        },
                        {
                            'url' => "exporting.html",
                            'title' => "Exporting and Importing Functions",
                        },
                        {
                            'url' => "variables.html",
                            'title' => "Using Variables from a Different Namespace",
                        },
                    ],
                },
                {
                    'url' => "begin_end.html",
                    'title' => "BEGIN and END",
                },
                {
                    'url' => "main.html",
                    'title' => "The \"main\" Namespace",
                },
                {
                    'url' => "difference.html",
                    'title' => "Difference between Namespaces and Modules",
                },
            ],
        },
        {
            'url' => "objects",
            'title' => "Objects in Perl",
            'subs' =>
            [
                {
                    'url' => "how_it_works.html",
                    'title' => "How it Works behind the Scenes",
                },
                {
                    'url' => "object_use",
                    'title' => "Object Use",
                    'subs' =>
                    [
                        {
                            'url' => "methods.html",
                            'title' => "Calling the Methods of an Object",
                        },
                    ],
                },
                {
                    'url' => "making",
                    'title' => "Making Your Own Objects",
                    'subs' =>
                    [
                        {
                            'url' => "constructor.html",
                            'title' => "The Constructor",
                        },
                        {
                            'url' => "methods.html",
                            'title' => "Defining Methods",
                        },
                        {
                            'url' => "inheritance",
                            'title' => "Object Inheritance",
                            'subs' =>
                            [
                                {
                                    'url' => "super.html",
                                    'title' => "Calling Overriden Methods of Base Classes",
                                },
                            ],
                        },
                        {
                            'url' => "destructor.html",
                            'title' => "The Destructor",
                        },
                    ],
                },
                {
                    'url' => "utils.html",
                    'title' => "Object Utility Functions - isa() and can()",
                },
            ],
        },
        {
            'url' => "finale",
            'title' => "Finale",
            'subs' =>
            [
                {
                    'url' => "links.html",
                    'title' => "Links and References",
                },
            ],
        },
    ],
    'images' =>
    [
        'style.css',
        'somerights20.gif',
        qw(
modules/declaring/Hoola/Hoop.pm
modules/declaring/MyModule.pm
modules/loading/Calc.pm
modules/loading/exporting_code.pl
modules/loading/MyModule.pm
modules/loading/MyVar.pm
modules/loading/test_export.pl
modules/loading/test_myvar.pl
modules/loading/test.pl
modules/MyLog.pm
objects/making/Bar2.pm
objects/making/Count.pm
objects/making/Foo2/Foo.pm
objects/making/Foo2/test.pl
objects/making/Foo.more-methods.pm
objects/making/Foo.orig.pm
objects/making/Foo.pm
objects/making/inheritance/Bar2.pm
objects/making/inheritance/Bar.pm
objects/making/inheritance/Foo.pm
objects/making/inheritance/test_bar2.pl
objects/making/inheritance/test_bar.pl
objects/making/test_count.pl
objects/making/test_methods.pl
objects/making/test.pl
objects/object_use/data_dumper.pl
refs_to_funcs/calling1.pl
refs_to_funcs/dynamic/closures.pl
refs_to_funcs/dynamic/dispatch.pl
refs_to_funcs/dynamic/dynamic.pl
        ),
    ],
};

sub get_contents
{
    return $contents;
}

