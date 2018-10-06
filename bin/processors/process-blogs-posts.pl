#!/usr/bin/env perl

use strict;
use warnings;

use Path::Tiny qw/ path /;

foreach my $fn (@ARGV)
{
    if ( my ($date) = $fn =~ m/(\d{4}-\d{2}-\d{2})\.html\z/ )
    {
        my $out_fn = "lib/feeds/shlomif_hsite/$date.html";

        my $contents = path($fn)->slurp_utf8;

        if ( not $contents =~ s{\A\s*<h2>([^<]+)</h2>\s*}{}ms )
        {
            die "Cannot match title at '$fn'!";
        }

        my $title = $1;

        $contents =~ s{\s*<!--.*?-->\s*}{}gms;

        my $out_contents = path($out_fn)->slurp_utf8;

        if ( $out_contents !~
            m{(<p><a href="http:.*?livejournal.*?</a></p>\s*\z)}ms )
        {
            die "Cannot match <a href in '$out_fn'";
        }
        my $comments = $1;
        path($out_fn)->spew_utf8("<!-- TITLE=$title-->\n$contents\n$comments");
    }
    else
    {
        die "'$fn' does not match date.!";
    }
}

foreach my $fn ( "t2/old-news.html.wml", "t2/index.html.wml" )
{
    path($fn)->touch;
}
