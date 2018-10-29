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

has '_inside' => ( is => 'rw', default => sub { return +{}; } );
has 'check_word_cb' => ( is => 'ro', required => 1 );

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

    binmode STDOUT, ":encoding(utf8)";

    my $app_key  = 'HTML-Spelling-Site';
    my $data_key = 'timestamp_cache';

    my $check_word = $self->check_word_cb;

FILENAMES_LOOP:
    foreach my $filename (@$filenames)
    {
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

                    my $verdict = ( ( $word !~ m#\A[\p{Hebrew}\-'’]+\z# )
                            && ( !( $check_word->($word) ) ) );

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

    }

    return { misspellings => \@ret, };
}

sub test_spelling
{
    my ( $self, $args ) = @_;

    my $misspellings = $self->_calc_mispellings($args);

    require Test::Differences;
    use Test::More;

    return is_deeply( $misspellings->{misspellings}, [], $args->{blurb}, );
}

package Shlomif::Spelling::Hebrew::Check;

use strict;
use warnings;
use autodie;
use utf8;

use Text::Hunspell;

my $speller = Text::Hunspell->new(
    '/usr/share/hunspell/he_IL.aff',
    '/usr/share/hunspell/he_IL.dic',
);

if ( not $speller )
{
    die "Could not initialize speller!";
}

HTML::Spelling::Site::Checker->new(
    {
        timestamp_cache_fn =>
            './Tests/data/cache/hebrew-spelling-timestamp.json',
        check_word_cb => sub {
            my ($word) = @_;
            return $speller->check($word);
        },
    }
)->test_spelling(
    {
        files => [
            map { s/\n?\z//r } `find dest/post-incs/t2 -name '*html' -type f`
        ],
        blurb => 'blurb',
    },
);
