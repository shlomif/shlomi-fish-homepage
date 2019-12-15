package Shlomif::XmlFictionSlurp;

use strict;
use warnings;

use Moo;

use Path::Tiny qw/ path /;

sub my_calc
{
    my ( $self, $args ) = @_;

    my $fn       = $args->{fn};
    my $index_id = $args->{index_id};

    my $text = path($fn)->slurp_utf8;

    $text =~ s{\bindex\b}{$index_id}g;
    $text =~ s# xml:space="preserve"([ >]|/>)#$1#g;
    $text =~ s#^[ \t]+(<)#$1#gms;

    return $text;
}

1;
