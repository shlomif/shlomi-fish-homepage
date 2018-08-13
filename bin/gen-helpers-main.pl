#!/usr/bin/env perl

use strict;
use warnings;

use HTML::Latemp::GenMakeHelpers v0.5.0;
use File::Copy qw/ copy /;
use Path::Tiny qw/ path /;
use List::MoreUtils ();

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
        'Shlomif::Homepage::FortuneCollections->print_all_fortunes_html_wmls()',
    ],
    "print_all_fortunes_html_wmls failed!"
);

_exec_perl(
    [
        'bin/gen-forts-all-in-one-page.pl',
        't2/humour/fortunes/all-in-one.uncompressed.html.wml',
    ],
    "gen-forts-all-in-one-page.pl failed!"
);

my $DIR = "lib/make/";

my $generator = HTML::Latemp::GenMakeHelpers->new(
    'hosts' => [
        map {
            +{
                'id'         => $_,
                'source_dir' => $_,
                'dest_dir'   => "\$(ALL_DEST_BASE)/$_"
                }
        } (qw(common t2))
    ],
    out_dir                    => $DIR,
    filename_lists_post_filter => sub {
        my ($args) = @_;
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
                    return $ipp_filter->(
                        [
                            grep {
                                not(
m#\Ahumour/fortunes/([a-zA-Z_\-\.]+)\.html\z#
                                    && $1 ne 'index' )
                            } @$filenames
                        ]
                    );
                }
                if ( $is_bucket->('IMAGES') )
                {
                    return [ grep { $_ ne 'humour/fortunes/show.cgi' }
                            @$filenames ];
                }
                if ( $is_bucket->('DIRS') )
                {
                    return $ipp_filter->($filenames);
                }
            }
            return $filenames;
            }
            ->();

        return [ grep { not m#\Ahumour/fortunes/\S+\.tar\.gz\z# } @$results ];
    },
);

$generator->process_all();

my $r_fh = path("$DIR/rules.mak");
my $text = $r_fh->slurp_utf8;
$text =~
s#^(\$\(T2_DOCS_DEST\)[^\n]+\n\t)[^\n]+#${1}\$(call T2_INCLUDE_WML_RENDER)#ms
    or die "Cannot subt";
{
    my $needle = 'cp -f $< $@';
    $text =~ s#^\t\Q$needle\E$#\t\$(call COPY)#gms;
}

$r_fh->spew_utf8($text);

sub _my_system
{
    my $cmd = shift;

    print join( ' ', @$cmd ), "\n";
    if ( system { $cmd->[0] } (@$cmd) )
    {
        die "<<@$cmd>> failed.";
    }
}

foreach my $cmd (
    [ $^X, "./bin/gen-docbook-make-helpers.pl" ],
    [ $^X, "./bin/gen-fortunes.pl" ],
    [ $^X, "./bin/gen-deps-mak.pl" ],
    [ $^X, "./lib/factoids/gen-html.pl" ],
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

foreach my $ext (qw/ html pdf /)
{
    my $fh = letter_io($ext);
    if ( $fh->stat->mtime < letter_io('odt')->stat->mtime )
    {
        $fh->touch;
    }
}

path('Makefile')->spew_utf8("include ${DIR}_Main.mak\n");

_my_system( [ 'make', 'sects_cache' ] );
