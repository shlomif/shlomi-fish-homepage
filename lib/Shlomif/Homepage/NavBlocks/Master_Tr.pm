package Shlomif::Homepage::NavBlocks::Master_Tr;

use strict;
use warnings;

use MooX (qw( late ));

extends('Shlomif::Homepage::NavBlocks::Title_Tr');

has 'css_class' => ( is => 'ro', isa => 'Str', default => 'main_title' );

use Shlomif::Homepage::NavBlocks::LocalLink ();

sub title_html
{
    my ( $self, $args ) = @_;

    return
        $self->title . " "
        . Shlomif::Homepage::NavBlocks::LocalLink->new(
        {
            css_class => "to_block",
            %$args,
            inner_html => "Link",
            path => sprintf( "meta/nav-blocks/blocks/#%s", $args->{table}->id ),
            no_wrap => 1,
        }
        )->render($args);
}

1;
