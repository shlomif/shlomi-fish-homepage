package Shlomif::Homepage::RelUrl;

use strict;
use warnings;

use parent 'Exporter';
my $latemp_fn;
our @EXPORT_OK = (qw( _path_info _rel_url _set_url ));

sub _is_slash_terminated
{
    my $string = shift;
    if ( !defined $string )
    {
        Carp::confess("undef");
    }
    return ( ( $string =~ m#/\z# ) ? 1 : 0 );
}

use HTML::Widgets::NavMenu::Url      ();
use HTML::Widgets::NavMenu::Url::Obj ();

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
    my ( $from_url, $to_text, $no_leading_dot ) = @_;

    my $to_url = _text_to_url_obj($to_text);
    my $ret    = $from_url->_get_relative_url( $to_url, $latemp_fn->is_slash(),
        $no_leading_dot, );
    return $ret;
}

sub _rel_url
{
    return _get_relative_url( $latemp_fn->obj(), shift, 1 );
}

sub _path_info
{
    return $latemp_fn->filename();
}

sub _set_url
{
    my ($from_text)     = @_;
    my $latemp_is_slash = _is_slash_terminated($from_text);
    my $latemp_filename = $from_text;
    my $latemp_obj      = _text_to_url_obj($latemp_filename);
    $latemp_fn = HTML::Widgets::NavMenu::Url::Obj->new(
        +{
            filename => $latemp_filename,
            is_slash => $latemp_is_slash,
            obj      => $latemp_obj,
        }
    );
    return;

}

1;
