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

package Shlomif::Spelling::Hebrew::Check;

use strict;
use warnings;
use autodie;
use utf8;

use Moo;

use Text::Hunspell;
use HTML::Spelling::Site::Checker;

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
