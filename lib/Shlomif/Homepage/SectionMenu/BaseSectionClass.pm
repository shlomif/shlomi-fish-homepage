package Shlomif::Homepage::SectionMenu::BaseSectionClass;

use strict;
use warnings;

sub _calc_lang_tree
{
    my ( $self, $lang, $tree ) = @_;

    my $ret = +{%$tree};

    my $rec_lang = ( delete( $ret->{lang} ) // "en" );
    if ( $rec_lang ne $lang )
    {
        $ret->{skip} = 1;
    }

    if ( exists $ret->{subs} )
    {
        $ret->{subs} =
            [ map { $self->_calc_lang_tree( $lang, $_ ) } @{ $ret->{subs} } ];
    }
    return $ret;
}

my @langs = (qw/ ar en he /);

sub _available_langs
{
    my ( $self, $p ) = @_;

    return \@langs;
}

1;
