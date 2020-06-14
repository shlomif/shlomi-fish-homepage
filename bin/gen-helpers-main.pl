#!/usr/bin/env perl

use strict;
use warnings;

use HTML::Latemp::GenMakeHelpers v0.8.0;
use Path::Tiny qw/ path /;

package Shlomif::Homepage::GenMakeHelpers;

use parent 'HTML::Latemp::GenMakeHelpers';

sub place_files_into_buckets
{
    my ( $self, $host, $files, $buckets ) = @_;
    my $host_id         = $host->{'id'};
    my $is_common       = ( $host_id eq "common" );
    my $_common_buckets = $self->_common_buckets;
FILE_LOOP:
    foreach my $f (@$files)
    {
    BUCKETS:
        foreach my $bucket (@$buckets)
        {
            next BUCKETS if not $bucket->{'filter'}->($f);
            if ($is_common)
            {
                $_common_buckets->{ $bucket->{name} }->{$f} = 1;
            }

            if (
                $is_common
                || (
                    !(
                        $bucket->{'filter_out_common'}
                        && exists( $_common_buckets->{ $bucket->{name} }->{$f} )
                    )
                )
                )
            {
                push @{ $bucket->{'results'} }, $bucket->{'map'}->($f);
            }

            next FILE_LOOP;
        }
        die HTML::Latemp::GenMakeHelpers::Error::UncategorizedFile->new(
            {
                'file' => $f,
                'host' => $host_id,
            }
        );
    }
}

sub get_initial_buckets
{
    my ( $self, $host ) = @_;

    return [
        {
            'name'   => "IMAGES",
            'filter' => sub {
                my $fn = shift;
                return ( $fn !~ /\.tt2\z/ )
                    && ( -f $self->_make_path( $host, $fn ) );
            },
        },
        {
            'name'   => "DIRS",
            'filter' => sub {
                my $fn = shift;
                return ( -d $self->_make_path( $host, $fn ) );
            },
            filter_out_common => 1,
        },
        {
            'name'   => "DOCS",
            'filter' => sub {
                return shift() =~ /\.x?html\.tt2\z/;
            },
            'map' => sub {
                return shift() =~ s#\.tt2\z##r;
            },
        },
    ];
}

package main;

use lib './lib';
use Shlomif::MySystem qw/ my_system my_exec_perl /;

path("lib/VimIface.pm")->copy("lib/presentations/qp/common/VimIface.pm");

require lib;
lib->import("./lib");

require Shlomif::Homepage::LongStories;
Shlomif::Homepage::LongStories->new->render_make_fragment;
require Shlomif::Homepage::FortuneCollections;
Shlomif::Homepage::FortuneCollections->new->print_all_fortunes_html_tt2s;

my_exec_perl(
    [
        'bin/gen-forts-all-in-one-page.pl',
        'src/humour/fortunes/all-in-one.uncompressed.html.tt2',
    ],
    "gen-forts-all-in-one-page.pl failed!"
);

my $DIR = "lib/make/";

foreach my $cmd (
    ["./bin/gen-docbook-make-helpers.pl"], ["./lib/factoids/gen-html.pl"],
    ["./bin/gen-fortunes-dats.pl"],        ["./bin/gen-deps-mak.pl"],
    )
{
    my_exec_perl($cmd);
}

sub letter_fn
{
    my $ext = shift;
    return
        "src/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.$ext";
}

sub letter_io
{
    return path( letter_fn(shift) );
}

foreach my $ext (qw/ xhtml pdf /)
{
    my $fh = letter_io($ext);
    if ( $fh->stat->mtime < letter_io('odt')->stat->mtime )
    {
        $fh->touch;
    }
}
{
    my $idx  = -1;
    my $COPY = qq#\t\$(call COPY)\n#;

    my %all_deps;
    my @captioned_images = (
        map {
            my $src = path("lib/repos/$_");
            ++$idx;
            my $bn       = $src->basename;
            my $dn       = $src->parent->stringify;
            my $bn_var   = "CAPT_IMG_BN$idx";
            my $dest_var = "CAPT_IMG_DEST_$idx";
            $all_deps{"\$($dest_var)"} = 1;
qq#$bn_var := $bn\n$dest_var := \$(POST_DEST__HUMOUR_IMAGES)/\$($bn_var)\n\$($dest_var): $dn/\$($bn_var)\n${COPY}\n#;
        } path("lib/Shlomif/Homepage/captioned-images.txt")->lines_utf8
    );
    path("${DIR}copies-generated-include.mak")->spew_utf8(
        (
            map { $_ . $COPY . "\n" }
                path("${DIR}copies-source.mak")->lines_utf8
        ),
        @captioned_images,
        "all: " . join( " ", sort keys %all_deps ) . "\n\n"
    );
}

path('Makefile')->spew_utf8("include ${DIR}main.mak\n");

my_exec_perl(
    [ 'lib/images/navigation/section/sect-nav-arrows.pl', "./src/images", ] );
my $generator = Shlomif::Homepage::GenMakeHelpers->new(
    'hosts' => [
        map {
            my $dir      = $_;
            my $dest_dir = ( ( $dir eq 'src' ) ? 't2' : $dir );
            +{
                'id'         => $dir,
                'source_dir' => $dir,
                'dest_dir'   => "\$(ALL_DEST_BASE)/$dest_dir",
            }
        } (qw(common src))
    ],
    out_dir                    => $DIR,
    filename_lists_post_filter => sub {
        my ($args)    = @_;
        my $filenames = $args->{filenames};
        my $ret       = [
            grep {
                not(   m#\Ahumour/fortunes/\S+(?:\.tar\.gz|\.sqlite3)\z#
                    || m#\Aimages/bk2hp-v2\.(?:svgz?|min\.svg)\z# )
            } @$filenames
        ];
        if ( $args->{bucket} eq 'DOCS' and $args->{host} eq 'src' )
        {
            path("${DIR}tt2.txt")->spew_raw( join "\n", (@$ret), "" );
        }
        return $ret;
    },
    out_docs_ext          => '.tt2',
    docs_build_command_cb => sub {
        my ( undef, $args ) = @_;
        return sprintf(
            '$(call %s%s_INCLUDE_TT2_RENDER)',
            uc( $args->{host}->id ),
            $args->{is_common} ? "_COMMON" : ""
        );
    },
    images_dest_varname_cb => sub {
        my ( undef, $args ) = @_;
        return sprintf( '%s%s_DEST', uc( $args->{host}->id ), '_POST', );
    },
);

eval { $generator->process_all(); };
if ( my $Err = $@ )
{
    require Data::Dumper;
    print Data::Dumper->new( [$Err] )->Dump;
    die $Err;
}

{
    my $src = (
        ( scalar(`inkscape --help`) =~ /--export-type/ )
        ? path("./bin/inkscape-wrapper-new.bash")
        : path("./bin/inkscape-wrapper-old.pl")
    );

    $src->copy("./bin/inkscape-wrapper")->chmod(0755);
}
my_system( [ 'gmake', 'bulk-make-dirs', 'sects_cache', 'mathjax_dest', ] );
