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

sub _my_system
{
    my $cmd = shift;

    print join(' ', @$cmd), "\n";
    if (system { $cmd->[0] } (@$cmd)) {
        die "<<@$cmd>> failed.";
    }
}

foreach my $cmd (
    [ "./bin/gen-docbook-make-helpers.pl" ],
    [ "./bin/gen-fortunes.pl" ],
    [ "./bin/gen-deps-mak.pl" ],
)
{
    _my_system($cmd);
}

1;

