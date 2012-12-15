#!/usr/bin/perl

use strict;
use warnings;

use IO::All;
use Data::Dumper;
use CGI;

my %images =
(
    1 =>
    {
        'd' => "Spotty cat with white, brown and black spots",
    },
    2 =>
    {
        'd' => "Shot of the entrance to the park",
    },
    5 =>
    {
        'd' => "Black and white kitten",
    },
    6 =>
    {
        'd' => "Striped grey kitten",
    },
    8 => { d => "Same striped grey kitten lying on a stone bench",},
    9 => { d => "Two kittens on the floor",},
    10 => { d => "Grey kitten lying on the stone bench",},
    11 => { d => "Close up on the grey kitten",},
    13 => { d => "Close up on a grey and white kitten", },
    14 => { d => "Ginger cat on the bench from the front", },
    16 => { d => "Ginger cat on the bench from the side", },
    17 => { d => "Striped grey cat on a stone wall with his eyes closed",},
    18 => { d => "Close up on the same cat, with his eyes open", },
    19 => { d => "Grey cat on the bench",},
    20 => { d => "Close up on that grey cat",},
);

sub get_record
{
    my $filename = shift;
    if ($filename =~ /(\d{4})/)
    {
        my $record = $images{sprintf("%d",$1)};
        if (!defined($record))
        {
            die "Unknown record for file \"$filename\".";
        }
        return %{$record};
    }
    else
    {
        die "Filename \"$filename\" does not match pattern.";
    }
}

my $dir = io()->dir("..");
my $target_dir = io()->dir("./target");
my $photos_dir = io->catdir($target_dir, "photos");
my $thumbs_dir = io->catdir($target_dir, "thumbnails");

foreach my $dir ($target_dir, $photos_dir, $thumbs_dir)
{
    $dir->mkpath();
}

#my @filenames = (map { $_->filename() }
#    (grep
#        { $_->is_file() && $_->filename() =~ (/^img_\d{4}\.jpg$/)
#        }
#        @{$dir}
#    ));

my @filenames = (map { sprintf("img_%04d.jpg", $_) } keys(%images));
my @files_sorted = (sort {$a cmp $b } @filenames);
my @files_records = (map { +{ fn => $_, get_record($_), } } @files_sorted);

my $d = Data::Dumper->new([\@files_records]);
print $d->Dump();

my $html;
foreach my $file (@files_records)
{
    # First render the HTML.
    my $fn = CGI::escapeHTML($file->{fn});
    my $desc = CGI::escapeHTML($file->{d});
    my $link = qq{<a href="photos/$fn" title="$desc">};
    $html .= qq{<tr>\n<td>$link<img src="thumbnails/$fn.png" alt="Thumbnail for &quot;$fn&quot;" /></a></td>\n<td>$link$desc</a></td>\n</tr>\n};

    # Now copy the file.
    io->catfile($dir, $fn) > io->catfile($photos_dir, $fn);
    # Now copy the thumbnail
    io()->file("/home/shlomi/.gimv/thumbnail" . io->catfile($dir, $fn)->absolute()->pathname() . ".png") > io->catfile($thumbs_dir, $fn.".png");
}

my $target_html = io()->file("out.html")->print($html);

