#!/usr/bin/perl

use strict;
use warnings;

use CGI;

sub debug
{
    require Data::Dumper;
    print "Content-Type: text/plain\n\nHello\n";
    print Data::Dumper::Dumper(\%ENV);
    exit(0);
}

# debug();
my $cgi = CGI->new();
my $path = $ENV{'REDIRECT_URL'};

if (!defined($path) and !exists($ENV{APACHE_REDIRECT_URL}))
{
    $path = "/";
}

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
        id => "selina",
        url => "http://www.shlomifish.org/humour/Selina-Mandrake/",
        desc => qq{Selina Mandrake - The Slayer},
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
    {
        id => "perfect-workplace",
        url => "http://www.shlomifish.org/philosophy/computers/software-management/perfect-workplace/",
        desc => qq{The Perfect Info-Tech Workplace},
    },
    {
        id => "sourceware",
        url => "http://www.shlomifish.org/philosophy/foss-other-beasts/revision-2/foss-and-other-beasts/criteria.html#criteria_sourceware",
        desc => qq{Open source vs. Sourceware},
    },
    {
        id => "closed-books",
        url => "http://www.shlomifish.org/philosophy/philosophy/closed-books-are-so-19th-century/",
        desc => qq{Why Closed Books are So 19th-Century},
    },
    {
        id => "reply",
        url => "http://www.shlomifish.org/meta/FAQ/#reply_to_list",
        desc => qq{Reply to the list.},
    },
    {
        id => "port-libs",
        url => "http://www.shlomifish.org/open-source/portability-libs/",
        desc => qq{List of Cross-Platform, Abstraction, Portability Libraries},
    },
    {
        id => "IDEs",
        url => "http://www.shlomifish.org/open-source/resources/editors-and-IDEs/",
        desc => qq{List of Text Editors and IDEs},
    },
    {
        id => "text-proc",
        url => "http://www.shlomifish.org/open-source/resources/text-processing-tools/",
        desc => qq{List of Text Processing Tools},
    },
    {
        id => "net-clients",
        url => "http://www.shlomifish.org/open-source/resources/networking-clients/",
        desc => qq{List of Networking Clients},
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

my $url;

if (my ($id) = $path =~ m{\A/([^/]+)\z})
{
    $url = $urls_by_id{$id};
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
<title>Unknown shlom.in URL</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>

<h1>URL not found</h1>

<p>
This URL alias is not defined. If you've reached this URL and think it should
be defined please contact <a href="mailto:shlomif@shlomifish.org">Shlomi
Fish (the Webmaster)</a> and let him know of this problem.
</p>
</body>
</html>
EOF
    }
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
<title>Welcome to http://shlom.in/</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>

<h1>Welcome to http://shlom.in/</h1>

<p>
This domain serves as <a href="http://www.shlomifish.org/">Shlomi Fish's</a>
<b>non-public</b> URL shortening service. As such, it is fully under his
control, does not have a convenient web-interface to add more links, and
cannot be used to redirect to spam links. Therefore, I ask you not to block
it in spam filters.
</p>

<p>
In the future, there may be a list of public URLs that are pointed by this
service, but it's not implemented yet. For more information please contact
<a href="http://www.shlomifish.org/me/contact-me/">Shlomi Fish</a>.
</p>

</body>
</html>
EOF
}
