package Shlomif::Homepage::SectionMenu::IsHumour;

use strict;
use warnings;
use 5.014;

use parent 'Exporter';

our @EXPORT_OK = (qw/ get_is_humour_re humour_should_mutate_title /);
my $IS_HUMOUR =
    qr#(?:humour/|(?:(?:humour(?:-heb)?|wonderous|wysiwyt)\.html\z))#;

sub get_is_humour_re
{
    return $IS_HUMOUR;
}

sub humour_should_mutate_title
{
    my ($raw_fn_path) = @_;
    return (    $raw_fn_path =~ $IS_HUMOUR
            and $raw_fn_path !~ m#humour/bits/true-stories/#ms );
}

1;
