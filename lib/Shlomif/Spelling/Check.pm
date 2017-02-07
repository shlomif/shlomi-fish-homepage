package Shlomif::Spelling::Check;

use strict;
use warnings;
use autodie;
use utf8;

use MooX qw/late/;

use Text::Hunspell;
use Shlomif::Spelling::Whitelist;
use HTML::Spelling::Site::Checker;

has obj => (
    is      => 'ro',
    default => sub {
        my ($self) = @_;
        my $speller = Text::Hunspell->new(
            '/usr/share/hunspell/en_GB.aff',
            '/usr/share/hunspell/en_GB.dic',
        );

        if ( not $speller )
        {
            die "Could not initialize speller!";
        }

        return HTML::Spelling::Site::Checker->new(
            {
                timestamp_cache_fn =>
                    './Tests/data/cache/spelling-timestamp.json',
                whitelist_parser =>
                    scalar( Shlomif::Spelling::Whitelist->new() ),
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

1;

