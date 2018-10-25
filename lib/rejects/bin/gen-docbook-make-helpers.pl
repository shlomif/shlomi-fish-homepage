#!/usr/bin/env perl

use strict;
use warnings;

sub _bitbucket_hg_shlomif_clone
{
    my ( $into_dir, $repo ) = @_;

    return _github_clone(
        {
            type     => 'bitbucket_hg',
            username => 'shlomif',
            into_dir => $into_dir,
            repo     => $repo,
        }
    );
}
