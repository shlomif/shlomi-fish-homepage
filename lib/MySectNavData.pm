package MySectNavData;

use strict;
use warnings;

use Shlomif::Homepage::SectionMenu;

my @sections = 
(
    {
        'id' => "essays",
        'regex' => "^/philosophy/",
        'class' => "Essays",
        'title' => "Essays Section Menu",
    },
    {
        'id' => "lectures",
        'regex' => "^/lecture/",
        'class' => "Lectures",
        'title' => "Lectures Section Menu",
    },
    {
        'id' => "software",
        'regex' => "^/(open-source|jmikmod|grad-fu|rwlock|software-tools)/",
        'class' => "Software",
        'title' => "Software Section Menu",
    },
    {
        'id' => "humour",
        'regex' => "^/(humour/|((humour|wysiwyt|wonderous)\.html))",
        'class' => "Humour",
        'title' => "Humour Section Menu",
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
