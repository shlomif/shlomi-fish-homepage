#!/usr/bin/env perl

use strict;
use warnings;

if (system("make", "--silent", "-f", "lib/make/build-deps/build-deps.mak"))
{
    die "build-deps failed!";
}

require HTML::Latemp::GenMakeHelpers;
require IO::All;

IO::All->import('io');

require List::MoreUtils;

if (system($^X,
        '-Ilib', '-MShlomif::Homepage::FortuneCollections',
        '-e',
        'Shlomif::Homepage::FortuneCollections->print_all_fortunes_html_wmls()'
    )
)
{
    die "print_all_fortunes_html_wmls failed!";
}

if (system($^X,
        '-Ilib', 'bin/gen-forts-all-in-one-page.pl',
        't2/humour/fortunes/all-in-one.uncompressed.html.wml',
    )
)
{
    die "gen-forts-all-in-one-page.pl failed!";
}

my $generator =
    HTML::Latemp::GenMakeHelpers->new(
        'hosts' =>
        [ map {
            +{ 'id' => $_, 'source_dir' => $_,
                'dest_dir' => "\$(ALL_DEST_BASE)/$_"
            }
        } (qw(common t2 vipe)) ],
    );

$generator->process_all();


my $text = io("include.mak")->slurp();
$text =~ s!^(T2_DOCS = )([^\n]*)!my ($prefix, $files) = ($1,$2); $prefix . ($files =~ s#\bhumour/fortunes/[a-zA-Z_\-\.]+\.html\b##gr)!ems;
$text =~ s!^((?:T2_DOCS|T2_DIRS) = )([^\n]*)!my ($prefix, $files) = ($1,$2); $prefix . ($files =~ s# +ipp\.\S*##gr)!ems;
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
    [ $^X, "./bin/gen-docbook-make-helpers.pl" ],
    [ $^X, "./bin/gen-fortunes.pl" ],
    [ $^X, "./bin/gen-deps-mak.pl" ],
)
{
    _my_system($cmd);
}

io()->file('Makefile')->print("include _Main.mak\n");

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
