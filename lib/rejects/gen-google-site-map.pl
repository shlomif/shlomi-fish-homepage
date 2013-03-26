#!/usr/bin/perl

use strict;
use warnings;

use Carp;
use POSIX;

use WWW::Google::SiteMap;

my $map = WWW::Google::SiteMap->new();

sub get_params
{
    my (%args) = (@_);
    my $filename = $args{'fn'};
    my $host = $args{'host'};

    my $base_url;
    if ($host eq "vipe")
    {
        $base_url = "http://vipe.technion.ac.il/~shlomif/";
    }
    elsif ($host eq "t2")
    {
        $base_url = "http://www.shlomifish.org/";
    }
    else
    {
        croak "Wrong host \"$host\"!";
    }
    if ($filename =~ m!^/!)
    {
        croak "Filename begins with /";
    }
    return (
        'loc' => "$base_url$filename",
        'lastmod' => get_file_last_mod($host, $filename),
    );
}

sub get_real_file
{
    my $file = shift;
    if ($file !~ m{\.html$})
    {
        $file .= "index.html";
    }
    return $file.".wml";
}

sub get_file_last_mod
{
    my $host = shift;
    my $file = shift;
    my $real_file = get_real_file("$host/$file");
    if (! -f $real_file)
    {
        $real_file = get_real_file("common/$file");
    }
    if (! -f $real_file)
    {
        croak "File does not exist \"$real_file\"!";
    }
    my @stat = stat($real_file);
    my $timestamp = $stat[9];
    return POSIX::strftime("%Y-%m-%d", gmtime($timestamp));
}

$map->add(WWW::Google::SiteMap::URL->new(
    get_params(host => "t2", fn => ""),
    changefreq => 'daily',
    priority   => 1.0,
));

foreach my $params (
    {host => "t2", fn => "me/", },
    {host => "t2", fn => "humour/", },
    {host => "t2", fn => "philosophy/", },
    {host => "t2", fn => "puzzles/", },
    {host => "t2", fn => "open-source/", },
    # Seems like the Google sitemaps' processor does not like out of-host
    # URLs.
    # {host => "vipe", fn => "lecture/",},
    {host => "t2", fn => "lecture/",},
    {host => "t2", fn => "DeCSS/",},
    {host => "t2", fn => "links.html",},
    )
{
    $map->add(
        WWW::Google::SiteMap::URL->new(
            get_params(%$params),
            changefreq => 'weekly',
            priority => 1.0,
        )
    );
}
foreach my $host (qw(t2 vipe))
{
    $map->write("dest/$host-homepage/sitemap.xml.gz");
}
