#!/usr/bin/perl -w

use strict;

use Xmms::Remote ();

IRC::register("Xmms Song Displayer", "1.0", "", "");
IRC::add_command_handler("nowplay", "display_now_playing_song");

my $remote = Xmms::Remote->new();

sub display_now_playing_song
{
    my $pos = $remote->get_playlist_pos();
    my $title = $remote->get_playlist_title($pos);
    IRC::command("/me is listening to $title");
}

