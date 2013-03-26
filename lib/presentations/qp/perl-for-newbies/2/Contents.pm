package Contents;

use strict;

my $contents =
{
    'title' => "\"Perl for Perl Newbies\" - Part 2",
    'subs' =>
    [
        {
            'url' => "for",
            'title' => "The for Loop",
            'subs' =>
            [
                {
                    'url' => "next.html",
                    'title' => "Behaviour of next in the for Loop",
                },
                {
                    'url' => "whence_for.html",
                    'title' => "Whence for?",
                },
            ],
        },
        {
            'url' => "hashes",
            'title' => "Hashes",
            'subs' =>
            [
                {
                    'url' => "functions.html",
                    'title' => "Hash-Related Functions",
                },
            ],
        },
        {
            'url' => "my",
            'title' => "Declaring Local Variables with \"my\"",
            'subs' =>
            [
                {
                    'url' => "use_strict.html",
                    'title' => "\"use strict\", Luke!",
                },
                {
                    'url' => "use_warnings.html",
                    'title' => "\"use warnings\", Luke!",
                },
            ],
        },
        {
            'url' => "functions",
            'title' => "Functions",
            'subs' =>
            [
                {
                    'url' => "recursion.html",
                    'title' => "Function Recursion",
                },
                {
                    'url' => "shift.html",
                    'title' => "Use of \"shift\" in Functions",
                },
            ],
        },
        {
            'url' => "files",
            'title' => "File Input/Output",
            'subs' =>
            [
                {
                    'url' => "print.html",
                    'title' => "Using \"print\" with Files",
                },
                {
                    'url' => "readline.html",
                    'title' => "The \&lt;FILEHANDLE\&gt; Operator",
                },
            ],
        },
        {
            'url' => "argv.html",
            'title' => "The \@ARGV Array",
        },
        {
            'url' => "regexps",
            'title' => "Regular Expressions",
            'subs' =>
            [
                {
                    'url' => "syntax.html",
                    'title' => "Syntax",
                },
                {
                    'url' => "multi_char.html",
                    'title' => "\".\", \"[ ... ]\"",
                },
                {
                    'url' => "asterisk.html",
                    'title' => "The \"*\" and Friends",
                },
                {
                    'url' => "grouping.html",
                    'title' => "Grouping",
                },
                {
                    'url' => "alternation.html",
                    'title' => "Alternation with \"|\"",
                },
                {
                    'url' => "binding.html",
                    'title' =>
                        "Binding to the Beginning or the End of a String",
                },
                {
                    'url' => "substitute",
                    'title' => "Substituting using Regular Expressions",
                    'subs' =>
                    [
                        {
                            'url' => "e_switch.html",
                            'title' => "The \"e\" Switch",
                        },
                        {
                            'url' => "ungreedy.html",
                            'title' => "Ungreedy Matching with *? and Friends",
                        },
                    ],
                },
                {
                    'url' => "flags.html",
                    'title' => "Useful Flags",
                },
                {
                    'url' => "esc_seqs.html",
                    'title' => "Useful Escape Sequences",
                },
                {
                    'url' => "next_step.html",
                    'title' => "The Next Step",
                },
            ],
        },
        {
            'url' => "interpolation.html",
            'title' => "String Interpolation",
        },
        {
            'url' => "useful_funcs",
            'title' => "Useful Functions",
            'subs' =>
            [
                {
                    'url' => "split.html",
                    'title' => "split",
                },
                {
                    'url' => "map.html",
                    'title' => "map",
                },
                {
                    'url' => "sort",
                    'title' => "sort",
                    'subs' =>
                    [
                        {
                            'url' => "cmp.html",
                            'title' => "&lt;=&gt; and cmp",
                        },
                    ],
                },
                {
                    'url' => "grep.html",
                    'title' => "grep",
                },
            ],
        },
        {
            'url' => "references",
            'title' => "References",
            'subs' =>
            [
                {
                    'url' => "hanoi.html",
                    'title' => "Example: The Towers of Hanoi",
                },
                {
                    'url' => "backslash.html",
                    'title' => "\\ - Taking a Reference to an Existing Variable",
                },
                {
                    'url' => "square_brackets.html",
                    'title' => "[ \@array ] - a Dynamic Reference to an Array",
                },
                {
                    'url' => "curly_brackets.html",
                    'title' => "{ \%hash } - a Dynamic Reference to a Hash",
                },
                {
                    'url' => "arrow.html",
                    'title' => "The Arrow Operators",
                },
                {
                    'url' => "dereferencing.html",
                    'title' => "Dereferencing",
                },
            ],
        },
        {
            'url' => "debugger",
            'title' => "Using the perl Debugger",
            'subs' =>
            [
                {
                    'url' => "stepping.html",
                    'title' => "Stepping over and Stepping in",
                },
                {
                    'url' => "breakpoints.html",
                    'title' => "Setting Breakpoints and Continuing",
                },
                {
                    'url' => "perl_cmds.html",
                    'title' => "Executing Perl Commands inside the Debugger",
                },
                {
                    'url' => "more_info.html",
                    'title' => "Getting More Information",
                },
            ],
        },
        {
            'url' => "finale.html",
            'title' => "Finale",
        },
    ],
    'images' =>
    [
        'somerights20.gif',
        'style.css',
        qw(
        argv/copy.pl
files/line_count.pl
files/line_numbers.pl
files/print2.pl
files/print.pl
for/multiplication_board.pl
for/primes.pl
for/primes_while.pl
functions/min_max.pl
functions/pythagoras.pl
functions/splitting.pl
functions/splitting_shift.pl
hashes/bank.old.pl
hashes/bank.pl
hashes/comma.pl
hashes/delete.pl
hashes/unique.pl
interpolate1.pl
my/my1.pl
my/primes_us.pl
references/deref1.pl
references/hanoi.pl
references/lol.pl
references/print_contents.pl
references/update_sum.pl
references/vector_sum.pl
regexps/all_as.pl
regexps/flags/index.pl
regexps/hello.pl
regexps/l---x.pl
regexps/perl_var.pl
regexps/semicolons_and_commas.pl
regexps/sentence.pl
regexps/sentence_with_numbers.pl
regexps/string_ends_ellip.pl
regexps/substitute/length.pl
regexps/substitute/number.pl
regexps/substitute/reverse_words.pl
regexps/substitute/ungreedy.pl
regexps/substitute/uppercase.pl
useful_funcs/double.pl
useful_funcs/grep.pl
useful_funcs/primes.pl
useful_funcs/rle.pl
useful_funcs/sort/integer_sort_cmp.pl
useful_funcs/sort/integer_sort.pl
useful_funcs/sort/reverse_string_sort.pl
useful_funcs/uid.pl
useful_funcs/words.pl
),
    ],
};

sub get_contents
{
    return $contents;
}
