package Shlomif::Out;

use strict;
use warnings;

use IO::All qw/ io /;

use parent 'Exporter';

our @EXPORT_OK = (qw(write_on_change));

sub write_on_change
{
    my ($io, $text_ref) = @_;

    if ((! $io->()->exists()) or ($io->()->all() ne $$text_ref))
    {
        $io->()->print($$text_ref);
    }

    return;
}

1;

