#!/usr/bin/env perl

use strict;
use warnings;

use Path::Tiny qw/ path /;

my $t = path("lib/Shlomif/Homepage/LongStories.pm")->slurp_utf8;

my @ids = $t =~ /id => '([^']+)'/g;

my %h;

my $m = path("_Main.mak")->slurp_utf8;

foreach my $id (@ids)
{
    my $id_uc = uc($id);

    if (   $id eq 'tow_the_fountainhead'
        or $id eq 'we_the_living_dead'
        or $id eq 'selina_mandrake'
        or $id eq 'summerschool_at_the_nsa'
        or $id eq 'muppets_show_tni' )
    {
        $h{$id} = '//$SKIP';
    }
    elsif ( my ($svg) =
        $m =~ m#^\$\(\Q$id_uc\E_+SMALL_LOGO_PNG\): \$\(T2_SRC_DIR\)/(\S+)$#ms )
    {
        $h{$id} = $svg;
        print "$id: $svg\n";
    }
    else
    {
        die "Cannot find $id";
    }
}

while ( my ( $id, $svg ) = each(%h) )
{
    my $t = '';
    my @l = path("lib/Shlomif/Homepage/LongStories.pm")->lines_utf8;
    while ( my $l = shift(@l) )
    {
        $t .= $l;
        if ( $l =~ /id => '\Q$id\E'/ )
        {
        INNER:
            while ( $l = shift(@l) )
            {
                $t .= $l;
                if ( $l =~ /^(\slurp_utf8s+)logo_src =>/ )
                {
                    $t .= "$1logo_svg => '$svg',\n";
                    last INNER;
                }
            }
        }
    }
    path("lib/Shlomif/Homepage/LongStories.pm")->spew_utf8($t);
}
