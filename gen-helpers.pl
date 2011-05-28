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

# Write deps.mak
{
    my @files =
        map {
            my $s = $_;
            $s =~ s{\.wml\z}{};
            $s =~ s{\A(?:\./)?t2/}{\$(T2_DEST)/};
            $s;
            }
        File::Find::Object::Rule
            ->name('*.wml')
            ->grep(qr/\A#include *"toc_div/)
            ->in('t2');

    io->file("deps.mak")->print("@files: lib/toc_div.wml");
}


1;

