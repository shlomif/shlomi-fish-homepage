package Shlomif::XmlFictionSlurp;

use strict;
use warnings;

use Path::Tiny qw/ path /;
use Text::WrapAsUtf8 qw/ print_utf8 /;

sub my_calc
{
    my ( $class, $args ) = @_;

    my $fn       = $args->{fn};
    my $index_id = $args->{index_id};

    my $text = path($fn)->slurp_utf8;

    $text =~ s{\bindex\b}{$index_id}g;
    $text =~ s# xml:space="preserve"([ >]|/>)#$1#g;
    $text =~ s#^[ \t]+(<)#$1#gms;

    return $text;
}

sub my_slurp
{
    my ( $class, $args ) = @_;

    print_utf8( $class->my_calc($args) );

    return;
}

1;
