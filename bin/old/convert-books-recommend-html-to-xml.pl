#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

my @lines = io()->file("old-index.html.temp.wml")->slurp();

my $line_idx = 0;
sub get_line
{
    return $lines[$line_idx++];
}
my $line;

while ($line = get_line())
{
    if ($line =~ s/^\s*<dt id="([^"]*)">//)
    {
        my $id = $1;
        my $asin;
        if ($line =~ s{^<a href="http://www.amazon.com/.*?ASIN/(\w+)&amp;[^"]*">}{})
        {
            $asin = $1;
        }
        elsif ($line =~ s{^<a href="<affil_link id="([^"]+)" */? *>">}{})
        {
            $asin = $1;
        }
        else
        {
            die "Unknown formatting [link] at Line $line_idx\n";
        }
        my $title;
        my $author;
        if ($line =~ s{^(.*?)</a>\s*-?\s*by (.*?)</dt>\s*$}{})
        {
            $title = $1;
            $author = $2;
        }
        else
        {
            die "Unknown formatting [author/title] at Line $line_idx\n";
        }
        my $desc = "";
        while ($line = get_line())
        {
            if ($line =~ s{^\s*<dd>}{})
            {
                $desc .= $line;
                while ($line = get_line())
                {
                    if ($line =~ s{\s*</dd>$}{})
                    {
                        $desc .= $line;
                        last;
                    }
                    $desc .= $line;
                }
                last;
            }
        }
        if ($desc !~ /<p>/)
        {
            $desc = "<p>\n$desc\n</p>\n";
        }

        print <<"EOF";
<prod id="$id">
    <title>$title</title>
    <isbn>$asin</isbn>
    <creator type="author">$author</creator>
    <desc>
$desc
    </desc>
</prod>
EOF

    }
}
