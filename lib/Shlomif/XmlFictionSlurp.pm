package Shlomif::XmlFictionSlurp;

use strict;
use warnings;

use Moo;

use Path::Tiny qw/ path /;

sub my_calc
{
    my ( $self, $args ) = @_;

    my $fn       = $args->{fn};
    my $h_delta  = ( $args->{h_delta}  // 0 );
    my $h1_delta = ( $args->{h1_delta} // 0 );
    my $index_id = $args->{index_id};

    my $text = path($fn)->slurp_utf8;

    $text =~ s{\bindex\b}{$index_id}g;
    $text =~ s# xml:space="preserve"([ >]|/>)#$1#g;
    $text =~ s#^[ \t]+(<)#$1#gms;
    $text =~
s{\bh([1-6])\b}{my $n = $1; "h" . (($n eq "1") ? ($h1_delta + $n) : ($h_delta + $n))}egms;

    return $text;
}

1;
