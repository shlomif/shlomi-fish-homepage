package Shlomif::Homepage::SectionMenu::BaseSectionClass;

use strict;
use warnings;
use List::Util qw/ none notall /;

sub _check_subtree
{
    my ( $self, $t ) = @_;

    return ( ( $t->{subs} && @{ $t->{subs} } ) || ( !$t->{_lang_skip} ) );
}

sub _calc_lang_tree
{
    my ( $self, $lang, $tree ) = @_;

    my $ret = +{%$tree};

    my $rec_lang = ( delete( $ret->{lang} ) // { "en" => 1, } );
    if ('')
    {
        if ( '' eq ref $rec_lang )
        {
            $rec_lang = { $rec_lang => 1, };
        }
    }
    if ( exists $ret->{subs} )
    {
        my $subs = [
            grep { $self->_check_subtree($_) }
            map  { $self->_calc_lang_tree( $lang, $_ ) } @{ $ret->{subs} }
        ];
        if (@$subs)
        {
            if ( notall { defined } @$subs )
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
    if (    ( not $ret->{subs} )
        and ( none { exists( $rec_lang->{$_} ) } keys %$lang ) )
    {
        # die "not any lang; skip.";
        $ret->{_lang_skip} = 1;
        return $ret;
    }
    $ret->{lang} = $rec_lang;

    if ('')
    {
        if ( $self->_check_subtree($ret) )
        {
            $ret->{lang} //= $rec_lang;
        }
    }

    if ( not( defined $ret ) )
    {
        die;
    }
    return $ret;
}

my @langs = (qw/ ar en he /);

sub _available_langs
{
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
