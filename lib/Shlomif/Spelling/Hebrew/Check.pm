package Shlomif::Spelling::Hebrew::Check;

use strict;
use warnings;
use autodie;
use utf8;

use Path::Tiny qw/ path /;

use MooX qw/late/;

use Shlomif::Spelling::Hebrew::Whitelist   ();
use Shlomif::Spelling::Hebrew::SiteChecker ();

use Text::Hspell ();

has obj => (
    is      => 'ro',
    default => sub {
        my ($self) = @_;
        my $dir = ( ( $ENV{TMPDIR} // "/tmp" )
            . "/Shlomif-Spelling-Hebrew-SiteChecker-Inline/" );
        path($dir)->mkpath;

        my $hspell = Text::Hspell->new;
        return Shlomif::Spelling::Hebrew::SiteChecker->new(
            {
                timestamp_cache_fn =>
                    './Tests/data/cache/hebrew-spelling-timestamp.json',
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
