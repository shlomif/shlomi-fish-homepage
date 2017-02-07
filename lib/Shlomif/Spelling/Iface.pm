package Shlomif::Spelling::Iface;

use strict;
use warnings;

use MooX (qw( late ));

use Shlomif::Spelling::Check;
use Shlomif::Spelling::FindFiles;

has obj =>
    ( is => 'ro', default => sub { return Shlomif::Spelling::Check->new(); } );

has files => (
    is      => 'ro',
    default => sub { return Shlomif::Spelling::FindFiles->new->list_htmls(); }
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
