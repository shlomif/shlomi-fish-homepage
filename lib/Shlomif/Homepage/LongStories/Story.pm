package Shlomif::Homepage::LongStories::Story;

use strict;
use warnings;

use Moo;

has [ 'abstract', 'id', 'logo_alt', 'logo_src', 'logo_svg', 'tagline', ] =>
    ( is => 'ro', required => 1 );

has [ 'entry_id', 'entry_text', 'href', ] => ( is => 'ro', );

has [ 'entry_extra_html', ]           => ( is => 'ro', default => q{}, );
has [ 'should_skip_abstract_h_tag', ] => ( is => 'ro', default => q{}, );

has logo_class => ( is => 'ro', );

has logo_id => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        return shift()->id() . '_logo';
    },
);

sub calc_logo_class
{
    my $self = shift;

    return $self->logo_class ? " " . $self->logo_class : "";
}

1;
