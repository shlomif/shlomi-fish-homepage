package Shlomif::Spelling::Hebrew::Check;

use strict;
use warnings;
use autodie;

use Moo;

use Shlomif::Spelling::Hebrew::Whitelist   ();
use Shlomif::Spelling::Hebrew::SiteChecker ();

use Text::Hspell ();

has obj => (
    is      => 'ro',
    default => sub {
        my ($self) = @_;

        my $hspell = Text::Hspell->new;
        return Shlomif::Spelling::Hebrew::SiteChecker->new(
            {
                timestamp_cache_fn => (
                    ( $ENV{LATEMP_SPELL_CACHE_DIR} // './Tests/data/cache' )
                    . '/hebrew-spelling-timestamp.json',
                ),
                whitelist_parser =>
                    scalar( Shlomif::Spelling::Hebrew::Whitelist->new() ),
                check_word_cb => sub {
                    my ($word) = @_;
                    return $hspell->check_word($word);
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

1;
