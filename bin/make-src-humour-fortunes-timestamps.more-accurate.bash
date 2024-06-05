#!usr/bin/env bash

git log -p --date=unix -- {src,t2}/humour/fortunes/ | perl -ln -E '
use strict;
use warnings;
use vars qw(
    $date
    $section
    %ids
);

my $l = $_;
if ( my ($d) = $l =~ /^Date:\s*([0-9]+)/ )
{
    say $l;
    undef($section);
    $date = $d;
}
if ( $l =~ /^diff / )
{
    say $l;
    if (
        my ( undef(), $fn ) = (
            $l =~
m#\Adiff --git a/((?:src|t2)/humour/fortunes/([a-zA-Z0-9\-_]+)\.xml) b/\1#
        )
        )
    {
        $section = $fn;
    }
    else { undef($section); }
}
if ( my ($id) = $l =~ /^\+\s*<fortune id="([^"]+)"/ms )
{
    if ( $date != 1575282953 )
    {
        say "id=$id";
        if ( exists( $ids{$id} ) ) { die "$id already registered!" }

        if ( !$section ) { die "unknown section" }

        if ( !$date ) { die "unknown date" }

        $ids{$id} = [ $section, $date ];
    }
}

END
{
    require DateTime;
    require DateTime::Format::W3CDTF;
    require YAML::XS;
    my $yamlfn          = "src/humour/fortunes/fortunes-shlomif-ids-data.yaml";
    my $persistent_data = YAML::XS::LoadFile($yamlfn);
    my $scripts_hash    = $persistent_data->{"files"};
    my $_date_formatter = DateTime::Format::W3CDTF->new();
IDS:

    foreach my $k ( keys(%ids) )
    {
        my $v = $ids{$k};
        my ( $s, $d ) = @$v;
        if ( $s eq "proto--shlomif-factoids" )
        {
            next IDS;
        }
        my $fn = "$s.xml";
        if ( not $scripts_hash->{$fn}->{$k} )
        {
            warn "$k $s $d $fn";
            next IDS;
        }
        my $dobj = DateTime->from_epoch( epoch => $d, );
        my $dfmt =$_date_formatter->format_datetime(
                $dobj,
            );
        if ($dobj->year() == 2014 and $dobj->month() == 10 and $dobj->day() == 21)
        {
            next IDS;
        }
        $scripts_hash->{$fn}->{$k} = {
            q#date# => $dfmt,
        };
    }
    YAML::XS::DumpFile( $yamlfn, $persistent_data, );

}

'
