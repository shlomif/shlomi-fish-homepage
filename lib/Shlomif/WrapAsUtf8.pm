package Shlomif::WrapAsUtf8;

use strict;
use warnings;

use parent 'Exporter';

our @EXPORT_OK = (qw(_print_utf8 _wrap_as_utf8));

sub _wrap_as_utf8
{
    my ($cb) = @_;

    binmode STDOUT, ":encoding(UTF-8)";

    $cb->();

    binmode STDOUT, ":raw";

    return;
}

sub _print_utf8
{
    my (@data) = @_;

    _wrap_as_utf8(
        sub {
            print @data;

            return;
        }
    );

    return;
}

1;
