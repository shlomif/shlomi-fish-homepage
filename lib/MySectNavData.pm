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
    },
    {
        'id' => "lectures",
        'regex' => "^/lecture/",
        'class' => "Lectures",
    },
    {
        'id' => "software",
        'regex' => "^/(open-source|jmikmod|grad-fu|rwlock|software-tools)/",
        'class' => "Software",
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
