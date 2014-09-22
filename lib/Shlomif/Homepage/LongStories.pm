package Shlomif::Homepage::LongStories;

use strict;
use warnings;

use utf8;

use CGI ();

use Shlomif::WrapAsUtf8 qw(_print_utf8);

use Shlomif::Homepage::LongStories::Story;

use parent ('Exporter');

our @EXPORT_OK = (qw(
    get_nav_block
));

my @_Stories =
(
    map { Shlomif::Homepage::LongStories::Story->new($_) }
    (
        {
            id => 'tow_the_fountainhead',
            tagline => "<i>The Fountainhead</i> may have been good enough in the 60’s, but we’re in the Information Age now",
            logo_alt => "The One With The Fountainhead Logo",
            logo_class => "towtf",
            logo_id => "tow_the_fountainhead_logo",
            logo_src => "humour/TOWTF/images/towtf-logo-200px.jpg",
            abstract => <<'EOF',
<p>
A parody of Ayn Rand’s novel,
<a href="http://en.wikipedia.org/wiki/The_Fountainhead"><i>The
Fountainhead</i></a>, modelled around a two part episode of
the Television sitcom show
<a href="http://en.wikipedia.org/wiki/Friends"><i>Friends</i></a>.
Somewhat unhappy with the original book, the six friends in the show role-play
their own version of <i>The Fountainhead</i>, while trying to improve upon it.
Will they succeed?
</p>

<p>
What was the <b>photo</b> of the Parthenon <b>replaced</b> with?<br />
Why was <b>Chandler</b> happy to play Peter Keating?<br />
Which element is featured in every second-rate <b>romantic novel</b>?<br />
Which piece of advice did <b>Toohey</b> give Dominique Francon?<br />
Why did <b>cruising</b> with Gail Wynand turn out to be a <b>bad idea</b>?<br />
And who were the <b>bad</b> guys in the story?
</p>

<p>
Read the screenplays to find out.
</p>
EOF
        },
        {
            id => 'hhfg',
            tagline => "Who said girls can’t code?",
            logo_alt => "Human Hacking Field Guide Logo",
            logo_class => "hhfg",
            logo_id => "hhfg_logo",
            logo_src => "humour/human-hacking/images/hhfg-logo-small.png",
        },
        {
            id => 'we_the_living_dead',
            tagline => "From perfection to imperfection; from finity to infinity" ,

            logo_alt => "Fiery Q",
            logo_class => "st_wtld",
            logo_id => "we_the_living_dead_logo",
            logo_src => "humour/Star-Trek/We-the-Living-Dead/images/fiery-Q.png",
            abstract => <<'EOF',
<p>
In this fan episode of the Television show
<a href="http://en.wikipedia.org/wiki/Star_Trek:_Deep_Space_Nine"><i>Star Trek: Deep Space Nine</i></a>,
we discover the true essence of the Q Continuum, and meet
some “living dead”: conscious beings (including humans) who reportedly died,
but actually were saved and still live a prosperous life some place
else in the universe, as well as “vampires”: individuals who never died and
have instead remained alive since they were born.
</p>

<p>
A Star Trek episode to end all Star Trek episodes, (and, more
generally - story to end all stories).
</p>
EOF
        },
        {
            id => 'selina_mandrake',
            tagline => "Caught between Post-modernism and the New Age",
            logo_alt => "1d10 die",
            logo_class => "selina",
            logo_id => "selina_mandrake_logo",
            logo_src => "humour/Selina-Mandrake/images/Green-d10-dice.png",
        },
        {
            id => 'summerschool_at_the_nsa',
            tagline => "As the sling shoots, grown men will cry",
            logo_alt => "Summerschool at the NSA Logo",
            logo_class => "summernsa",
            logo_id => "summernsa_logo",
            logo_src => "humour/Summerschool-at-the-NSA/images/summernsa-logo-small.png",
        },
        {
            id => 'buffy_a_few_good_slayers',
            tagline => "I learned more from my students than I have from my teachers." ,
            logo_alt => "Buffy - a Few Good Slayers Logo",
            logo_class => "buffy_few_good",
            logo_id => "buffy_a_few_good_slayers_logo",
            logo_src => "humour/Buffy/A-Few-Good-Slayers/images/buffy-afgs-logo-small.png",
        },
        {
            id => 'who_is_qoheleth',
            tagline => "What had been, is what will be. There is nothing new under the sun." ,
            logo_alt => "“So who the Hell is Qoheleth?” Logo",
            logo_class => "who_is_qoheleth",
            logo_id => "who_is_qoheleth_logo",
            logo_src => "humour/So-Who-The-Hell-Is-Qoheleth/images/who-is-qoheleth-small.png",
        },
        {
            id => 'muppets_show_tni',
            tagline => "Muppets!" ,
            logo_alt => "The Muppets Show TNI",
            logo_class => "muppets",
            logo_id => "muppets_show_tni_logo",
            logo_src => "humour/Muppets-Show-TNI/images/Muppet-Show-TNI-Logo--take1.svg.png",
        },

    )
);

my %_Stories_by_id = (map { $_->id() => $_ } @_Stories);

sub _get_story
{
    my ($class, $id) = @_;

    return $_Stories_by_id{$id} ||
        die "Unknown story '$id'";
}

sub get_tagline
{
    my ($class, $id) = @_;

    return $class->_get_story($id)->tagline;
}

sub render_tagline
{
    my ($class, $id) = @_;

    _print_utf8 (qq#<h2 id="tagline">@{[$class->get_tagline($id)]}</h2>\n#);

    return;
}

sub render_abstract
{
    my ($class, $id) = @_;

    _print_utf8($class->_get_story($id)->abstract || die "No abstract");

    return;
}

sub render_logo
{
    my ($class, $id) = @_;

    my $o = $class->_get_story($id);

    _print_utf8(
        sprintf(qq#<img id="%s" src="%s" alt="%s" class="story_logo %s" />\n#,
            $o->logo_id,
            CGI::escapeHTML(
                $::nav_bar->get_cross_host_rel_url_ref(
                    {
                        host => 't2',
                        host_url => $o->logo_src,
                        url_type => 'rel',
                        url_is_abs => 0,
                    }
                ),
            ),
            $o->logo_alt,
            $o->logo_class,
        ),

    );

    return;
}

sub render_1
{
    my ($class, $id) = @_;

    $class->render_tagline($id);
    $class->render_logo($id);

    return;
}

1;

