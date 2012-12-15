package Contents;

use strict;

my $contents =
{
    'title' => "\"Perl for Perl Newbies\" - Part 4",
    'subs' =>
    [
        {
            'url' => "cpan",
            'title' => "CPAN Modules",
            'subs' =>
            [
                {
                    'url' => "manual.html",
                    'title' => "Manual Compilation",
                },
                {
                    'url' => "mcpan.html",
                    'title' => "The -MCPAN Interface",
                }
            ],
        },
        {
            'url' => "sprintf",
            'title' => "The sprintf function",
            'subs' =>
            [
                {
                    'url' => "conversions.html",
                    'title' => "Supported Conversions",
                },
                {
                    'url' => "flags.html",
                    'title' => "Flags to the conversions",
                },
                {
                    'url' => "width.html",
                    'title' => "Width and Max Width",
                },
            ],
        },
        {
            'url' => "string-forms",
            'title' => "Alternate Forms for Writing Strings",
            'subs' =>
            [
                {
                    'url' => "q_qq.html",
                    'title' => "q{}, qq{} and Friends",
                },
                {
                    'url' => "here_doc.html",
                    'title' => "Here Document",
                },
            ],
        },
        {
            'url' => "processes",
            'title' => "Executing Other Processes",
            'subs' =>
            [
                {
                    'url' => "system.html",
                    'title' => "The system() Command",
                },
                {
                    'url' => "backticks.html",
                    'title' => "Trapping Command Output with `...`",
                },
                {
                    'url' => "opens.html",
                    'title' => "open() for Command Execution",
                },
                {
                    'url' => "string-shellquote.html",
                    'title' => "String::ShellQuote",
                },
            ],
        },
        {
            'url' => "and_or",
            'title' => "More about || and &amp;&amp;",
            'subs' =>
            [
                {
                    'url' => "sort.html",
                    'title' => "For sort()",
                },
                {
                    'url' => "english_and_or.html",
                    'title' => "The \"and\" and \"or\" Operators",
                },
            ],
        },
        {
            'url' => "exceptions",
            'title' => "Exceptions",
            'subs' =>
            [
                {
                    'url' => "die_and_eval.html",
                    'title' => "die and eval",
                },
                {
                    'url' => "carp.html",
                    'title' => "The Carp module",
                },
                {
                    'url' => "error.pm.html",
                    'title' => "The Error.pm module",
                },
            ],
        },
        {
            'url' => "system-funcs",
            'title' => "More System Functions",
            'subs' =>
            [
                {
                    'url' => "dir.html",
                    'title' => "Directory Input Routines",
                },
                {
                    'url' => "random_io.html",
                    'title' => "Random File I/O",
                },
                {
                    'url' => "file-tests.html",
                    'title' => "File Tests (-e, -d...)"
                },
                {
                    'url' => "chdir_getcwd_mkdir.html",
                    'title' => "chdir(), getcwd() and mkdir().",
                },
                {
                    'url' => "stat.html",
                    'title' => "The stat() Function",
                },
            ],
        },
    ],
    'images' =>
    [
        'style.css',
        'somerights20.gif',
        qw(
and_or/open-or.pl
and_or/shift-or.pl
and_or/sort-or.pl
exceptions/die-eval.pl
processes/count-dirs.pl
processes/open1.pl
processes/open2.pl
processes/system.pl
sprintf/conv-examples.pl
sprintf/flags-examples.pl
sprintf/sprintf1.pl
sprintf/width.pl
string-forms/here-doc.pl
string-forms/q_qq-examples.pl
system-funcs/rot13.pl
system-funcs/r.pl
system-funcs/search-mp3s.pl
        ),
    ],
};

sub get_contents
{
    return $contents;
}

1;
