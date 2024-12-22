package Shlomif::Homepage::TrueStories;

use 5.014;
use strict;
use warnings;
use utf8;

use Moo;

use Path::Tiny qw/ cwd path tempdir tempfile /;

sub _calc_url
{
    my ($url_base) = @_;

    return "humour/bits/true-stories/${url_base}/";
}

sub _calc_dir
{
    my ($url_base) = @_;

    return path( "src/" . _calc_url($url_base) );
}

sub _calc_dir_main_file
{
    my ($dir) = @_;

    return $dir->child("index.xhtml.tt2");
}

my $SRC = "avoiding-getting-run-over-by-a-horse";

sub _process
{
    my ($rec) = @_;
    my $url_base = ( $rec->{url_base} //= $rec->{id} );
    $rec->{url} //= _calc_url($url_base);
    my $dir = _calc_dir($url_base);
    my $fn  = _calc_dir_main_file($dir);
    if ( not -f $fn )
    {
        my $srcdir = _calc_dir($SRC);
        my $srcfn  = _calc_dir_main_file($srcdir);
        $dir->mkdir();
        $srcfn->copy($fn);
        system( "git", "add", "$fn" );
    }

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
<q>I will await her.</q>
</p>
EOF
            id   => "showing-the-apartment-to-a-hot-girl",
            text => "Showing the rented apartment to a hot girl",
        },
        {
            html => <<"EOF",
<p>
<q>Never give up.</q>
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
Conversations with people on buses.
</p>
EOF
            id   => "bus-conversations",
            text => "Conversations with People on Buses",
        },
        {
            html => <<"EOF",
<p>
Fencing with plastic hammers during the Israeli Independence Day.
</p>
EOF
            id   => "fencing-with-plastic-hammers",
            text => "Fencing with plastic hammers",
        },
        {
            html => <<"EOF",
<p>
Why I decided to not care too much about people caring about “faults”
I do not find important.
</p>
EOF
            id   => "does-he-keep-kashruth",
            text => "“Does he keep Kashruth?”",
        },
        {
            html => <<"EOF",
<p>
A story about my classmates and I participating in an Israel-wide mathematics
competition for teams from high schools, during the 12th grade, and later
working on solving the previously-unsolved riddles from the problems-sheet.
</p>
EOF
            id   => "twelfth-grade-mathematics-competition",
            text => "12th Grade Mathematics Competition",
        },
        {
            html => <<"EOF",
<p>
Playing Ball with my Cousin’s Son at a Family Event.
</p>
EOF
            id   => "playing-ball-with-my-cousin-son",
            text => "Playing Ball with my Cousin’s Son at a Family Event",
        },
        {
            html => <<"EOF",
<p>
“A Shameful Profession”.
</p>
EOF
            id   => "shameful-profession",
            text => "“A Shameful Profession”",
        },
        {
            html => <<"EOF",
<p>
Hand-calculators-use memoir.
</p>
EOF
            id   => "calculators-use",
            text => "Hand-calculators-use memoir",
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

sub _get_record_by_id
{
    my ( $self, $id ) = @_;

    return $self->get_list()
        ->[ $id_lookup->{$id} // ( die "unknown id='$id'" ) ];
}

sub get_html_by_id
{
    my ( $self, $id ) = @_;

    return $self->_get_record_by_id($id)->{'html'};
}

1;

__END__
