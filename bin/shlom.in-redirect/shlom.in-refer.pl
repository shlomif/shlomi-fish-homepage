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
    {
        id => "humanity",
        url => "http://www.shlomifish.org/humour/humanity/",
        desc => "Humanity - The Movie",
    },
    {
        id => "sussman",
        url => "http://www.shlomifish.org/open-source/interviews/sussman.html",
        desc => "Interview with Ben Collins-Sussman",
    },
    {
        id => "optimise",
        url => "http://www.shlomifish.org/philosophy/computers/optimizing-code-for-speed/",
        desc => "Optimising Code for Speed",
    },
    {
        id => "towtf",
        url => "http://www.shlomifish.org/humour/TOWTF/",
        desc => "The One With the Fountainhead",
    },
    {
        id => "rethinking-cpan",
        url => "http://perlbuzz.com/2008/04/rethinking-the-interface-to-cpan.html",
        desc => "Rethinking CPAN",
    },
    {
        id => "st-wtld",
        url => "http://www.shlomifish.org/humour/Star-Trek/We-the-Living-Dead/",
        desc => qq{Star Trek: "We, the Living Dead"},
    },
    {
        id => "file-swap",
        url => "http://www.shlomifish.org/philosophy/case-for-file-swapping/",
        desc => qq{The Case for File Swapping},
    },
    {
        id => "hhfg",
        url => "http://www.shlomifish.org/humour/human-hacking/",
        desc => qq{The Human Hacking Field Guide},
    },
    {
        id => "oss-fs",
        url => "http://www.shlomifish.org/philosophy/foss-other-beasts/",
        desc => qq{Open Source, Free Software and Other Beasts},
    },
    {
        id => "def-zionism",
        url => "http://www.shlomifish.org/philosophy/politics/define-zionism/",
        desc => qq{Define "Zionism"},
    },
    {
        id => "sw-quality",
        url => "http://www.shlomifish.org/philosophy/computers/high-quality-software/",
        desc => qq{What Makes Software High-Quality?},
    },
    {
        id => "joy-of-perl",
        url => "http://www.shlomifish.org/philosophy/computers/perl/joy-of-perl/",
        desc => qq{The Joy of Perl},
    },
    {
        id => "gpl-bsd-sucker",
        url => "http://www.shlomifish.org/philosophy/computers/open-source/gpl-bsd-and-suckerism/",
        desc => qq{The GPL, The BSD Licence and Being a Sucker},
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

