#!/usr/bin/env perl

use strict;
use warnings;
use lib './lib';
use HTML::Latemp::Local::Paths            ();
use Test::HTML::Recursive::DeprecatedTags ();

my $T2_POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;
Test::HTML::Recursive::DeprecatedTags->new(
    {
        targets         => [$T2_POST_DEST],
        filename_filter => sub {
            my $fn = shift;
            return (
                not(   $fn =~ m{js/MathJax}
                    or $fn =~
m#\A \Q$T2_POST_DEST\E/lecture/.*(?:Vim|Test-Run|Opt-Multi-Task)#x
                )
            );
        },
    }
)->run;