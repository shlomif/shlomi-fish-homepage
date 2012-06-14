#!/usr/bin/perl -w

# Run this script inside the wiki.d directory.

use strict;
use warnings;

use File::Path;

# 1078144122
my $good_time;

$good_time = shift(@ARGV) or
    die "You must specify a good timestamp.";

opendir D, ".";
my @files = (readdir(D));
closedir(D);

@files = grep { (-f $_) && /\./ } @files;

mkpath(["Temp", "New"]);
foreach my $file (@files)
{
    open I, "<", "$file";
    open O, ">", "New/$file-temp";
    my $newline = "";
    $file =~ /^[^\.]+\.(.*)$/;
    my $text = "Describe $1 here.\n";
    if (-e "../wikilib.d/$file")
    {
        open ORIG_TEXT, "<", "../wikilib.d/$file";
        my $orig_newline = "";
        ORIG_TEXT_LOOP: while(my $l = <ORIG_TEXT>)
        {
            if ($l =~ /^newline=(.)$/)
            {
                $orig_newline = $1;
            }
            if ($l =~ /^text=(.*)$/)
            {
                $text = $1;
                $text =~ s!$orig_newline!\n!g;
                last ORIG_TEXT_LOOP;
            }
        }
    }

    my $line;
    LINES_LOOP: while($line = <I>)
    {
        chomp($line);
        $line =~ /^([^=]+)=(.*)$/ or
            die "Incorrect line at file $file.";
        my ($key, $value) = ($1, $2);
        if ($key eq "newline")
        {
            $newline = $value;
            print O "$line\n";
        }
        elsif ($key eq "version")
        {
            print O "$line\n";
        }
        elsif ($key eq "text")
        {
            print O "text=:::TEXT:::\n";
        }
        elsif ($key eq "time")
        {
            print O "$line\n";
        }
        elsif ($key =~ /^diff:(\d+):(\d+):/)
        {
            my ($time1, $time2) = ($1, $2);
            if ($time1 <= $good_time)
            {
                # Apply the diff
                open DIFF, ">", "Temp/patch.diff";
                my $diff = $value;
                $diff =~ s!$newline!\n!g;
                print DIFF $diff;
                close(DIFF);
                open ORIG, ">", "Temp/orig.txt";
                print ORIG $text;
                close(ORIG);
                if (system("patch", "-R", "Temp/orig.txt", "Temp/patch.diff") != 0)
                {
                    die "patch program could not be run on file $file - time1=$time1.";
                }
                open ORIG, "<", "Temp/orig.txt";
                $text = join("", <ORIG>);
                close(ORIG);
                print O "$line\n";
                while($line = <I>)
                {
                    if ($line =~ /^diff/)
                    {
                        redo LINES_LOOP;
                    }
                    print O "$line\n";
                }
            }
            else
            {
                last LINES_LOOP;
            }
        }
    }
    close(O);
    close(I);
    $text =~ s!\n!$newline!g;
    open I, "<", "New/$file-temp";
    open O, ">", "New/$file";
    while(my $line = <I>)
    {
        if ($line eq "text=:::TEXT:::\n")
        {
            print O "text=$text\n";
        }
        else
        {
            print O $line;
        }
    }
    close(I);
    close(O);
}

1;
