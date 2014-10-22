package MySectNavData;

use strict;
use warnings;

use Shlomif::Homepage::SectionMenu;

use Shlomif::Homepage::SectionMenu::AllSects;

my @sections =
(
    {
        'id' => "art",
        'regex' => "^/art/",
        'class_base' => "Art",
        'title' => "Art Section Menu",
    },
    {
        'id' => "essays",
        'regex' => "^/(?:philosophy|prog-evolution|DeCSS)/",
        'class_base' => "Essays",
        'title' => "Essays Section Menu",
    },
    {
        'id' => "puzzles",
        'regex' => q{^/(?:(?:puzzles|MathVentures)/|toggle.html$)},
        'class_base' => "Puzzles",
        'title' => "Puzzles Section Menu",
    },
    {
        'id' => "lectures",
        'regex' => "^/lecture/",
        'class_base' => "Lectures",
        'title' => "Lectures Section Menu",
    },
    {
        'id' => "software",
        'regex' => "^/(?:open-source|jmikmod|grad-fu|rwlock|software-tools|no-ie|rindolf)/",
        'class_base' => "Software",
        'title' => "Software Section Menu",
    },
    {
        'id' => "humour",
        'regex' => "^/(?:humour/|(?:(?:humour(?:-heb)?|wysiwyt|wonderous)\.html))",
        'class_base' => "Humour",
        'title' => "Humour Section Menu",
    },
    {
        'id' => "meta",
        'regex' => "^/meta/",
        'class_base' => "Meta",
        'title' => "Site Meta Information Section Menu",
    },
);

foreach my $s (@sections)
{
    $s->{class} = "Shlomif::Homepage::SectionMenu::Sects::$s->{class_base}";
}

sub get_nav_menu
{
    return Shlomif::Homepage::SectionMenu->new(
        'sections' => \@sections,
        @_,
    );
}

1;
