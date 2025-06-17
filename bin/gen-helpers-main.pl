#!/usr/bin/env perl

use strict;
use warnings;

use File::Find::Object ();
use File::Update       qw/ write_on_change_raw /;
use Path::Tiny         qw/ path /;

use lib './lib';
use Shlomif::MySystem qw/ my_exec_perl my_system /;

sub _run_inkscape
{
    my $inkscape_wrap = path("./bin/inkscape-wrapper");
    my $inkscape_help = scalar(`inkscape --help`);
    my $src           = (
        ( $inkscape_help =~ /--export-type/ )
        ? path("./bin/inkscape-wrapper-new.bash")
        : path("./bin/inkscape-wrapper-old.pl")
    );

    $src->copy($inkscape_wrap)->chmod(0755);
    my $evilphish_right_face =
        path("src/images/evilphish-svg--facing-right.svg");
    my $flip = "EditSelectAll;ObjectFlipHorizontally;";
    if ( $inkscape_help =~ /--action-list/ )
    {
        if (1)
        {
            $flip = "select-all:all;object-flip-horizontal;";
        }
    }

    my_system(
        [
            $inkscape_wrap,
            "--batch-process",
            "--actions",
            "${flip}export-filename:$evilphish_right_face;export-do;",

            # "--export-filename=$evilphish_right_face",
            "src/images/evilphish-svg--facing-left.svg",
        ]
    );
    $evilphish_right_face->copy("src/images/evilphish-svg.svg");

    return;
}

_run_inkscape();

require Shlomif::Homepage::LongStories;
Shlomif::Homepage::LongStories->new->render_make_fragment;
require Shlomif::Homepage::FortuneCollections;
my $fortune_colls_obj = Shlomif::Homepage::FortuneCollections->new();
$fortune_colls_obj->print_all_fortunes_html_tt2s;
$fortune_colls_obj->write_epub_and_all_in_one(
    'src/humour/fortunes/all-in-one.uncompressed.html.tt2');
my $DIR = "lib/make/";

foreach my $cmd (
    ["./bin/gen-docbook-make-helpers.pl"], ["./lib/factoids/gen-html.pl"],
    ["./bin/gen-fortunes-dats.pl"],        ["./bin/gen-deps-mak.pl"],
    )
{
    my_exec_perl($cmd);
}
write_on_change_raw(
    path("src/me/images/bizcard.svg"),
    \(
        path(
"lib/repos/shlomif-business-card/shlomif-business-card/old-2--bizcard--wo-site-highlights.svg"
        )->slurp_raw()
    ),
);
write_on_change_raw(
    path("src/me/images/evilphish-monochrome-for-business-card-b-N-w.png"),
    \(
        path(
"lib/repos/shlomif-business-card/shlomif-business-card/evilphish-monochrome-for-business-card-b-N-w.png"
        )->slurp_raw()
    ),
);

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
        } path("lib/Shlomif/Homepage/captioned-images.txt")->lines_utf8(
            {
                chomp => 1,
            }
        )
    );
    path("${DIR}generated/copies-generated-include.mak")->spew_utf8(
        (
            map { $_ . $COPY . "\n" } (
                sort { $a cmp $b } (
                    path("${DIR}copies-source.mak")->lines_utf8,
                    path(
                        "${DIR}generated/copies-generated-screenplay-images.mak"
                    )->lines_utf8,
                )
            ),
        ),
        @captioned_images,
        "all: " . join( " ", sort keys %all_deps ) . "\n\n"
    );
    path("${DIR}generated/asciidocs2db5-include.mak")->spew_utf8(
        (
            map { $_ . "\t\$(call ASCIIDOCTOR_TO_DOCBOOK5)\n" . "\n" } (
                sort { $a cmp $b }
                    ( path("${DIR}asciidocs2db5-source.mak")->lines_utf8, )
            ),
        ),
    );
}

my_exec_perl(
    [ 'lib/images/navigation/section/sect-nav-arrows.pl', "./src/images", ] );

my %buckets_by_dir;
foreach my $host ( "common", "src" )
{
    my $HOST_IS_COMMON = ( $host eq 'common' );
    my @docs_paths;
    my @dirs_paths;
    my @images_paths;
    my $tree = File::Find::Object->new( {}, $host );

FIND_FILES:
    while ( my $r = $tree->next_obj() )
    {
        my $path = join "/", @{ $r->full_components() };
        if (   $path =~ m#\Ahumour/fortunes/\S+(?:\.tar\.gz|\.sqlite3)\z#
            or $path =~ m#\Aimages/bk2hp-v2\.(?:svgz?|min\.svg)\z# )
        {
            next FIND_FILES;
        }
        if ( $r->is_file() )
        {
            if ( $path =~ s#\.x?html\K\.tt2\z##ms )
            {
                push @docs_paths, $path;
            }
            elsif ( $path !~ m#(?:\~)\z#ms )
            {
                push @images_paths, $path;
            }
        }
        elsif ( $r->is_dir() )
        {
            if ( length($path)
                and ( $HOST_IS_COMMON ? 1 : ( not -e "common/$path" ) ) )
            {
                push @dirs_paths, $path;
            }
        }
    }
    @docs_paths            = sort @docs_paths;
    @dirs_paths            = sort @dirs_paths;
    @images_paths          = sort @images_paths;
    $buckets_by_dir{$host} = +{
        docs   => \@docs_paths,
        dirs   => \@dirs_paths,
        images => \@images_paths,
    };
}

path("${DIR}generated/tt2.txt")
    ->spew_raw( join "\n", ( @{ $buckets_by_dir{'src'}{'docs'} } ), "" );
path("${DIR}generated/include.mak")->spew_utf8(
    map {
        my $host = $_;
        map {
            my $key = $_;
            join( " ",
                uc( $host . "_" . $key ),
                ":=", @{ $buckets_by_dir{$host}{$key} } )
                . "\n"
        } qw( images dirs docs )
    } qw( common src )
);

sub _ascertain_xhtml_dtds_on_fedora
{
    if ( -e "/etc/fedora-release" )
    {
        my $pivot = path("/usr/share/xml/xhtml/1.0/xhtml1-strict.dtd");
        if ( not -e $pivot )
        {
            die
qq#"xhtml1-dtds" / etc. should be installed on Fedora; $pivot is not present.#;
        }
    }
}

_ascertain_xhtml_dtds_on_fedora();

path('Makefile')->spew_utf8("include ${DIR}main.mak\n");

exit if delete $ENV{LATEMP_STOP_GEN};

my_system( [ 'gmake', 'bulk-make-dirs', 'sects_cache', 'mathjax_dest', ] );
my_system( [ 'gmake', '-j1', 'tsc_cmdline', 'tsc_non_min_www', 'tsc_www', ] );
