#! /usr/bin/env perl

use strict;
use warnings;

use utf8;

use Shlomif::Screenplays::EPUB ();

use Path::Tiny qw/ path /;

my $obj = Shlomif::Screenplays::EPUB->new;
$obj->run;

my $gfx      = $obj->gfx;
my $filename = $obj->filename;

my $base = 'He-Damsel-in-Distress-and-a-Distressing-Damsel';

# ''
foreach
    my $part ( path($filename)->basename =~ /\A\Q$base\E([0-9A-Za-z_\-]*)/g )
{
    my $epub_basename = $base . $part;
    $obj->epub_basename($epub_basename);

    my $ext = ( $part ? " - $part" : "" );
    $obj->output_json(
        {
            data => {
                filename => $epub_basename,
                title    => qq/$base$ext/,
                authors  => [
                    {
                        name => "Shlomi Fish",
                        sort => "Fish, Shlomi",
                    },
                ],
                contributors => [
                    {
                        name => "Shlomi Fish",
                        role => "oth",
                    },
                ],
                cover  => "images/$gfx",
                rights =>
"Creative Commons Attribution Noncommercial ShareAlike Unported (CC-by-nc-sa 4.0)",
                publisher  => 'http://www.shlomifish.org/',
                language   => 'en-GB',
                subjects   => [ 'FICTION/Humorous', 'FICTION/Mashups', ],
                identifier => {
                    scheme => 'URL',
                    value  =>
'https://www.shlomifish.org/humour/He-Damsel-in-Distress-and-a-Distressing-Damsel/',
                },
            },
        },
    );
}
