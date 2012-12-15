#!/usr/bin/perl

use strict;
use warnings;

use IO::All;
use Imager;

my $dir = io->dir("./2009-06-29/");
$dir->catdir("thumbnails")->mkdir;
foreach my $image_fn (grep { m{\.jpg\z} } $dir->readdir())
{
    my $image = Imager->new();
    $image->read(file => $dir->catfile($image_fn));
    my $req_w = 200;
    my $req_h = 400;

    $image = $image->scale(xpixels => $req_w, ypixels => $req_h, type => 'min');

    my $buffer = "";
    $image->write(
        file => $dir->catfile("thumbnails", $image_fn),
        type => "jpeg"
    );
}
