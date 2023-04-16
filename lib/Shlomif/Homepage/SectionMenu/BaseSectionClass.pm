package Shlomif::Homepage::SectionMenu::BaseSectionClass;

use strict;
use warnings;
use List::Util qw/ any /;

sub _check_subtree
{
    my ( $self, $t ) = @_;

    return ( ( $t->{subs} && @{ $t->{subs} } ) || ( !$t->{skip} ) );
}

sub _calc_lang_tree
{
    my ( $self, $lang, $tree ) = @_;

    my $ret = +{%$tree};

    my $rec_lang = ( delete( $ret->{lang} ) // { "en" => 1, } );
    if ( '' eq ref($rec_lang) )
    {
        $rec_lang = { $rec_lang => 1, };
    }
    if ( exists $ret->{subs} )
    {
        my $subs = [

            # grep { $self->_check_subtree($_) }
            map { $self->_calc_lang_tree( $lang, $_ ) } @{ $ret->{subs} }
        ];
        if (@$subs)
        {
            if ( grep { !defined } @$subs )
            {
                die;
            }
            foreach my $t (@$subs)
            {
                %$rec_lang = ( %$rec_lang, ( %{ $t->{lang} // +{} } ), );
            }
            $ret->{subs} = $subs;
        }
        else
        {
            delete $ret->{subs};
        }
    }
    if ( not( any { exists( $rec_lang->{$_} ) } keys %$lang ) )
    {
        $ret->{skip} = 1;
    }
    else
    {
        $ret->{lang} = $rec_lang;
    }

    if ( $self->_check_subtree($ret) )
    {
        $ret->{lang} //= $rec_lang;
    }
    if ( !defined $ret )
    {
        die;
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
                (
                    $l => $self->_calc_lang_tree(
                        +{ $l => 1, }, $tree_contents,
                    )
                );
            } @{ $self->_available_langs() },
        )
    };
}

sub generic_get_params
{
    my ( $self, $args ) = @_;

    return $self->get_params($args);
}

1;
