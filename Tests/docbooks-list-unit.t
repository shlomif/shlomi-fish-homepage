#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 3;
use List::Util qw/ all /;

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
    "case-for-file-swapping-rev3 is present and only once",
);

# TEST
is_deeply( [ sort { $a->{base} cmp $b->{base} } @$documents ],
    $documents, "Are sorted", );

