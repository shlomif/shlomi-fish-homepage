package Shlomif::MD;

use strict;
use warnings;

use parent 'Exporter';

our @EXPORT_OK = qw/ print_markdown /;

use Markdent::Simple::Fragment ();
use Path::Tiny qw/ path /;
use Text::WrapAsUtf8 qw/ print_utf8 /;

sub as_text
{
    return Markdent::Simple::Fragment->new->markdown_to_html(
        markdown => path(shift)->slurp_utf8,
        dialects => [qw/ GitHub /],
    );
}

sub print_markdown
{
    print_utf8(
        Markdent::Simple::Fragment->new->markdown_to_html(
            markdown => path(shift)->slurp_utf8,
            dialects => [qw/ GitHub /],
        ),
    );

    return;
}

1;
