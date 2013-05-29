#!/usr/bin/perl

use strict;
use warnings;

use IO::All;
use File::Find::Object::Rule;

use 5.014;

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

=begin foo

lib/amazon.wml
lib/camila_ron.wml
lib/cpan_dists.wml
lib/dbook.wml
lib/div2mag.wml
lib/driver.wml
lib/footer.wml
lib/iglu.wml
lib/lang_switch.wml
lib/local-defs.wml
lib/mathjax.wml
lib/multi-lang.wml
lib/paypal.wml
lib/prelude.wml
lib/render_fortunes_pages.wml
lib/rest-of-template.wml
lib/SFresume_base.wml
lib/share-this.wml
lib/sponsored_ad.wml
lib/toc_div.wml
lib/utils.wml
lib/vim_include_code.wml
lib/xml_g_fiction.wml

=end foo

=cut

# Write deps.mak
{
    my @files =
        File::Find::Object::Rule
            ->name('*.wml')
            ->in('t2');

    my $rule = File::Find::Object::Rule->new;
    my $discard =
        $rule->new->directory
        # Temporarily added for debugging:
        # ->exec(sub { print "$_[2]\n"; })
        ->name(
            qr{\A(?:docbook|screenplay-xml|fiction-xml|presentations|MathJax)\z}
        )
        ->prune->discard
        ;

    my @headers =
        map { ($_ . '') =~ s{\Alib/}{}r }
        File::Find::Object::Rule
            ->or($discard,$rule->new())
            ->name('*.wml')
            ->in('lib');

    my %files_containing_headers =
    (
        map {
            $_ =>
            {
                re => qr{^\#include *"\Q$_\E"}ms,
                files => {},
            },
        }
        @headers,
    );

    foreach my $fn (@files)
    {
        my $contents = io->file($fn)->slurp;

        foreach my $match ($contents =~ m{^\#include *"([^"]+)"}gms)
        {
            if (exists($files_containing_headers{$match}))
            {
                $files_containing_headers{$match}{files}{$fn} = 1;
            }
        }
    }

    my $deps_text = "";

    foreach my $header (sort { $a cmp $b } keys(%files_containing_headers))
    {
        my $header_deps =
        [
            sort { $a cmp $b }
            keys( %{$files_containing_headers{$header}{files}} )
        ];

        if (@$header_deps)
        {
            $deps_text .= join(' ', @{ _map_wmls_to_deps($header_deps ) });

            $deps_text .= ": lib/$header\n\n";
        }
    }

    io->file("deps.mak")->print($deps_text);
}

