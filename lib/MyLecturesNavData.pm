package MyLecturesNavData;

my $essays_tree_contents =
{
    'host' => "vipe",
    'text' => "Shlomi Fish' Presentations",
    'title' => "Shlomi Fish' Presentations",
    'show_always' => 1,
    'subs' =>
    [
        {
            'text' => "Presentations",
            'url' => "lecture/",
            'title' => "Nav Menu for Shlomi Fish' Presentations",
        },
        {
            'text' => "Perl for Newbies",
            'url' => "lecture/Perl/Newbies/",
            'title' => "Perl for Perl Newbies - Introducing Perl for Beginners",
        },
        {
            'text' => "Web Publishing with LAMP",
            'url' => "lecture/LAMP/",
            'title' => "Web Publishing using Linux/Apache/MySQL/Perl/PHP/Python",
            'host' => "t2",
        },
        {
            'text' => "Scheme & Lambda Calculus",
            'url' => "lecture/Lambda-Calculus/",
        },
        {
            'text' => "Haskell for Perlers",
            'url' => "lecture/Perl/Haskell/",
            'title' => "The Haskell Programming Language for Perl Programmers",
        },
        {
            'text' => "Tools",
            'url' => "lecture/cat/various-tools/",
            'title' => "Various Tools",
            'subs' =>
            [
                {
                    'text' => "GIMP",
                    'url' => "lecture/Gimp/",
                    'title' => "The GNU Image Manipulation Program",
                },
                {
                    'text' => "PostgreSQL",
                    'url' => "lecture/PostgreSQL/",
                    'title' => "The PostgreSQL Database Server",
                },
                {
                    'text' => "Lex & Yacc",
                    'url' => "lecture/Sys-Call-Track/Lex-Yacc/",
                    'title' => "Lex and Yacc - for Tokenizing and Parsing",
                },
                {
                    'text' => "Autotools",
                    'url' =>"lecture/Autotools/",
                    'title' => "GNU Autoconf/Automake/Libtool",
                },
                {
                    'text' => "Web Meta Lecture",
                    'url' => "lecture/WebMetaLecture/",
                    'title' => "Presentation about Web Meta Language",
                },
            ],
        },
        {
            'text' => "Welcome to Linux",
            'url' => "lecture/W2L/",
            'title' => "Presentations in the Series for Linux Beginners",
            'subs' =>
            [
                {
                    'text' => "Basic Use",
                    'url' => "lecture/W2L/Basic_Use/",
                    'title' => "Basic Linux Use",
                },
                {
                    'text' => "Linux for the Technion Student",
                    'url' => "lecture/W2L/Technion/",
                    'title' => "Performing Common Programming Tasks in Linux",
                },
                {
                    'text' => "Blitz",
                    'url' => "lecture/W2L/Blitz/",
                    'host' => "t2",
                    'title' => "Getting up to speed with Linux (Hebrew)",
                },
            ],
        },
        {
            'text' => "Projects",
            'url' => "lecture/cat/projects/",
            'title' => "Presentations about my Software Projects",
            'subs' =>
            [
                {
                    'text' => "Freecell Solver",
                    'url' => "lecture/Freecell-Solver/",
                    'title' => "Freecell Solver - Evolution of a C Program",
                    'subs' =>
                    [
                        {
                            'text' => "The Next Presentation",
                            'url' => "lecture/Freecell-Solver/The-Next-Pres/",
                            'title' => "Freecell Solver - The Next Presentation",
                        },
                        {
                            'text' => "Project Intro",
                            'url' => "lecture/Freecell-Solver/project-intro/",
                            'title' => "Freecell Solver: Project Introduction",
                        },
                    ],
                },
                {
                    'text' => "LM-Solve",
                    'url' => "lecture/LM-Solve/",
                    'title' => "LM-Solve - a Logic Mazes Solver",
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

