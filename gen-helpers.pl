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

sub _exec_perl
{
    my ($cmd, $err) = @_;

    if (system($^X, '-Ilib', @$cmd))
    {
        die $err;
    }
}

_exec_perl(['-MShlomif::Homepage::LongStories',
        '-e',
        'Shlomif::Homepage::LongStories->render_make_fragment()',
    ],"LongStories render_make_fragment failed!");

_exec_perl(['-MShlomif::Homepage::FortuneCollections',
        '-e',
        'Shlomif::Homepage::FortuneCollections->print_all_fortunes_html_wmls()',
    ], "print_all_fortunes_html_wmls failed!");

_exec_perl(['bin/gen-forts-all-in-one-page.pl',
        't2/humour/fortunes/all-in-one.uncompressed.html.wml',],
    "gen-forts-all-in-one-page.pl failed!");

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

sub _process_T2_DOCS_files
{
    my ($files) = @_;

    return \(join(' ', grep {
            not
            (
                m#\Ahumour/fortunes/([a-zA-Z_\-\.]+)\.html\z#
                && $1 ne 'index'
            )
        } split /\s+/, $$files
    ));
}

my $text = io("include.mak")->slurp();
$text =~ s!^(T2_DOCS = )([^\n]*)!my ($prefix, $files) = ($1,$2); $prefix . ${_process_T2_DOCS_files(\$files)}!ems;
$text =~ s!^((?:T2_DOCS|T2_DIRS) = )([^\n]*)!my ($prefix, $files) = ($1,$2); $prefix . ($files =~ s# +ipp\.\S*##gr)!ems;
$text =~ s!^(T2_IMAGES = .*)humour/fortunes/show\.cgi!$1!m;
$text =~ s{ *humour/fortunes/\S+\.tar\.gz}{}g;
io("include.mak")->print($text);

$text = io("rules.mak")->slurp();
$text =~ s#^(\$\(T2_DOCS_DEST\)[^\n]+\n\t)[^\n]+#${1}\$(call T2_INCLUDE_WML_RENDER)#ms or die "Cannot subt";
$text =~ s#^(\$\(VIPE_DOCS_DEST\)[^\n]+\n\t)[^\n]+#${1}\$(call VIPE_INCLUDE_WML_RENDER)#ms or die "Cannot subt";
$text =~ s#^(\$\(T2_COMMON_DOCS_DEST\)[^\n]+\n\t)[^\n]+#${1}\$(call T2_COMMON_INCLUDE_WML_RENDER)#ms or die "Cannot subt";
$text =~ s#^(\$\(VIPE_COMMON_DOCS_DEST\)[^\n]+\n\t)[^\n]+#${1}\$(call VIPE_COMMON_INCLUDE_WML_RENDER)#ms or die "Cannot subt";

{
    my $needle = 'cp -f $< $@';
    $text =~ s#^\t\Q$needle\E$#\t\$(call COPY)#gms;
}

io("rules.mak")->print($text);

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
    [ $^X, "./lib/factoids/gen-html.pl" ],
)
{
    _my_system($cmd);
}

sub letter_fn
{
    my $ext = shift;
    return "t2/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.$ext";
}

sub letter_io
{
    return io()->file(letter_fn(shift));
}

foreach my $ext (qw/ html pdf /)
{
    if (letter_io($ext)->mtime < letter_io('odt')->mtime)
    {
        utime(undef, undef, letter_fn($ext));
    }
}

io()->file('Makefile')->print("include lib/make/_Main.mak\n");

_my_system(['make', 'sects_cache']);

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
