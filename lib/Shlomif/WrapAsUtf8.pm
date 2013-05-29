package Shlomif::WrapAsUtf8;

use strict;
use warnings;

use parent 'Exporter';

our @EXPORT_OK = (qw(_wrap_as_utf8));

sub _wrap_as_utf8 {
    my ($cb) = @_;

    binmode STDOUT, ":utf8";

    $cb->();

    binmode STDOUT, ":raw";
}

1;
