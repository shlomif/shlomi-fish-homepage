#!/usr/bin/perl

use strict;
use warnings;

use utf8;

use open IO => ':encoding(utf8)';

local $/;

my $text = <ARGV>;

$text =~ s{(?<=\n\n)"([^"]+)"(?=\n\n)}{„$1“}msg;

binmode STDOUT, ':encoding(utf8)';
print $text;
