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
from __future__ import unicode_literals
import HspellPy

speller = HspellPy.Hspell(linguistics=True)

def hspell_check(word):
    # print("<{}>".format(word))
    try:
        ret = speller.check_word(word);
    except Exception:
        ret = False
    # print("ret=<{}>".format(ret))
    return ret
EOF
        require Inline;
        Inline->import(
            Python    => $code,
            directory => $dir,
        );
        return Shlomif::Spelling::Hebrew::SiteChecker->new(
            {
                timestamp_cache_fn =>
                    './Tests/data/cache/hebrew-spelling-timestamp.json',
                whitelist_parser =>
                    scalar( Shlomif::Spelling::Hebrew::Whitelist->new() ),
                check_word_cb => sub {
                    my ($word) = @_;
                    return hspell_check($word);
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
