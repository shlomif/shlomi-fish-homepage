#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

foreach my $fn (@ARGV)
{
    if (my ($date) = $fn =~ m/(\d{4}-\d{2}-\d{2})\.html\z/)
    {
        my $out_fn = "lib/feeds/shlomif_hsite/$date.html";

        my $contents = io($fn)->slurp;
        
        if (not $contents =~ s{\A\s*<h2>([^<]+)</h2>\s*}{}ms)
        {
            die "Cannot match title at '$fn'!";
        }
        
        my $title = $1;

        $contents =~ s{\s*<!--.*?-->\s*}{}gms;

        my $out_contents = io($out_fn)->slurp();

        if ($out_contents !~ m{(<p><a href="http:.*?livejournal.*?</a></p>\s*\z)}ms)
        {
            die "Cannot match <a href in '$out_fn'";
        }
        my $comments = $1;
        io($out_fn)->print("<!-- TITLE=$title-->\n$contents\n$comments");
    }
    else
    {
        die "'$fn' does not match date.!";
    }
}

system("touch", "t2/old-news.html.wml", "t2/index.html.wml");
