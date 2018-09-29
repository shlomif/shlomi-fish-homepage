package Shlomif::Homepage::RelUrl;

use strict;
use warnings;

use parent ('Exporter');

our @EXPORT_OK = (qw( _path_info _rel_url ));

sub _is_slash_terminated
{
    my $string = shift;
    if ( !defined $string )
    {
        Carp::confess("undef");
    }
    return ( ( $string =~ m#/\z# ) ? 1 : 0 );
}

use HTML::Widgets::NavMenu::Url;

sub _text_to_url_obj
{
    my $text = shift;
    my $url =
        HTML::Widgets::NavMenu::Url->new( $text,
        ( _is_slash_terminated($text) || ( $text eq "" ) ), "server", );
    return $url;
}

sub _get_relative_url
{
    my ( $from_text, $to_text, $no_leading_dot ) = @_;

    my $from_url = _text_to_url_obj($from_text);
    my $to_url   = _text_to_url_obj($to_text);
    my $ret =
        $from_url->_get_relative_url( $to_url, _is_slash_terminated($from_text),
        $no_leading_dot, );
    return $ret;
}

sub _rel_url
{
    return _get_relative_url( $::latemp_filename, shift, 1 );
}

sub _path_info
{
    return $::latemp_filename;
}

1;
