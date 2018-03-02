package Shlomif::MD;

use strict;
use warnings;

use parent 'Exporter';

our @EXPORT_OK = qw/ print_markdown /;

use Text::Markdown qw/ markdown /;
use Path::Tiny qw/ path /;
use Text::WrapAsUtf8 qw/ print_utf8 /;

sub print_markdown
{
    print_utf8( markdown( path(shift)->slurp_utf8 ) );

    return;
}

1;
