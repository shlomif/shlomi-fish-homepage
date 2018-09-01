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
                not(   $fn =~ m{\Apost-dest/t2/meta/FAQ/}
                    or $fn =~ m{js/MathJax}
                    or $fn =~ m{\Apost-dest/t2/MathVentures/} )
            );
        },
    }
)->run;
