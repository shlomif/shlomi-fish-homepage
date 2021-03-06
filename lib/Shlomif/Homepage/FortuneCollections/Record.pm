package Shlomif::Homepage::FortuneCollections::Record;

use strict;
use warnings;

use Moo;

has [
    qw(
        about_blurb
        desc
        id
        meta_desc
        page_title
        text
        title
    )
] => ( is => 'ro', required => 1 );

sub nav_record
{
    my ($self) = @_;

    return {
        text  => scalar( $self->text() ),
        url   => sprintf( "humour/fortunes/%s.html", scalar( $self->id() ) ),
        title => scalar( $self->title() ),
    };
}

1;
