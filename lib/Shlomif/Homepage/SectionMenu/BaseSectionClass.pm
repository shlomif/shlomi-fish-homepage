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
        my $subs = [
            grep { ( ( $_->{subs} && @{ $_->{subs} } ) || ( !$_->{skip} ) ) }
            map  { $self->_calc_lang_tree( $lang, $_ ) } @{ $ret->{subs} }
        ];
        if (@$subs)
        {
            $ret->{subs} = $subs;
        }
        else
        {
            delete $ret->{subs};
        }
    }
    return $ret;
}

my @langs = (qw/ ar en he /);

sub _available_langs
{
    my ( $self, $p ) = @_;

    return \@langs;
}

sub _calc_lang_trees_hash
{
    my ( $self, $tree_contents ) = @_;

    return +{
        (
            map {
                my $l = $_;
                ( $l => $self->_calc_lang_tree( $l, $tree_contents ) );
            } @{ $self->_available_langs() },
        )
    };
}

1;
