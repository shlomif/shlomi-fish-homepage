package HTML::Latemp::Local::Paths::Test;

use strict;
use warnings;
use Moo;
extends('HTML::Latemp::Local::Paths');
use Test::More;

sub _check_size
{
    my ( $self, $path, $args ) = @_;
    $args //= +{};
    my $size = $args->{size} // 100;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my $POST_DEST = $self->t2_post_dest;

    return cmp_ok( scalar( -s "$POST_DEST/$path" ),
        ">", $size, "$path has size greater than $size" );
}

1;
