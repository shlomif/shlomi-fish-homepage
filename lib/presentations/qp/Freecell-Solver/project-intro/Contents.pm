package Contents;

use strict;

my $contents =
{
    'title' => "Freecell Solver: Project Introduction",
    'subs' =>
    [
        {
            'title' => "Goals",
            'url' => "goals.html",
        },
        {
            'title' => "History",
            'url' => "history.html",
        },
        {
            'title' => "Architecture",
            'url' => "architecture.html",
        },
        {
            'title' => "To Do's",
            'url' => "to-dos.html",
        },
        {
            'title' => "Links and References",
            'url' => "links.html",
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
