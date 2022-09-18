package HTML::Widgets::NavMenu::Url::Obj;

use strict;
use warnings;

use Moo;

use HTML::Widgets::NavMenu::Url ();

has ['filename'] => ( is => 'ro', );
has ['is_slash'] => ( is => 'ro', );
has ['obj']      => ( is => 'ro', );

sub _is_slash_terminated
{
    my $string = shift;
    if ( !defined $string )
    {
        Carp::confess("undef");
    }
    return ( ( $string =~ m#/\z# ) ? 1 : 0 );
}

sub _text_to_url_obj
{
    my $text = shift;
    my $url =
        HTML::Widgets::NavMenu::Url->new( $text,
        ( _is_slash_terminated($text) || ( $text eq "" ) ), "server", );
    return $url;
}

sub get_relative_url
{
    my ( $self, $to_text, $no_leading_dot ) = @_;
    my $from_url = $self->obj;

    my $to_url = _text_to_url_obj($to_text);
    my $ret    = $from_url->_get_relative_url( $to_url, $self->is_slash(),
        $no_leading_dot, );
    return $ret;
}

1;

# __END__
# # Below is stub documentation for your module. You'd better edit it!
