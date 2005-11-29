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

sub get_hosts
{
    return $hosts;
}

my @personal_expand = ('expand' => { 're' => "^(me/|personal\.html)", },);

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
            @personal_expand,
            'subs' => 
            [
                {
                    'text' => "Bio",
                    'url' => "personal.html",
                    'title' => "A Short Biography of Myself",
                    @personal_expand,
                    'subs' =>
                    [
                        {
                            'text' => "Intros",
                            'url' => "me/intros/",
                            'title' => "Introductions of Me to Various Forums",
                            @personal_expand,
                            'subs' =>
                            [
                                {
                                    'text' => "MIT Writers",
                                    'url' => "me/intros/writers/",
                                    'title' => "My Intro to the MIT Writers Mailing List",
                                    @personal_expand,
                                },
                            ],
                        },
                    ],
                },
                {
                    'text' => "Contact",
                    'url' => "me/contact-me/",
                    'title'=> "How to Contact Me",
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
                {
                    'text' => "Personal Ad",
                    'url' => "me/personal-ad.html",
                    'title' => "My Personal Ad: what I'm looking for in a prospective girlfriend and what I can add to the relationship.",
                },
                {
                    'text' => "My Weblogs",
                    'url' => "me/blogs/",
                    'title' => "Links to my online journals.",
                },
            ],               
        },
        {
            'text' => "Work",
            'url' => "work/",
            'expand' => { 're' => "", },
            'title' => "Work-Related Pages",
            'subs' =>
            [
                {
                    'text' => "Hire Me!",
                    'url' => "work/hire-me/",
                    'title' => "I'm a Geek for Hire",
                    'expand' => { 're' => "work/", },
                    'subs' =>
                    [
                        {
                            'text' => "Private Lessons",
                            'url' => "work/private-lessons/",
                            'title' => "I'm Giving Private Lessons for High School Subjects and Computing.",
                        },
                    ],
                },
            ],
        },
        {
            'text' => "Humour", 
            'url' => "humour/",
            'expand' => { 're' => "^humour/", },
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
                    'text' => "HHFG",
                    'url' => "humour/human-hacking/",
                    'title' => "The Human Hacking Field Guide",
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
                {
                    'text' => "Ways to do it",
                    'title' => "&quot;Ways to do it&quot; according to the programming languages of the world",
                    'url' => "humour/ways_to_do_it.html",
                    'hide' => 1,
                },
            ],
        },
        {
            'text' => "Puzzles",
            'url' => "puzzles/",
            'expand' => { 're' => "^(MathVentures/|puzzles/)", },
            'title' => "Puzzles, Riddles and Brain-teasers",
            'subs' =>
            [
                {
                    'text' => "Math-Ventures",
                    'url' => "MathVentures/",
                    'expand' => { 're' => "^MathVentures/", },
                    'title' => "Mathematical Riddles and their Solutions",
                },
                {
                    'text' => "Logic Puzzles",
                    'url' => "puzzles/logic/",
                    'expand' => { 're' => "^puzzles/logic/", },
                },
            ],
        },
        {
            'text' => "Computer Art",
            'url' => "art/",
            'expand' => { 're' => "^art/", },
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
                {
                    'text' => "Made with Latemp",
                    'url' => "art/made-with-latemp/",
                    'title' => "&quot;Made with Latemp&quot; Button",
                },
                {
                    'text' => "HHFG Background",
                    'url' => "art/hhfg-background/",
                    'title' => "Background Image for the &quot;Human Hacking Field Guide&quot; Story",
                },
                {
                    'text' => "Better SCM Logo",
                    'url' => "art/better-scm/",
                    'title' => "Logo for the  &quot;Better SCM&quot; Site",
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
                    'text' => "Gradient-Fu",
                    'title' => "Gradient-Fu Patch for the GIMP",
                    'url' => "grad-fu/",
                    'host' => "t2",
                    'hide' => 1,
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
                    'text' => "Anti Pages",
                    'title' => "Against Commonly Used but Bad Software",
                    'url' => "open-source/anti/",
                    'expand' => { 're' => "^(no-ie|open-source/anti)/", },
                },                
                {
                    'text' => "Portability Libraries",
                    'title' => "Cross-Platform Abstraction Libraries",
                    'url' => "open-source/portability-libs/",
                    'hide' => 1,
                },
                {
                    'text' => "Software Tools",
                    'title' => "Software Constructions and Management Tools",
                    'url' => "open-source/resources/software-tools/",
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
            'expand' => { 're' => "^philosophy/", },
            'title' => "Various Essays and Articles about Technology and Philosophy in General",
            'subs' =>
            [
            
                {
                    'text' => "Index to Essays",
                    'url' => "philosophy/Index/",
                    'title' => "Index to Essays and Articles I wrote.",
                },
                {
                    'text' => "Computing",
                    'url' => "philosophy/computers/",
                    'title' => "Computing-related Essays and Articles",
                    'expand' => { 're' => "^philosophy/computers/", },
                },
                {
                    'text' => "Political Essays",
                    'url' => "philosophy/politics/",
                    'title' => "Essays about Politics and" . 
                        "Philosophical Politics",
                    'expand' => { 're' => "^philosophy/politics/", },
                },
                {
                    'text' => "General Philosophy",
                    'url' => "philosophy/philosophy/",
                    'expand' => { 're' => "^philosophy/(philosophy/|the-eternal-jew/)" },
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
            'expand_re' => "^meta/",
            'url' => "meta/",
            'text' => "Meta Info",
            'title' => "Information about this Site",
            'show_always' => 1,
            'subs' =>
            [
                {
                    'url' => "meta/site-source/",
                    'text' => "Site's Source",
                    'title' => "The source code used to generate this site",
                },
                {
                    'url' => "meta/donate/",
                    'text' => "Please Donate",
                },
            ],
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
