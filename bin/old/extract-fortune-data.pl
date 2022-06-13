#!/usr/bin/env perl

use strict;
use warnings;
use 5.014;

use Path::Tiny qw/ path /;
use List::Util qw/ first /;
use YAML::XS   qw/ LoadFile DumpFile /;

use lib './lib';
use Shlomif::Homepage::FortuneCollections ();

my %d;

my $yaml_data_fn = $INC{'Shlomif/Homepage/FortuneCollections.pm'} =~
    s#/[^/]+\z#/fortunes-meta-data.yml#r;
my $data = LoadFile($yaml_data_fn);

my @fields = (qw(page_title meta_desc about_blurb));

foreach
    my $r ( @{ Shlomif::Homepage::FortuneCollections->new->sorted_fortunes } )
{
    my $id = $r->id();

    my $contents = path("./t2/humour/fortunes/$id.html.wml")->slurp_utf8;

    if (
        $contents !~ m%
\A\#include\ '\.\./template\.wml'\n
\#include\ "render_fortunes_pages\.wml"\n
\n
<latemp_subject\ "(?<page_title>[^"]+)"\ />\n
<latemp_meta_desc\ "(?<meta_desc>[^"]+)"\ />\n
\n
<h2\*>About<\/h2\*>\n
\n
(?<about_blurb>.*?)
\n
<toc_div\ head_tag="h3"\ />\n
\n
<h2\ id="fortunes-list">The\ Fortunes\ Themselves</h2>\n
<div\ class="fortunes_list">\n
\#include\ "fortunes/xhtmls/\Q$id\E.xhtml-for-input"\n
</div>\n
\s*
\z
 %gmsx
        )

    {
        die "Cannot match at ID=$id\n";
    }

    my $added = +{ map { $_ => $+{$_} } @fields };

REC_LOOP:
    foreach
        my $rec ( @{ $data->{'shlomif_fortunes_collections'}->{'fortunes'} } )
    {
        if ( $rec->{id} eq $id )
        {
            %$rec = ( %$rec, %$added );
            last REC_LOOP;
        }
    }

}

DumpFile( $yaml_data_fn, $data );
