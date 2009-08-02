#!/usr/bin/perl

use strict;

foreach my $file (@ARGV)
{
    open I, "<$file";
    my $contents = join("",<I>);
    close(I);

    my $c = "[\\x00-\\xFF]";
    my $start = "<table class=\"mycode\">\n" .
        "<tr class=\"mycode\">\n" .
        "<td class=\"mycode\">\n" .
        "<pre class=\"myclass\">\n";

    my $end = "</pre>\n</td>\n</tr>\n</table>\n";
    $contents =~ s/(<p>(\s*\n)*<pre>($c*?)<\/pre>)/<p>\n$start$3$end\n/g;

    open O, ">$file";
    print O $contents;
    close(O);
}
