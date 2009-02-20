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
                    'text' => "When C is the Best?",
                    'url' => "philosophy/computers/when-c-is-best/",
                    'title' => "An Essay that Explains when the C Language should be used instead of Other Languages",
                    'subs' =>
                    [
                        {
                            'text' => "The Text Itself",
                            'url' => "philosophy/computers/when-c-is-best/when-c-is-the-best.html",
                        },
                    ],
                },
                {
                    'text' => "Open Source",
                    'url' => "philosophy/computers/open-source/",
                    subs =>
                    [
                        {
                            'text' => "What is Open Source?",
                            'url' => "philosophy/foss-other-beasts/",
                            'title' => "Open Source, Free Software and Other Beasts",
                        },
                        {
                            'text' => "GPL, BSD and Suckerism",
                            'url' => "philosophy/computers/open-source/gpl-bsd-and-suckerism/",
                            'title' => "The GPL, The BSD Licence and Being a Sucker",
                        },
                        {
                            'text' => "The Linus Bus Factor",
                            'url' => "philosophy/computers/open-source/linus-torvalds-bus-factor/",
                            'title' => "The Virtue of Multiple Committers and Overthrowing the Benevolent Dictator",
                        },
                    ],
                },
                {
                    'text' => "Software Management",
                    'url' => "philosophy/computers/software-management/",
                    'title' => "Managing Software Teams, People, Projects",
                    subs =>
                    [
                        {
                            'text' => "The End of IT Slavery",
                            'url' => "philosophy/computers/software-management/end-of-it-slavery/",
                            'title' => "The end of Info-Tech/High-Tech slavery - if you want great people to work for you, make sure they love your workplace",
                        },
                    ],
                },
                {
                    'text' => "What Makes Software High-Quality?",
                    'url' => "philosophy/computers/high-quality-software/",
                    'subs' =>
                    [
                        {
                            'text' => "2nd Revision",
                            'url' => "philosophy/computers/high-quality-software/rev2/",
                            'title' => "'What Makes Software High Quality?' - Revision 2",
                        },
                    ],
                },
                {
                    'text' => "Perl",
                    'url' => "philosophy/computers/perl/",
                    'title' => "Articles Related to the Perl Programming Language",
                    subs =>
                    [
                        {
                            'text' => "Perl &amp; Newcomers",
                            'url' => "philosophy/perl-newcomers/",
                            'title' => "&quot;Usability&quot; of the Perl Online World for Newcomers",
                        },
                        {
                            'text' => "The Joy of Perl",
                            'url' => "philosophy/computers/perl/joy-of-perl/",
                            'title' => "An Essay about why I Like Perl so much.",
                            'subs' =>
                            [
                                {
                                    'text' => "The Text Itself",
                                    'url' => "philosophy/computers/perl/joy-of-perl/joy-of-perl.html",
                                },
                            ],
                        },
                        {
                            'text' => "Perl 6 Critique",
                            'url' => "philosophy/computers/perl/perl6-critique/",
                            'title' => "Critique of where Perl 6 is Heading",
                        },
                    ],
                },
                {
                    text => "Web",
                    url => "philosophy/computers/web/",
                    title => "Web-related Articles",
                    subs =>
                    [
                        {
                            'text' => "Create a Homesite",
                            'url' => "philosophy/computers/web/create-a-great-personal-homesite/",
                            'title' => "Create a Great Personal Homesite",
                        },
                        {
                            'text' => "Which Wiki?",
                            'url' => "philosophy/computers/web/which-wiki/",
                            'title' => "Which Open Source Wiki Engine Works for you",
                            'subs' =>
                            [
                                {
                                    'text' => "July 2006 Update",
                                    'url' => "philosophy/computers/web/which-wiki/update-2006-07/",
                                },
                            ],
                        },
                        {
                            'text' => "Choice of Doc Formats",
                            'url' => "philosophy/computers/web/choice-of-docs-formats/",
                            'title' => "Coverage of the Current Choice of Document Formats",
                        },
                        {
                            'text' => "The \"Use qmail instead\" Syndrome",
                            'url' => "philosophy/computers/web/use-qmail-instead/",
                        },
                        {
                            'text' => "Homepage vs. Blog",
                            'url' => "philosophy/computers/web/homepage-vs-blog/",
                        },
                        {
                            'text' => "Online Communities",
                            'url' => "philosophy/computers/web/online-communities/",
                            'title' => "Reflections on Online Communities",
                        },
                    ],
                },
                {
                    'text' => "Education",
                    'url' => "philosophy/computers/education/",
                    'title' => "Articles about Computer Learning and Education",
                    'subs' =>
                    [
                        {
                            'text' => "EE in the Technion",
                            'url' => "philosophy/computers/education/opinion-on-the-technion/",
                            'title' => "My Opinion on Electrical Engineering Stuies in the Technion",
                        },
                        {
                            'text' => "Best Introudctory Language",
                            'url' => "philosophy/computers/education/introductory-language/",
                            'title' => "What is the best Introductory Programming Language?",
                        },
                    ],
                },
                {
                    'text' => "My Memoirs",
                    'url' => "prog-evolution/",
                    'title' => "My Memoirs as a Programmer",
                    'subs' =>
                    [
                        {
                            'text' => "Pre-Elpas",
                            'url' => "prog-evolution/pre-elpas.html",
                            'title' => ("Memoirs as a Programmer from" 
                                . " Elementary School, High School, etc."),
                        },
                        {
                            'text' => "At Elpas",
                            'url' => "prog-evolution/shlomif-at-elpas.html",
                            'title' => ("Memoirs as a Programmer from"
                                . " Elpas, which was my first workplace as a"
                                . " programmer"
                            ),
                        },
                    ],
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
                {
                    'text' => "Case for File Swapping",
                    'url' => "philosophy/case-for-file-swapping/",
                    'title' => "Why File Swapping is Ethical and Moral and should be Legal",
                    'subs' =>
                    [
                        {
                            'text' => "Revision 3 Text",
                            'url' => "philosophy/case-for-file-swapping/revision-3/",
                            'title' => "Text of the Third Revision",
                        },
                    ],
                },
                {
                    'text' => "Why Scientology is Bad",
                    'url' => "philosophy/politics/why-scientology-is-bad/",
                    'title' => "How I Concluded that Scientology is Bad",
                },
                {
                    'text' => "Case for Drug Legalisation",
                    'url' => "philosophy/politics/drug-legalisation/",
                    'title' => "Why the War on Drugs is the Real Drug Problem",
                    'subs' =>
                    [
                        {
                            'text' => "Hebrew Translation",
                            'url' => "philosophy/politics/drug-legalisation/hebrew.html",
                        },
                    ],
                },
                {
                    'text' => "Define \"Zionism\"!",
                    'url' => "philosophy/politics/define-zionism/",
                    'title' => ("What is &quot;Zionism&quot; really? What " . 
                        "does anti-Israel, anti-Zionist, etc. mean?"),
                },
                {
                    'text' => "Dispelling Some Myths about Israel",
                    'url' => "philosophy/politics/dispelling-myths-about-israel/",
                },
            ],
        },
        {
            'text' => "Philosophy",
            'url' => "philosophy/philosophy/",
            'title' => "Writings about General Philosophy",
            'subs' =>
            [
                {
                    'text' => "The Eternal Jew",
                    'url' => "philosophy/the-eternal-jew/",
                    'title' => "The Eternal Jew - An Essay about the value of Self",
                },
                {
                    'text' => "Guide to Neo-Tech",
                    'url' => "philosophy/philosophy/guide-to-neo-tech/",
                },
                {
                    'text' => "Advice for the Young",
                    'url' => "philosophy/philosophy/advice-for-the-young/",
                    'title' => "Advice for the Young (and for the not-so Young)",
                },
            ],
        },
        {
            'text' => "Random Ideas",
            'url' => "philosophy/ideas/",
            'title' => "Various Random (and Practical) Ideas I Have",
            'subs' =>
            [
                {
                    'text' => "Fortunes Mania",
                    'url' => "philosophy/ideas/fortunes-mania/",
                    'title' => "A community site for collecting and organising fortune cookies",
                },
                {
                    'text' => "Unixdoc",
                    'url' => "philosophy/ideas/unixdoc/",
                    'title' => "An Integrated Offline and Online Documentation Framework",
                },
            ],
        },
        {
            'text' => "By Others",
            'url' => "philosophy/by-others/",
            subs =>
            [
                {
                    'text' => "James Carr - &quot;Completely Overrated&quot;",
                    'url' => "philosophy/by-others/james-carr--completely-overrated.html",
                    'title' => "James Carr about the anti-Muslim Cartoons",
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
            'tree_contents' => $essays_tree_contents,
        );
}

1;

