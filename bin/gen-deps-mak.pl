#!/usr/bin/perl

use strict;
use warnings;

use IO::All;
use File::Find::Object::Rule;

sub _map_wmls_to_deps
{
    my $files = shift;

    return
    [
        map
        {
            my $s = $_;
            $s =~ s{\.wml\z}{};
            $s =~ s{\A(?:\./)?t2/}{\$(T2_DEST)/};
            $s;
        } 
        @$files
    ];
}

# Write deps.mak
{
    my @files =
        File::Find::Object::Rule
            ->name('*.wml')
            ->in('t2');

    my %files_containing_headers =
    (
        map {
            $_ =>
            {
                re => qr{^\#include *"\Q$_\E\.wml"}ms,
                files => [],
            },
        } 
        qw(
            amazon
            dbook
            div2mag
            iglu
            multi-lang
            SFresume_base
            stories/blurbs
            stories/stories-list
            toc_div
            vim_include_code
            xml_g_fiction
        ),
    );

    foreach my $fn (@files)
    {
        my $contents = io->file($fn)->slurp;

        foreach my $header (keys(%files_containing_headers))
        {
            if ($contents =~ $files_containing_headers{$header}{re})
            {
                push @{ $files_containing_headers{$header}{files} }, 
                    $fn;
            }
        }
    }
    
    my $deps_text = "";

    foreach my $header (sort { $a cmp $b } keys(%files_containing_headers))
    {
        $deps_text .= 
            join(' ', 
                @{ _map_wmls_to_deps(
                        $files_containing_headers{$header}{files}
                    ) 
                }
            );

        $deps_text .= ": lib/$header.wml\n\n";
    }

    io->file("deps.mak")->print($deps_text);
}

