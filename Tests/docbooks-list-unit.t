#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Test::More tests => 2;
use Test::Differences (qw(eq_or_diff));
use List::MoreUtils qw/ all /;

use lib './Tests/lib';
use lib './lib';
use HTML::Latemp::DocBook::DocsList ();

my $documents = HTML::Latemp::DocBook::DocsList->new->docs_list;

# TEST
ok( scalar( all { $_->{db_ver} eq 5 } @$documents ), "db_ver is 5" );

# TEST
is(
    scalar(
        grep {
                    $_->{base} eq "case-for-file-swapping-rev3"
                and $_->{id} eq "case-for-file-swapping-rev3"
                and $_->{path} eq "philosophy/case-for-file-swapping/revision-3"
        } @$documents
    ),
    1,
    "db_ver is 5"
);
