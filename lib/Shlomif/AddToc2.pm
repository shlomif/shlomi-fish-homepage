package Shlomif::AddToc2;

use strict;
use warnings;
use utf8;

use Moo;
use HTML::Toc                 ();
use HTML::TocGenerator        ();
use Path::Tiny                qw( path );
use XML::LibXML               qw( XML_DOCUMENT_NODE XML_ELEMENT_NODE );
use XML::LibXML::XPathContext qw(  );

my $xpc = XML::LibXML::XPathContext->new();
$xpc->registerNs( 'x', q{http://www.w3.org/1999/xhtml} );

my $TOC = qr#<toc *lang=\"([a-z\-A-Z]+)\" *((?:nohtag="1" *)?) */ *>#;

my $parser = XML::LibXML->new();

sub _get_doc
{
    my ( $self, $str_ref ) = @_;

    return ( $parser->load_xml( string => $str_ref ) );
}

my %SECT_TAGS = ( map { $_ => 1 } qw( article section ) );

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
            my $desc     = [];
            my $ret      = $desc;
            my $type     = $parent->nodeType;
            if (   ( $type == XML_DOCUMENT_NODE )
                or ( $type == XML_ELEMENT_NODE ) )
            {
                my $localname = $parent->localname();
                print $localname, "\n";
                if ( exists $SECT_TAGS{$localname} )
                {
                    my $r = $xpc->find(
                        sprintf(
                            q{x:header/*[%s]/@id},
                            join( " or ",
                                map { sprintf( "(local-name() = 'h%d')", $_ ) }
                                    ( 1 .. 6 ) ),
                        ),
                        $doc
                    );
                    $ret = [ { el => $localname, subs => $desc, } ];
                }
                my @childs = $parent->childNodes();
                foreach my $child (@childs)
                {
                    my ($cret) = $child_trav->($child);
                    push @$desc, @$cret;
                }
            }
            return $ret;
        };
        my ($tree) = $child_trav->($dom);
        $DB::single = 1;

        # die;
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
