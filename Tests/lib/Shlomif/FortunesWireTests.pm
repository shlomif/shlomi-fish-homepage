package Shlomif::FortunesWireTests;

use strict;
use warnings;
our $VERSION = '0.0.1';

use Moo;

use Test::More;

use WWW::Mechanize ();

has 'base_url' => ( is => 'ro', required => 1 );

sub run
{
    my ( $self, ) = @_;

    my $base_url = $self->base_url();

    return;
}

1;

__END__

# # Below is stub documentation for your module. You'd better edit it!
