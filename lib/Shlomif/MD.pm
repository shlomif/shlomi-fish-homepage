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
    my ($fn) = @_;
    return Markdent::Simple::Fragment->new->markdown_to_html(
        markdown => path($fn)->slurp_utf8,
        dialects => [qw/ GitHub /],
    );
}

sub print_markdown
{
    my ($fn) = @_;
    print_utf8( as_text($fn) );

    return;
}

1;
