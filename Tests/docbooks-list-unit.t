#!/usr/bin/env perl

use strict;
use warnings;
use utf8;

use Test::More tests => 1;
use Test::Differences (qw(eq_or_diff));
use List::MoreUtils qw/ all /;

use lib './Tests/lib';
use lib './lib';
use HTML::Latemp::DocBook::DocsList ();

my $documents = HTML::Latemp::DocBook::DocsList->new->docs_list;

# TEST
ok( scalar( all { $_->{db_ver} eq 5 } @$documents ), "db_ver is 5" );
