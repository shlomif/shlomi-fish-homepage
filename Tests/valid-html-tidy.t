#!/usr/bin/perl

use strict;
use warnings;

use Data::Munge qw/ list2re /;
use Test::HTML::Tidy::Recursive ();
use lib './lib';
use Shlomif::Homepage::Paths ();

my $T2_POST_DEST = Shlomif::Homepage::Paths->new->t2_post_dest;

my @SKIP_LIST = (
    qw#
        dest/post-incs/t2/MathVentures/
        dest/post-incs/t2/MathVentures/3d-outof-4d-mathml.xhtml
        dest/post-incs/t2/MathVentures/bugs-in-square-mathml.xhtml
        dest/post-incs/t2/grad-fu/
        dest/post-incs/t2/humour/
        dest/post-incs/t2/lecture/
        dest/post-incs/t2/me/
        dest/post-incs/t2/open-source/
        dest/post-incs/t2/philosophy/
        dest/post-incs/t2/prog-evolution/
        dest/post-incs/t2/puzzles/
        dest/post-incs/t2/rindolf/
        dest/post-incs/t2/work/
        #
);

my $RE = list2re @SKIP_LIST;
Test::HTML::Tidy::Recursive->new(
    {
        targets         => [$T2_POST_DEST],
        filename_filter => sub {
            my $fn = shift;
            return (
                not(   $fn =~ m{/index\.xhtml\z}
                    or $fn =~ m{\A$RE}
                    or $fn =~ m{js/MathJax} )
            );
        },
    }
)->run;
