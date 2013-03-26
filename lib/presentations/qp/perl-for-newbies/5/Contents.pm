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
                    url => "mercurial-demo.html",
                    title => "Demo of Mercurial",
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
        {
            url => "pod-documentation",
            title => "Using POD for Documentation",
            subs =>
            [
                {
                    url => "demo.html",
                    title => "POD Demonstration",
                },
                {
                    url => "pod-testing.html",
                    title => "Testing and Verifying POD",
                },
                {
                    url => "literate-programming.html",
                    title => "Literate Programming",
                },
                {
                    url => "extensions.html",
                    title => "POD Extensions",
                },
            ],
        },
        {
            url => "module-build-and-starter",
            title => "Module-Build and Module-Starter",
            subs =>
            [
                {
                    url => "invocation.html",
                    title => "The Module-Starter Invocation Command",
                },
                {
                    url => "commands.html",
                    title => "Module-Build commands",
                },
                {
                    url => "coding.html",
                    title => "Adding meaningful code",
                },
                {
                    url => "boilerplate.html",
                    title => "Getting rid of the boilerplate",
                },
                {
                    url => "additional-resources.html",
                    title => "Additional Resources",
                },
            ],
        },
        {
            url => "conclusion",
            title => "Conclusion",
            subs =>
            [
                {
                    url => "links.html",
                    title => "Links",
                },
                {
                    url => "thanks.html",
                    title => "Thanks",
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
module-build-and-starter/module-starter.help.txt
module-build-and-starter/perl-Build-PL-1-output.txt
module-build-and-starter/perl-Build-and-Build-test-1.txt
version-control/MyModule.pm
        ),
    ],
};

sub get_contents
{
    return $contents;
}

1;
