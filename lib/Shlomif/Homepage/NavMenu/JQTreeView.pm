package Shlomif::Homepage::NavMenu::JQTreeView;

use strict;
use warnings;

use base 'HTML::Widgets::NavMenu';

sub render
{
    my $self = shift;

    return $self->render_jquery_treeview(@_);
}

1;

