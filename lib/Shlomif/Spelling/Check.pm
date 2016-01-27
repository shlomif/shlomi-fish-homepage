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

    my $files = $args->{files};

    return HTML::Spelling::Site::Checker->new(
        {
            whitelist_fn => 'lib/hunspell/whitelist1.txt',
        }
    )->spell_check(
        {
            files => $args->{files}
        }
    );
}

1;

