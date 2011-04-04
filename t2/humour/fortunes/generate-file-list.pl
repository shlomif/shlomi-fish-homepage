#!/usr/bin/perl

use strict;
use warnings;

use IO::All;
use CGI;

open my $arcs_list_fh, "<", "fortunes-list.mak";
my @lines = <$arcs_list_fh>;
close($arcs_list_fh);

shift(@lines);

my @fortunes = (map { /([\w\-_]+)/ ; $1 } @lines);

my $out = io()->file("source-files-list.html");

$out->print(<<"EOF");
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE
    html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US">
<head>
<title>Shlomi Fish's Fortunes' Files List</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="author" content="Shlomi Fish" />
<meta name="description" content="Shlomi Fish's Fortunes Files List" />
<meta name="keywords" content="Shlomi Fish, Shlomi, Fish, Fortunes" />
</head>
<body>
<h1>Shlomi Fish's Fortunes' Files List</h1>

<h2 id="intro">Introduction</h2>

<p>
Download this list using <tt>wget -r --level=1</tt>.
</p>

<h2 id="list">The List</h2>

<ul>
EOF

$out->print(
    map { "$_\n" }
    map { my $escaped = CGI::escapeHTML($_); qq{<li><a href="$escaped">$escaped</a></li>} }
    sort { $a cmp $b }
    (
        (map { ( "$_.xml", $_, "$_.dat" ) } @fortunes),
        (map { $_->filename(); }
        io(".")->filter( sub { $_->filename =~ m{\.(?:pl|mak|bash|spec\.in)\z} })->all_files()),
        "fortunes-shlomif-all.atom",
        "fortunes-shlomif-all.rss",
        "Makefile", "ver.txt", "show.cgi.txt",
    )
);

$out->print(<<"EOF");
</ul>
</body>
</html>
EOF

