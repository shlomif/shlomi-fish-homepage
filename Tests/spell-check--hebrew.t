#!/usr/bin/env perl

use strict;
use warnings;

use lib './lib';

use Test::More;

if ( $ENV{SKIP_SPELL_CHECK} )
{
    plan skip_all => 'Skipping spell check due to environment variable';
}
else
{
    plan tests => 1;
}

package Shlomif::Spelling::Hebrew::Whitelist;

use strict;
use warnings;

use Moo;

sub check_word
{
    my ( $self, $args ) = @_;

    my $filename = $args->{filename};
    my $word     = $args->{word};
    return 0;
}

sub parse
{
    return;
}

package HTML::Spelling::Site::Checker;
$HTML::Spelling::Site::Checker::VERSION = '0.0.5';
use strict;
use warnings;
use autodie;
use utf8;

use 5.014;

use Moo;

use HTML::Parser 3.00 ();
use List::MoreUtils qw(any);
use JSON::MaybeXS qw(decode_json);
use IO::All qw/ io /;

has '_inside'            => ( is => 'rw', default  => sub { return +{}; } );
has 'whitelist_parser'   => ( is => 'ro', required => 1 );
has 'check_word_cb'      => ( is => 'ro', required => 1 );
has 'timestamp_cache_fn' => ( is => 'ro', required => 1 );

sub _tag
{
    my ( $self, $tag, $num ) = @_;

    $self->_inside->{$tag} += $num;

    return;
}

sub _calc_mispellings
{
    my ( $self, $args ) = @_;

    my @ret;

    my $filenames = $args->{files};

    my $whitelist = $self->whitelist_parser;
    $whitelist->parse;

    binmode STDOUT, ":encoding(utf8)";

    my $calc_cache_io = sub {
        return io->file( $self->timestamp_cache_fn );
    };

    my $app_key  = 'HTML-Spelling-Site';
    my $data_key = 'timestamp_cache';

    my $write_cache = sub {
        my $ref = shift;
        $calc_cache_io->()->print(
            JSON::MaybeXS->new( canonical => 1 )->encode(
                {
                    $app_key => {
                        $data_key => $ref,
                    },
                },
            )
        );

        return;
    };

    if ( !$calc_cache_io->()->exists() )
    {
        $write_cache->( +{} );
    }

    my $timestamp_cache =
        decode_json( scalar( $calc_cache_io->()->slurp() ) )->{$app_key}
        ->{$data_key};

    my $check_word = $self->check_word_cb;

FILENAMES_LOOP:
    foreach my $filename (@$filenames)
    {
        if ( exists( $timestamp_cache->{$filename} )
            and $timestamp_cache->{$filename} >=
            ( io->file($filename)->mtime() ) )
        {
            next FILENAMES_LOOP;
        }

        my $file_is_ok = 1;

        my $process_text = sub {
            if (
                any
                {
                    exists( $self->_inside->{$_} ) and $self->_inside->{$_} > 0
                }
                qw(script style)
                )
            {
                return;
            }

            my $text = shift;

            my @lines = split /\n/, $text, -1;

            foreach my $l (@lines)
            {

                my $mispelling_found = 0;

                my $mark_word = sub {
                    my ($word) = @_;

                    $word =~ s{’(ve|s|m|d|t|ll|re)\z}{'$1};
                    $word =~ s{[’']\z}{};
                    if ( $word =~ /[A-Za-z]/ )
                    {
                        $word =~
s{\A(?:(?:ֹו?(?:ש|ל|מ|ב|כש|לכש|מה|שה|לכשה|ב-))|ו)-?}{};
                        $word =~ s{'?ים\z}{};
                    }

                    my $verdict = (
                        (
                            !$whitelist->check_word(
                                { filename => $filename, word => $word }
                            )
                        )
                            && ( $word !~ m#\A[\p{Hebrew}\-'’]+\z# )
                            && ( !( $check_word->($word) ) )
                    );

                    $mispelling_found ||= $verdict;

                    return $verdict ? "«$word»" : $word;
                };

                $l =~ s/
                # Not sure this regex to match a word is fully
                # idiot-proof, but we can amend it later.
                ([\w'’-]+)
                /$mark_word->($1)/egx;

                if ($mispelling_found)
                {
                    $file_is_ok = 0;
                    push @ret,
                        {
                        filename          => $filename,
                        line_num          => 1,
                        line_with_context => $l,
                        };
                }
            }
        };

        open( my $fh, "<:utf8", $filename );

        HTML::Parser->new(
            api_version => 3,
            handlers    => [
                start => [ sub { return $self->_tag(@_); }, "tagname, '+1'" ],
                end   => [ sub { return $self->_tag(@_); }, "tagname, '-1'" ],
                text => [ $process_text, "dtext" ],
            ],
            marked_sections => 1,
        )->parse_file($fh);

        close($fh);

        if ($file_is_ok)
        {
            $timestamp_cache->{$filename} = io->file($filename)->mtime();
        }
    }

    $write_cache->($timestamp_cache);

    return { misspellings => \@ret, };
}

sub spell_check
{
    my ( $self, $args ) = @_;

    my $misspellings = $self->_calc_mispellings($args);

    foreach my $error ( @{ $misspellings->{misspellings} } )
    {
        printf {*STDOUT} (
            "%s:%d:%s\n",       $error->{filename},
            $error->{line_num}, $error->{line_with_context},
        );
    }

    print "\n";
}

sub test_spelling
{
    my ( $self, $args ) = @_;

    my $misspellings = $self->_calc_mispellings($args);

    require Test::Differences;

    return Test::Differences::eq_or_diff( $misspellings->{misspellings},
        [], $args->{blurb}, );
}

package Shlomif::Spelling::Hebrew::Check;

use strict;
use warnings;
use autodie;
use utf8;

use Moo;

use Text::Hunspell;

has obj => (
    is      => 'ro',
    default => sub {
        my ($self) = @_;
        my $speller = Text::Hunspell->new(
            '/usr/share/hunspell/he_IL.aff',
            '/usr/share/hunspell/he_IL.dic',
        );

        if ( not $speller )
        {
            die "Could not initialize speller!";
        }

        return HTML::Spelling::Site::Checker->new(
            {
                timestamp_cache_fn =>
                    './Tests/data/cache/hebrew-spelling-timestamp.json',
                whitelist_parser =>
                    scalar( Shlomif::Spelling::Hebrew::Whitelist->new() ),
                check_word_cb => sub {
                    my ($word) = @_;
                    return $speller->check($word);
                },
            }
        );
    }
);

sub spell_check
{
    my ( $self, $args ) = @_;

    return $self->obj->spell_check(
        {
            files => $args->{files}
        }
    );
}

package Shlomif::Spelling::Hebrew::FindFiles;

use strict;
use warnings;

use Moo;
use List::MoreUtils qw/any/;

use HTML::Spelling::Site::Finder;
use lib './lib';

sub list_htmls
{
    my ($self) = @_;

    return HTML::Spelling::Site::Finder->new(
        {
            root_dir => './dest/post-incs/t2',
            prune_cb => sub {
                my ($path) = @_;
                return 0;
            },
        }
    )->list_all_htmls;
}

package Shlomif::Spelling::Hebrew::Iface;

use strict;
use warnings;

use Moo;

has obj => (
    is      => 'ro',
    default => sub { return Shlomif::Spelling::Hebrew::Check->new(); }
);

has files => (
    is => 'ro',
    default =>
        sub { return Shlomif::Spelling::Hebrew::FindFiles->new->list_htmls(); }
);

sub run
{
    my ($self) = @_;

    return $self->obj->spell_check(
        {
            files => $self->files,
        },
    );
}

sub test_spelling
{
    my ( $self, $blurb ) = @_;

    return $self->obj->obj->test_spelling(
        {
            files => $self->files,
            blurb => $blurb,
        },
    );
}

1;

package main;

# TEST
Shlomif::Spelling::Hebrew::Iface->new->test_spelling("No spelling errors.");
