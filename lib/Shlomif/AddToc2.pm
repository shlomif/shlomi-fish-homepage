package Shlomif::AddToc2;

use strict;
use warnings;
use utf8;

use Moo;
use HTML::Toc          ();
use HTML::TocGenerator ();
use Path::Tiny         qw( path );
use XML::LibXML        qw( XML_DOCUMENT_NODE XML_ELEMENT_NODE );

my $TOC = qr#<toc *lang=\"([a-z\-A-Z]+)\" *((?:nohtag="1" *)?) */ *>#;

my $parser = XML::LibXML->new();

sub _get_doc
{
    my ( $self, $str_ref ) = @_;

    return ( $parser->load_xml( string => $str_ref ) );
}

sub add_toc
{
    my ( $self, $html_ref ) = @_;
    if ( my ( $lang, $nohtag ) = $$html_ref =~ $TOC )
    {
        my $INCS = 1;
        if ($INCS)
        {
            $$html_ref =~
s#^\({5}include[= ](['"])([^'"]+)\1\){5}\n#path("lib/$2")->slurp_utf8#egms;
            $$html_ref =~
s#\({5}chomp_inc[= ](['"])([^'"]+)\1\){5}#my ($l) = path("lib/$2")->lines_utf8({count => 1});chomp$l;$l#egms;
        }
        my $dom = $self->_get_doc($html_ref);
        my $child_trav;
        $child_trav = sub {
            my ($parent) = @_;
            my $type = $parent->nodeType;
            if (   ( $type == XML_DOCUMENT_NODE )
                or ( $type == XML_ELEMENT_NODE ) )
            {
                print $parent->localname(), "\n";
                my @childs = $parent->childNodes();
                foreach my $child (@childs)
                {
                    $child_trav->($child);
                }
            }
        };
        $child_trav->($dom);
        die;
        my $toc = HTML::Toc->new();
        $toc->setOptions(
            {
                0
                ? (
                    templateAnchorName => sub {
                        return $_[-1] =~ /id="([^"]+)/
                            ? $1
                            : ( die "no id found" );
                    }
                    )
                : ( doLinkToId => 1 ),
                tokenToToc => [
                    map {
                        +{
                            tokenBegin => "<h" . ( $_ + 1 ) . " id=\\S+>",
                            level      => $_,
                        }
                    } ( 1 .. 5 )
                ],
            }
        );
        my $tocgen = HTML::TocGenerator->new();
        $tocgen->generate( $toc, $$html_ref, {} );
        my $text = $toc->format();
        my $title =
            $lang eq 'en'
            ? "Table of Contents"
            : "תוכן העניינים";
        $text =~ s%\A\s*<!-.*?->\s*%<h2 id="toc">$title</h2>%ms
            or die "foo";
        $text =~ s%(</a>)\s*(<ul>)%$1<br/>$2%gms;
        $text =~ s%<!-.*?->\s*%%gms;
        my $text_nohtag =
            $nohtag ? $text =~ s%<h2 id="toc">[^<]+</h2>%%mrs : $text;
        $$html_ref =~ s#$TOC#$text_nohtag#g;
    }

    return;
}

1;
