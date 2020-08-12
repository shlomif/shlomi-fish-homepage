package Shlomif::Homepage::LongStories;

use strict;
use warnings;
use utf8;

use Moo;

use Path::Tiny qw/ path /;
use HTML::Widgets::NavMenu::EscapeHtml qw(escape_html);

use Shlomif::Homepage::LongStories::Story ();

my @_Stories = (
    map { Shlomif::Homepage::LongStories::Story->new($_) } (
        {
            id         => 'the_enemy',
            tagline    => "I came; I saw; I left no trace",
            logo_alt   => "A = not-A",
            logo_class => "ene",
            logo_id    => "the_enemy_logo",
            logo_src   => "humour/TheEnemy/images/The-Enemy-logo-small.png",
            logo_svg   => 'humour/TheEnemy/images/The-Enemy--Logo.svg',
            entry_id   => "enemy-how-i-helped",
            entry_text => "The Enemy and How I Helped to Fight it",
            href       => "humour/TheEnemy/",
            abstract   => <<'EOF',
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
            tagline =>
"The Fountainhead may have been good enough in the 60’s, but we’re in the Information Age now",
            logo_alt   => "The One With The Fountainhead Logo",
            logo_class => "towtf",
            logo_id    => "tow_the_fountainhead_logo",
            logo_src =>
                "humour/TOneW-the-Fountainhead/images/towtf-logo-200px.jpg",
            logo_svg   => '//$SKIP',
            entry_id   => "fountainhead",
            entry_text => "The One with the Fountainhead",
            href       => "humour/TOneW-the-Fountainhead/",
            abstract   => <<'EOF',
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
What was the <b>photo</b> of the Parthenon <b>replaced</b> with?<br/>
Why was <b>Chandler</b> happy to play Peter Keating?<br/>
Which element is featured in every second-rate <b>romantic novel</b>?<br/>
Which piece of advice did <b>Toohey</b> give Dominique Francon?<br/>
Why did <b>cruising</b> with Gail Wynand turn out to be a <b>bad idea</b>?<br/>
And who were the <b>bad</b> guys in the story?
</p>

<p>
Read the screenplays to find out.
</p>
EOF
        },
        {
            id         => 'humanity',
            tagline    => "Intelligent (?) and Conscious (?)",
            logo_alt   => "Humanity Logo",
            logo_class => "humanity",
            logo_id    => "humanity_logo",
            logo_src   => "humour/humanity/images/humanity-logo-small.png",
            logo_svg   => 'humour/humanity/images/humanity-logo.svg',
            entry_id   => "humanity",
            entry_text => "Humanity",
            href       => "humour/humanity/",
            abstract   => <<'EOF',
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
        {
            id         => 'hhfg',
            tagline    => "Who said girls can’t code?",
            logo_alt   => "Human Hacking Field Guide Logo",
            logo_class => "hhfg",
            logo_id    => "hhfg_logo",
            logo_src   => "humour/human-hacking/images/hhfg-logo-small.png",
            logo_svg =>
'humour/human-hacking/images/human-hacking-field-guide-logo.svg',
            entry_id   => "human-hacking",
            entry_text => "The Human Hacking Field Guide",
            href       => "humour/human-hacking/",
            abstract   => <<'EOF',
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
            tagline =>
                "From perfection to imperfection; from finity to infinity",

            logo_alt   => "Fiery Q",
            logo_class => "st_wtld",
            logo_id    => "we_the_living_dead_logo",
            logo_src =>
                "humour/Star-Trek/We-the-Living-Dead/images/fiery-Q.png",
            logo_svg   => '//$SKIP',
            entry_id   => "we-the-living-dead",
            entry_text => "Star Trek: We the Living Dead",
            href       => "humour/Star-Trek/We-the-Living-Dead/",
            abstract   => <<'EOF',
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
            id         => 'selina_mandrake',
            tagline    => "Caught between Post-modernism and the New Age",
            logo_alt   => "1d10 die",
            logo_class => "selina",
            logo_id    => "selina_mandrake_logo",
            logo_src   => "humour/Selina-Mandrake/images/Green-d10-dice.png",
            logo_svg   => '//$SKIP',
            entry_id   => "selina-mandrake",
            entry_text => "Selina Mandrake - The Slayer (Buffy Parody)",
            href       => "humour/Selina-Mandrake/",
            abstract   => <<'EOF',
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
other sources, is still work-in-progress, but is already in a usable state.
</p>
EOF

        },
        {
            id         => 'summerschool_at_the_nsa',
            tagline    => "As the sling shoots, grown men will cry",
            logo_alt   => "Summerschool at the NSA Logo",
            logo_class => "summernsa",
            logo_id    => "summernsa_logo",
            logo_src =>
"humour/Summerschool-at-the-NSA/images/summernsa-logo-small.png",
            logo_svg   => '//$SKIP',
            entry_id   => "summerschool-at-the-nsa",
            entry_text => "Summerschool at the NSA - A Screenplay",
            href       => "humour/Summerschool-at-the-NSA/",
            abstract   => <<'EOF',
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
            tagline =>
                "I learned more from my students than I have from my teachers.",
            logo_alt   => "Buffy - a Few Good Slayers Logo",
            logo_class => "buffy_few_good",
            logo_id    => "buffy_a_few_good_slayers_logo",
            logo_src =>
'humour/Buffy/A-Few-Good-Slayers/images/Buffy-A-Few-Good-Slayers-Logo--take1.min.svg',
            logo_svg =>
'humour/Buffy/A-Few-Good-Slayers/images/Buffy-A-Few-Good-Slayers-Logo--take1.svg',
            entry_id   => "buffy-few-good",
            entry_text => "Buffy: a Few Good Slayers - A Screenplay",
            href       => "humour/Buffy/A-Few-Good-Slayers/",
            abstract   => <<'EOF',
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
            id         => 'muppets_show_tni',
            tagline    => "Muppets!",
            logo_alt   => "The Muppets Show TNI",
            logo_class => "muppets",
            logo_id    => "muppets_show_tni_logo",
            logo_src   => "humour/Muppets-Show-TNI/images/muppets-200w.png",
            logo_svg   => '//$SKIP',
            entry_id   => "muppets-show-TNI",
            entry_text => "Muppets / Sesame Street Fanfic",
            href       => "humour/Muppets-Show-TNI/",
            abstract   => <<'EOF',
<p class="muppets_show_tni abstract">
Fanfic episodes of <a href="http://muppet.wikia.com/wiki/The_Muppet_Show"><b>The
Muppets’ show</b></a> or <a href="https://muppet.fandom.com/wiki/Sesame_Street">Sesame Street</a>.
Each show will cover a <b>theme</b> such
as <a href="$(ROOT)/humour/Muppets-Show-TNI/Harry-Potter.html"></a>Harry Potter, or
<a href="$(ROOT)/humour/bits/facts/Summer-Glau/">Summer Glau</a> &amp;
<a href="$(ROOT)/humour/bits/facts/Chuck-Norris/">Chuck Norris</a> as
two ruthless <a href="$(ROOT)/humour/Muppets-Show-TNI/Summer-Glau-and-Chuck-Norris.html">Grammar Nazis</a>.
</p>
EOF
        },
        {
            id => 'who_is_qoheleth',
            tagline =>
"What had been, is what will be. There is nothing new under the sun.",
            logo_alt   => "“So, who the Hell is Qoheleth?” Logo",
            logo_class => "who_is_qoheleth",
            logo_id    => "who_is_qoheleth_logo",
            logo_src =>
"humour/So-Who-The-Hell-Is-Qoheleth/images/who-is-qoheleth-small.png",
            logo_svg =>
                'humour/So-Who-The-Hell-Is-Qoheleth/images/who-is-qoheleth.svg',
            entry_id   => "who-is-qoheleth",
            entry_text => "“So, who the Hell is Qoheleth?”",
            href       => "humour/So-Who-The-Hell-Is-Qoheleth/",
            abstract   => <<'EOF',
<p class="who_is_qoheleth abstract">
Josephus was a budding philosopher of Jewish descent in
<a href="https://en.wikipedia.org/wiki/Damascus">Damascus</a> of
<a href="http://en.wikipedia.org/wiki/Hellenistic_period">Hellenistic
times</a>, when he took a bet that he could produce a decent work
of philosophy, and wrote the Biblical scroll of
<a href="http://en.wikipedia.org/wiki/Ecclesiastes">Ecclesiastes</a>.
Soon after that, he became the most notorious celebrity in his town,
made a moderate fortune from donations of enthusiastic fans of the
scroll, and became annoyed by the fact that he has become the object of
affection of nearly every single young female in his town.
</p>
<p class="who_is_qoheleth abstract">
However, nothing could prepare Josephus to the day he ran into a trio of
female <a href="http://en.wikipedia.org/wiki/Celts">Celtic</a> travellers,
who provide him with many questions, including the million dollar question,
“Who is the Qoheleth (Now)?”.
</p>
<p>
This is an illustrated screenplay inspired by the
<a href="$(ROOT)/philosophy/SummerNSA/">#SummerNSA effort</a>
and set in a time of great confusion — not unlike our own.
</p>

EOF
        },
        {
            id         => 'terminator_liberation',
            tagline    => "Tell about the Exodus. And the more, the better.",
            logo_alt   => "“Terminator: Liberation” Logo",
            logo_class => "terminator_liberation",
            logo_id    => "terminator_liberation_logo",
            logo_src =>
                "humour/Terminator/Liberation/images/terminator_liberation.png",
            logo_svg =>
                "humour/Terminator/Liberation/images/terminator_liberation.svg",
            entry_id   => "terminator--liberation",
            entry_text => "Terminator: Liberation",
            href       => "humour/Terminator/Liberation/",
            abstract   => <<'EOF',
<p class="terminator_liberation abstract">
A self-referential parody of the <a
href="https://terminator.fandom.com/wiki/Terminator_(franchise)">Terminator
franchise</a>, with <a href="$(ROOT)/humour/bits/facts/Emma-Watson/">Emma
Watson</a> as herself and as the evil terminator Hanna, and with <a
href="https://en.wikipedia.org/wiki/Arnold_Schwarzenegger">Arnold
Schwarzenegger</a> as himself and as the good terminator Aharon, that takes place in
<a href="https://en.wikipedia.org/wiki/Tel_Aviv">Tel Aviv</a> during <a
href="https://en.wikipedia.org/wiki/Passover">Passover</a> (when <a
href="https://shlomif.fandom.com/wiki/Olamot_Con">Olamot Con</a> takes place).
</p>

EOF
        },
        {
            id => 'pope_died_on_sunday',
            tagline =>
                "And so starts what appears to be an ordinary week… or not!",
            logo_alt   => "“The Pope Died on Sunday” Logo",
            logo_class => "pope_died_on_sunday",
            logo_id    => "pope_died_on_sunday_logo",
            logo_src   => "humour/Pope/images/pope-logo-small.png",
            logo_svg   => 'humour/Pope/images/pope-logo.svg',
            entry_id   => "pope-died-on-sunday",
            entry_text => "The Pope Died on Sunday",
            href       => "humour/Pope/",
            abstract   => <<'EOF',
<p class="pope_died_on_sunday abstract">
Rachel Southern, an American graphic artist who lives and works in
<a href="https://en.wikipedia.org/wiki/Milwaukee">Milwaukee</a>, did not expect the week following the death of the Roman Catholic
Pope to be particularly notable for her, but boy was she wrong!
</p>

<p class="pope_died_on_sunday abstract">
From meeting a guy she really liked, to her best friend almost ruining a date
with him, to her family coming to visit, to helping organise a “fashion-play”,
to pondering the answer to the question of Life, the Universe, and
Everything — Rachel’s week proved to be one of the most hectic in her life.
</p>

<p class="pope_died_on_sunday abstract">
This story is still incomplete, and only a relatively small part of it has
been written.
</p>

EOF
        },
        {
            id         => 'blue_rabbit',
            tagline    => "TODO FILL IN",
            logo_alt   => "The Blue Rabbit Log Logo",
            logo_class => "blue_rabbit",
            logo_id    => "blue_rabbit_logo",
            logo_src =>
                "humour/Blue-Rabbit-Log/images/blue-rabbit-logo-small.png",
            logo_svg   => 'humour/Blue-Rabbit-Log/images/blue-rabbit-logo.svg',
            entry_id   => "blue-rabbit",
            entry_text => "The Blue Rabbit Log",
            href       => "humour/Blue-Rabbit-Log/",
            abstract   => <<'EOF',
<p>
Screenplays for a series of crazy comedy films parodying
<a href="http://en.wikipedia.org/wiki/Role-playing_game">Fantasy
Role-Playing Games</a>. Join the band of the player characters called “The
Blue Rabbit Adventuring Company”, as they journey in the imaginary role-playing
world, and their struggles and
encounters with monsters, the non-player characters, their players,
and... the Game Master! (Muahahahahaha).
</p>

<p>
Work in progress.
</p>
EOF
        },
        {
            id         => 'the_earth_angel',
            tagline    => "TODO FILL IN",
            logo_alt   => "The Earth Angel Logo",
            logo_class => "the_earth_angel",
            logo_id    => "the_earth_angel_logo",
            logo_src =>
                "humour/The-Earth-Angel/images/the-earth-angel-logo-small.png",
            logo_svg =>
                'humour/The-Earth-Angel/images/the-earth-angel-logo.svg',
            entry_id   => "the-earth-angel",
            entry_text => "The Earth Angel",
            href       => "humour/The-Earth-Angel/",
            abstract   => <<'EOF',
<p>
A novella titled “The Earth Angel” in which a colloquial Black man in 2013 Los
Angeles teaches a copyrights attorney all about life.
</p>

<p>
It seems that I found writing most of this redundant, due to
<i>Summerschool at the NSA</i> and later <i>Buffy: A Few Good Slayers</i>,
but I’m keeping what I have written so far of it for posterity in its
preliminary state.
</p>

EOF
        },
    )
);

my %_Stories_by_id = ( map { $_->id() => $_ } @_Stories );

sub _get_story
{
    my ( $self, $args ) = @_;

    my $id = $args->{id};

    return $_Stories_by_id{$id}
        || die "Unknown story '$id'";
}

sub get_tagline
{
    my ( $self, $id ) = @_;

    return $self->_get_story($id)->tagline;
}

sub _get_tagline_tags
{
    my ( $self, $id ) = @_;

    my $tag_id    = 'tagline';
    my $tag_title = $self->get_tagline($id);
    return [ qq#<h2 id="$tag_id">#, $tag_title, qq#</h2>\n#, ];
}

use Shlomif::Homepage::RelUrl qw/ _rel_url /;

sub _get_abstract_tags
{
    my ( $self, $id ) = @_;

    my $abstract = $self->_get_story($id)->abstract || die "No abstract";

    $abstract =~ s#"\$\(ROOT\)/([^"]+?)"#
                q{"}
                . _rel_url($1)
                . q{"}
        #eg;

    return [$abstract];
}

sub _get_logo_tags
{
    my ( $self, $id ) = @_;

    my $o = $self->_get_story($id);

    return [
        sprintf(
            qq#<img id="%s" src="%s" alt="%s" class="story_logo %s"/>\n#,
            $o->logo_id,
            escape_html( _rel_url( $o->logo_src =~ s/\.png\z/.webp/r ) ),
            $o->logo_alt, $o->logo_class,
        ),
    ];
}

sub _get_list_items_tags
{
    my ( $self, $id ) = @_;

    return [ @{ $self->_get_abstract_tags($id) }, ];
}

sub _get_common_top_elems
{
    my ( $self, $id ) = @_;
    my $ret = [
        @{ $self->_get_tagline_tags($id) },
        @{ $self->_get_logo_tags($id) },
        sprintf( qq#<div class="%s abstract">\n#,
            $self->_get_story($id)->logo_class ),
        qq#<h2 id="abstract">Abstract</h2>\n#,
        @{ $self->_get_abstract_tags($id) },
        qq{</div>\n},
    ];
    return $ret;
}

sub _get_story_entry_tags
{
    my ( $self, $args ) = @_;

    my $id  = $args->{id};
    my $tag = $args->{tag};

    my $o = $self->_get_story($args);

    return [
        qq{<section class="story">\n},
        qq{<header>\n},
        @{ $self->_get_logo_tags($args) },
        sprintf(
            qq{<%s class="story" id="%s"><a href="%s">%s</a></%s>\n},
            $tag,
            ( $o->entry_id || ( die "Foo $id" ) ),
            escape_html( _rel_url( $o->href || die "Qlax $id" ) ),
            ( $o->entry_text || die "Elimbda $id" ),
            $tag,
        ),
        qq{</header>\n},
        @{ $self->_get_list_items_tags($args) },
        $o->entry_extra_html(),
        qq{</section>\n}
    ];
}

sub _get_all_stories_entries_tags
{
    my ( $self, $tag ) = @_;

    return [
        map {
            @{
                $self->_get_story_entry_tags(
                    { id => $_->id(), tag => $tag->{tag}, }
                )
            }
        } @_Stories
    ];
}

sub calc_abstract
{
    my ( $self, $id ) = @_;

    return join( "", @{ $self->_get_abstract_tags($id) } );
}

sub calc_logo
{
    my ( $self, $id ) = @_;

    return join( '', @{ $self->_get_logo_tags($id) } );
}

sub calc_common_top_elems
{
    my ( $self, $id ) = @_;

    return join( '', @{ $self->_get_common_top_elems($id) }, );
}

sub calc_all_stories_entries
{
    my ( $self, $tag ) = @_;

    return join( '', @{ $self->_get_all_stories_entries_tags($tag) }, );
}

my %png_stories = (
    map { $_ => 1 }
        qw#
        muppets_show_tni
        selina_mandrake
        summerschool_at_the_nsa
        we_the_living_dead
        #
);

sub render_make_fragment
{
    my @var_decls;
    my @rules;
    my $deps = '';
    my $pngs = '';

    foreach my $s (@_Stories)
    {
        my $uc_id    = uc( $s->id );
        my $logo_src = $s->logo_src;
        my $logo_svg = $s->logo_svg;

        my $m_id = "${uc_id}__SMALL_LOGO_PNG";
        if ( $logo_src =~ /\.png\z/ )
        {
            if (1)    # if ( $uc_id !~ /WE_THE_LIVING_DEAD/ )
            {
                push @var_decls, "$m_id := \$(POST_DEST)/$logo_src\n";
            }
        }
        if ( $logo_svg ne '//$SKIP' )
        {
            push @rules,
"\$($m_id): \$(SRC_SRC_DIR)/$logo_svg\n\t\$(call EXPORT_INKSCAPE_PNG)\n\n"
                ,;

            $deps .= " \$($m_id)";
        }
        else
        {
            if ( not exists $png_stories{ $s->id } )
            {
                push @rules,
                    "\$($m_id): \$(SRC_SRC_DIR)/$logo_src\n\t\$(call COPY)\n\n"
                    ,;
            }
            $pngs .= " \$($m_id)";
        }
    }

    path("lib/make/long_stories.mak")->spew_utf8(
        @var_decls,
        "\n",
        @rules,
        "\n",
        "LONG_STORIES__SMALL_LOGO_PNGS := $deps $pngs\n\n",
"LONG_STORIES__SMALL_LOGO_WEBPS := \$(patsubst %.png,%.webp,\$(filter %.png,\$(LONG_STORIES__SMALL_LOGO_PNGS)))\n\n",
        "\$(LONG_STORIES__SMALL_LOGO_WEBPS): %.webp: %.png\n",
        "\tgm convert \$< \$\@\n\n",
"art_slogans_targets: \$(LONG_STORIES__SMALL_LOGO_PNGS) \$(LONG_STORIES__SMALL_LOGO_WEBPS)\n\n",
    );
}

1;
