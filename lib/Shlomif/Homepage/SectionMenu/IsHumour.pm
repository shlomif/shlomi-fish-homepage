package Shlomif::Homepage::SectionMenu::IsHumour;

use strict;
use warnings;
use 5.014;

use parent 'Exporter';

our @EXPORT_OK = (qw/ get_is_humour_re /);
my $IS_HUMOUR =
    qr#(?:humour/|(?:(?:humour(?:-heb)?|wonderous|wysiwyt)\.html\z))#;

sub get_is_humour_re
{
    return $IS_HUMOUR;
}

1;
