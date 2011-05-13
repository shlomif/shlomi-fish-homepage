package Shlomif::Homepage::Rss;

use strict;
use warnings;

use base 'HTML::Widgets::NavMenu::Object';
use base 'Class::Accessor';

use XML::Feed;
use CGI;

use Encode (qw(decode));

__PACKAGE__->mk_accessors(qw(
    feed
));
    
sub _init
{
    my $self = shift;
    my $feed = XML::Feed->parse($ENV{'SF_HSITE_FEED_FILE'} || URI->new("http://shlomif-hsite.livejournal.com/data/atom"))
        or die XML::Feed->errstr;
    $self->feed($feed);

    return 0;
}

sub _calc_entry_body
{
    my ($self, $entry) = @_;
    my $body = $entry->content()->body();

    $body =~ s{<a name="cut[^"]*"></a>}{}g;

    return "<!-- TITLE=" . CGI::escapeHTML(decode('utf-8', $entry->title())) . "-->\n" . $body;
}

sub run
{
    my $self = shift;
    foreach my $entry ($self->feed()->entries())
    {
        my $text = $self->_calc_entry_body($entry) . "\n\n" . "<p><a href=\"" . CGI::escapeHTML($entry->link()) . "\">See comments and comment on this.</a></p>\n";
        my $issued = $entry->issued();
        my $filename = "lib/feeds/shlomif_hsite/" . $issued->ymd() . ".html";
        open O, ">", $filename;
        binmode O, ":utf8";
        print O $text;
        close(O);
    }
}

1;

