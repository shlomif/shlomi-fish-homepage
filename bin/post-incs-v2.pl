#!/usr/bin/perl

use strict;
use warnings;

use Data::Munge qw/ list2re /;
use File::Update qw/ modify_on_change write_on_change /;
use Path::Tiny qw/ path /;

my $XMLNS_NEEDLE = <<'EOF';
 xmlns:db="http://docbook.org/ns/docbook" xmlns:d="http://docbook.org/ns/docbook" xmlns:vrd="http://www.shlomifish.org/open-source/projects/XML-Grammar/Vered/" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xhtml="http://www.w3.org/1999/xhtml"
EOF

my @needles = $XMLNS_NEEDLE =~ m#\b(xmlns:[a-zA-Z_]+="[^"]+")#g;

my $ALTERNATIVES_TEXT = list2re @needles;

my @filenames;
my @ad_filenames;
my @raw_filenames;
my $source_dir = shift @ARGV;
my $dest_dir   = shift @ARGV;
my $temp_dir   = Path::Tiny->tempdir;
my $counter    = 0;
foreach my $bn (@ARGV)
{
    my $_f = sub {
        return path("$source_dir/$bn");
    };

    eval {
        PROCESS_FILE:
        {
            my $orig_text = $_f->()->slurp_utf8;
            my $text      = $orig_text;

            if ( $text =~ /^<!-- Project Wonderful/ms )
            {
                last PROCESS_FILE;
            }

            if ( !$ENV{NO_I} )
            {
                $text =~
s#^\({5}include "([^"]+)"\){5}\n#path("lib/$1")->slurp_utf8#egms;
                $text =~
s#\({5}chomp_inc='([^']+)'\){5}#my ($l) = path("lib/$1")->lines_utf8({count => 1});chomp$l;$l#egms;
            }

            if ( $ENV{F} )
            {
                foreach my $class (qw(info irc-conversation))
                {
                    my $table_from = qq{<table class="$class">};
                    my $table_to   = qq{<table class="$class" summary="">};

                    $text =~ s#\Q$table_from\E#$table_to#g;
                }
            }

            $text =~ s# +$##gms;
            $text =~ s#(</div>|</li>|</html>)\n\n#$1\n#g;

            $text =~ s#\s+xml:space="[^"]*"##g;
            $text =~ s#(<div)(?:\s+(?:$ALTERNATIVES_TEXT))+#$1 #gms;

            # Remove surrounding space of tags.
            $text =~
s#\s*(</?(?:body|(?:br /)|div|head|li|ol|p|title|ul)>)\s*#$1#gms;

            # Remove document trailing space.
            $text =~ s#\s+\z##ms;

            my $minify = $ENV{ALWAYS_MIN};
            if ( $text ne $orig_text )
            {
                $minify //= 1;
            }
            my $temp_fh = $temp_dir->child( ( ++$counter ) . ".html" );
            $temp_fh->spew_utf8($text);
            my $fn  = $temp_fh . '';
            my $rec = +{
                bn   => $bn,
                temp => $fn,
            };
            if ($minify)
            {
                push @filenames, $rec;
            }
            elsif ( $ENV{APPLY_ADS} )
            {
                push @ad_filenames, $rec;
            }
            else
            {
                push @raw_filenames, $rec;
            }
        }
    };
    if ( my $err = $@ )
    {
        # In case there's an error - fail and need to rebuild.
        $_f->()->remove();
        die $err;
    }
}
system(
    'bin/batch-inplace-html-minifier',   '-c',
    'bin/html-min-cli-config-file.conf', '--keep-closing-slash',
    ( map { $_->{temp} } @filenames ),
) and die "html-min $!";

if ( $ENV{APPLY_ADS} )
{
    my $dir = "lib/ads/";
    my %TEXTS = ( map { $_ => path("$dir/texts/$_")->slurp_utf8 }
            path("$dir/texts-lists.txt")->lines_utf8( { chomp => 1 } ) );
    foreach my $rec ( @filenames, @ad_filenames )
    {
        modify_on_change(
            scalar( path( $rec->{temp} ) ),
            sub {
                my $text_ref = shift;
                my $r1 =
                    ( $$text_ref =~
s%<div id="([^"]+)">Placeholder</div>%"\n" . $TEXTS{$1}%egms
                    );
                my $r2 = '';
                if ( index( $$text_ref, q#<!DOCTYPE html># ) >= 0 )
                {
                    $r2 = $$text_ref =~ s%<table summary=""%<table%g;
                }
                return ( $r1 || $r2 );
            }
        );
    }
}
foreach my $rec ( @filenames, @ad_filenames, @raw_filenames )
{
    my $d = path("$dest_dir/$rec->{bn}");
    write_on_change( $d->touchpath, \( path( $rec->{temp} )->slurp_utf8 ) );
}
