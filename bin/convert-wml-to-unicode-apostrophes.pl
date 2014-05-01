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
    "anyone's",
    "aren't",
    "can't",
    "couldn't",
    "didn't",
    "doesn't",
    "don't",
    "everyone's",
    "hadn't",
    "hasn't",
    "haven't",
    "he'd",
    "he'll",
    "Here's",
    "he's",
    "he'syou'd",
    "how's",
    "I'd",
    "i'll",
    "I'll",
    "I'm",
    "isn't",
    "it's",
    "I've",
    "let's",
    "she'll",
    "she's",
    "shouldn't",
    "that's",
    "there's",
    "they'll",
    "they're",
    "they've",
    "wasn't",
    "we'd",
    "we'll",
    "we're",
    "weren't",
    "we've",
    "what's",
    "where's",
    "who's",
    "why's",
    "won't",
    "wouldn't",
    "you'd",
    "you'll",
    "you're",
    "you've",
);

my $re_s = join("|", map { '(?:' . quotemeta($_) . ')' } @matches);
my $re = qr/\b$re_s\b/i;

$content =~ s{($re)}{to_unicode($1)}egi;

print $content;
