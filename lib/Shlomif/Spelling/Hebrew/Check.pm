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

def create_hspell_instance(args):
    return HspellPy.Hspell(linguistics=True)

def hspell_check(speller, word):
    try:
        ret = speller.check_word(word);
    except Exception:
        ret = False
    return ret
EOF
        require Inline;
        Inline->import(
            Python    => $code,
            directory => $dir,
        );
        my $hspell = create_hspell_instance( +{} );
        return Shlomif::Spelling::Hebrew::SiteChecker->new(
            {
                timestamp_cache_fn =>
                    './Tests/data/cache/hebrew-spelling-timestamp.json',
                whitelist_parser =>
                    scalar( Shlomif::Spelling::Hebrew::Whitelist->new() ),
                check_word_cb => sub {
                    my ($word) = @_;
                    return hspell_check( $hspell, $word );
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
