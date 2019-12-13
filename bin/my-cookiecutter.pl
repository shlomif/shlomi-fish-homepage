#!/usr/bin/env perl

use strict;
use warnings;

sub _exec
{
    my ( $cmd, $err ) = @_;

    if ( system(@$cmd) )
    {
        die $err;
    }
    return;
}

_exec(
    [
        'cookiecutter',
        '-f',
        '--no-input',
        '-c',
        'e2955d0d7001ef64b552202fe9ad7b6dfe219f13',
        'gh:shlomif/cookiecutter--shlomif-latemp-sites',
        'project_slug=.',
    ],
    'cookiecutter failed.'
);
