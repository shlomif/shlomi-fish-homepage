#!/usr/bin/env perl

use strict;
use warnings;

use HTML::Latemp::GenMakeHelpers;
use File::Find::Object::Rule;
use IO::All;
use File::Which qw(which);

use List::MoreUtils;

{
    foreach my $cmd (qw(
        asciidoc
        docmake
        inkscape
        xsltproc
        ))
    {
        if (!defined(scalar(which($cmd))))
        {
            die "Cannot find '$cmd' in path. Please install it.";
        }
    }
}

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

=begin removed_duplicate_code

my $wml_deps = io->file("deps.mak");

foreach my $wml_obj (
    io->dir("t2")->filter(sub { $_->filename =~ qr/\.wml\z/ })->All_Files
)
{
    my $filename = $wml_obj->canonpath;
    my @deps =
        grep { $_ ne '../template.wml' }
    List::MoreUtils::uniq(
        map { /\A\s*#include (?:'([^']+)'|"([^"]+)"|<([^>]+)>)\s*\z/ ? ($1 || $2 || $3) : () }
        grep { /\A\s*#include/ } $wml_obj->chomp->getlines);

    foreach my $dep (@deps)
    {
        foreach my $dir (".", "lib")
        {
            my $full_dep = "$dir/$dep";
            if (-e $full_dep)
            {
                print "$filename: $full_dep\n";
            }
        }
    }
}

=end removed_duplicate_code

=cut

1;
