package Shlomif::MD;

use strict;
use warnings;

use Markdent::Simple::Fragment ();
use Path::Tiny qw/ path /;

sub as_text
{
    my ($fn) = @_;
    return Markdent::Simple::Fragment->new->markdown_to_html(
        markdown => path($fn)->slurp_utf8,
        dialects => [qw/ GitHub /],
    );
}

1;
