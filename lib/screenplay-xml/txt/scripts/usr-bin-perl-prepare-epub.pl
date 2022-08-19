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

my $base = 'usr-bin-perl-';
foreach
    my $part ( path($filename)->basename =~ /\A\Q$base\E([0-9A-Za-z_\-]+)/g )
{
    my $epub_basename = $base . $part;
    $obj->epub_basename($epub_basename);

    $obj->output_json(
        {
            data => {
                filename => $epub_basename,
                title    => qq/usr-bin-perl - $part/,
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
"Creative Commons Attribution Noncommercial ShareAlike Unported (CC-by-nc-sa-3.0)",
                publisher => 'http://www.shlomifish.org/',
                language  => 'en-GB',
                subjects  => [
                    'FICTION/Horror', 'FICTION/Humorous', 'FICTION/Mashups',
                ],
                identifier => {
                    scheme => 'URL',
                    value  => 'http://www.shlomifish.org/humour/usr-bin-perl/',
                },
            },
        },
    );
}
