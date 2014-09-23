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
            id => 'the_enemy',
            tagline => "I came; I saw; I left no trace",
            logo_alt => "A = not-A",
            logo_class => "ene",
            logo_id => "the_enemy_logo",
            logo_src => "humour/TheEnemy/images/The-Enemy-logo-small.png",
            entry_id => "enemy-how-i-helped",
            entry_text => "The Enemy and How I Helped to Fight it",
            href => "humour/TheEnemy/",
            abstract => <<'EOF',
<p>
A member of the terrorist organisation “The Organisation” gets
up in the morning, goes to his post, and quits. But before he
leaves, he makes a suggestion that makes his former comrades
fight each other to death. Join the now ex‐Member of the
Organisation as he embarks on an ego trip, where he tries to
prove that A can in fact be not‐A, whether or not Aristotle
would agree.
</p>
EOF
            entry_extra_html => <<'EOF',
<p>
A political satire about the situation that prevailed in the Israeli-Lebanese
border. Lots of exits about mathematical logic, and a general critique of the
irrationality guiding political bodies.
</p>
EOF
        },
        {
            id => 'tow_the_fountainhead',
            tagline => "<i>The Fountainhead</i> may have been good enough in the 60’s, but we’re in the Information Age now",
            logo_alt => "The One With The Fountainhead Logo",
            logo_class => "towtf",
            logo_id => "tow_the_fountainhead_logo",
            logo_src => "humour/TOWTF/images/towtf-logo-200px.jpg",
            entry_id => "fountainhead",
            entry_text => "The One with the Fountainhead",
            href => "humour/TOWTF/",
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
            entry_id => "human-hacking",
            entry_text => "The Human Hacking Field Guide",
            href => "humour/human-hacking/",
            abstract => <<'EOF',
<p class="hhfg abstract">
Jennifer is a trendy and popular high school senior who is living and
studying in the vicinity of Los Angeles. Her best friend, Taylor, convinces her
to try to become a developer of open source software. He puts her
under the tutorship of a different friend of his, the female open source
contributor Eve, who prefers to be called “Erisa”, and who is a self-conscious
and rebelling punk, with whom Jennifer finds it hard to deal. Jennifer remains
determined to learn how to become an open source developer from Erisa, but
there are some surprises along the road.
</p>
EOF
        },
        {
            id => 'we_the_living_dead',
            tagline => "From perfection to imperfection; from finity to infinity" ,

            logo_alt => "Fiery Q",
            logo_class => "st_wtld",
            logo_id => "we_the_living_dead_logo",
            logo_src => "humour/Star-Trek/We-the-Living-Dead/images/fiery-Q.png",
            entry_id => "we-the-living-dead",
            entry_text => "Star Trek: We the Living Dead",
            href => "humour/Star-Trek/We-the-Living-Dead/",
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
            entry_id => "selina-mandrake",
            entry_text => "Selina Mandrake - The Slayer (Buffy Parody)",
            href => "humour/Selina-Mandrake/",
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
            entry_extra_html => <<'EOF',
<p>
This screenplay, a parody and reflection on
<a href="http://en.wikipedia.org/wiki/Buffy_the_Vampire_Slayer">Buffy the
Vampire Slayer</a> (both the movie and the show) and inspired by many
other sources, is still under work, but is already in a usable state.
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
            entry_id => "summerschool-at-the-nsa",
            entry_text => "Summerschool at the NSA - A Screenplay",
            href => "humour/Summerschool-at-the-NSA/",
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
            entry_extra_html => <<'EOF',
<p>
This screenplay is surrealistic realism and takes place in
April 2013. Very farfetched, but could happen.
</p>

<p>
I see it as a reflection and a modernisation of Ayn Rand’s novel
<a href="https://en.wikipedia.org/wiki/Atlas_Shrugged"><i>Atlas
Shrugged</i></a>
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
            entry_id => "buffy-few-good",
            entry_text => "Buffy: a Few Good Slayers - A Screenplay",
            href => "humour/Buffy/A-Few-Good-Slayers/",
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
            id => 'muppets_show_tni',
            tagline => "Muppets!" ,
            logo_alt => "The Muppets Show TNI",
            logo_class => "muppets",
            logo_id => "muppets_show_tni_logo",
            logo_src => "humour/Muppets-Show-TNI/images/Muppet-Show-TNI-Logo--take1.svg.png",
            entry_id => "muppets-show-TNI",
            entry_text => "The Muppets’ Show - The New Incarnation",
            href => "humour/Muppets-Show-TNI/",
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
        {
            id => 'who_is_qoheleth',
            tagline => "What had been, is what will be. There is nothing new under the sun." ,
            logo_alt => "“So who the Hell is Qoheleth?” Logo",
            logo_class => "who_is_qoheleth",
            logo_id => "who_is_qoheleth_logo",
            logo_src => "humour/So-Who-The-Hell-Is-Qoheleth/images/who-is-qoheleth-small.png",
            entry_id => "who-is-qoheleth",
            entry_text => "“So who the Hell is Qoheleth?”",
            href => "humour/So-Who-The-Hell-Is-Qoheleth/",
            abstract => <<'EOF',
<p class="who_is_qoheleth abstract">
An illustrated screenplay about what happened to the author of the scroll of
Ecclesiastes/Qoheleth shortly after writing it.
</p>
EOF
        },
        {
            id => 'humanity',
            tagline => "TODO FILL IN" ,
            logo_alt => "Humanity Logo",
            logo_class => "humanity",
            logo_id => "humanity_logo",
            logo_src => "humour/humanity/images/humanity-logo-small.png",
            entry_id => "humanity",
            entry_text => "Humanity",
            href => "humour/humanity/",
            abstract => <<'EOF',
<p class="humanity abstract">
Humanity is a screenplay for a movie
that aims to be a parody about humanity and modern life in particular. It
tells the story of a day in the life of a <a href="http://en.wikipedia.org/wiki/Semitic">Semitic</a> city in
<a href="http://en.wikipedia.org/wiki/Canaan">Canaan</a> circa the year
500 B.C. Each scene is dedicated to one of the city’s elements: The Cathedral
(OK - an altar with a priest), the Bazaar, the Well, the Wall, etc.
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

sub render_common_top_elems
{
    my ($class, $id) = @_;

    $class->render_1($id);

    _print_utf8(sprintf(qq#<div class="%s abstract">\n#, $class->_get_story($id)->logo_class));

    _print_utf8(qq#<h2 id="abstract">Abstract</h2>\n#);

    $class->render_abstract($id);

    _print_utf8(qq{</div>\n});

    return;
}

sub render_story_entry
{
    my ($class, $id, $tag) = @_;

    my $o = $class->_get_story($id);

    _print_utf8(
        qq{<div class="story">\n},
        sprintf(qq{<%s id="%s"><a href="%s">%s</a></%s>\n},
            $tag,
            ($o->entry_id || (die "Foo $id")),
            CGI::escapeHTML(
                $::nav_bar->get_cross_host_rel_url_ref(
                    {
                        host => 't2',
                        host_url => ($o->href || die "Qlax $id"),
                        url_type => 'rel',
                        url_is_abs => 0,
                    }
                )
            ),
            ($o->entry_text || die "Elimbda $id"),
            $tag,
        )
    );

    $class->render_list_items($id);
    _print_utf8(
        $o->entry_extra_html(),
        qq{</div>\n}
    );

    return;
}

sub render_all_stories_entries
{
    my ($class, $tag) = @_;

    foreach my $o (@_Stories)
    {
        $class->render_story_entry( $o->id(), $tag, );
    }

    return;
}

1;

