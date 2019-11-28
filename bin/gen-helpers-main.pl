#!/usr/bin/env perl

use strict;
use warnings;

use HTML::Latemp::GenMakeHelpers v0.5.0;
use File::Copy qw/ copy /;
use File::Which qw/ which /;
use Path::Tiny qw/ path /;
use List::MoreUtils ();

package Shlomif::Homepage::GenMakeHelpers;

use parent 'HTML::Latemp::GenMakeHelpers';

sub place_files_into_buckets
{
    my ( $self, $host, $files, $buckets ) = @_;

FILE_LOOP:
    foreach my $f (@$files)
    {
        foreach my $bucket (@$buckets)
        {
            if ( $bucket->{'filter'}->($f) )
            {
                if ( $host->{'id'} eq "common" )
                {
                    $self->_common_buckets->{ $bucket->{name} }->{$f} = 1;
                }

                if (
                    ( $host->{'id'} eq "common" )
                    || (
                        !(
                            $bucket->{'filter_out_common'} && exists(
                                $self->_common_buckets->{ $bucket->{name} }
                                    ->{$f}
                            )
                        )
                    )
                    )
                {
                    push @{ $bucket->{'results'} }, $bucket->{'map'}->($f);
                }

                next FILE_LOOP;
            }
        }
        if ( $host->id ne 't2' )
        {
            die HTML::Latemp::GenMakeHelpers::Error::UncategorizedFile->new(
                {
                    'file' => $f,
                    'host' => $host->id(),
                }
            );
        }
    }
}

sub get_initial_buckets
{
    my $self = shift;
    my $host = shift;
    print $host->source_dir;
    my $is_t2 = $host->source_dir eq 't2';

    return [
        {
            'name'   => "IMAGES",
            'filter' => sub {
                my $fn = shift;
                return ( $fn !~ /\.(?:tt2|ttml|wml)\z/ )
                    && ( -f $self->_make_path( $host, $fn ) );
            },
        },
        {
            'name'   => "DIRS",
            'filter' => sub {
                my $fn = shift;
                return ( -d $self->_make_path( $host, $fn )
                        and ( $is_t2 ? ( !-d ( 'src/' . $fn ) ) : 1 ) );
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

sub _exec
{
    my ( $cmd, $err ) = @_;

    if ( system(@$cmd) )
    {
        die $err;
    }
    return;
}

sub _exec_perl
{
    my ( $cmd, $err ) = @_;

    return _exec( [ $^X, '-Ilib', @$cmd ], $err );
}

copy( "lib/VimIface.pm", "lib/presentations/qp/common/VimIface.pm" );
_exec_perl(
    [
        '-MShlomif::Homepage::LongStories', '-e',
        'Shlomif::Homepage::LongStories->render_make_fragment()',
    ],
    "LongStories render_make_fragment failed!"
);

_exec_perl(
    [
        '-MShlomif::Homepage::FortuneCollections',
        '-e',
        'Shlomif::Homepage::FortuneCollections->print_all_fortunes_html_tt2s()',
    ],
    "print_all_fortunes_html_tt2s failed!"
);

_exec_perl(
    [
        'bin/gen-forts-all-in-one-page.pl',
        'src/humour/fortunes/all-in-one.uncompressed.html.tt2',
    ],
    "gen-forts-all-in-one-page.pl failed!"
);

my $DIR = "lib/make/";

sub _my_system
{
    my $cmd = shift;

    print join( ' ', @$cmd ), "\n";
    if ( system { $cmd->[0] } (@$cmd) )
    {
        die "<<@$cmd>> failed.";
    }
}

# [ $^X, "./bin/gen-fortunes.pl" ],

foreach my $cmd (
    [ $^X, "./bin/gen-docbook-make-helpers.pl" ],
    [ $^X, "./lib/factoids/gen-html.pl" ],
    [ $^X, "./bin/gen-fortunes-dats.pl" ],
    [ $^X, "./bin/gen-deps-mak.pl" ],
    )
{
    _my_system($cmd);
}

sub letter_fn
{
    my $ext = shift;
    return
        "t2/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.$ext";
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
    path("${DIR}copies-generated-include.mak")->spew_utf8(
        ( map { $_, $COPY, "\n" } path("${DIR}copies-source.mak")->lines_utf8 ),
        (
            map {
                my $src = "lib/repos/$_";
                ++$idx;
                my $bn       = path($src)->basename;
                my $dn       = path($src)->parent->stringify;
                my $bn_var   = "CAPT_IMG_BN$idx";
                my $dest_var = "CAPT_IMG_DEST_$idx";
qq#$bn_var := $bn\n$dest_var := \$(T2_POST_DEST__HUMOUR_IMAGES)/\$($bn_var)\n\$($dest_var): $dn/\$($bn_var)\n${COPY}\nall: \$($dest_var)\n\n#;
            } path("lib/Shlomif/Homepage/captioned-images.txt")->lines_utf8
        )
    );
}

path('Makefile')->spew_utf8("include ${DIR}main.mak\n");

my $iter = path("./src")->iterator( { recurse => 1, } );
my @tt;
my %src_dirs;
while ( my $next = $iter->() )
{
    my $s = "$next";
    $s =~ s#\A(\./)?src/##;
    if ( -d $next )
    {
        $src_dirs{$s} = 1;
    }
    elsif ( $s =~ s#\.tt2\z## )
    {
        push @tt, $s;
    }
}

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
        } (qw(common src t2))
    ],
    out_dir                    => $DIR,
    filename_lists_post_filter => sub {
        my ($args)     = @_;
        my $is_bucket  = sub { return $args->{bucket} eq shift; };
        my $filenames  = $args->{filenames};
        my $ipp_filter = sub {
            return [ grep { not /\Aipp\.\S*\z/ } @{ shift @_ } ];
        };
        my $results = sub {
            if ( $args->{host} eq 't2' )
            {
                if ( $is_bucket->('DOCS') )
                {
                    return $ipp_filter->( $filenames, );
                }
                if ( $is_bucket->('IMAGES') )
                {
                    return [ grep { $_ ne 'humour/fortunes/show.cgi' }
                            @$filenames ];
                }
                if ( $is_bucket->('DIRS') )
                {
                    return [
                        sort keys %{
                            +{
                                map { $_ => 1 } @{ $ipp_filter->($filenames) }
                            }
                        }
                    ];
                }
            }
            return $filenames;
            }
            ->();

        return [ grep { not m#\Ahumour/fortunes/\S+\.tar\.gz\z# } @$results ];
    },
);

eval { $generator->process_all(); };
if ( my $Err = $@ )
{
    require Data::Dumper;
    print Data::Dumper->new( [$Err] )->Dump;
    die $Err;
}
my $r_fh = path("$DIR/rules.mak");
my $text = $r_fh->slurp_utf8;
my $H    = qr/SRC|T2/;
$text =~
s#^(\$\(($H)_DOCS_DEST\)[^\n]+\n\t)[^\n]+#${1}\$(call ${2}_INCLUDE_TT2_RENDER)#gms
    or die "Cannot subt";
$text =~ s#(($H)_IMAGES_DEST\b[^\n]*?)\$\(\2_DEST\)#${1}\$(${2}_POST_DEST)#gms
    or die "Cannot subt";
$text =~ s#^(T2_COMMON_(?:DIRS|IMAGES)_DEST =)[^\n]*(\n)#${1}${2}#gms
    or die "Cannot subt";
$text =~ s#^\$\(T2_DEST\):\n(?: [^\n]+\n)*##gms
    or die "Cannot subt";
$text =~ s#\.wml#.tt2#gms
    or die "Cannot subt";
{
    my $needle = 'cp -f $< $@';
    $text =~ s#^\t\Q$needle\E$#\t\$(call COPY)#gms;
}

$r_fh->spew_utf8($text);
push @tt, "humour/fortunes/all-in-one.uncompressed.html";
path("$DIR/tt2.txt")->spew_raw( join "\n", ( sort @tt ), "" );

_my_system( [ 'gmake', 'bulk-make-dirs' ] );
_my_system( [ 'gmake', 'sects_cache' ] );

# For https://reproducible-builds.org/
_my_system( [ 'gmake', 'mathjax_dest' ] );
