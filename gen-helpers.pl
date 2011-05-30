#!/usr/bin/env perl

use strict;
use warnings;

use HTML::Latemp::GenMakeHelpers;
use File::Find::Object::Rule;
use IO::All;

my $generator = 
    HTML::Latemp::GenMakeHelpers->new(
        'hosts' =>
        [ map { 
            +{ 'id' => $_, 'source_dir' => $_,
                'dest_dir' => "\$(ALL_DEST_BASE)/$_-homepage" 
            } 
        } (qw(common t2 vipe)) ],
    );
    
$generator->process_all();


my $text = io("include.mak")->slurp();
$text =~ s!^(T2_DOCS = .*)humour/fortunes/index\.html!$1!m;
$text =~ s!^(T2_IMAGES = .*)humour/fortunes/show\.cgi!$1!m;
$text =~ s{ *humour/fortunes/\S+\.tar\.gz}{}g;
io("include.mak")->print($text);

system("./bin/gen-docbook-make-helpers.pl");
system("./bin/gen-fortunes.pl");

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
        } qw(toc_div xml_g_fiction),
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


1;

