package Shlomif::Homepage::Rss;

use strict;
use warnings;

use base 'HTML::Widgets::NavMenu::Object';
use base 'Class::Accessor';

use XML::Feed;
use CGI;

__PACKAGE__->mk_accessors(qw(
    feed
));
    
sub _init
{
    my $self = shift;
    my $feed = XML::Feed->parse(URI->new("http://www.livejournal.com/community/shlomif_hsite/data/atom"))
        or die XML::Feed->errstr;
    $self->feed($feed);

    return 0;
}

sub run
{
    my $self = shift;
    foreach my $entry ($self->feed()->entries())
    {
        my $text = $entry->content()->body() . "\n\n" . "<p><a href=\"" . CGI::escapeHTML($entry->link()) . "\">See comments and comment on this.</a></p>\n";
        my $issued = $entry->issued();
        my $filename = "lib/feeds/shlomif_hsite/" . $issued->ymd() . ".html";
        open O, ">", $filename;
        print O $text;
        close(O);
        system("svn", "add", "-q", $filename);
    }
}

1;

