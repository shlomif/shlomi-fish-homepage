#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

use utf8;

binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";

my $content = io('-')->slurp();

sub to_unicode
{
    my ($s) = @_;

    $s =~ tr/'/’/;

    return $s;
}

$content =~ s{\b(I'd|I'll|it's|they're|you're|we'll|we'd|wasn't|weren't|aren't|Here's)\b}{to_unicode($1)}egi;

print $content;
