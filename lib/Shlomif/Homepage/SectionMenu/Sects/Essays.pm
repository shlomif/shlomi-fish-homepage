package Shlomif::Homepage::SectionMenu::Sects::Essays;

use strict;
use warnings;

use MyNavData;

my $essays_tree_contents =
{
    'host' => "t2",
    'text' => "Shlomi Fish' Essays",
    'title' => "Shlomi Fish' Essays",
    'show_always' => 1,
    'subs' =>
    [
        {
            'text' => "Essays",
            'url' => "philosophy/",
            'title' => "Nav Menu for Shlomi Fish' Essays",
        },
        {
            'text' => "Index to Essays",
            'url' => "philosophy/Index/",
            'title' => "Index to Essays and Articles I wrote.",
        },
        {
            'text' => "Recommended Books",
            'url' => "philosophy/books-recommends/",
            'title' => "Recommendations of Good Books I read and was Enlightened by.",
        },
        {
            'text' => "Computing",
            'url' => "philosophy/computers/",
            'title' => "Computing-related Essays and Articles",
            'subs' =>
            [
                {
                    'text' => "What is Open Source?",
                    'url' => "philosophy/foss-other-beasts/",
                    'title' => "Free Software, Open Source and Other Beasts",
                },
                {
                    'text' => "Perl &amp; Newcomers",
                    'url' => "philosophy/perl-newcomers/",
                    'title' => "&quot;Usability&quot; of the Perl Online World for Newcomers",
                },
                {
                    'text' => "When C is the Best?",
                    'url' => "philosophy/computers/when-c-is-best/",
                    'title' => "An Essay that Explains when the C Language should be used instead of Other Languages",
                },
                {
                    'text' => "The Joy of Perl",
                    'url' => "philosophy/computers/perl/joy-of-perl/",
                    'title' => "An Essay about why I Like Perl so much.",
                },
                {
                    'text' => "Perl 6 Critique",
                    'url' => "philosophy/computers/perl/perl6-critique/",
                    'title' => "Critique of where Perl 6 is Heading",
                },
                {
                    'text' => "Which Wiki?",
                    'url' => "philosophy/computers/web/which-wiki/",
                    'title' => "Which Open Source Wiki Engine Works for you",
                },
            ],
        },
        {
            'text' => "Political Essays",
            'url' => "philosophy/politics/",
            'title' => "Essays about Politics and Philosophical Politics",
            'subs' =>
            [
                {
                    'text' => "Objectivism and Open Source",
                    'url' => "philosophy/obj-oss/",
                    'title' => "Objectivism and Open Source",
                },
                {
                    'text' => "Israeli-Palestinian Conflict",
                    'url' => "philosophy/israel-pales/",
                    'title' => "A Solution to the Israeli Palestinian Conflict",
                },
            ],
        },
        {
            'text' => "The Eternal Jew",
            'url' => "philosophy/the-eternal-jew/",
            'title' => "The Eternal Jew - An Essay about the value of Self",
        },
    ],
};

sub get_params
{
    return 
        (
            'hosts' => MyNavData::get_hosts(),
            'tree_contents' => $essays_tree_contents,
        );
}

1;

