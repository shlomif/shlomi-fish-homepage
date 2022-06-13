package Shlomif::MD;

use strict;
use warnings;

use Markdent::Simple::Fragment ();
use Path::Tiny                 qw/ path /;

sub as_text
{
    my ($fn) = @_;
    return Markdent::Simple::Fragment->new->markdown_to_html(
        markdown => path($fn)->slurp_utf8,
        dialects => [qw/ GitHub /],
    );
}

sub as_fixed_xhtml5
{
    my $args = shift;

    return as_text( $args->{fn} ) =~
        s#align="(left|right)"#style="float:$1;"#gr =~ s#(<img )([^>]+)(>)#
    my ($s, $mid, $e)=($1, $2, $3);
    $mid.=" /" if $mid !~ m%/\s*\z%;
    $s.$mid.$e
        #egr =~ s#<hr>#<hr />#gr;
}

1;
