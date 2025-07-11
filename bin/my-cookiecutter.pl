#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use lib './lib';
use Shlomif::MySystem qw/ my_system /;

my $src_dn =
"$ENV{HOME}/.cookiecutters/cookiecutter--shlomif-latemp-sites/\{\{cookiecutter.project_slug\}\}";
if ( -d $src_dn )
{
    my_system( [ "rsync", "-ra", "$src_dn/", "./" ], "rsync failed", );
    require Path::Tiny;
    Path::Tiny::path("./bin/batch-inplace-html-minifier")
        ->edit_raw( sub { s/\n\{% (?:end)?raw %\}\n/\n/g; } );
    my $d = Path::Tiny::path("./lib/tempsgml/");
    if ( -e $d )
    {
        my @c = $d->children(qr/\.xsl\z/ms);
        foreach my $c (@c)
        {
            $c->copy(
                Path::Tiny::path('lib/sgml/shlomif-docbook/xsl-5-stylesheets/')
            );

        }
    }
}
else
{
    my_system(
        [
            'cookiecutter', '-f', '--no-input',
            'gh:shlomif/cookiecutter--shlomif-latemp-sites',
            'project_slug=.',
        ],
        'cookiecutter failed.'
    );
}
