package Shlomif::Homepage::SectionMenu::Sects::Essays;

use strict;
use warnings;

use utf8;
use MyNavData;

my $essays_tree_contents =
{
    host => "t2",
    text => "Shlomi Fish’s Essays",
    title => "Shlomi Fish’s Essays",
    show_always => 1,
    subs =>
    [
        {
            text => "Essays",
            url => "philosophy/",
            title => "Nav Menu for Shlomi Fish’s Essays",
        },
        {
            text => "Index to Essays",
            url => "philosophy/Index/",
            title => "Index to Essays and Articles I wrote.",
        },
        {
            text => "Book Reviews",
            url => "philosophy/books-recommends/",
            title => "Reviews of Books I read.",
        },
        {
            text => "Philosophy",
            url => "philosophy/philosophy/",
            title => "Writings about General Philosophy",
            subs =>
            [
                {
                    text => "The Eternal Jew",
                    url => "philosophy/the-eternal-jew/",
                    title => "The Eternal Jew - An Essay about the value of Self",
                },
                {
                    text => "Guide to Neo-Tech",
                    url => "philosophy/philosophy/guide-to-neo-tech/",
                },
                {
                    text => "Advice for the Young",
                    url => "philosophy/philosophy/advice-for-the-young/",
                    title => "Advice for the Young (and for the not-so Young)",
                },
                {
                    text => "Why Closed Books are So 19th Century",
                    url => "philosophy/philosophy/closed-books-are-so-19th-century/",
                    title => "Why authors of books should make sure they are publicly available online.",
                },
                {
                    text => "Putting all the Cards on the Table (2013)",
                    url => "philosophy/philosophy/putting-all-cards-on-the-table-2013/",
                    title => "A snapshot of my personal philosophy as of March 2013",
                }
            ],
        },
        {
            text => "Psychology",
            url => "philosophy/psychology/",
            title => "Writings about Psychology",
            subs =>
            [
                {
                    text => "Dealing with Hypomanias",
                    url => "philosophy/psychology/hypomanias/",
                    title => "How I deal with the bad psychological periods that affect me",
                },
                {
                    text => "The Elephant in the Circus",
                    url => "philosophy/psychology/elephant-in-the-circus/",
                    title => "A (non-original) story with self-growth implications",
                    subs =>
                    [
                        {
                            text => "Hebrew Translation",
                            url => "philosophy/psychology/elephant-in-the-circus/hebrew.html",
                        },
                    ],
                },
            ],
        },
        {
            text => "Political Essays",
            url => "philosophy/politics/",
            title => "Essays about Politics and Philosophical Politics",
            subs =>
            [
                {
                    text => "#SummerNSA",
                    url => "philosophy/SummerNSA/",
                    title => "The #SummerNSA / “Summerschool at the NSA” effort",
                    subs =>
                    [
                        {
                            text => "A #SummerNSA’s Reading",
                            url => "philosophy/SummerNSA/A-SummerNSA-Reading/",
                            title => "Summarising the #SummerNSA effort so far.",
                        },
                        {
                            text => "Letter to Summer Glau on Oct 2014",
                            url => "philosophy/SummerNSA/Letter-to-SGlau-2014-10/",
                        },
                        {
                            text => "Sep 2014 Call for Action",
                            url => "philosophy/philosophy/SummerNSA-2014-09-call-for-action/",
                        },
                    ],
                },
                {
                    text => "Objectivism and Open Source",
                    url => "philosophy/obj-oss/",
                    title => "Objectivism and Open Source",
                    subs =>
                    [
                        {
                            text => "Revision 2",
                            url => "philosophy/obj-oss/rev2/",
                            title => "Revision 2 of the Objectivism and Open Source Article",
                        },
                    ],
                },
                {
                    text => "Israeli-Palestinian Conflict",
                    url => "philosophy/israel-pales/",
                    title => "A Solution to the Israeli Palestinian Conflict",
                },
                {
                    text => "Case for File Swapping",
                    url => "philosophy/case-for-file-swapping/",
                    title => "Why File Swapping is Ethical and Moral and should be Legal",
                    subs =>
                    [
                        {
                            text => "Revision 3 Text",
                            url => "philosophy/case-for-file-swapping/revision-3/",
                            title => "Text of the Third Revision",
                        },
                    ],
                },
                {
                    text => "Why Scientology is Bad",
                    url => "philosophy/politics/why-scientology-is-bad/",
                    title => "How I Concluded that Scientology is Bad",
                },
                {
                    text => "Case for Drug Legalisation",
                    url => "philosophy/politics/drug-legalisation/",
                    title => "Why the War on Drugs is the Real Drug Problem",
                    subs =>
                    [
                        {
                            text => "Hebrew Translation",
                            url => "philosophy/politics/drug-legalisation/hebrew.html",
                        },
                    ],
                },
                {
                    text => "Define “Zionism”!",
                    url => "philosophy/politics/define-zionism/",
                    title => ("What is “Zionism” really? What " .
                        "does anti-Israel, anti-Zionist, etc. mean?"),
                    subs =>
                    [
                        {
                            text => "Hebrew Translation",
                            url => "philosophy/politics/define-zionism/heb/",
                        },
                    ],
                },
                {
                    text => "Dispelling Some Myths about Israel",
                    url => "philosophy/politics/dispelling-myths-about-israel/",
                },
                {
                    text => "Opinion on DeCSS",
                    url => "DeCSS/",
                    title => "My Opinion on the DeCSS (= DVDs’ de-scrambling code) fiasco",
                },
            ],
        },
        {
            text => "Computing",
            url => "philosophy/computers/",
            title => "Computing-related Essays and Articles",
            subs =>
            [
                {
                    text => "When C is the Best?",
                    url => "philosophy/computers/when-c-is-best/",
                    title => "An Essay that Explains when the C Language should be used instead of Other Languages",
                    subs =>
                    [
                        {
                            text => "The Text Itself",
                            url => "philosophy/computers/when-c-is-best/when-c-is-the-best.html",
                        },
                    ],
                },
                {
                    text => "Open Source",
                    url => "philosophy/computers/open-source/",
                    subs =>
                    [
                        {
                            text => "What is Open Source?",
                            url => "philosophy/foss-other-beasts/",
                            title => "Open Source, Free Software and Other Beasts",
                        },
                        {
                            text => "How to Contribute to Open Source",
                            url => "philosophy/computers/open-source/how-to-start-contributing/",
                            title => "How can one start contributing to free and open-source software (FOSS)",
                            subs =>
                            [
                                {
                                    text => "Mirror of Longer Document",
                                    url => "philosophy/computers/open-source/how-to-start-contributing/tos-document.html",
                                },
                            ],
                        },
                        {
                            text => "GPL, BSD and Suckerism",
                            url => "philosophy/computers/open-source/gpl-bsd-and-suckerism/",
                            title => "The GPL, The BSD Licence and Being a Sucker",
                        },
                        {
                            text => "The Linus Bus Factor",
                            url => "philosophy/computers/open-source/linus-torvalds-bus-factor/",
                            title => "The Virtue of Multiple Committers and Overthrowing the Benevolent Dictator",
                        },
                        {
                            text => "FOSS Licences Wars",
                            url => "philosophy/computers/open-source/foss-licences-wars/",
                            title => "An overview of open-source licences and some recommendations and opinions",
                        },
                        {
                            text => "Why I Don’t Trust Non-FOSS",
                            url => "philosophy/computers/open-source/trust-non-FOSS/",
                        },
                    ],
                },
                {
                    text => "Software Management",
                    url => "philosophy/computers/software-management/",
                    title => "Managing Software Teams, People, Projects",
                    subs =>
                    [
                        {
                            text => "The End of IT Slavery",
                            url => "philosophy/computers/software-management/end-of-it-slavery/",
                            title => "The end of Info-Tech/High-Tech slavery - if you want great people to work for you, make sure they love your workplace",
                        },
                        {
                            text => "The Perfect Info-Tech Workplace",
                            url => "philosophy/computers/software-management/perfect-workplace/",
                            title => "How to make an Info-Tech Workplace Where Programmers Will Be Happy, Want to Stay, Be Super-Productive and Efficient and will Rave About",
                            subs =>
                            [
                                {
                                    text => "Revision 1",
                                    url => "philosophy/computers/software-management/perfect-workplace/perfect-it-workplace.xhtml",
                                },
                            ],
                        },
                    ],
                },
                {
                    text => "What Makes Software High-Quality?",
                    url => "philosophy/computers/high-quality-software/",
                    subs =>
                    [
                        {
                            text => "2nd Revision",
                            url => "philosophy/computers/high-quality-software/rev2/",
                            title => "“What Makes Software High Quality?” - Revision 2",
                        },
                    ],
                },
                {
                    text => "Optimising Code for Speed",
                    url => "philosophy/computers/optimizing-code-for-speed/",
                },
                {
                    text => "Perl",
                    url => "philosophy/computers/perl/",
                    title => "Articles Related to the Perl Programming Language",
                    subs =>
                    [
                        {
                            text => "Perl &amp; Newcomers",
                            url => "philosophy/perl-newcomers/",
                            title => "“Usability” of the Perl Online World for Newcomers",
                            subs =>
                            [
                                {
                                    text => "Version 1",
                                    url => "philosophy/perl-newcomers/v1/",
                                },
                            ],
                        },
                        {
                            text => "The Joy of Perl",
                            url => "philosophy/computers/perl/joy-of-perl/",
                            title => "An Essay about why I Like Perl so much.",
                            subs =>
                            [
                                {
                                    text => "The Text Itself",
                                    url => "philosophy/computers/perl/joy-of-perl/joy-of-perl.html",
                                },
                            ],
                        },
                        {
                            text => "Perl 6 Critique",
                            url => "philosophy/computers/perl/perl6-critique/",
                            title => "Critique of where Perl 6 is Heading",
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
                            text => "Create a Homesite",
                            url => "philosophy/computers/web/create-a-great-personal-homesite/",
                            title => "Create a Great Personal Homesite",
                            subs =>
                            [
                                {
                                    text => "Revision 2",
                                    url => "philosophy/computers/web/create-a-great-personal-homesite/rev2.html",
                                },
                            ],
                        },
                        {
                            text => "Which Wiki?",
                            url => "philosophy/computers/web/which-wiki/",
                            title => "Which Open Source Wiki Engine Works for you",
                            subs =>
                            [
                                {
                                    text => "July 2006 Update",
                                    url => "philosophy/computers/web/which-wiki/update-2006-07/",
                                },
                            ],
                        },
                        {
                            text => "Choice of Doc Formats",
                            url => "philosophy/computers/web/choice-of-docs-formats/",
                            title => "Coverage of the Current Choice of Document Formats",
                        },
                        {
                            text => "The “Use qmail instead” Syndrome",
                            url => "philosophy/computers/web/use-qmail-instead/",
                        },
                        {
                            text => "Homepage vs. Blog",
                            url => "philosophy/computers/web/homepage-vs-blog/",
                        },
                        {
                            text => "Online Communities",
                            url => "philosophy/computers/web/online-communities/",
                            title => "Reflections on Online Communities",
                        },
                    ],
                },
                {
                    text => "Education",
                    url => "philosophy/computers/education/",
                    title => "Articles about Computer Learning and Education",
                    subs =>
                    [
                        {
                            text => "EE in the Technion",
                            url => "philosophy/computers/education/opinion-on-the-technion/",
                            title => "My Opinion on Electrical Engineering Studies in the Technion",
                        },
                        {
                            text => "Best Introductory Language",
                            url => "philosophy/computers/education/introductory-language/",
                            title => "What is the best Introductory Programming Language?",
                        },
                    ],
                },
                {
                    text => "How to Get Help Online",
                    url => "philosophy/computers/how-to-get-help-online/",
                    title => "Where on the Internet one can get help with their (probably technical) problems",
                    subs =>
                    [
                        {
                            text => "2013 Edition",
                            url => "philosophy/computers/how-to-get-help-online/2013.html",
                        },
                    ],
                },
                {
                    text => "Netiquette",
                    url => "philosophy/computers/netiquette/",
                    title => "Articles and Links about Netiquette - the Internet Etiquette",
                    subs =>
                    [
                        {
                            text => "Email",
                            url => "philosophy/computers/netiquette/email/",
                            title => "Articles and Links about E-mail netiquette.",
                            subs =>
                            [
                                {
                                    text => "Start New Thread",
                                    url => "philosophy/computers/netiquette/email/start-new-thread.html",
                                    title => "How to start a new thread",
                                },
                                {
                                    text => "Reply to List",
                                    url => "philosophy/computers/netiquette/email/reply-to-list.html",
                                    title => "Reply to List on a Mailing List Post",
                                },
                            ],
                        },
                    ],
                },
                {
                    text => "My Memoirs",
                    url => "prog-evolution/",
                    title => "My Memoirs as a Programmer",
                    subs =>
                    [
                        {
                            text => "Pre-Elpas",
                            url => "prog-evolution/pre-elpas.html",
                            title => ("Memoirs as a Programmer from"
                                . " Elementary School, High School, etc."),
                        },
                        {
                            text => "At Elpas",
                            url => "prog-evolution/shlomif-at-elpas.html",
                            title => ("Memoirs as a Programmer from"
                                . " Elpas, which was my first workplace as a"
                                . " programmer"
                            ),
                        },
                    ],
                },
            ],
        },
        {
            text => "Random Ideas",
            url => "philosophy/ideas/",
            title => "Various Random (and Practical) Ideas I Have",
            subs =>
            [
                {
                    text => "Fortunes Mania",
                    url => "philosophy/ideas/fortunes-mania/",
                    title => "A community site for collecting and organising fortune cookies",
                },
                {
                    text => "Unixdoc",
                    url => "philosophy/ideas/unixdoc/",
                    title => "An Integrated Offline and Online Documentation Framework",
                },
            ],
        },
        {
            text => "By Others",
            url => "philosophy/by-others/",
            subs =>
            [
                {
                    text => "James Carr - “Completely Overrated”",
                    url => "philosophy/by-others/james-carr--completely-overrated.html",
                    title => "James Carr about the anti-Muslim Cartoons",
                },
                {
                    text => "Hebrew Translation of “Ten Reasons for Web Standards”",
                    url => "philosophy/by-others/mashhoor--10-reasons--hebrew.html",
                    title => "10 Reasons for Companies to Consider Web Standards - Hebrew Translation",
                },
                {
                    text => "Transcript of the Perlcast Interview with Tom Limoncelli",
                    url => "philosophy/by-others/perlcast-transcript--tom-limoncelli-interview/",
                    title => "Transcript of the Perlcast Interview with Tom Limoncelli",
                },
            ],
        },
    ],
};

sub get_params
{
    return
        (
            hosts => MyNavData::get_hosts(),
            tree_contents => $essays_tree_contents,
        );
}

1;

