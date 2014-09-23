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
            abstract => <<'EOF',
<p class="selina abstract">
A geeky Anglo-American girl in her high school senior year in 2011
California, finds out that she is none other than <b>The Slayer</b>,
a legendary heroine who is destined to slay many notable vampires and demons,
culminating in none other than The Master, the vampire with the oldest
soul. See how she manages to do so, despite being completely non-violent, and
even supportive of the demons she encounters.
</p>
EOF
        },
        {
            id => 'summerschool_at_the_nsa',
            tagline => "As the sling shoots, grown men will cry",
            logo_alt => "Summerschool at the NSA Logo",
            logo_class => "summernsa",
            logo_id => "summernsa_logo",
            logo_src => "humour/Summerschool-at-the-NSA/images/summernsa-logo-small.png",
            abstract => <<'EOF',
<p class="summernsa abstract">
The Hollywood actresses
<a href="https://en.wikipedia.org/wiki/Sarah_Michelle_Gellar">Sarah
Michelle Gellar</a> (of
<a href="http://en.wikipedia.org/wiki/Buffy_the_Vampire_Slayer">Buffy</a>
fame) and
<a href="https://en.wikipedia.org/wiki/Summer_Glau">Summer Glau</a> (of
<a href="http://en.wikipedia.org/wiki/Xkcd">xkcd</a> notability)
conspire to <b>kick the ass</b> of the
<a href="https://en.wikipedia.org/wiki/National_Security_Agency">NSA</a>
(= the United States government’s National Security Agency), while using
special warfare that is completely non-violent and <b>non-destructive</b>. Two
attractive, intelligent, and resourceful women against a large, <b>inefficient</b>,
federal government organisation whose estimated annual budget is
several times their combined worth. Does the NSA actually stand
a chance?
</p>
EOF
        },
        {
            id => 'buffy_a_few_good_slayers',
            tagline => "I learned more from my students than I have from my teachers." ,
            logo_alt => "Buffy - a Few Good Slayers Logo",
            logo_class => "buffy_few_good",
            logo_id => "buffy_a_few_good_slayers_logo",
            logo_src => "humour/Buffy/A-Few-Good-Slayers/images/buffy-afgs-logo-small.png",
            abstract => <<'EOF',
<p class="buffy_few_good abstract">
The Demonic underworld is held under tight control in a forked version of the
<a href="https://en.wikipedia.org/wiki/Buffyverse">Buffy</a> universe where
the <a href="http://buffy.wikia.com/wiki/Scooby_Gang">Scooby Gang</a> all
ended up happier and more powerful, and men and women have equal opportunities
when it comes to fighting Demons. A
new class of tenth grade (sophomore) students start the three year demon
fighting program in the scholastic year of 2014/2015 in Sunnydale High School,
while the older Scooby Gang, who are their teachers and mentors, have to deal
with the usual set of problems that come with being teachers, parents,
spouses and adults.
</p>
EOF
        },
        {
            id => 'who_is_qoheleth',
            tagline => "What had been, is what will be. There is nothing new under the sun." ,
            logo_alt => "“So who the Hell is Qoheleth?” Logo",
            logo_class => "who_is_qoheleth",
            logo_id => "who_is_qoheleth_logo",
            logo_src => "humour/So-Who-The-Hell-Is-Qoheleth/images/who-is-qoheleth-small.png",
            abstract => <<'EOF',
<p class="who_is_qoheleth abstract">
An illustrated screenplay about what happened to the author of the scroll of
Ecclesiastes/Qoheleth shortly after writing it.
</p>
EOF
        },
        {
            id => 'muppets_show_tni',
            tagline => "Muppets!" ,
            logo_alt => "The Muppets Show TNI",
            logo_class => "muppets",
            logo_id => "muppets_show_tni_logo",
            logo_src => "humour/Muppets-Show-TNI/images/Muppet-Show-TNI-Logo--take1.svg.png",
            abstract => <<'EOF',
<p class="muppets_show_tni abstract">
A new incarnation of <a href="http://muppet.wikia.com/wiki/The_Muppet_Show"><b>The
Muppets’ show</b></a>. Each show will cover a <b>theme</b> such
as Harry Potter, or
<a href="$(ROOT)/humour/bits/facts/Summer-Glau/">Summer Glau</a> &amp;
<a href="$(ROOT)/humour/bits/facts/Chuck-Norris/">Chuck Norris</a> as
ruthless Grammar Nazis.
</p>
EOF
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

    my $abstract = $class->_get_story($id)->abstract || die "No abstract";

    $abstract =~ s#"\$\(ROOT\)/([^"]+?/)"#
                q{"}
                . $::nav_bar->get_cross_host_rel_url_ref(
                    {
                        host => 't2',
                        host_url => $1,
                        url_type => 'rel',
                        url_is_abs => 0,
                    }
                )
                . q{"}
        #eg;
    _print_utf8($abstract);

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

sub render_list_items
{
    my ($class, $id) = @_;

    $class->render_logo($id);
    $class->render_abstract($id);

    return;
}

1;

