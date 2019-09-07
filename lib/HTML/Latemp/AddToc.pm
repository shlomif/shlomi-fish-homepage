package HTML::Latemp::AddToc;

use strict;
use warnings;

use Moo;
use HTML::Toc          ();
use HTML::TocGenerator ();

my $TOC         = qr#<toc */ *>#;
my $TOC_NO_HTAG = qr#<toc *nohtag="1" */ *>#;

sub add_toc
{
    my ( $self, $html_ref ) = @_;
    if ( $$html_ref =~ $TOC or $$html_ref =~ $TOC_NO_HTAG )
    {
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
        $text =~ s%\A\s*<!-.*?->\s*%<h2 id="toc">Table of Contents</h2>%ms
            or die "foo";
        $text      =~ s%(</a>)\s*(<ul>)%$1<br/>$2%gms;
        $text      =~ s%<!-.*?->\s*%%gms;
        $$html_ref =~ s#$TOC#$text#g;
        my $text_nohtag = $text =~ s%<h2 id="toc">Table of Contents</h2>%%mrs;
        $$html_ref =~ s#$TOC_NO_HTAG#$text_nohtag#g;
    }

    return;
}

1;
