package Shlomif::Homepage::GenScreenplaysMak::ImageLister;

use strict;
use warnings;

use Moo;
use File::Update qw( write_on_change );
use XML::LibXML  ();

use XML::Grammar::Screenplay::API::ImageListDoc      ();
use XML::Grammar::Screenplay::FromProto::Parser::QnD ();

my $xml_parser = XML::LibXML->new();
$xml_parser->validation(0);

sub calc_doc__from_proto_text
{
    my ( $self, $xml_out_fh, $args ) = @_;

    my $ret = XML::Grammar::Screenplay::API::ImageListDoc->new(
        {
            parser_class => 'XML::Grammar::Screenplay::FromProto::Parser::QnD',
            %$args,
        }
    );
    my $xml_text = $ret->convert($args);
    $ret->_xml($xml_text);
    write_on_change( $xml_out_fh, \$xml_text );
    $ret->_dom( $xml_parser->parse_string( $ret->_xml() ) );

    return $ret;
}

1;

__END__
