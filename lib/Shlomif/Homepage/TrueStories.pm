package Shlomif::Homepage::TrueStories;

use strict;
use warnings;
use utf8;

use Moo;

sub _process
{
    my ($rec) = @_;

    $rec->{url_base} //= $rec->{id};
    $rec->{url}      //= "humour/bits/true-stories/$rec->{url_base}/";
    return $rec;
}

sub _nav_process
{
    my ($rec) = @_;
    $rec = +{%$rec};
    delete $rec->{id};
    delete $rec->{url_base};
    return $rec;
}

my $stories_list = [
    map { _process($_) } (
        {
            text  => "Who gets the final say?",
            id    => "who-gets-the-final-say",
            title =>
"True story about asking people by the road about relationships",
        },
        {
            text =>
                "Socialising with a Young Hermione Cosplayer and Her Family",
            id       => "hermione-cosplayer",
            url_base => "socialising-with-a-young-hermione-cosplayer",
            title    =>
"Socialising with an ~11 years old Hermione (“Harry Potter”) Cosplayer and her family at GeekCon Nine Worlds",
        },
        {
            text  => "First Kiss",
            id    => "my-first-kiss",
            title =>
"True story about asking people by the road about relationships",
        },
        {
            text => "Showing the rented apartment to a hot girl",
            id   => "showing-the-apartment-to-a-hot-girl",
        },
        {
            text => "Preventing a football goal",
            id   => "preventing-a-football-goal",
        },
        {
            text => "Avoiding getting run over by a horse",
            id   => "avoiding-getting-run-over-by-a-horse",
        },
        {
            text => "Sneaking into the van Gogh museum",
            id   => "sneaking-into-the-van-gogh-museum",
        },
    )
];
my $nav_list = [ map { _nav_process($_) } @$stories_list ];

sub get_list
{
    return $stories_list;
}

sub get_nav_list
{
    return $nav_list;
}

1;

__END__
