#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use Shlomif::Homepage::FortuneCollections;

binmode STDOUT, ':encoding(UTF-8)';

my $filename = shift(@ARGV);

Shlomif::Homepage::FortuneCollections->write_fortune_all_in_one_page_to_file(
    $filename
);

Shlomif::Homepage::FortuneCollections->write_epub_json('lib/fortunes/xhtmls/book.json');

1;
