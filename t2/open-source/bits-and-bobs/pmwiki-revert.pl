#!/usr/bin/env perl

# Run this script inside the wiki.d directory.

use strict;
use warnings;
use autodie;

use File::Path;

# 1078144122
my $good_time = shift(@ARGV)
    or die "You must specify a good timestamp.";

opendir my $dh, ".";
my @files = ( readdir($dh) );
closedir($dh);

@files = grep { ( -f $_ ) && /\./ } @files;

mkpath( [ "Temp", "New" ] );
foreach my $file (@files)
{
    open my $in,  "<", $file;
    open my $out, ">", "New/$file-temp";
    my $newline = "";
    $file =~ /^[^\.]+\.(.*)$/;
    my $text = "Describe $1 here.\n";
    if ( -e "../wikilib.d/$file" )
    {
        open $orig_text, "<", "../wikilib.d/$file";
        my $orig_newline = "";
    ORIG_TEXT_LOOP: while ( my $l = <$orig_text> )
        {
            if ( $l =~ /^newline=(.)$/ )
            {
                $orig_newline = $1;
            }
            if ( $l =~ /^text=(.*)$/ )
            {
                $text = $1;
                $text =~ s!$orig_newline!\n!g;
                last ORIG_TEXT_LOOP;
            }
        }
        close($orig_text);
    }

    my $line;
LINES_LOOP: while ( $line = <$in> )
    {
        chomp($line);
        $line =~ /^([^=]+)=(.*)$/
            or die "Incorrect line at file $file.";
        my ( $key, $value ) = ( $1, $2 );
        if ( $key eq "newline" )
        {
            $newline = $value;
            print {$out} "$line\n";
        }
        elsif ( $key eq "version" )
        {
            print {$out} "$line\n";
        }
        elsif ( $key eq "text" )
        {
            print {$out} "text=:::TEXT:::\n";
        }
        elsif ( $key eq "time" )
        {
            print {$out} "$line\n";
        }
        elsif ( $key =~ /^diff:(\d+):(\d+):/ )
        {
            my ( $time1, $time2 ) = ( $1, $2 );
            if ( $time1 <= $good_time )
            {
                # Apply the diff
                open my $DIFF, ">", "Temp/patch.diff";
                my $diff = $value;
                $diff =~ s!$newline!\n!g;
                print {$DIFF} $diff;
                close($DIFF);
                {
                    open my $ORIG, ">", "Temp/orig.txt";
                    print {$ORIG} $text;
                    close($ORIG);
                }
                if (
                    system( "patch", "-R", "Temp/orig.txt", "Temp/patch.diff" )
                    != 0 )
                {
                    die
"patch program could not be run on file $file - time1=$time1.";
                }
                {
                    open my $ORIG, "<", "Temp/orig.txt";
                    $text = join( "", <$ORIG> );
                    close($ORIG);
                }
                print {$out} "$line\n";
                while ( $line = <$in> )
                {
                    if ( $line =~ /^diff/ )
                    {
                        redo LINES_LOOP;
                    }
                    print {$out} "$line\n";
                }
            }
            else
            {
                last LINES_LOOP;
            }
        }
    }
    close(O);
    close($in);
    $text =~ s!\n!$newline!g;
    {
        open my $in_fh,  "<", "New/$file-temp";
        open my $out_fh, ">", "New/$file";
        while ( my $line = <$in_fh> )
        {
            if ( $line eq "text=:::TEXT:::\n" )
            {
                print {$out_fh} "text=$text\n";
            }
            else
            {
                print {$out_fh} $line;
            }
        }
        close($in_fh);
        close($out_fh);
    }
}

1;
