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
system("./bin/gen-deps-mak.pl");

1;

