package Shlomif::Homepage::SectionMenu::Sects::Essays;

use strict;
use warnings;
use 5.014;
use parent 'Shlomif::Homepage::SectionMenu::BaseSectionClass';
use utf8;
use Carp qw/ cluck confess /;

use MyNavData::Hosts ();

my $_section_navmenu_tree_contents = {
    host        => "t2",
    text        => "Essays",
    url         => "philosophy/",
    title       => "Nav Menu for Shlomi Fish’s Essays",
    show_always => 1,
    subs        => [
        {
            text  => "Book Reviews",
            url   => "philosophy/books-recommends/",
            title => "Reviews of Books I read.",
        },
        {
            text  => "Philosophy",
            url   => "philosophy/philosophy/",
            title => "Writings about General Philosophy",
            subs  => [
                {
                    text  => "The Eternal Jew",
                    url   => "philosophy/the-eternal-jew/",
                    title =>
                        "The Eternal Jew - An Essay about the value of Self",
                    subs => [
                        {
                            text => "Ongoing Text",
                            url  =>
                                "philosophy/the-eternal-jew/ongoing-text.xhtml",
                        },
                    ],
                },
                {
                    text => "Putting all the Cards on the Table (2013)",
                    url  =>
"philosophy/philosophy/putting-all-cards-on-the-table-2013/",
                    title =>
                        "A snapshot of my personal philosophy as of March 2013",
                },
                {
                    text => "Putting Cards on the Table (2019-*)",
                    url  =>
"philosophy/philosophy/putting-cards-on-the-table-2019-2020/",
                    title => "Update to my personal philosophy as of 2019-2023",
                },
                {
                    text => "Guide to Neo-Tech",
                    url  => "philosophy/philosophy/guide-to-neo-tech/",
                },
                {
                    text  => "Advice for the Young",
                    url   => "philosophy/philosophy/advice-for-the-young/",
                    title => "Advice for the Young (and for the not-so Young)",
                },
                {
                    text => "Why Closed Books are So 19th Century",
                    url  =>
"philosophy/philosophy/closed-books-are-so-19th-century/",
                    title =>
"Why authors of books should make sure they are publicly available online.",
                },
            ],
        },
        {
            text  => "Psychology",
            url   => "philosophy/psychology/",
            title => "Writings about Psychology",
            subs  => [
                {
                    text  => "Dealing with Hypomanias",
                    url   => "philosophy/psychology/hypomanias/",
                    title =>
"How I deal with the bad psychological periods that affect me",
                },
                {
                    text  => "The Elephant in the Circus",
                    url   => "philosophy/psychology/elephant-in-the-circus/",
                    title =>
                        "A (non-original) story with self-growth implications",
                    subs => [
                        {
                            lang => +{ "he" => 1, },
                            text => "Hebrew Translation",
                            url  =>
"philosophy/psychology/elephant-in-the-circus/hebrew.html",
                        },
                    ],
                },
                {
                    text => "Why Openly Bipolar People Should Not Be Medicated",
                    url  =>
"philosophy/psychology/why-openly-bipolar-people-should-not-be-medicated/",
                },
                {
                    text => "Changing the Seldon Plan",
                    url  => "philosophy/psychology/changing-the-seldon-plan/",
                },
                {
                    text =>
"Crossover hypothesis about the origin of human consciousness",
                    url =>
"philosophy/psychology/crossover-hypothesis-about-the-origin-of-consciousness/",
                },
            ],
        },
        {
            text => "Culture, Art, and Entertainment",
            url  => "philosophy/culture/",
            subs => [
                {
                    text =>
                        "Why I will continue to write my real person fiction",
                    url => "philosophy/culture/my-real-person-fan-fiction/",
                },
                {
                    text =>
                        "Commercial Fanfiction as a Geeky/Hackery Imperative",
                    url =>
                        "philosophy/culture/case-for-commercial-fan-fiction/",
                    subs => [
                        {
                            skip => 1,
                            text => "Reduced Version",
                            url  =>
"philosophy/culture/case-for-commercial-fan-fiction/screenplays-shortage-reduced-version.xhtml",
                        },
                    ],
                },
                {
                    text => "The multiverse’s cosmology",
                    url  => "philosophy/culture/multiverse-cosmology/",
                    subs => [
                        {
                            text =>
"Reasons why the outside world, as I perceive it, does not make sense, is contradictory, illogical, or is difficult-to-believe-can-be-real",
                            url =>
"philosophy/culture/multiverse-cosmology/why-the-so-called-real-world-makes-little-sense/",
                        },
                    ],
                },
            ],
        },
        {
            text  => "Political Essays",
            url   => "philosophy/politics/",
            title => "Essays about Politics and Philosophical Politics",
            subs  => [
                {
                    expand => {
                        re =>
"^philosophy/(?:philosophy/SummerNSA-2014-09-call-for-action/|politics/)",
                    },
                    text  => "#SummerNSA",
                    url   => "philosophy/SummerNSA/",
                    title =>
                        "The #SummerNSA / “Summerschool at the NSA” effort",
                    subs => [
                        {
                            text => "A #SummerNSA’s Reading",
                            url  => "philosophy/SummerNSA/A-SummerNSA-Reading/",
                            title =>
                                "Summarising the #SummerNSA effort so far.",
                        },
                        {
                            text => "Letter to Summer Glau on Oct 2014",
                            url  =>
                                "philosophy/SummerNSA/Letter-to-SGlau-2014-10/",
                        },
                        {
                            text => "Sep 2014 Call for Action",
                            url  =>
"philosophy/philosophy/SummerNSA-2014-09-call-for-action/",
                        },
                    ],
                },
                {
                    text  => "Objectivism and Open Source",
                    url   => "philosophy/obj-oss/",
                    title => "Objectivism and Open Source",
                    subs  => [
                        {
                            text  => "Revision 2",
                            url   => "philosophy/obj-oss/rev2/",
                            title =>
"Revision 2 of the Objectivism and Open Source Article",
                        },
                    ],
                },
                {
                    text  => "Israeli-Palestinian Conflict",
                    url   => "philosophy/israel-pales/",
                    title => "A Solution to the Israeli Palestinian Conflict",
                },
                {
                    text  => "Case for File Swapping",
                    url   => "philosophy/case-for-file-swapping/",
                    title =>
"Why File Swapping is Ethical and Moral and should be Legal",
                    subs => [
                        {
                            text => "Revision 3 Text",
                            url  =>
                                "philosophy/case-for-file-swapping/revision-3/",
                            title => "Text of the Third Revision",
                        },
                    ],
                },
                {
                    text  => "Why Scientology is Bad",
                    url   => "philosophy/politics/why-scientology-is-bad/",
                    title => "How I Concluded that Scientology is Bad",
                },
                {
                    text  => "Case for Drug Legalisation",
                    url   => "philosophy/politics/drug-legalisation/",
                    title => "Why the War on Drugs is the Real Drug Problem",
                    subs  => [
                        {
                            lang => +{ "he" => 1, },
                            text => "Hebrew Translation",
                            url  =>
"philosophy/politics/drug-legalisation/hebrew.html",
                        },
                    ],
                },
                {
                    text  => "Define “Zionism”!",
                    url   => "philosophy/politics/define-zionism/",
                    title => (
                              "What is “Zionism” really? What "
                            . "do “anti-Israel”, “anti-Zionist”, etc. mean?"
                    ),
                    subs => [
                        {
                            lang => +{ "he" => 1, },
                            text => "Hebrew Translation",
                            url  => "philosophy/politics/define-zionism/heb/",
                        },
                    ],
                },
                {
                    text => "Dispelling Some Myths about Israel",
                    url => "philosophy/politics/dispelling-myths-about-israel/",
                },
                {
                    text  => "Opinion on DeCSS",
                    url   => "DeCSS/",
                    title =>
"My Opinion on the DeCSS (= DVDs’ de-scrambling code) fiasco",
                },
            ],
        },
        {
            text  => "Computing",
            url   => "philosophy/computers/",
            title => "Computing-related Essays and Articles",
            subs  => [
                {
                    text  => "When C is the Best?",
                    url   => "philosophy/computers/when-c-is-best/",
                    title =>
"An essay that explains when the C language should be used instead of other languages",
                    subs => [
                        {
                            text => "The Text Itself",
                            url  =>
"philosophy/computers/when-c-is-best/when-c-is-the-best.html",
                        },
                    ],
                },
                {
                    text => "Open Source",
                    url  => "philosophy/computers/open-source/",
                    subs => [
                        {
                            text  => "What is Open Source?",
                            url   => "philosophy/foss-other-beasts/",
                            title =>
                                "Open Source, Free Software and Other Beasts",
                        },
                        {
                            text => "How to Contribute to Open Source",
                            url  =>
"philosophy/computers/open-source/how-to-start-contributing/",
                            title =>
"How can one start contributing to free and open-source software (FOSS)",
                            subs => [
                                {
                                    text => "Longer Document",
                                    url  =>
"philosophy/computers/open-source/how-to-start-contributing/tos-document.html",
                                },
                            ],
                        },
                        {
                            text => "GPL, BSD and Suckerism",
                            url  =>
"philosophy/computers/open-source/gpl-bsd-and-suckerism/",
                            title =>
                                "The GPL, The BSD Licence and Being a Sucker",
                        },
                        {
                            text => "The Linus Bus Factor",
                            url  =>
"philosophy/computers/open-source/linus-torvalds-bus-factor/",
                            title =>
"The virtue of having multiple committers and overthrowing the benevolent dictator",
                        },
                        {
                            text => "FOSS Licences Wars",
                            url  =>
"philosophy/computers/open-source/foss-licences-wars/",
                            title =>
"An overview of open-source licences and some recommendations and opinions",
                            skip => 1,
                            subs => [
                                {
                                    text => "FOSS Licences Wars (Revision 2)",
                                    url  =>
"philosophy/computers/open-source/foss-licences-wars/rev2/",
                                    title =>
"An overview of open-source licences and some recommendations and opinions",
                                },
                            ],
                        },
                        {
                            text => "Why I Don’t Trust Non-FOSS",
                            url  =>
"philosophy/computers/open-source/not-trust-non-FOSS/",
                        },
                    ],
                },
                {
                    text  => "Software Management",
                    url   => "philosophy/computers/software-management/",
                    title => "Managing software teams, people, projects",
                    subs  => [
                        {
                            text => "The End of IT Slavery",
                            url  =>
"philosophy/computers/software-management/end-of-it-slavery/",
                            title =>
"The end of Info-Tech/High-Tech slavery - if you want great people to work for you, make sure they love your workplace",
                        },
                        {
                            text => "The Perfect Info-Tech Workplace",
                            url  =>
"philosophy/computers/software-management/perfect-workplace/",
                            title =>
"How to make an info-tech workplace where programmers will be happy, want to stay, be super-productive and efficient and will rave about",
                            subs => [
                                {
                                    text => "Revision 1",
                                    url  =>
"philosophy/computers/software-management/perfect-workplace/perfect-it-workplace.xhtml",
                                },
                            ],
                        },
                        {
                            text => "Getting Your Job Ad Replied To",
                            url  =>
"philosophy/computers/software-management/getting-your-job-ad-replied-to/",
                        },
                    ],
                },
                {
                    text => "What Makes Software High-Quality?",
                    url  => "philosophy/computers/high-quality-software/",
                    subs => [
                        {
                            text => "2nd Revision",
                            url  =>
"philosophy/computers/high-quality-software/rev2/",
                            title =>
"“What Makes Software High Quality?” - Revision 2",
                        },
                        {
                            text =>
"Reflections on (circa 2020) software quality trends",
                            url =>
"philosophy/computers/high-quality-software/reflections-on-software-quality-trends/",
                        },
                    ],
                },
                {
                    text => "Optimising Code for Speed",
                    url  => "philosophy/computers/optimizing-code-for-speed/",
                },
                {
                    text => "How to share code online for getting help with it",
                    url  =>
"philosophy/computers/how-to-share-code-for-getting-help/",
                },
                {
                    text => "Why Your Programming Language Must Suck",
                    url  =>
"philosophy/computers/your-programming-language-must-suck/",
                },
                {
                    text => "The “Broken Window” Fallacy",
                    url  => "philosophy/computers/the-broken-window-fallacy/",
                },
                {
                    text  => "Perl",
                    url   => "philosophy/computers/perl/",
                    title =>
                        "Articles Related to the Perl Programming Language",
                    subs => [
                        {
                            text  => "Perl &amp; Newcomers",
                            url   => "philosophy/perl-newcomers/",
                            title =>
"“Usability” of the Perl Online World for Newcomers",
                            subs => [
                                {
                                    skip => 1,
                                    text => "Version 1",
                                    url  => "philosophy/perl-newcomers/v1/",
                                },
                            ],
                        },
                        {
                            text  => "The Joy of Perl",
                            url   => "philosophy/computers/perl/joy-of-perl/",
                            title => "An Essay about why I Like Perl so much.",
                            subs  => [
                                {
                                    skip => 1,
                                    text => "The Text Itself",
                                    url  =>
"philosophy/computers/perl/joy-of-perl/joy-of-perl.html",
                                },
                            ],
                        },
                        {
                            text => "Perl 6 Critique",
                            url  => "philosophy/computers/perl/perl6-critique/",
                            title => "Critique of where Perl 6 is Heading",
                        },
                    ],
                },
                {
                    text  => "Web",
                    url   => "philosophy/computers/web/",
                    title => "Web-related Articles",
                    subs  => [
                        {
                            text => "Create a Homesite",
                            url  =>
"philosophy/computers/web/create-a-great-personal-homesite/",
                            title => "Create a Great Personal Homesite",
                            subs  => [
                                {
                                    text => "Revision 2",
                                    url  =>
"philosophy/computers/web/create-a-great-personal-homesite/rev2.html",
                                },
                            ],
                        },
                        {
                            text  => "Which Wiki?",
                            url   => "philosophy/computers/web/which-wiki/",
                            title =>
                                "Which Open Source Wiki Engine Works for you",
                            subs => [
                                {
                                    text => "July 2006 Update",
                                    url  =>
"philosophy/computers/web/which-wiki/update-2006-07/",
                                },
                            ],
                        },
                        {
                            text => "Choice of Doc Formats",
                            url  =>
"philosophy/computers/web/choice-of-docs-formats/",
                            title =>
"Coverage of the current choice of document formats",
                        },
                        {
                            text => "The “Use qmail instead” Syndrome",
                            url  =>
                                "philosophy/computers/web/use-qmail-instead/",
                        },
                        {
                            text => "Homepage vs. Blog",
                            url => "philosophy/computers/web/homepage-vs-blog/",
                        },
                        {
                            text => "Online Communities",
                            url  =>
                                "philosophy/computers/web/online-communities/",
                            title => "Reflections on online communities",
                        },
                        {
                            text => "Models for Web-based Commerce",
                            url  =>
                                "philosophy/computers/web/models-for-commerce/",
                            title =>
"Alternative models for web-based commerce that do not involve intrusive advertising",
                        },
                        {
                            text => "Validate Your HTML",
                            url  =>
                                "philosophy/computers/web/validate-your-html/",
                        },
                    ],
                },
                {
                    text  => "Education",
                    url   => "philosophy/computers/education/",
                    title => "Articles about Computer Learning and Education",
                    subs  => [
                        {
                            text => "EE in the Technion",
                            url  =>
"philosophy/computers/education/opinion-on-the-technion/",
                            title =>
"My Opinion on Electrical Engineering Studies in the Technion",
                        },
                        {
                            text => "Best Introductory Language",
                            url  =>
"philosophy/computers/education/introductory-language/",
                            title =>
"What is the best introductory programming language?",
                        },
                    ],
                },
                {
                    text  => "How to Get Help Online",
                    url   => "philosophy/computers/how-to-get-help-online/",
                    title =>
"Where on the Internet one can get help with their (probably technical) problems",
                    subs => [
                        {
                            text => "2013 Edition",
                            url  =>
"philosophy/computers/how-to-get-help-online/2013.html",
                        },
                    ],
                },
                {
                    text  => "Netiquette",
                    url   => "philosophy/computers/netiquette/",
                    title =>
"Articles and Links about Netiquette - the Internet Etiquette",
                    subs => [
                        {
                            text  => "Email",
                            url   => "philosophy/computers/netiquette/email/",
                            title =>
                                "Articles and Links about E-mail netiquette.",
                            subs => [
                                {
                                    text => "Start New Thread",
                                    url  =>
"philosophy/computers/netiquette/email/start-new-thread.html",
                                    title => "How to start a new thread",
                                },
                                {
                                    text => "Reply to List",
                                    url  =>
"philosophy/computers/netiquette/email/reply-to-list.html",
                                    title =>
                                        "Reply to List on a Mailing List Post",
                                },
                            ],
                        },
                    ],
                },
                {
                    text  => "My Memoirs",
                    url   => "prog-evolution/",
                    title => "My Memoirs as a Programmer",
                    subs  => [
                        {
                            text  => "Pre-Elpas",
                            url   => "prog-evolution/pre-elpas.html",
                            title => (
                                      "Memoirs as a Programmer from"
                                    . " Elementary School, High School, etc."
                            ),
                        },
                        {
                            text  => "At Elpas",
                            url   => "prog-evolution/shlomif-at-elpas.html",
                            title => (
                                      "Memoirs as a Programmer from"
                                    . " Elpas, which was my first workplace as a"
                                    . " programmer"
                            ),
                        },
                        {
                            text  => "At Cortext",
                            url   => "prog-evolution/shlomif-at-cortext.html",
                            title => (
"Describes my experiences in Cortext, a web-design shop based on UNIX, "
                                    . "Windows, and Perl."
                            ),
                        },
                    ],
                },
            ],
        },
        {
            text  => "Random Ideas",
            url   => "philosophy/ideas/",
            title => "Various Random (and Practical) Ideas I Have",
            subs  => [
                {
                    text  => "Fortunes Mania",
                    url   => "philosophy/ideas/fortunes-mania/",
                    title =>
"A community site for collecting and organising fortune cookies",
                },
                {
                    text  => "Unixdoc",
                    url   => "philosophy/ideas/unixdoc/",
                    title =>
"An integrated offline and online documentation framework",
                },
            ],
        },
        {
            text  => "Index to Essays",
            url   => "philosophy/Index/",
            title => "Index to essays and articles I wrote.",
        },
        {
            text => "By Others",
            url  => "philosophy/by-others/",
            subs => [
                {
                    text => "James Carr - “Completely Overrated”",
                    url  =>
"philosophy/by-others/james-carr--completely-overrated.html",
                    title => "James Carr about the anti-Muslim Cartoons",
                },
                {
                    lang => +{ "he" => 1, },
                    text =>
"Hebrew Translation of “Ten Reasons for Web Standards”",
                    url =>
"philosophy/by-others/mashhoor--10-reasons--hebrew.html",
                    title =>
"10 Reasons for Companies to Consider Web Standards - Hebrew Translation",
                },
                {
                    text =>
"Transcript of the Perlcast Interview with Tom Limoncelli",
                    url =>
"philosophy/by-others/perlcast-transcript--tom-limoncelli-interview/",
                    title =>
"Transcript of the Perlcast Interview with Tom Limoncelli",
                },
            ],
        },
        {
            text => "Fan Pages",
            url  => "philosophy/fan-pages/",
            subs => [
                {
                    text => "Christina Grimmie",
                    url  => "philosophy/fan-pages/christina-grimmie/",
                },
                {
                    text => "Samantha Smith",
                    url  => "philosophy/fan-pages/samantha-smith/",
                },
            ],
        },
    ],
};

my $section_navmenu_tree_contents_by_lang =
    __PACKAGE__->_calc_lang_trees_hash($_section_navmenu_tree_contents);

sub get_params
{
    my ( $self, $args ) = @_;

    my $lang = $args->{lang}
        or confess("lang was not specified.");

    my @keys = sort keys %$lang;
    if ( @keys == 1 )
    {
        $lang = shift @keys;
    }
    else
    {
        $lang = 'en';
    }
    my $tree_contents = $section_navmenu_tree_contents_by_lang->{$lang};
    if (0)    # ( $lang ne 'en' )
    {
        cluck "lang=$lang";
        say Data::Dumper->new( [ $tree_contents, ] )->Dump();
    }
    return (
        hosts         => scalar( MyNavData::Hosts::get_hosts() ),
        tree_contents => $tree_contents,
    );
}

1;
