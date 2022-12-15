package Shlomif::Homepage::SectionMenu::Manager;

use strict;
use warnings;

use Shlomif::Homepage::SectionMenu ();
use Shlomif::Homepage::SectionMenu::IsHumour (qw/ get_is_humour_re /);

use Shlomif::Homepage::SectionMenu::AllSects ();

my @sections = (
    {
        'id'    => "art",
        'regex' => qr#\A/art/#,
        'class' => "Shlomif::Homepage::SectionMenu::Sects::Art",
        'title' => "Art Section Menu",
    },
    {
        'id'    => "essays",
        'regex' => qr#\A/(?:philosophy|prog-evolution|DeCSS)/#,
        'class' => "Shlomif::Homepage::SectionMenu::Sects::Essays",
        'title' => "Essays Section Menu",
    },
    {
        'id'    => "me",
        'regex' => qr#\A(/me/|/personal)#,
        'class' => "Shlomif::Homepage::SectionMenu::Sects::Me",
        'title' => "About Myself Section Menu",
    },
    {
        'id'    => "puzzles",
        'regex' => qr{\A/(?:(?:puzzles|MathVentures)/|toggle.html\z)},
        'class' => "Shlomif::Homepage::SectionMenu::Sects::Puzzles",
        'title' => "Puzzles Section Menu",
    },
    {
        'id'    => "lectures",
        'regex' => qr#\A/lecture/#,
        'class' => "Shlomif::Homepage::SectionMenu::Sects::Lectures",
        'title' => "Lectures Section Menu",
    },
    {
        'id'    => "software",
        'regex' =>
qr#\A/(?:open-source|jmikmod|grad-fu|rwlock|software-tools|no-ie|rindolf)/#,
        'class' => "Shlomif::Homepage::SectionMenu::Sects::Software",
        'title' => "Software Section Menu",
    },
    {
        'id'    => "humour",
        'regex' => qr#\A/@{[ get_is_humour_re()]}#,
        'class' => "Shlomif::Homepage::SectionMenu::Sects::Humour",
        'title' => "Humour Section Menu",
    },
    {
        'id'    => "meta",
        'regex' => qr#\A/meta/#,
        'class' => "Shlomif::Homepage::SectionMenu::Sects::Meta",
        'title' => "Site Meta Information Section Menu",
    },
);

sub get_nav_menu
{
    my ( $self, $args ) = @_;

    return Shlomif::Homepage::SectionMenu->new(
        {
            'sections' => [ @sections, ],
            %$args,
        }
    );
}

1;
