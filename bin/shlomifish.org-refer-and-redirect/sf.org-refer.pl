#!/usr/bin/perl

use strict;
use warnings;

use CGI;

my $cgi = CGI->new();
my $path = $ENV{'REDIRECT_SCRIPT_URL'};

if (! $path)
{
    $path = '/';
}

my $link = "http://www.shlomifish.org$path";
my $link_esc = CGI::escapeHTML($link);

my $title = "There's Nothing Here on Purpose - see http://www.shlomifish.org/";

print $cgi->header();
print <<"EOF";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE
    html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-US">
<head>
<title>$title</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<h1>$title</h1>

<p>
This domain is kept empty in order to not fragment the links and page rank of
Shlomi Fish' site. Please don't use it. See
<a href="$link_esc">$link_esc</a> for the page on the
site.
</p>

</body>
</html>
EOF

