#!/usr/bin/env perl

use strict;
use warnings;

use lib "./lib";

use Shlomif::Homepage::Rss;

my $feed = Shlomif::Homepage::Rss->new();
$feed->run();

# Touch the files so they'll be recompiled.
utime( undef, undef, "t2/index.xhtml.wml", "t2/old-news.html.wml" );
