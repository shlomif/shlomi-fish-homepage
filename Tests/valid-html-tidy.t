#!/usr/bin/perl

use strict;
use warnings;

use Test::HTML::Tidy::Recursive;

Test::HTML::Tidy::Recursive->new({
        targets => ['./dest'],
        filename_filter => sub {
            my $fn = shift;
            return (not ($fn =~ m{js/MathJax}
                        or $fn =~ m{\Adest/t2/MathVentures/}));
        },
    })->run;
