#!/usr/bin/perl -w

use strict;

# use Xmms::Remote ();
use Net::DBus ();

IRC::register("Xmms Song Displayer", "1.0", "", "");
IRC::add_command_handler("nowplay", "display_now_playing_song");

# my $remote = Xmms::Remote->new();

my $bus = Net::DBus->find;

# Get a handle to the HAL service

sub get_amarok_dbus_title
{
    my $amarok = eval { $bus->get_service("org.kde.amarok") };
    if ($@ || (!$amarok))
    {
        return;
    }

    my $tracklist = $amarok->get_object("/TrackList", "org.freedesktop.MediaPlayer");
    if (!$tracklist)
    {
        return;
    }
    
    my $track_idx = $tracklist->GetCurrentTrack();
    if ($track_idx < 0)
    {
        return;
    }
    my $track = $tracklist->GetMetadata($track_idx);
    return
        join(" - ", 
            grep { lc($_) ne "unknown" }
            @{$track}{qw(artist title)}
        );
}

sub get_amarok_title
{
    my $t = `dcop amarok player nowPlaying`;
    chomp($t);
    return $t;
}

sub get_kaffeine_title
{
    my $artist = `dcop kaffeine KaffeineIface artist`;
    chomp($artist);
    my $t = `dcop kaffeine KaffeineIface title`;
    chomp($t);
    
    if ($artist || $t)
    {
        return "$artist - $t";
    }
    else
    {
        return;
    }
}

=begin foo

sub get_xmms_title
{
    # Check for amaroK
    my $pos = $remote->get_playlist_pos();
    return $remote->get_playlist_title($pos);
}

=end foo

=cut

sub display_now_playing_song
{
    my $title = get_amarok_dbus_title() || get_kaffeine_title() || get_amarok_title();
    IRC::command("/me is listening to $title");
}

