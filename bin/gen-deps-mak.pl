#!/usr/bin/perl

use strict;
use warnings;
use 5.014;

use File::Find::Object::Rule;
use Path::Tiny qw/ path /;

sub _map_wmls_to_deps
{
    my $files = shift;

    return [
        map {
            my $s = $_;
            $s =~ s{\.wml\z}{};
            $s =~ s{\A(?:\./)?t2/}{\$(T2_DEST)/};
            $s;
        } @$files
    ];
}

# Write deps.mak
{
    my @files = File::Find::Object::Rule->name('*.wml')->in('t2');

    my $rule    = File::Find::Object::Rule->new;
    my $discard = $rule->new->directory

        # Temporarily added for debugging:
        # ->exec(sub { print "$_[2]\n"; })
        ->name(
        qr{\A(?:screenplay-xml/from-vcs|fiction-xml|presentations|MathJax)\z})
        ->prune->discard;

    my @headers =
        map { ( $_ . '' ) =~ s{\Alib/}{}r }
        File::Find::Object::Rule->or( $discard, $rule->new() )
        ->name(qr/\.(wml|html|xhtml)\z/)->in('lib');

    my %files_containing_headers = (
        map { $_ => { re => qr{^\#include *"\Q$_\E"}ms, files => {}, }, }
            @headers,
    );

    foreach my $fn (@files)
    {
        my $contents = path($fn)->slurp_utf8;

        foreach my $match ( $contents =~
m{^(?:(?:\#include *")|(?:<include file="\.\./lib/)|(?:<shlomif_include_colorized_file filename="\.\./lib/))([^"]+)"}gms
            )
        {
            if ( exists( $files_containing_headers{$match} )
                or ( $match =~ m#\Adocbook/|fiction-xml/|screenplay-xml/# ) )
            {
                $files_containing_headers{$match}{files}{$fn} = 1;
            }
        }
    }

    my $deps_text = "";

    foreach my $header ( sort { $a cmp $b } keys(%files_containing_headers) )
    {
        my $header_deps = [
            sort { $a cmp $b }
                keys( %{ $files_containing_headers{$header}{files} } )
        ];

        if (@$header_deps)
        {
            $deps_text .= join( ' ', @{ _map_wmls_to_deps($header_deps) } );

            $deps_text .= ": lib/$header\n\n";
        }
    }

    path("lib/make/deps.mak")->spew_utf8($deps_text);
}
