package MyNavData;

my $hosts =
{
    't2' => 
    {
        'base_url' => "http://shlomif.il.eu.org/",
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
        },
        {
            'value' => "Software",
            'url' => "open-source/",
            'title' => "Pages related to Software (mostly Open-Source)",
            'subs' => 
            [
                {
                    'value' => "Freecell Solver",
                    'url' => "freecell-solver/",
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
                },
                {
                    'value' => "Quad-Pres",
                    'title' => "A Tool for Creating HTML Presentations",
                    'url' => "quadpres/",
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
                    'url' => "lecture/Lambda-Calculus/",
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
                {
                    'value' => "Haskell",
                    'title' => "Haskell for Perl Programmers",
                    'url' => "lecture/Perl/Haskell/",
                    'hide' => 1,
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
