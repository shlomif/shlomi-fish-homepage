#!/usr/bin/env perl

use strict;
use warnings;

use HTML::Widgets::NavMenu::EscapeHtml qw( escape_html );
use Path::Tiny                         qw/ path /;

open my $arcs_list_fh, "<", "fortunes-list.mak";
my @lines = <$arcs_list_fh>;
close($arcs_list_fh);

shift(@lines);

my @fortunes = ( map { /([\w\-_]+)/; $1 } @lines );

my $out = path("source-files-list.html");

$out->spew_utf8(<<"EOF");
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>Shlomi Fish's Fortunes' Files List</title>
<meta charset="utf-8" />
<meta name="author" content="Shlomi Fish" />
<meta name="description" content="Shlomi Fish's Fortunes Files List" />
<meta name="keywords" content="Shlomi Fish, Shlomi, Fish, Fortunes" />
</head>
<body>
<h1>Shlomi Fish's Fortunes' Files List</h1>

<h2 id="intro">Introduction</h2>

<p>
Download this list using <code>wget -r --level=1</code>.
</p>

<h2 id="list">The List</h2>

<ul>
EOF

$out->append_utf8(
    map { "$_\n" }
        map {
        my $escaped = escape_html($_);
        qq{<li><a href="$escaped">$escaped</a></li>}
        }
        sort { $a cmp $b } (
        ( map { ( "$_.xml", $_, "$_.dat" ) } @fortunes ),
        (
            map { $_->basename; }
                path(".")->children(qr{\.(?:pl|mak|bash|spec\.in|xsl)\z})
        ),
        "fortunes-shlomif-all.atom",
        "fortunes-shlomif-all.rss",
        "Makefile",
        "ver.txt",
        "show-cgi.txt",
        )
);

$out->append_utf8(<<"EOF");
</ul>
</body>
</html>
EOF
