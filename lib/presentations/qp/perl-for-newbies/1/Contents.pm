package Contents;

use strict;

my $contents =
{
    'title' => "\"Perl for Perl Newbies\" - Part 1",
    'subs' =>
    [
        {
            'url' => "intro",
            'title' => "Introduction",
            'subs' =>
            [
                {
                    'url' => "capabilities.html",
                    'title' => "The capabilities of Perl",
                },
                {
                    'url' => "history.html",
                    'title' => "A brief history of Perl",
                },
                {
                    'url' => "devel_cycle.html",
                    'title' => "The perl development cycle",
                },
            ],
        },
        {
            'url' => "output",
            'title' => "Basic Output (The \"Hello World\" program)",
            'subs' =>
            [
                {
                    'url' => "semicolons.html",
                    'title' => "More about semicolons",
                },
            ],
        },
        {
            'url' => "expressions",
            'title' => "Expressions",
            'subs' =>
            [
                {
                    'url' => "operators.html",
                    'title' => "Operators and Precedence",
                },
                {
                    'url' => "functions.html",
                    'title' => "Functions",
                },

                {
                    'url' => "strings",
                    'title' => "More about strings",
                    'subs' =>
                    [
                        {
                            'url' => "escape.html",
                            'title' => "Escape Sequences",
                        },
                    ],
                },
            ],
        },
        {
            'url' => "variables",
            'title' => "Variables",
            'subs' =>
            [
                {
                    'url' => "plus-equal.html",
                    'title' => "\"+=\" and friends",
                },
            ],
        },
        {
            'url' => "input.html",
            'title' => "Input",
        },
        {
            'url' => "for_loop.html",
            'title' => "The For Loop",
        },
        {
            'url' => "conditionals",
            'title' => "Conditionals",
            'subs' =>
            [
                {
                    'url' => "numerical.html",
                    'title' => "Numerical Comparison Operators",
                },
                {
                    'url' => "string.html",
                    'title' => "String Comparison Operators",
                },
                {
                    'url' => "boolean.html",
                    'title' => "Boolean Operators",
                },
                {
                    'url' => "true_vs_false.html",
                    'title' => "True Expressions vs. False Expressions",
                },
                {
                    'url' => "elsif.html",
                    'title' => "elsif",
                },
            ],
        },
        {
            'url' => "while",
            'title' => "The While Loop",
            'subs' =>
            [
                {
                    'url' => "last_and_next.html",
                    'title' => "last and next",
                },
            ],
        },
        {
            'url' => "arrays",
            'title' => "Arrays",
            'subs' =>
            [
                {
                    'url' => "comma.html",
                    'title' => "The ',' operator",
                },
                {
                    'url' => "negative_indexes.html",
                    'title' => "Negative Indexes",
                },
                {
                    'url' => "foreach",
                    'title' => "The foreach loop",
                    'subs' =>
                    [
                        {
                            'url' => "for_and_dotdot.html",
                            'title' => "The for keyword and the .. operator",
                        },
                    ],
                },
                {
                    'url' => "functions.html",
                    'title' => "Built-In Array Functions",
                },
                {
                    'url' => "x.html",
                    'title' => "The x operator",
                },
            ],
        },
    ],
    'images' =>
    [
        'somerights20.gif',
        'style.css',
        qw(
conditionals/name_abc.pl
conditionals/even_numbers.pl
conditionals/letter_a.pl
conditionals/range.pl
conditionals/string_compare.pl
conditionals/non_div3_numbers.pl
conditionals/elsif.pl
variables/plus-equal2.pl
variables/plus-equal1.pl
variables/var1.pl
arrays/comma2.pl
arrays/x.pl
arrays/foreach/foreach.pl
arrays/pop2.pl
arrays/push.pl
arrays/pop.pl
arrays/join.pl
arrays/shift.pl
arrays/primes1.pl
arrays/comma1.pl
arrays/primes2.pl
arrays/reverse.pl
for_loop/multiplication_board.pl
for_loop/1to100.pl
input/input1.pl
input/input2.pl
while/all_as.pl
while/all_as_with_last.pl
while/power_of_2.pl
while/pyramid1.pl
output/hello.pl
output/oftf1.pl
output/oftf2.pl
expressions/strings/strings_and_numbers.pl
expressions/strings/escape.pl
expressions/length.pl
expressions/int.pl
expressions/operators.pl
expressions/operators.out.txt
expressions/substr2.pl
expressions/substr.pl
expressions/substr.out.txt
expressions/concat.pl
)
    ],
};

sub get_contents
{
    return $contents;
}
