package Shlomif::XmlFictionSlurp;

use strict;
use warnings;

use IO::All qw/ io /;

use Shlomif::WrapAsUtf8 (qw(_print_utf8));

sub my_slurp
{
    my ( $class, $args ) = @_;

    my $fn       = $args->{fn};
    my $index_id = $args->{index_id};

    my $text = io->file($fn)->utf8->slurp;

    $text =~ s{\bindex\b}{$index_id}g;
    $text =~ s# xml:space="preserve"([ >]|/>)#$1#g;
    $text =~ s#^[ \t]+(<)#$1#gms;

    _print_utf8($text);

    return;
}

1;
