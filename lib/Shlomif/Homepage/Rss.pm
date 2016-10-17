package Shlomif::Homepage::Rss;

use strict;
use warnings;

use MooX (qw( late ));

use XML::Feed;
use HTML::Widgets::NavMenu::EscapeHtml qw(escape_html);


use IO::All qw/ io /;

use Encode (qw(decode));

has 'feed' => (
    is => 'rw',
    default => sub {
        my $feed = XML::Feed->parse($ENV{'SF_HSITE_FEED_FILE'} || URI->new("http://shlomif-hsite.livejournal.com/data/atom"))
            or die XML::Feed->errstr;
        return $feed;
    },
);

sub _calc_entry_body
{
    my ($self, $entry) = @_;
    my $body = $entry->content()->body();

    $body =~ s{<a name="cut[^"]*"></a>}{}g;

    $body =~ s{ rel="nofollow"}{}g;

    return "<!-- TITLE=" . decode('utf-8', $entry->title()) . "-->\n" . $body;
}

sub run
{
    my $self = shift;
    foreach my $entry ($self->feed()->entries())
    {
        my $text = $self->_calc_entry_body($entry) . "\n\n" . "<p><a href=\"" . escape_html($entry->link()) . "\">See comments and comment on this.</a></p>\n";

        $text =~ s{[ \t]+$}{}gms;

        my $issued = $entry->issued();

        my $filename = "lib/feeds/shlomif_hsite/" . $issued->ymd() . ".html";
        io()->file($filename)->utf8->print($text);
    }
}

1;

