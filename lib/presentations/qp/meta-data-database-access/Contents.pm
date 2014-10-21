package Contents;

use strict;

my $contents =
{
    'title' => "Meta-Data Database Access",
    'subs' =>
    [
        {
            'url' => "intro.html",
            'title' => "Introduction",
        },
        {
            'url' => "example",
            'title' => "Example",
            'subs' =>
            [
                {
                    'url' => "wheres_the_code.html",
                    'title' => "Where's the code?"
                },
            ],
        },
        {
            'url' => "future.html",
            'title' => "Future Directions",
        },
    ],
    'images' =>
    [
        'style.css',
    ],
};

sub get_contents
{
    return $contents;
}

1;
