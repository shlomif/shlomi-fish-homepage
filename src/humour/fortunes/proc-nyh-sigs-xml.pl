#!/usr/bin/env perl

use strict;
use warnings;

use HTML::Widgets::NavMenu::EscapeHtml qw( escape_html );

use List::Util qw(min);

my $count     = 1;
my $enc       = 0;
my $id_str    = "PLOC-IDENT";
my $title_str = "QUACKPROLOKOG==UNKNOWN-TITLE";

my @lines;
while (<>)
{
    if ( m{\A *<fortune id=} .. m{\A *</raw>} )
    {
        push @lines, $_;
    }
    else
    {
        if (@lines)
        {
            my $text = join( "", @lines );
            $text =~ m{<!\[CDATA\[([^\n]*)$}ms;
            my $sig       = $1;
            my @words     = split( /\s+/, $sig );
            my @fmt_words = (
                map  { lc($_) }
                grep { length($_) }
                map  { my $s = $_; $s =~ s{\W}{}g; $s; } @words
            );

            my $id = "nyh-sig--"
                . join( "-", @fmt_words[ 0 .. min( 2, $#fmt_words ) ] );
            $text =~ s{(<fortune id=")[^"]+(">)}{$1$id$2};

            my $sig_esc = escape_html($sig);
            $text =~ s{(<title>)[^<]+(</title>)}{$1$sig_esc$2};
            print $text;
            @lines = ();
        }
        print $_;
    }
}
