package Contents;

use strict;

my $contents =
{
    'title' => "QuaD-Pres - A Perl-based Tool for Presentation",
    'subs' =>
    [
        {
            'url' => "intro.html",
            'title' => "Introduction",
        },
        {
            'url' => "history.html",
            'title' => "The History of QuaD-Pres",
        },
        {
            'url' => "features.html",
            'title' => "Quad-Pres Features",
        },
        {
            'url' => "usage",
            'title' => "Usage",
            'subs' =>
            [
                {
                    'url' => "setting-up.html",
                    'title' => "Setting Up",
                },
                {
                    'url' => "Contents.pm.html",
                    'title' => "The Contents.pm File",
                },
                {
                    'url' => "page.html",
                    'title' => "An Individual Page",
                },
                {
                    'url' => "images.html",
                    'title' => "Including Images",
                },
            ],
            'images' => [ 'logo-wml.png' ],
        },
        {
            'url' => "no_wml",
            'title' => "Using QuaD-Pres without WebMetaLanguage",
            'subs' =>
            [
                {
                    'url' => "page.html",
                    'title' => "An Individual Page",
                },
                {
                    'url' => "render-modes.html",
                    'title' => "The Render Modes",
                },
            ],
        },
        {
            'url' => "finale",
            'title' => "Finale",
            'subs' =>
            [
                {
                    'url' => "samples.html",
                    'title' => "Sample Presentations",
                },
                {
                    'url' => "links.html",
                    'title' => "Links",
                },
            ],
        }
    ],
    'images' =>
    [
        'style.css',
    ],
};

sub get_contents
{
    return $contents;
}
