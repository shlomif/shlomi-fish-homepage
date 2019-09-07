package HTML::Latemp::AddToc;

use strict;
use warnings;
use utf8;

use Moo;
use HTML::Toc          ();
use HTML::TocGenerator ();

my $TOC = qr#<toc *lang=\"([a-z\-A-Z]+)\" *((?:nohtag="1" *)?) */ *>#;

sub add_toc
{
    my ( $self, $html_ref ) = @_;
    if ( my ( $lang, $nohtag ) = $$html_ref =~ $TOC )
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
