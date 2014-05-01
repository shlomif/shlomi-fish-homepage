#!/usr/bin/perl

use strict;
use warnings;

use Shlomif::Homepage::FortuneCollections;

binmode STDOUT, ':utf8';

my $filename = shift(@ARGV);

Shlomif::Homepage::FortuneCollections->write_fortune_all_in_one_page_to_file(
    $filename
);

1;
