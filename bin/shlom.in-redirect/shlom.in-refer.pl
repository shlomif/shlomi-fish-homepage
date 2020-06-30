#!/usr/bin/env perl

use strict;
use warnings;
use lib '.';

=begin debug

sub debug
{
    require Data::Dumper;
    print "Content-Type: text/plain\n\nHello\n";
    print Data::Dumper::Dumper(\%ENV);
    exit(0);
}

debug();

=end debug

=cut

my $HEADER = "Content-Type: text/html; charset=utf-8\r\n\r\n";
my $path   = $ENV{'REDIRECT_URL'};

if ( !defined($path) and !exists( $ENV{APACHE_REDIRECT_URL} ) )
{
    $path = "/";
}

use D ();

if ( my ($id) = $path =~ m{\A/([^/]+)\z} )
{
    my $url = $::U->{$id};
    if ( defined($url) )
    {
        print "Status: 301\r\nLocation: $url\r\n\r\n";
        exit(0);
    }
    else
    {
        print $HEADER, <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>Unknown shlom.in URL</title>
<meta charset="utf-8"/>
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
    print $HEADER, <<'EOF';
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>Welcome to http://shlom.in/</title>
<meta charset="utf-8"/>
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
