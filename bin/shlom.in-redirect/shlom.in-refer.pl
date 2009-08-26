#!/usr/bin/perl

use strict;
use warnings;

use CGI;

my $cgi = CGI->new();
my $path = $ENV{'REDIRECT_SCRIPT_URL'};

my @urls =
(
    {
        id => "intro-lang",
        url => "http://www.shlomifish.org/philosophy/computers/education/introductory-language/",
        desc => "Thoughts about the Best Introductory Programming Language"
    },
    {
        id => "hp",
        url => "http://www.shlomifish.org/",
        desc => "Shlomi Fish's Homepage",
    },
    {
        id => "enemy",
        url => "http://www.shlomifish.org/humour/TheEnemy/",
        desc => "The Enemy and How I Helped to Fight it",
    },
);

my %urls_by_id;

my $idx = 0;
foreach my $rec (@urls)
{
    if (!($rec->{id} && $rec->{url} && $rec->{desc}))
    {
        print $cgi->header();
        print "Ask Shlomi Fish to fix record No. $idx";
        exit(0);
    }
    $urls_by_id{$rec->{id}} = $rec->{url};
}
continue
{
    $idx++;
}

if (my ($id) = $path =~ m{\A/([^/]+)\z})
{
    my $url = $urls_by_id{$id};

    if (defined($url))
    {
        print $cgi->redirect(
            -uri => $url,
            -status => 301,
        );
        exit(0);
    }
    else
    {
        print $cgi->header();
        print <<'EOF';
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

<h1>URL not found</h1>

<p>
This URL alias is not defined.
</p>
</body>
</html>
EOF
    }
}

