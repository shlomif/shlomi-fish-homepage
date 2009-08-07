package Contents;

use strict;

my $contents =
{
    'title' => "\"Perl for Perl Newbies\" - Part 5 - Good Programming Practices",
    'subs' =>
    [
        {
            url => "intro.html",
            title => "Introduction",
        },

        {
            url => "testing",
            title => "Automated Testing",
            subs =>
            [
                {
                    url => "motivation.html",
                    title => "Motivation for Testing",
                },
                {
                    url => "demo",
                    title => "Demo",
                    subs =>
                    [
                        {
                            url => "test-more.html",
                            title => "Test::More",
                        },
                        {
                            url => "Build-test.html",
                            title => "./Build test",
                        },
                    ],
                },
                {
                    url => "types.html",
                    title => "Types of Tests: Unit Tests, Integration Tests, System Tests",
                },
                {
                    url => "mocking.html",
                    title => "Mocking",
                },
                {
                    url => "data-driven",
                    title => "Data-Driven Testing",
                    subs =>
                    [
                        {
                            url => "fit.html",
                            title => "FIT",
                        },
                        {
                            url => "Test-Base.html",
                            title => "Test-Base",
                        },
                    ],
                },
            ],
        },

        {
            url => "version-control",
            title => "Version Control",
            subs =>
            [
                {
                    url => "motivation.html",
                    title => "Motivation for Version Control",
                },
                {
                    url => "subversion-demo.html",
                    title => "Demo of Subversion",
                },
            ],
        },

        {
            url => "accessors",
            title => "Class Accessors",
            subs =>
            [
                {
                    url => "example.html",
                    title => "Example",
                },
                {
                    url => "motivation.html",
                    title => "Motivation",
                },
                {
                    url => "cpan-modules.html",
                    title => "Accessor modules on the CPAN",
                },
            ],
        },

        {
            url => "new-features",
            title => "Useful Features in Recent Perls",
            subs =>
            [
                {
                    url => "use-base.html",
                    title => "use base",
                },
                {
                    url => "lexical-filehandles.html",
                    title => "Lexical Filehandles",
                },
            ],
        },
        {
            url => "local-keyword",
            title => "The local keyword",
            subs =>
            [
                {
                    url => "use-and-abuse.html",
                    title => "Use and Abuse",
                },
            ],
        },
    ],
    'images' =>
    [
        'style.css',
        'somerights20.gif',
        qw(
testing/demo/Add1.pm
testing/demo/add1-test-2.pl
testing/demo/add1-test.pl
testing/demo/Add2.pm
testing/demo/add2-test-2.pl
testing/demo/Test-More-1.t
        ),
    ],
};

sub get_contents
{
    return $contents;
}

1;
