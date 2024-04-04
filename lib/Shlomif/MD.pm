package Shlomif::MD;

use strict;
use warnings;

use Moo;

use Markdent::Simple::Fragment ();
use Path::Tiny                 qw/ path /;

sub as_text
{
    my ( $self, $fn ) = @_;
    return Markdent::Simple::Fragment->new->markdown_to_html(
        markdown => path($fn)->slurp_utf8,
        dialects => [qw/ GitHub /],
    );
}

sub as_fixed_xhtml5
{
    my ( $self, $args ) = @_;

    return $self->as_text( $args->{fn} ) =~
        s#align="(left|right)"#style="float:$1;"#gr =~ s#(<img )([^>]+)(>)#
            my ($start, $mid, $end) = ($1, $2, $3);
            $mid .= " /" if $mid !~ m%/\s*\z%;
            $start . $mid . $end
        #egr =~ s#<hr>#<hr />#gr;
}

1;
