#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

use utf8;

use open IO => ":encoding(utf8)";

binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";

my $content = io('-')->binmode(":utf8")->slurp();

sub to_unicode
{
    my ($s) = @_;

    $s =~ tr/'/’/;

    return $s;
}

my @matches =
(
    "aren't",
    "doesn't",
    "don't",
    "Here's",
    "he'syou'd",
    "I'd",
    "I'd",
    "I'll",
    "I'm",
    "it's",
    "I've",
    "let's",
    "she's",
    "that's",
    "there's",
    "they're",
    "wasn't",
    "we'd",
    "we'll",
    "we're",
    "weren't",
    "what's",
    "won't",
    "you'd",
    "you're",
    "you've",
);

my $re_s = join("|", map { '(?:' . quotemeta($_) . ')' } @matches);
my $re = qr/\b$re_s\b/i;

$content =~ s{($re)}{to_unicode($1)}egi;

print $content;
