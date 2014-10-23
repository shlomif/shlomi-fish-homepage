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
        'class' => "Shlomif::Homepage::SectionMenu::Sects::Art",
        'title' => "Art Section Menu",
    },
    {
        'id' => "essays",
        'regex' => "^/(?:philosophy|prog-evolution|DeCSS)/",
        'class' => "Shlomif::Homepage::SectionMenu::Sects::Essays",
        'title' => "Essays Section Menu",
    },
    {
        'id' => "puzzles",
        'regex' => q{^/(?:(?:puzzles|MathVentures)/|toggle.html$)},
        'class' => "Shlomif::Homepage::SectionMenu::Sects::Puzzles",
        'title' => "Puzzles Section Menu",
    },
    {
        'id' => "lectures",
        'regex' => "^/lecture/",
        'class' => "Shlomif::Homepage::SectionMenu::Sects::Lectures",
        'title' => "Lectures Section Menu",
    },
    {
        'id' => "software",
        'regex' => "^/(?:open-source|jmikmod|grad-fu|rwlock|software-tools|no-ie|rindolf)/",
        'class' => "Shlomif::Homepage::SectionMenu::Sects::Software",
        'title' => "Software Section Menu",
    },
    {
        'id' => "humour",
        'regex' => "^/(?:humour/|(?:(?:humour(?:-heb)?|wysiwyt|wonderous)\.html))",
        'class' => "Shlomif::Homepage::SectionMenu::Sects::Humour",
        'title' => "Humour Section Menu",
    },
    {
        'id' => "meta",
        'regex' => "^/meta/",
        'class' => "Shlomif::Homepage::SectionMenu::Sects::Meta",
        'title' => "Site Meta Information Section Menu",
    },
);

sub get_nav_menu
{
    return Shlomif::Homepage::SectionMenu->new(
        'sections' => \@sections,
        @_,
    );
}

1;
