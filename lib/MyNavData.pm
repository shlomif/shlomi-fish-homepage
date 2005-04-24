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
    'text' => "Shlomi Fish",
    'title' => "Shlomi Fish' Homepage",
    'subs' =>
    [
        {
            'text' => "Home",
            'url' => "",
        },
        {
            'text' => "About Myself",
            'url' => "me/",
            'subs' => 
            [
                {
                    'text' => "Bio",
                    'url' => "personal.html",
                    'title' => "A Short Biography of Myself",
                },
                {
                    'text' => "Contact",
                    'url' => "me/contact-me/",
                    'title'=> "How to Contact me in Every Conceivable Way",
                },
                {
                    'text' => "My Resum&eacute;s",
                    'url' => "me/resumes/",
                    'subs' =>
                    [
                        {
                            'text' => "English Resum&eacute;",
                            'url' => "SFresume.html",
                            'skip' => 1,
                        },
                        {
                            'text' => "Detailed English Resum&eacute;",
                            'url' => "SFresume_detailed.html",
                            'skip' => 1,
                        },
                    ],
                },
            ],               
        },
        {
            'text' => "Work",
            'url' => "work/",
            'title' => "Work-Related Pages",
            'show_always' => 1,
            'subs' => 
            [
                {
                    'text' => "Private Lessons",
                    'url' => "work/private-lessons/",
                    'title' => "I'm Giving Private Lessons for High School Subjects and Computing.",
                },
            ],
        },
        {
            'text' => "Humour", 
            'url' => "humour/",
            'title' => "My Humorous Creations",
            'subs' => 
            [
                {
                    'text' => "The Enemy", 
                    'url' => "humour/TheEnemy/",
                    'title' => "The Enemy and How I Helped to Fight It",
                },
                {
                    'text' => "TOWTF",
                    'url' => "humour/TOWTF/",
                    'title' => "The One with the Fountainhead",
                },
                {
                    'text' => "The Pope",
                    'url' => "humour/Pope/",
                    'title' => "The Pope Died on Sunday",
                },
                {
                    'text' => "Humour Archive",
                    'title' => "Archive of Humorous Bits I came up with",
                    'url' => "humour.html",
                    'hide' => 1,
                },
                {
                    'text' => "Fortune Cookies Collection",
                    'title' => "Collection of Files for Input to the UNIX 'fortune' Program",
                    'url' => "humour/fortunes/",
                    'host' => "vipe",
                    'hide' => 1,
                },
            ],
        },
        {
            'text' => "Math-Ventures",
            'url' => "MathVentures/",
            'title' => "Mathematical Riddles and their Solutions",
        },
        {
            'text' => "Computer Art",
            'url' => "art/",
            'title' => "Computer art I created while explaining how.",
            'subs' =>
            [
                {
                    'text' => "Back to my Homepage",
                    'url' => "art/bk2hp/",
                    'title' => "A Back to my Homepage logo not unlike the one from the movie &quot;Back to the Future&quot;",
                },
                {
                    'text' => "Linux Banner",
                    'url' => "art/linux_banner/",
                    'title' => "Linux - Because Software Problems should not Cost Money",
                },
            ],
        },
        {
            'text' => "Software",
            'url' => "open-source/",
            'expand' => { 're' => "^open-source/", },
            'title' => "Pages related to Software (mostly Open-Source)",
            'subs' => 
            [
                {
                    'text' => "Freecell Solver",
                    'url' => "open-source/projects/freecell-solver/",
                },
                {
                    'text' => "MikMod for Java",
                    'title' => "A Player for MOD Files (a type of Music Files) for the Java Environment",
                    'url' => "jmikmod/",
                },
                {
                    'text' => "FCFS RWLock",
                    'title' => "A First-Come First-Served Readers/Writers Lock",
                    'url' => "rwlock/",
                    'host' => "vipe",
                },
                {
                    'text' => "Quad-Pres",
                    'title' => "A Tool for Creating HTML Presentations",
                    'url' => "open-source/projects/quad-pres/",
                },
                {
                    'text' => "Favourite OSS",
                    'title' => "Favourite Open-Source Software",
                    'url' => "open-source/favourite/",
                },
                {
                    'text' => "Interviews",
                    'title' => "Interviews with Open-Source People",
                    'url' => "open-source/interviews/",
                },
                {
                    'text' => "Contributions",
                    'title' => "Contributions to Other Projects, that I did not Start",
                    'url' => "open-source/contributions/",
                },
                {
                    'text' => "Bits and Bobs",
                    'title' => "Various Small-Scale Open-Source Works",
                    'url' => "open-source/bits.html",
                },
                {
                    'text' => "Portability Libraries",
                    'title' => "Cross-Platform Abstraction Libraries",
                    'url' => "abstraction/",
                    'host' => "vipe",
                    'hide' => 1,
                },
                {
                    'text' => "Software Tools",
                    'title' => "Software Constructions and Management Tools",
                    'url' => "software-tools/",
                    'host' => "vipe",
                    'hide' => 1,
                },
            ],
        },
        {
            'text' => "Lectures", 
            'url' => "lecture/",
            'expand' => { 're' => "^lecture/", },
            'title' => "Presentations I Wrote (Mostly Technical)",
            'host' => "vipe",
            'subs' => 
            [
                {
                    'text' => "Perl for Newbies",
                    'url' => "lecture/Perl/Newbies/",
                },
                {
                    'text' => "Freecell Solver",
                    'url' => "lecture/Freecell-Solver/",
                },
                {
                    'text' => "Lambda Calculus",
                    'title' => "A presentation about a Turing-complete programming environment with only two primitives",
                    'url' => "lecture/lc/",
                },
                {
                    'text' => "The Gimp",
                    'title' => "A Presentation about the GNU Image Manipulation Program",
                    'url' => "lecture/Gimp/",
                },
                {
                    'text' => "GNU Autotools",
                    'url' => "lecture/Autotools/",
                },
                {
                    'text' => "Web Meta Lecture",
                    'title' => "A Presentation about the Web Meta Language",
                    'url' => "lecture/WebMetaLecture/",
                },
            ],
        },
        {
            'text' => "Essays",
            'url' => "philosophy/",
            'title' => "Various Essays and Articles about Technology and Philosophy in General",
            'subs' =>
            [
                {
                    'text' => "Index to Essays",
                    'url' => "philosophy/Index/",
                    'title' => "Index to Essays and Articles I wrote.",
                },
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
                    'text' => "Objectivism and Open Source",
                    'url' => "philosophy/obj-oss/",
                    'title' => "Objectivism and Open Source",
                },
                {
                    'text' => "The Eternal Jew",
                    'url' => "philosophy/the-eternal-jew/",
                    'title' => "The Eternal Jew - An Essay about Philosophy",
                },
            ],
        },
        {
            'text' => "Opinion on DeCSS",
            'url' => "DeCSS/",
            'title' => "My Opinion on the DeCSS (= DVDs' de-scrambling code) fiasco",
        },
        {
            'separator' => 1,
            'skip' => 1,
        },
        {
            'text' => "Cool Links",
            'url' => "links.html",
            'title' => "An incomplete list of links I find cool and/or useful.",
        },
        {
            'separator' => 1,
            'skip' => 1,
        },
        {
            'url' => "site-map/",
            'text' => "Site Map",
            'title' => "A site map showing all of the main pages.",
        },
        {
            'separator' => 1,
            'skip' => 1,
        },
        {
            'url' => "site-source/",
            'text' => "Site's Source",
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
