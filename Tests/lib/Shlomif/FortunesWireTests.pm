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

    subtest 'check show.cgi' => sub {
        plan tests => 2;

        my $showcgi_url = $base_url . "humour/fortunes/show.cgi";
        my $cookie_url =
            $showcgi_url . "?id=i-thought-using-loops-was-cheating";
        pass("This is a subtest");
        my $mech = WWW::Mechanize->new();

        $mech->get($cookie_url);
        is( $mech->status(), 200, "show.cgi OK", );

        return;
    };

    return;
}

1;

__END__

# # Below is stub documentation for your module. You'd better edit it!
