#!/usr/bin/perl

use strict;
use warnings;

use HTML::Latemp::GenMakeHelpers;

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

use IO::All;

my $text = io("include.mak")->slurp();
$text =~ s!^(T2_DOCS = .*)humour/fortunes/fortunes-index.html!$1!m;
io("include.mak")->print($text);

1;

