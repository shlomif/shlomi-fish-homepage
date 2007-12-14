#!/usr/bin/perl -w

use strict;

use Xmms::Remote ();

IRC::register("Xmms Song Displayer", "1.0", "", "");
IRC::add_command_handler("nowplay", "display_now_playing_song");

my $remote = Xmms::Remote->new();

sub get_amarok_title
{
    my $t = `dcop amarok player title`;
    my $a = `dcop amarok player artist`;
    chomp($t);
    chomp($a);
    if (length($t) + length($a) > 0)
    {
        return "$a - $t";
    }
    else
    {
        return undef;
    }
}

sub get_xmms_title
{
    # Check for amaroK
    my $pos = $remote->get_playlist_pos();
    return $remote->get_playlist_title($pos);
}

sub display_now_playing_song
{
    my $title = get_amarok_title() || get_xmms_title();
    IRC::command("/me is listening to $title");
}

