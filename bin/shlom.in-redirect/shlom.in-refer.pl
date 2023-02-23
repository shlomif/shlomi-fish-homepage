#!/usr/bin/env perl

use strict;
use warnings;
use lib '.';
binmode STDOUT, ':encoding(utf-8)';

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

my $HEADER = "Content-Type: application/xhtml+xml; charset=utf-8\r\n\r\n";
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
Fish (the Webmaster)</a> (
<a href="https://www.shlomifish.org/me/contact-me/">more contact options</a>
)
and let him know of this problem.
</p>
</body>
</html>
EOF
    }
}
else
{
    my $h = _utf8_slurp("front.txt");
    print $HEADER, $h;
}

sub _utf8_slurp
{
    my $filename = shift;

    open my $in, '<:encoding(utf8)', $filename
        or die "Cannot open '$filename' for slurping - $!";

    local $/;
    my $contents = <$in>;

    close($in);

    return $contents;
}

