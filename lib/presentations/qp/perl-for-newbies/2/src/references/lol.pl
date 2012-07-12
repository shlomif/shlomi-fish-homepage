use strict;
use warnings;

my $contents =
{
    'title' => "Contents",
    'subs' =>
    [
        {
            'url' => "for",
            'title' => "The for loop",
            'subs' =>
            [
                {
                    'url' => "next.html",
                    'title' => "Behaviour of next in the for loop",
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
                    'title' => "Hash Functions",
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
            ],
        },
        {
            'url' => "argv.html",
            'title' => "The \@ARGV array",
        },
    ],
    'images' =>
    [
        {
            'url' => 'style.css',
            'type' => 'text/css',
        }
    ],
};

sub get_contents
{
    return $contents;
}
