#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use Test::More tests => 1;

use IO::All qw/io/;

{
    my $content = io->file("./dest/t2/humour/fortunes/sharp-programming.html")->utf8->all;

    # TEST
    like ($content, qr{<a href=\r?\n?"https://en.wikipedia.org/wiki/NP-completeness" rel=\r?\n?"nofollow">https://en.wikipedia.org/wiki/NP-completeness</a>}, 'Contains a hyperlink.');
}
