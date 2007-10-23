#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

foreach my $ad (grep { /\.html$/ } io("Ads-for-Homepage")->all_files())
{
    my $contents = $ad->slurp();

    if ($contents !~ m{\Ahttp://www.shlomifish.org/(\S+)})
    {
        die "No line found in $ad!";
    }

    my $path = $1;

    if ($path =~ /\/$/)
    {
        $path .= "index.html.wml";
    }
    elsif ($path =~ /\.x?html$/)
    {
        $path .= ".wml";
    }
    else
    {
        die "Path $path does not end with /";
    }

    if ($path =~ m{(\A|/)\.\.?(/|\z)})
    {
        die "Malicious Path";
    }

    if ($contents !~ m{(<p>.*?</p>)}ms)
    {
        die "Could not find ad!";
    }

    my $ad = $1;

    open O, ">>", "t2/$path";
    print O <<"END_OF_HTML";


;;; Ad added at 2007-Oct-20 / 2007-10-20
;;; To be removed at 2008-Oct-20 / 2008-10-20
;;; Requested by Lauren Keidis
<shlomif_sponsored_ad requested_by="Lauren Keidis" remove_at="2008-10-20">
$ad
</shlomif_sponsored_ad>

END_OF_HTML

    close(O);
}

