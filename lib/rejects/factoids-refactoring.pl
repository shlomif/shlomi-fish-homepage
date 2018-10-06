#!/usr/bin/env perl

use strict;
use warnings;

my $lang = shift(@ARGV);

local $/;
my $text = <>;

if ( $text !~ m/<ul>/ )
{
    $text =~ s#<(/?)lip?>#<${1}li_$lang>#g;
}
else
{
    my $c = 0;

    $text =~ s#<li># (($c++) ? "<lip>" : "<$lang>\n<li>") #eg;

    $text =~ s#</li># ((--$c) ? "</lip>" : "</li>\n</$lang>\n") #eg;
}

$text =~ s{<br */ *>}{}g;

print $text;
