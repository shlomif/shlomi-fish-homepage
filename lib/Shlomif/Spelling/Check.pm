package Shlomif::Spelling::Check;

use strict;
use warnings;
use autodie;
use utf8;

use MooX qw/late/;

use HTML::Spelling::Site::Checker;

sub spell_check
{
    my ($self, $args) = @_;

    my $speller = Text::Hunspell->new(
        '/usr/share/hunspell/en_GB.aff',
        '/usr/share/hunspell/en_GB.dic',
    );

    if (not $speller)
    {
        die "Could not initialize speller!";
    }

    my $files = $args->{files};

    return HTML::Spelling::Site::Checker->new(
        {
            whitelist_fn => 'lib/hunspell/whitelist1.txt',
            check_word_cb => sub {
                my ($word) = @_;
                return $speller->check($word);
            },
        }
    )->spell_check(
        {
            files => $args->{files}
        }
    );
}

1;

