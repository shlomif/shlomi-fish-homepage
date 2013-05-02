#!/usr/bin/perl

use strict;
use warnings;

use Shlomif::Homepage::FortuneCollections;

binmode STDOUT, ':utf8';

Shlomif::Homepage::FortuneCollections->print_fortune_all_in_one_page();

1;
