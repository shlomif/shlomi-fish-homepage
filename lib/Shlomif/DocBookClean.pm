package Shlomif::DocBookClean;

use strict;
use warnings;

use XML::LibXML               ();
use XML::LibXSLT              ();
use XML::LibXML::XPathContext ();

my $xslt      = XML::LibXSLT->new;
my $style_doc = XML::LibXML->load_xml(
    location => "./bin/clean-up-docbook-xhtml5.xslt",
    no_cdata => 1
);
my $stylesheet = $xslt->parse_stylesheet($style_doc);

sub _place_introduction_on_top_of_xhtml
{
    my $fn  = shift;
    my $xml = shift;
    my $xpc = XML::LibXML::XPathContext->new($xml);
    $xpc->registerNs( 'xhtml', 'http://www.w3.org/1999/xhtml' );
    my @intro = $xpc->findnodes(
        q#//xhtml:section[@class = 'section' and descendant::*[@id='intro']]#);
    die "fn=$fn" if @intro != 1;
    my @parent = $xpc->findnodes(q#//xhtml:section[@class='article']#);
    my @heads  = $xpc->findnodes(
q#//xhtml:div[@class='titlepage']/descendant::*[starts-with(local-name(), 'h')]#
    );
    die if @parent != 1;
    die if @intro != 1;
    die if @heads == 0;
    my $i = $intro[0];
    $i->parentNode->removeChild($i);

    my $p = $parent[0];
    $p->insertBefore( $i,        $p->firstChild );
    $p->insertBefore( $heads[0], $p->firstChild );

    # my $ret = $xml->toString();
    my $ret = $xml;
    return $ret;
}

sub cleanup_docbook
{
    my ( $str_ref, $fn ) = @_;
    my $source  = XML::LibXML->load_xml( string => $$str_ref, );
    my $results = $stylesheet->transform($source);
    if ( "$fn" =~ /c-and-cpp-elements-to-avoid/i )
    {
        _place_introduction_on_top_of_xhtml( $fn, $results );
    }
    $$str_ref = $stylesheet->output_as_chars($results);

    # It's a kludge
    $$str_ref =~ s/[ \t]+$//gms;
    $$str_ref =~ s{ type="1"}{}g;

    $$str_ref =~ s{ align="left"}{}g;
    $$str_ref =~ s{ align="right"}{}g;
    $$str_ref =~ s{ valign="top"}{}g;

    return;
}

1;
__END__

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
