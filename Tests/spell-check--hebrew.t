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

use IO::All qw/ io /;

has '_general_whitelist' => (is => 'ro', default => sub { return []; });
has '_records' => (is => 'ro', default => sub { return []; });
has '_general_hashref' => (is => 'ro', default => sub { return +{}; });
has '_per_file' => (is => 'ro', default => sub { return +{}; });
has '_was_parsed' => (is => 'rw', default => '');

sub check_word
{
    my ($self, $args) = @_;

    my $filename = $args->{filename};
    my $word = $args->{word};

    return (exists( $self->_general_hashref->{$word} )
            or
        exists ($self->_per_file->{$filename}->{$word})
    );
}

sub parse
{
    my ($self) = @_;

    if (!$self->_was_parsed())
    {

        my $rec;
        open my $fh, '<:encoding(utf8)', $self->filename;
        my $found_global = 0;
        while (my $l = <$fh>)
        {
            chomp($l);
            # Whitespace or comment - skip.
            if ($l !~ /\S/ or ($l =~ /\A\s*#/))
            {
                # Do nothing.
            }
            elsif ($l =~ s/\A====\s+//)
            {
                if ($l =~ /\AGLOBAL:\s*\z/)
                {
                    if (defined($rec))
                    {
                        die "GLOBAL is not the first directive.";
                    }
                    $found_global = 1;
                }
                elsif ($l =~ /\AIn:\s*(.*)/)
                {
                    my @filenames = split /\s*,\s*/, $1;

                    if (defined($rec))
                    {
                        push @{$self->_records}, $rec;
                    }

                    my %found;
                    foreach my $fn (@filenames)
                    {
                        if (exists $found{$fn})
                        {
                            die "Filename <<$fn>> appears twice in line <<=== In: $l>>";
                        }
                        $found{$fn} = 1;
                    }
                    $rec = {
                        'files' => [ sort { $a cmp $b } @filenames],
                        'words' => [],
                    },
                }
                else
                {
                    die "Unknown directive <<==== $l>>!";
                }
            }
            else
            {
                if (defined($rec))
                {
                    push @{$rec->{'words'}}, $l;
                }
                else
                {
                    if (!$found_global)
                    {
                        die "GLOBAL not found before first word.";
                    }
                    push @{$self->_general_whitelist}, $l;
                }
            }
        }
        if (defined $rec)
        {
            push @{$self->_records}, $rec;
        }
        close ($fh);

        foreach my $w (@{$self->_general_whitelist})
        {
            $self->_general_hashref->{$w} = 1;
        }

        foreach my $rec (@{$self->_records})
        {
            my @lists;
            foreach my $fn (@{$rec->{files}})
            {
                push @lists,
                ($self->_per_file->{$fn} //= +{});
            }

            foreach my $w (@{$rec->{words}})
            {
                foreach my $l (@lists)
                {
                    $l->{$w} = 1;
                }
            }
        }
    }
    $self->_was_parsed(1);

    return;
}

sub _rec_sorter
{
    my ($a_aref, $b_aref, $idx) = @_;

    return (
        (@$a_aref == $idx) ? -1
        : (@$b_aref == $idx) ? 1
        : (($a_aref->[$idx] cmp $b_aref->[$idx])
        ||
        _rec_sorter($a_aref, $b_aref, $idx+1))
    );
}

sub _sort_words
{
    my $words_aref = shift;

    return [sort { $a cmp $b } @$words_aref];
}

sub get_sorted_text
{
    my ($self) = @_;

    $self->parse;

    my %_gen = map { $_ => 1 } @{$self->_general_whitelist};

    return join '',
    map { "$_\n" }
    (
        "==== GLOBAL:", '',
        @{_sort_words([keys %_gen])},
        (map
            { my %found;
                ('',("==== In: ".join(' , ', @{$_->{files}})), '',
                (@{ _sort_words(
                            [grep { !exists($_gen{$_}) and !($found{$_}++)} @{$_->{words}}]
                    )
                  }
                ))
            }
            sort { _rec_sorter($a->{files}, $b->{files}, 0) }
            @{$self->_records}
        )
    );
}

sub _get_io
{
    my ($self) = @_;

    return io->encoding('utf8')->file($self->filename);
}

sub is_sorted
{
    my ($self) = @_;

    $self->parse;

    return ($self->_get_io->all eq $self->get_sorted_text);
}

sub write_sorted_file
{
    my ($self) = @_;

    $self->parse;

    $self->_get_io->print($self->get_sorted_text);

    return;
}

1;

has 'filename' => ( is => 'rw', default => 'lib/hunspell/hebrew-whitelist1.txt' );

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
