#!/usr/bin/perl

use strict;
use warnings;

use Test::HTML::Tidy::Recursive;

Test::HTML::Tidy::Recursive->new(
    {
        targets         => ['./post-dest'],
        filename_filter => sub {
            my $fn = shift;
            return (
                not(   $fn =~ m{\A post-dest/t2/meta/FAQ/}x
                    or $fn =~ m{\A post-dest/t2/me/rindolf/ }x
                    or $fn =~ m{\A post-dest/t2/art/bk2hp/ }x
                    or $fn =~
                    m{\A post-dest/t2/art/back-to-my-homepage-2nd-ver/ }x
                    or $fn =~ m{\A post-dest/t2/humour/humanity/songs/ }x
                    or $fn =~ m{\A post-dest/t2/open-source/anti/Adobe-Flash/ }x
                    or $fn =~ m{js/MathJax}
                    or $fn =~ m{\A post-dest/t2/MathVentures/}x )
            );
        },
    }
)->run;
