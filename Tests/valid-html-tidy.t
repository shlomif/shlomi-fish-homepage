#!/usr/bin/perl

use strict;
use warnings;

use Data::Munge qw/ list2re /;
use Test::HTML::Tidy::Recursive;

my @SKIP_LIST = (
    qw#
        post-dest/t2/MathVentures/
        post-dest/t2/art/back-to-my-homepage-2nd-ver/
        post-dest/t2/art/bk2hp/
        post-dest/t2/art/index.xhtml
        post-dest/t2/art/original-graphics/
        post-dest/t2/humour/bits/Atom-Text-Editor-edits-2_000_001-bytes/index.xhtml
        post-dest/t2/humour/Selina-Mandrake/index.xhtml
        post-dest/t2/humour/humanity/songs/
        post-dest/t2/me/rindolf/
        post-dest/t2/meta/FAQ/
        post-dest/t2/open-source/anti/Adobe-Flash/
        #
);

my $RE = list2re @SKIP_LIST;
Test::HTML::Tidy::Recursive->new(
    {
        targets         => ['./post-dest'],
        filename_filter => sub {
            my $fn = shift;
            return (
                not(   $fn =~ m{\A$RE}
                    or $fn =~ m{js/MathJax} )
            );
        },
    }
)->run;
