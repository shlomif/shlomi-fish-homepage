#!/usr/bin/env perl

use strict;
use warnings;

use CGI;

my $cgi  = CGI->new();
my $path = $ENV{'REDIRECT_SCRIPT_URL'};

if ( !$path )
{
    $path = '/';
}

my $link     = "http://www.shlomifish.org$path";
my $link_esc = CGI::escapeHTML($link);

my $title = "There's Nothing Here on Purpose - see http://www.shlomifish.org/";

print $cgi->header();
print <<"EOF";
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>$title</title>
<meta charset="utf-8"/>
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
