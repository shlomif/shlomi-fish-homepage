package Shlomif::Spelling::Hebrew::Check;

use strict;
use warnings;
use autodie;
use utf8;

use Path::Tiny qw/ path /;

use MooX qw/late/;

use Text::Hunspell                         ();
use Shlomif::Spelling::Hebrew::Whitelist   ();
use Shlomif::Spelling::Hebrew::SiteChecker ();

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
        my $dir = ( ( $ENV{TMPDIR} // "/tmp" )
            . "/Shlomif-Spelling-Hebrew-SiteChecker-Inline/" );
        path($dir)->mkpath;

        my $code = <<'EOF';
import HspellPy

class HspellPyWrapper:
    def __init__(self):
        self._hspell = HspellPy.Hspell(linguistics=True)

    def check_word(self, word):
        return self._hspell.check_word(word);
EOF
        require Inline;
        Inline->import(
            Python    => $code,
            directory => $dir,
        );
        my $hspell =
            Inline::Python::Object->new( '__main__', 'HspellPyWrapper' );
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
