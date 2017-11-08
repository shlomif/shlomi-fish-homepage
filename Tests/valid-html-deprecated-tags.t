#!/usr/bin/perl

use strict;
use warnings;

use Test::HTML::Recursive::DeprecatedTags;

Test::HTML::Recursive::DeprecatedTags->new(
    {
        targets         => ['./dest'],
        filename_filter => sub {
            my $fn = shift;
            return (
                not(   $fn =~ m{js/MathJax}
                    or $fn =~
                    m#\A dest/t2/lecture/.*(?:Vim|Test-Run|Opt-Multi-Task)#x )
            );
        },
    }
)->run;
