#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

my $lang = shift(@ARGV);

my $text = io('-')->slurp();

if ($text !~ m/<ul>/)
{
    $text =~ s#<(/?)li>#<${1}item_$lang>#g;
}
else
{
    my $c = 0;

    $text =~ s#<li># $c++ ? "<lip>" : "<$lang>\n<li>"  #eg;

    $text =~ s#</li># --$c ? "</lip>" : "</li>\n</$lang>\n" #eg;
}

$text =~ s{<br */ *>}{}g;

print $text;
