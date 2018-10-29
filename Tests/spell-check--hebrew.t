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

package Shlomif::Spelling::Hebrew::Check;

use strict;
use warnings;
use autodie;
use utf8;

use MooX qw/late/;

use Text::Hunspell;
use Shlomif::Spelling::Hebrew::Whitelist;
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

use MooX qw/late/;
use List::MoreUtils qw/any/;

use HTML::Spelling::Site::Finder;
use lib './lib';
use HTML::Latemp::Local::Paths ();

my $T2_POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

my @prunes = (
    qr#^\Q$T2_POST_DEST\E/MANIFEST\.html$#,
    qr#\A\Q$T2_POST_DEST\E/lecture/.*?/[a-zA-Z_\-0-9\.]*?--all-in-one-html/#,
    qr#philosophy/foss-other-beasts/revision-2/#,
qr#philosophy/politics/drug-legalisation/case-for-drug-legalisation--hebrew-v3/#,
    qr#guide2ee/undergrad#,
    qr#(?:humour/TheEnemy/(?:The-Enemy-(?:English-)?rev|TheEnemy))#,
qr#(?:humour/by-others/(?:English-is-a-Crazy-Language|darien|funroll-loops|hitchhiker|how-many-newsgroup-readers|oded-c|s-stands-for-simple|technion-bit-1|top-12-things-likely|was-the-death-star-attack|grad-student-jokes-from-jnoakes|the-fountainhead-starring-skull-force|if-people-bought-cars))#,
    qr#^\Q$T2_POST_DEST\E/humour/fortunes/all-in-one#,
    qr#^\Q$T2_POST_DEST\E/humour/fortunes/sharp#,
    qr#^\Q$T2_POST_DEST\E/humour/fortunes/source-files-list.html#,
    qr#humour/human-hacking/.*arabic#,
    qr#humour/human-hacking/human-hacking-field-guide/#,
    qr#humour/human-hacking/hebrew-v2#,
    qr#humour/humanity/ongoing-text-hebrew#,
    qr#lecture/Lambda-Calculus/slides/shriram\.scm#,
    qr#lecture/HTML-Tutorial/v1/xhtml1/hebrew#,
    qr#js/MathJax/(?:test|docs)/#,
qr#\Q$T2_POST_DEST\E/philosophy/computers/high-quality-software/what-makes-software-high-quality#,
qr#\Q$T2_POST_DEST\E/philosophy/computers/open-source/linus-torvalds-bus-factor/index#,
    qr#\.raw\.html$#,
    qr#^\Q$T2_POST_DEST\E/js/jquery-ui#,
    qr#^\Q$T2_POST_DEST\E/Iglu/shlomif/gamla#,
qr#^\Q$T2_POST_DEST/open-source/anti/TIOBE/Berke-Durak--anti-TIOBE--Mirror\E#,
    qr#^\Q$T2_POST_DEST/open-source/resources/tech-tips/\E#,
qr#^\Q$T2_POST_DEST/philosophy/philosophy/putting-all-cards-on-the-table-2013/indiv-sections/\E#,
qr#^\Q$T2_POST_DEST/philosophy/philosophy/putting-all-cards-on-the-table-2013/DocBook5/\E#,
qr#^\Q$T2_POST_DEST/philosophy/philosophy/SummerNSA-2014-09-call-for-action/DocBook5/\E#,
qr#^\Q$T2_POST_DEST/philosophy/SummerNSA/Letter-to-SGlau-2014-10/letter-to-sglau.xhtml\E\z#,
qr#^\Q$T2_POST_DEST\E/humour/by-others/how-to-make-square-corners-with-CSS/#,
    qr#^\Q$T2_POST_DEST\E/philosophy/by-others/sscce/#,
);

sub list_htmls
{
    my ($self) = @_;

    return HTML::Spelling::Site::Finder->new(
        {
            root_dir => $T2_POST_DEST,
            prune_cb => sub {
                my ($path) = @_;
                return any { $path =~ $_ } @prunes;
            },
        }
    )->list_all_htmls;
}

package Shlomif::Spelling::Hebrew::Iface;

use strict;
use warnings;

use MooX (qw( late ));

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
