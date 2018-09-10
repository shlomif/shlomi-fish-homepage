#!/usr/bin/perl

use strict;
use warnings;

use Data::Munge qw/ list2re /;
use Test::HTML::Tidy::Recursive ();

my @SKIP_LIST = (
    qw#
        post-dest/t2/MathVentures/3d-outof-4d-mathml.xhtml
        post-dest/t2/MathVentures/bugs-in-square-mathml.xhtml
        post-dest/t2/humour/
        post-dest/t2/philosophy/computers/software-management/perfect-workplace/perfect-it-workplace.xhtml
        #
);

my $RE = list2re @SKIP_LIST;
Test::HTML::Tidy::Recursive->new(
    {
        targets         => ['./post-dest'],
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
