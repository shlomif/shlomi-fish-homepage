package Shlomif::Homepage::TrueStories;

use 5.014;
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
    delete $rec->{html};
    delete $rec->{id};
    delete $rec->{url_base};
    return $rec;
}

my $stories_list = [
    map { _process($_) } (
        {
            html => <<"EOF",
<p>
Who gets the final say, before and after marriage? A memoir.
</p>
EOF
            id    => "who-gets-the-final-say",
            text  => "Who gets the final say?",
            title =>
"True story about asking people by the road about relationships",
        },
        {
            html => <<"EOF",
<p>
A true story about a 37 years old me socialising with a young cosplayer
of Hermione in a sci-fi/fantasy/etc. convention in Greater London and the
antagonism I later received about it online
</p>
EOF
            id   => "hermione-cosplayer",
            text =>
                "Socialising with a Young Hermione Cosplayer and Her Family",
            title =>
"Socialising with a young Hermione (“Harry Potter”) cosplayer and her family at GeekCon Nine Worlds",
            url_base => "socialising-with-a-young-hermione-cosplayer",
        },
        {
            html => <<"EOF",
<p>
A memoir.
</p>
EOF
            id    => "my-first-kiss",
            text  => "My first kiss",
            title => "The story of my first kiss",
        },
        {
            html => <<"EOF",
<p>
Showing the rented apartment to a hot girl.
</p>
EOF
            id   => "showing-the-apartment-to-a-hot-girl",
            text => "Showing the rented apartment to a hot girl",
        },
        {
            html => <<"EOF",
<p>
Preventing a football goal.
</p>
EOF
            id   => "preventing-a-football-goal",
            text => "Preventing a football goal",
        },
        {
            html => <<"EOF",
<p>
Avoiding getting run over by a horse.
</p>
EOF
            id   => "avoiding-getting-run-over-by-a-horse",
            text => "Avoiding getting run over by a horse",
        },
        {
            html => <<"EOF",
<p>
Sneaking into the van Gogh museum.
</p>
EOF
            id   => "sneaking-into-the-van-gogh-museum",
            text => "Sneaking into the van Gogh museum",
        },
        {
            html => <<"EOF",
<p>
A case of <a href="https://en.wikipedia.org/wiki/Innumeracy_(book)">innumeracy</a>.
</p>
EOF
            id   => "your-character-must-be-30-years-old",
            text => "“Your character must be 30 years old”",
        },
        {
            html => <<"EOF",
<p>
Conversations with People on Buses.
</p>
EOF
            id   => "bus-conversations",
            text => "Conversations with People on Buses",
        },
    )
];

my $id_lookup =
    +{ map { $stories_list->[$_]->{'id'} => $_ } keys @$stories_list };

my $nav_list = [ map { _nav_process($_) } @$stories_list ];

sub get_list
{
    return $stories_list;
}

sub get_nav_list
{
    return $nav_list;
}

sub get_html_by_id
{
    my ( $self, $id ) = @_;

    return $self->get_list()
        ->[ $id_lookup->{$id} // ( die "unknown id='$id'" ) ]->{'html'};
}

1;

__END__
