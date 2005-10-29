#!/usr/bin/perl

use strict;
use warnings;

use lib "./lib";

use Shlomif::Homepage::Rss;

my $feed = Shlomif::Homepage::Rss->new();
$feed->run();

