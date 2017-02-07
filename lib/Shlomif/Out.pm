package Shlomif::Out;

use strict;
use warnings;

use parent 'Exporter';

our @EXPORT_OK = (qw(write_on_change write_on_change_no_utf8));

sub write_on_change
{
    my ( $io, $text_ref ) = @_;

    if ( ( !-e $io ) or ( $io->slurp_utf8() ne $$text_ref ) )
    {
        $io->spew_utf8($$text_ref);
    }

    return;
}

sub write_on_change_no_utf8
{
    my ( $io, $text_ref ) = @_;

    if ( ( !-e $io ) or ( $io->slurp() ne $$text_ref ) )
    {
        $io->spew($$text_ref);
    }

    return;
}

1;

