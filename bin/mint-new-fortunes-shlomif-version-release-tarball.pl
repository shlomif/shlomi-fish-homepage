#! /usr/bin/env perl
#
# Short description for mint-new-fortunes-shlomif-version-release-tarball.pl
#
# Version 0.0.1
# Copyright (C) 2020 Shlomi Fish < https://www.shlomifish.org/ >
#
# Licensed under the terms of the Apache License 2.0.

use strict;
use warnings;
use 5.014;
use autodie;

use Path::Tiny qw/ path /;

use vars qw/ $DIR /;

BEGIN
{
    $DIR = "./src/humour/fortunes";
}

use lib "$DIR";
use ShlomifFortunesMake ();

use lib './lib';
use Shlomif::MySystem qw/ my_system /;

my_system( [ 'gmake', "-C", $DIR, "dist" ] );
my $package_base = ShlomifFortunesMake->package_base();
my $full_path    = sprintf( "%s/%s", $DIR, $package_base );
my_system( [ "ls", $full_path ] );
use Shlomif::Homepage::Git ();
my $git_obj = Shlomif::Homepage::Git->new;
my $repos   = 'shlomif-humour-fortunes-archives-assets';
$git_obj->github_shlomif_clone( 'lib/repos', $repos );
my $full_r        = "lib/repos/$repos";
my $dir           = "humour/fortunes";
my $dest_pkg      = "$dir/$package_base";
my $full_dest_pkg = path("$full_r/$dest_pkg");
path($full_path)->copy($full_dest_pkg);
my $ver = ShlomifFortunesMake->ver();

if (1)
{
    my_system(
        [
            "bash",
            "-c",
"set -e -x ; cd $full_r && git add \"$dest_pkg\" && git commit -m \"add version @{[$ver]}\" && git push"
        ]
    );
}

my $post_dest = path("./dest/post-incs/t2/$dir");
foreach my $tar ( $full_dest_pkg->parent->children(qr/\.tar\.(gz|xz)\z/) )
{
    $tar->copy($post_dest);
}

my_system( [ "git", "tag", "fortunes-shlomif-v$ver" ] );
