package MyNavData;

my $hosts =
{
    't2' => 
    {
        'base_url' => "http://www.shlomifish.org/",
    },
    'vipe' =>
    {
        'base_url' => "http://vipe.technion.ac.il/~shlomif/",
    },
};

my $tree_contents =
{
    'host' => "t2",
    'value' => "Shlomi Fish",
    'title' => "Shlomi Fish' Homepage",
    'expand_re' => "",
    'subs' =>
    [
        {
            'value' => "Home",
            'url' => "",
        },
        {
            'value' => "About Myself",
            'url' => "me/",
            'subs' => 
            [
                {
                    'value' => "Bio",
                    'url' => "personal.html",
                    'title' => "A Short Biography of Myself",
                },
                {
                    'value' => "Contact",
                    'url' => "me/contact-me/",
                    'title'=> "How to Contact me in Every Conceivable Way",
                },
                {
                    'value' => "My Resum&eacute;s",
                    'url' => "me/resumes/",
                    'subs' =>
                    [
                        {
                            'value' => "English Resum&eacute;",
                            'url' => "SFresume.html",
                            'skip' => 1,
                        },
                        {
                            'value' => "Detailed English Resum&eacute;",
                            'url' => "SFresume_detailed.html",
                            'skip' => 1,
                        },
                    ],
                },
            ],               
        },
        {
            'value' => "Work",
            'url' => "work/",
            'title' => "Work-Related Pages",
            'show_always' => 1,
            'subs' => 
            [
                {
                    'value' => "Private Lessons",
                    'url' => "work/private-lessons/",
                    'title' => "I'm Giving Private Lessons for High School Subjects and Computing.",
                },
            ],
        },
        {
            'value' => "Humour", 
            'url' => "humour/",
            'title' => "My Humorous Creations",
            'subs' => 
            [
                {
                    'value' => "The Enemy", 
                    'url' => "humour/TheEnemy/",
                    'title' => "The Enemy and How I Helped to Fight It",
                },
                {
                    'value' => "TOWTF",
                    'url' => "humour/TOWTF/",
                    'title' => "The One with the Fountainhead",
                },
                {
                    'value' => "The Pope",
                    'url' => "humour/Pope/",
                    'title' => "The Pope Died on Sunday",
                },
                {
                    'value' => "Humour Archive",
                    'title' => "Archive of Humorous Bits I came up with",
                    'url' => "humour.html",
                    'hide' => 1,
                },
                {
                    'value' => "Fortune Cookies Collection",
                    'title' => "Collection of Files for Input to the UNIX 'fortune' Program",
                    'url' => "humour/fortunes/",
                    'host' => "vipe",
                    'hide' => 1,
                },
            ],
        },
        {
            'value' => "Math-Ventures",
            'url' => "MathVentures/",
            'title' => "Mathematical Riddles and their Solutions",
        },
        {
            'value' => "Computer Art",
            'url' => "art/",
            'title' => "Computer art I created while explaining how.",
            'subs' =>
            [
                {
                    'value' => "Back to my Homepage",
                    'url' => "art/bk2hp/",
                    'title' => "A Back to my Homepage logo not unlike the one from the movie &quot;Back to the Future&quot;",
                },
                {
                    'value' => "Linux Banner",
                    'url' => "art/linux_banner/",
                    'title' => "Linux - Because Software Problems should not Cost Money",
                },
            ],
        },
        {
            'value' => "Software",
            'url' => "open-source/",
            'expand_re' => "^open-source/",
            'title' => "Pages related to Software (mostly Open-Source)",
            'subs' => 
            [
                {
                    'value' => "Freecell Solver",
                    'url' => "open-source/projects/freecell-solver/",
                },
                {
                    'value' => "MikMod for Java",
                    'title' => "A Player for MOD Files (a type of Music Files) for the Java Environment",
                    'url' => "jmikmod/",
                },
                {
                    'value' => "FCFS RWLock",
                    'title' => "A First-Come First-Served Readers/Writers Lock",
                    'url' => "rwlock/",
                    'host' => "vipe",
                },
                {
                    'value' => "Quad-Pres",
                    'title' => "A Tool for Creating HTML Presentations",
                    'url' => "open-source/projects/quad-pres/",
                },
                {
                    'value' => "Favourite OSS",
                    'title' => "Favourite Open-Source Software",
                    'url' => "open-source/favourite/",
                },
                {
                    'value' => "Interviews",
                    'title' => "Interviews with Open-Source People",
                    'url' => "open-source/interviews/",
                },
                {
                    'value' => "Contributions",
                    'title' => "Contributions to Other Projects, that I did not Start",
                    'url' => "open-source/contributions/",
                },
                {
                    'value' => "Bits and Bobs",
                    'title' => "Various Small-Scale Open-Source Works",
                    'url' => "open-source/bits.html",
                },
                {
                    'value' => "Portability Libraries",
                    'title' => "Cross-Platform Abstraction Libraries",
                    'url' => "abstraction/",
                    'host' => "vipe",
                    'hide' => 1,
                },
                {
                    'value' => "Software Tools",
                    'title' => "Software Constructions and Management Tools",
                    'url' => "software-tools/",
                    'host' => "vipe",
                    'hide' => 1,
                },
            ],
        },
        {
            'value' => "Lectures", 
            'url' => "lecture/",
            'expand_re' => "^lecture/",
            'title' => "Presentations I Wrote (Mostly Technical)",
            'host' => "vipe",
            'subs' => 
            [
                {
                    'value' => "Perl for Newbies",
                    'url' => "lecture/Perl/Newbies/",
                },
                {
                    'value' => "Freecell Solver",
                    'url' => "lecture/Freecell-Solver/",
                },
                {
                    'value' => "Lambda Calculus",
                    'title' => "A presentation about a Turing-complete programming environment with only two primitives",
                    'url' => "lecture/lc/",
                },
                {
                    'value' => "The Gimp",
                    'title' => "A Presentation about the GNU Image Manipulation Program",
                    'url' => "lecture/Gimp/",
                },
                {
                    'value' => "GNU Autotools",
                    'url' => "lecture/Autotools/",
                },
                {
                    'value' => "Web Meta Lecture",
                    'title' => "A Presentation about the Web Meta Language",
                    'url' => "lecture/WebMetaLecture/",
                },
            ],
        },
        {
            'value' => "Essays",
            'url' => "philosophy/",
            'title' => "Various Essays and Articles about Technology and Philosophy in General",
            'subs' =>
            [
                {
                    'value' => "Index to Essays",
                    'url' => "philosophy/Index/",
                    'title' => "Index to Essays and Articles I wrote.",
                },
                {
                    'value' => "What is Open Source?",
                    'url' => "philosophy/foss-other-beasts/",
                    'title' => "Free Software, Open Source and Other Beasts",
                },
                {
                    'value' => "Perl &amp; Newcomers",
                    'url' => "philosophy/perl-newcomers/",
                    'title' => "&quot;Usability&quot; of the Perl Online World for Newcomers",
                },
                {
                    'value' => "Objectivism and Open Source",
                    'url' => "philosophy/obj-oss/",
                    'title' => "Objectivism and Open Source",
                },
                {
                    'value' => "The Eternal Jew",
                    'url' => "philosophy/the-eternal-jew/",
                    'title' => "The Eternal Jew - An Essay about Philosophy",
                },
            ],
        },
        {
            'value' => "Opinion on DeCSS",
            'url' => "DeCSS/",
            'title' => "My Opinion on the DeCSS (= DVDs' de-scrambling code) fiasco",
        },
        {
            'separator' => 1,
            'skip' => 1,
        },
        {
            'value' => "Cool Links",
            'url' => "links.html",
            'title' => "An incomplete list of links I find cool and/or useful.",
        },
        {
            'separator' => 1,
            'skip' => 1,
        },
        {
            'url' => "site-source/",
            'value' => "Site's Source",
            'title' => "The source code used to generate this site",
        },
    ],
};

sub get_params
{
    return 
        (
            'hosts' => $hosts,
            'tree_contents' => $tree_contents,
        );
}

1;
