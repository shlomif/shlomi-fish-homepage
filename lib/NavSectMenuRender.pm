package NavSectMenuRender;

use strict;
use warnings;

use utf8;

use MyNavData;

use Shlomif::Homepage::SectionMenu::Manager ();

use vars (qw($section_nav_menu));

sub init_section_nav_menu
{
    my ( $class, $args ) = @_;

    my $filename = $args->{filename};
    my $host     = $args->{host};
    my $ROOT     = $args->{ROOT};

    # Adding to disable the google ads since they're not
    # operational.
    my $ads_side = '';

    my $section_nav_menu =
        Shlomif::Homepage::SectionMenu::Manager->get_nav_menu(
        {
            'path_info'    => $filename,
            'current_host' => $host,
            'root'         => "$ROOT",
            'bottom_code'  => $ads_side,
        },
        );

    return +{ section_nav_menu => $section_nav_menu, };
}

1;
