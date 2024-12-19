package Shlomif::Homepage::LongStories;

use strict;
use warnings;
use utf8;

use Moo;

use DateTime                           ();
use HTML::Acronyms                     ();
use Path::Tiny                         qw/ path /;
use HTML::Widgets::NavMenu::EscapeHtml qw( escape_html );
use YAML::XS                           ();

use Shlomif::Homepage::LongStories::Story ();

has 'fn' => ( is => 'rw', );

my $ACRONYMS_FN = "lib/acronyms/list1.yaml";
my $latemp_acroman =
    HTML::Acronyms->new( dict => scalar( YAML::XS::LoadFile($ACRONYMS_FN) ) );

my $BtVS = $latemp_acroman->abbr( { key => 'BtVS', link => 1, } )->{html};
my $RPF  = $latemp_acroman->abbr( { key => 'RPF',  link => 1, } )->{html};

my $FAN_FIC_PARA = <<"EOF";
<p>
Fanfic: parody, crossover, $RPF, self-reference.
</p>
EOF

sub _to_story_objects
{
    return ( map { Shlomif::Homepage::LongStories::Story->new($_) } @_ );
}

my $QOH_TITLE = "“So, who the Hell is Qoheleth?”";

sub qoh_title
{
    my ($self) = @_;

    return $QOH_TITLE;
}

my @active_Stories = _to_story_objects(
    {
        id         => 'the_enemy',
        tagline    => "I came; I saw; I left no trace",
        logo_alt   => "A = not-A",
        logo_src   => "humour/TheEnemy/images/The-Enemy-logo-small.png",
        logo_svg   => 'humour/TheEnemy/images/The-Enemy--Logo.svg',
        entry_id   => "enemy-how-i-helped",
        entry_text => "The Enemy and How I Helped to Fight it",
        start_date => DateTime->new( year => 1996, ),
        href       => "humour/TheEnemy/",
        abstract   => <<'EOF',
<p>
A member of the terrorist organisation “The Organisation” gets
up in the morning, goes to his post, and quits. But before he
leaves, he makes a suggestion that makes his former comrades
fight each other to death. Join the now ex‐Member of the
Organisation as he embarks on an ego trip, where he tries to
prove that A can in fact be not‐A, despite whatever reservations
Aristotle may have.
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
        id      => 'tow_the_fountainhead',
        tagline =>
"The Fountainhead may have been good enough in the 60’s, but we’re in the Information Age now",
        logo_alt   => "The One With The Fountainhead Logo",
        logo_class => "towtf",
        logo_src => "humour/TOneW-the-Fountainhead/images/towtf-logo-200px.jpg",
        logo_svg => '//$SKIP',
        start_date => DateTime->new( year => 1998, ),
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
Which element is featured in every second-class <b>romantic novel</b>?<br/>
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
        tagline    => "Intelligent (?) and Conscious (?) People",
        logo_alt   => "Humanity Logo",
        logo_src   => "humour/humanity/images/humanity-logo-small.png",
        logo_svg   => 'humour/humanity/images/humanity-logo.svg',
        entry_id   => "humanity",
        entry_text => "Humanity",
        href       => "humour/humanity/",
        start_date => DateTime->new( year => 2000, ),
        abstract   => <<'EOF',
<p class="humanity abstract">
<i>Humanity</i> is a screenplay for a movie
that aims to be a parody about humanity and modern life in particular. It
tells the story of a day in the life of a <a href="http://en.wikipedia.org/wiki/Semitic">Semitic</a> city in
<a href="http://en.wikipedia.org/wiki/Canaan">Canaan</a> circa the year
500 B.C. Each scene is dedicated to one of the city’s elements: The Cathedral
(OK - an altar with a priest), the Bazaar, the Well, the Wall, etc.
</p>

<p class="humanity abstract">
The original <a href="http://humanity.shlomifish.org/">Humanity project</a>, back in 2000 was my opening shot of the <a
href="$(ROOT)/me/resumes/Shlomi-Fish-Resume-as-Writer-Entertainer.html">the
open content / Web 2.0 revolution</a> aiming to be a "bazaar-style"
collaborative project for writing a screenplay. It failed due to the
clunky <a href="https://en.wikipedia.org/wiki/Concurrent_Versions_System">CVS</a> UI, but nowadays collaboratively written screenplays are
common - only using <a href="https://en.wikipedia.org/wiki/List_of_wiki_software">wiki
software</a>
or <a href="https://better-scm.shlomifish.org/docs/this-site-is-irrelevant/">git DVCS</a>
or similar.
</p>
EOF
    },
    {
        id       => 'hhfg',
        tagline  => "Who said girls can’t code?",
        logo_alt => "Human Hacking Field Guide Logo",
        logo_src => "humour/human-hacking/images/hhfg-logo-small.png",
        logo_svg =>
            'humour/human-hacking/images/human-hacking-field-guide-logo.svg',
        entry_id   => "human-hacking",
        entry_text => "The Human Hacking Field Guide",
        start_date => DateTime->new( year => 2004, ),
        href       => "humour/human-hacking/",
        abstract   => <<'EOF',
<p class="hhfg abstract">
Jennifer (loosely based on
<a href="https://buffy.fandom.com/wiki/Buffy_Summers">Buffy</a>
from $(BtVS))
is a trendy and popular high school senior who is living and
studying in the vicinity of Los Angeles. Her best friend, Taylor
(<a href="https://buffy.fandom.com/wiki/Alexander_Harris">Xander</a>), convinces her
to try to become a developer of open source software. He puts her
under the tutorship of a different friend of his, the female open source
contributor Eve (<a
href="https://buffy.fandom.com/wiki/Faith_Lehane">Faith</a>), who prefers
to be called “Erisa”, and who is a self-conscious
and rebelling punk, with whom Jennifer finds it hard to deal. Jennifer remains
determined to learn how to become an open source developer from Erisa, but
there are some surprises along the way.
</p>
EOF
    },
    {
        id      => 'we_the_living_dead',
        tagline => "From perfection to imperfection; from finity to infinity",

        logo_alt   => "Fiery Q",
        logo_src   => "humour/Star-Trek/We-the-Living-Dead/images/fiery-Q.png",
        logo_svg   => '//$SKIP',
        entry_id   => "we-the-living-dead",
        entry_text => "Star Trek: We the Living Dead",
        start_date => DateTime->new( year => 2007, ),
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
A Star Trek episode to end all Star Trek episodes, (and — more
generally - a story to end all stories).
</p>
EOF
    },
    {
        id         => 'selina_mandrake',
        tagline    => "Caught between Post-modernism and the New Age",
        logo_alt   => "1d10 die",
        logo_class => "selina",
        logo_src   => "humour/Selina-Mandrake/images/Green-d10-dice.png",
        logo_svg   => '//$SKIP',
        entry_id   => "selina-mandrake",
        entry_text => "Selina Mandrake - The Slayer (Buffy Parody)",
        start_date => DateTime->new( year => 2011, ),
        href       => "humour/Selina-Mandrake/",
        abstract   => <<'EOF',
<p class="selina abstract">
Selina Mandrake ( <a href="$(ROOT)/humour/bits/facts/Emma-Watson/">Emma Watson</a> )
was a geeky Anglo-American girl in her high school senior year in 2011
California, who thought that the show $(BtVS) was fictional.
However, one day she was approached by a mysterious goth man calling himself "The Guide"
( <a href="https://en.wikipedia.org/wiki/Wil_Wheaton">Wil Wheaton</a> )
who told her that she was none other than Buffy Mageia, <b>The Slayer</b>,
a legendary heroine who was destined to slay many notable vampires and demons,
culminating in none other than The Master, the vampire with the oldest
soul. See how she managed to do so, despite being completely non-violent, and
even supportive of the demons she encountered.
</p>
<p>
This is a parody of the television series
$(BtVS), while referencing other pieces of popular
culture, and has many ties to my previous screenplay,
<a href="$(ROOT)/humour/Star-Trek/We-the-Living-Dead/">Star Trek: “We, the
Living Dead”</a>. It’s far-fetched, but, on the other hand, conveys some
serious messages and insights.
</p>
EOF
        entry_extra_html => <<'EOF',
<p>
This screenplay, a parody and reflection on $(BtVS),
and inspired by many other sources, is in a mostly complete state.
</p>
EOF

    },
    {
        id       => 'summerschool_at_the_nsa',
        tagline  => "As the sling shoots, grown men will cry",
        logo_alt => "Summerschool at the NSA Logo",
        logo_id  => "summernsa_logo",
        logo_src =>
            "humour/Summerschool-at-the-NSA/images/summernsa-logo-small.png",
        logo_svg   => '//$SKIP',
        entry_id   => "summerschool-at-the-nsa",
        entry_text => "Summerschool at the NSA - A Screenplay",
        start_date => DateTime->new( month => 3, year => 2013, ),
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
<p class="summernsa abstract">
This screenplay is surrealistic realism and takes place in April 2013. It is
far-fetched, but could actually happen.
</p>
EOF
    },
    {
        id      => 'buffy_a_few_good_slayers',
        tagline =>
            "I learned more from my students than I have from my teachers.",
        logo_alt   => "Buffy - a Few Good Slayers Logo",
        logo_class => "buffy_few_good",
        logo_src   =>
'humour/Buffy/A-Few-Good-Slayers/images/Buffy-A-Few-Good-Slayers-Logo--take1.min.svg',
        logo_svg =>
'humour/Buffy/A-Few-Good-Slayers/images/Buffy-A-Few-Good-Slayers-Logo--take1.svg',
        entry_id   => "buffy-few-good",
        entry_text => "Buffy: a Few Good Slayers",
        start_date => DateTime->new( year => 2014, ),
        href       => "humour/Buffy/A-Few-Good-Slayers/",
        abstract   => <<'EOF',
<p class="buffy_few_good abstract">
The Demonic underworld is held under tight control in a forked version of the
<a href="https://en.wikipedia.org/wiki/Buffyverse">Buffy universe</a> where
the <a href="http://buffy.wikia.com/wiki/Scooby_Gang">Scooby Gang</a> all
ended up happier and more powerful, and men and women have equal opportunities
when it comes to fighting Demons. A new class of tenth grade (sophomore)
students start the three year demon-fighting program in the scholastic year of
2014/2015 in Sunnydale High School, while the older Scooby Gang, who are their
teachers and mentors, have to deal with the usual set of problems that come
with being teachers, parents, spouses and adults.
</p>
EOF
    },
    {
        id         => 'muppets_show_tni',
        tagline    => "We’d love to learn more about you.",
        logo_alt   => "The Muppet Show TNI",
        logo_src   => "humour/Muppets-Show-TNI/images/muppets-200w.png",
        logo_svg   => '//$SKIP',
        entry_id   => "muppets-show-TNI",
        entry_text => "Muppets / Sesame Street Fanfic",
        start_date => DateTime->new( year => 2014, ),
        href       => "humour/Muppets-Show-TNI/",
        abstract   => <<'EOF',
<p class="muppets_show_tni abstract">
Fanfic episodes of <a href="http://muppet.wikia.com/wiki/The_Muppet_Show"><b>The
Muppet show</b></a> or <a href="https://muppet.fandom.com/wiki/Sesame_Street">Sesame Street</a>.
Each show will cover a <b>theme</b> such
as <a href="$(ROOT)/humour/Muppets-Show-TNI/Harry-Potter.html">Harry Potter</a>, or
<a href="$(ROOT)/humour/bits/facts/Summer-Glau/">Summer Glau</a> &amp;
<a href="$(ROOT)/humour/bits/facts/Chuck-Norris/">Chuck Norris</a> as
two ruthless <a href="$(ROOT)/humour/Muppets-Show-TNI/Summer-Glau-and-Chuck-Norris.html">Grammar Nazis</a>.
</p>
EOF
    },
    {
        id      => 'who_is_qoheleth',
        tagline =>
"What had been, is what will be. There is nothing new under the sun.",
        logo_alt   => "$QOH_TITLE Logo",
        logo_class => "who_is_qoheleth",
        logo_src   =>
"humour/So-Who-The-Hell-Is-Qoheleth/images/who-is-qoheleth-small.png",
        logo_svg =>
            'humour/So-Who-The-Hell-Is-Qoheleth/images/who-is-qoheleth.svg',
        entry_id   => "who-is-qoheleth",
        entry_text => $QOH_TITLE,
        start_date => DateTime->new( year => 2014, ),
        href       => "humour/So-Who-The-Hell-Is-Qoheleth/",
        abstract   => <<'EOF',
<p class="who_is_qoheleth abstract">
Josephus was a budding philosopher of Jewish descent in
<a href="https://en.wikipedia.org/wiki/Damascus">Damascus</a> of
<a href="http://en.wikipedia.org/wiki/Hellenistic_period">Hellenistic
times</a>, when he took a bet that he could produce a decent work
of philosophy, and wrote the Biblical scroll of
<a href="http://en.wikipedia.org/wiki/Ecclesiastes">Ecclesiastes (Qoheleth)</a>.
Soon after that, he became the most notorious celebrity in his town,
made a moderate fortune from donations of enthusiastic fans of the
scroll, and became annoyed by the fact that he has become the object of
affection of nearly every unmarried young female in Damascus.
</p>

<p class="who_is_qoheleth abstract">
However, nothing could prepare Josephus to the day he ran into a trio of
female <a href="http://en.wikipedia.org/wiki/Celts">Celtic</a> travellers,
who provide him with many questions, including the million dollar question,
“Who is the Qoheleth (Now)?”.
</p>

<p class="who_is_qoheleth abstract">
This is an illustrated screenplay inspired by the
<a href="$(ROOT)/philosophy/SummerNSA/">#SummerNSA effort</a>
and set in a time of great confusion — not unlike our own — while containing
some <a href="https://en.wikipedia.org/wiki/Anachronism">anachronisms</a>.
</p>
EOF
    },
    {
        id => 'terminator_liberation',

        # tagline    => "Tell about the Exodus. And the more, the better.",
        tagline    => "“Hasta la vista, baby tank girl!”",
        logo_alt   => "“Terminator: Liberation” Logo",
        logo_class => "terminator_liberation",
        logo_src   =>
            "humour/Terminator/Liberation/images/terminator_liberation.png",
        logo_svg =>
            "humour/Terminator/Liberation/images/terminator_liberation.svg",
        entry_id   => "terminator--liberation",
        entry_text => "Terminator: Liberation",
        start_date => DateTime->new( year => 2019, ),
        href       => "humour/Terminator/Liberation/",
        abstract   => <<'EOF',
<div class="terminator_liberation abstract">

<blockquote cite="https://www.shlomifish.org/humour/fortunes/show.cgi?id=shlomif-fact-emma-watson-11" class="fancy">

<p>
It might seem preposterous to believe Emma Watson is the new Arnold
Schwarzenegger just because they were both Hollywood's best paid actors and you
would be right. Emma Watson is not the new Arnold Schwarzenegger.
</p>

<p>
But Arnold Schwarzenegger will forever be remembered as the old EMMA FUCKIN'
WATSON!
</p>

</blockquote>

<p>
( <a href="$(ROOT)/philosophy/culture/case-for-commercial-fan-fiction/#bad_acting_emma_watson">Reference and Midrash.</a> )
</p>

<p>
A self-referential and illustrated parody of the <a
href="https://terminator.fandom.com/wiki/Terminator_(franchise)">Terminator
franchise</a>, with <a href="$(ROOT)/humour/bits/facts/Emma-Watson/">Emma
Watson</a> as herself and her cosplayer, <a href="https://www.facebook.com/hannah.saunders.1213">Hannah</a>,
as the evil terminator,
and with <a
href="https://en.wikipedia.org/wiki/Arnold_Schwarzenegger">Arnold
Schwarzenegger</a> as himself and a cosplayer of his, Aharon, as the good terminator.
Takes place in
<a href="https://en.wikipedia.org/wiki/Tel_Aviv">Tel Aviv</a> during <a
href="https://en.wikipedia.org/wiki/Passover">Passover</a> and <a
href="https://shlomif.fandom.com/wiki/Olamot_Con">Olamot Con</a>.
</p>
</div>

EOF
    },
    {
        id       => 'queen_padme_tales',
        tagline  => "Why can’t we have them all?",
        logo_alt => "“Queen Padmé Tales” logo",
        logo_src =>
            "humour/Queen-Padme-Tales/images/queen_padme_tales_logo.png",
        logo_svg   => '//$SKIP',
        logo_title =>
qq#The Tacos are a reference to the “Porque no los dos” Taco commercial ; their many toppings allude to the general pluralism/crossover theme#,
        entry_id   => "queen--padme--tales",
        entry_text =>
            "Queen Padmé Tales (Star Wars / Star Trek / Real Life Crossover)",
        should_skip_abstract_h_tag => 1,
        start_date => DateTime->new( month => 12, year => 2020, ),
        href       => "humour/Queen-Padme-Tales/",
        abstract   => <<'EOF',
<div class="queen_padme_tales abstract">

<section>

<header>
<h2 id="objective">Objective</h2>
</header>

<p>
This ambitious series of screenplays breaks a long-time taboo against writing
<i>Star Wars</i> and <i>Star Trek</i> crossovers, but also aims to make
the case for commercial yet free/open (<a href="https://creativecommons.org/">Creative Commons</a>
/ etc.) fan fiction / crossovers / real person fiction
(see e.g: <a href="$(ROOT)/philosophy/culture/case-for-commercial-fan-fiction/">Our
mission statement</a>)
and screenplays written in easier to write formats than the
draconian, finicky, and boring, Hollywood-blessed format.
</p>
</section>

<section>

<header>
<h2 id="queen_padme_tales__abstract">Abstract</h2>
</header>

<p>
While the birth parents of
<a href="https://en.wikipedia.org/wiki/Padm%C3%A9_Amidala">Queen Padmé Amidala</a>
of the Naboo of <a href="https://buffyfanfiction.fandom.com/wiki/Selinaverse">the Selinaverse</a>
(<a href="https://en.wikipedia.org/wiki/Tiffany_Alvord">Tiffany Alvord</a> , b. 1992)
were killed in a starship crash when she was 1 years old, she was adopted by her aunt,
the Duchess Elizabeth Amidala (<a href="https://en.wikipedia.org/wiki/Natalie_Portman_filmography">Natalie
Portman</a>), and her aunt's husband,
<a href="https://en.wikipedia.org/wiki/Darth_Vader">Darth Vader</a>, who
volunteered to act as King-in-effect until Padmé's coming-of-age. As a result,
Padmé had a happy childhood until she turned 18 at 2010 and was ready to become
the bona fide monarch of Naboo.
</p>

<p>
Padmé already learned a lot about managing a planet country by volunteering
to help Vader, and he encouraged her to do so. On the surface, she is happy:
</p>

<ul>

<li>
<p>
She is the richest person in Naboo and one of the richest women in the galaxy.
</p>
</li>

<li>
<p>
She has enough free time to contribute on Internet content and code sharing sites.
</p>
</li>

<li>
<p>
She has many supporting friends, including her boyfriend, Anakin Skywalker
(<a href="https://www.youtube.com/jakecoco/about">Jake Coco</a>),
a promising jedi-wannabe, who is about her age, and with aspirations
for joining the mysterious but revered jedi order of Siths, of which only Vader
and <a href="https://starwars.fandom.com/wiki/Darth_Sidious">Emperor Palpatine</a>
are the known extant members.
</p>
</li>

</ul>

<p>
In practice, though, there is <a href="https://en.wikipedia.org/wiki/Damocles">the Sword of Damocles</a>:
</p>

<ul>

<li>
<p>
Critics on online publications and social media who are unhappy with every
choice she makes.
</p>
</li>

<li>
<p>
A poorly-executed takeover attempt of the Naboo crown, by a “real life”
celebrity (<a href="[% base_path %]humour/bits/facts/Emma-Watson/">Emma
Watson</a>) thought to be flawless.
</p>
</li>

<li>
<p>
Her boyfriend being so busy with his studies, that he becomes awfully laconic
even in his emails.
</p>
</li>

<li>
<p>
Her spirit friends, who are animated characters from
<a href="https://mlp.fandom.com/wiki/My_Little_Pony_Friendship_is_Magic_Wiki"><i>My Little Pony: Friendship Is Magic</i></a>
and other fantastical universes, who appear at the seemingly least desirable
moments, and whom everyone can see, hear, photograph, and record, but whom many
people believe are some kind of trick.
</p>
</li>

<li>
<p>
And her biggest pet peeve: her positive bank balance which keeps getting
larger, despite her many attempts to reduce it.
</p>
</li>

</ul>

</section>

</div>

EOF
    },
    {
        id         => 'the_10th_muse',
        tagline    => "“We’re a progressive pantheon after all”",
        logo_alt   => "“The 10th Muse” logo",
        logo_src   => 'humour/The-10th-Muse/images/the-10th-muse-logo.png',
        logo_svg   => 'humour/The-10th-Muse/images/the-10th-muse-logo.svg',
        entry_id   => "The-10th-Muse",
        entry_text => "The 10th Muse",
        start_date => DateTime->new( month => 2, year => 2022, ),
        href       => "humour/The-10th-Muse/",
        abstract   => <<"EOF",
<p>
The <a href="https://en.wikipedia.org/wiki/Twelve_Olympians">Greek Pantheon</a> of ~2022 AD decides it is high time to hire a 10th muse,
in charge of the interactive arts. Thus, it hires Arielle (<a href="https://en.wikipedia.org/wiki/Regina_King">Regina King</a>,
e.g.: in <a href="https://en.wikipedia.org/wiki/Jerry_Maguire">Jerry Maguire</a>),
an Afro-American woman, who is happy to be among the first Black
hires in a whites-dominated Pantheon. (<a href="\$(ROOT)/philosophy/philosophy/putting-all-cards-on-the-table-2013/indiv-nodes/seize_opportunities.xhtml">Reference</a>.)
</p>

<p>
Other planned episodes:
</p>

<ol>

<li>
<p>
Athena takes a bet with Dionysus that she will remain under control after
getting drunk, and <a href="\$(ROOT)/humour/The-10th-Muse/The-10th-Muse--Athena-Gets-Laid.html">loses more than just the bet</a>…
</p>
</li>

<li>
<p>
Hera was convinced to seduce Zeus, and they both hate the new situation because
it voids all the excitement.
</p>
</li>

<li>
<p>
An annual <a href="\$(ROOT)/humour/The-10th-Muse/The-10th-Muse--Trojan-War-Reenactment.html">reenactment of The Trojan War</a>, with <a href="https://en.wikipedia.org/wiki/Achilles">Achilles</a>
getting killed using a <a href="https://en.wikipedia.org/wiki/Bazooka">bazooka</a>,
and the Trojan horse being a Trojan pony shaped
like <a href="https://mlp.fandom.com/wiki/Princess_Celestia">Princess Celestia</a>.
</p>
</li>

</ol>

$FAN_FIC_PARA
EOF
    },
    {
        id         => 'All-in-an-Atypical-Day-Work',
        tagline    => "Love is Evil, and Evil is Love",
        logo_alt   => "Evil Reindeer",
        logo_class => "selina",
        logo_src   => "me/rindolf/images/evil-reindeer-200w.png",
        logo_svg   => '//$SKIP',
        entry_id   => "All-in-an-Atypical-Day-Work",
        entry_text => "All in an Atypical Day’s Work",
        start_date => DateTime->new( day => 20, month => 3, year => 2023, ),
        href       => "humour/All-in-an-Atypical-Day-Work/",
        abstract   => <<"EOF",
<p class="abstract">
<a href="\$(ROOT)/me/rindolf/">Rindolf “Aim Very High” Hitlower</a>, the
Norwegian EvilReindeer, is threatening to turn Christmas into EvilChristmas,
by having stolen all the Christmas' presents and the Chanukkah coins.
His twin brothers, Rudolph Hitlower and Randolph Hitlower,
Santa Claus’ right-hoof reindeer, recruit the elite commando unit,
<a href="https://hero.fandom.com/wiki/Mane_Six">the Mane Six</a>,
and together go to the Selinaverse's Norway to try to prevent that.
</p>

$FAN_FIC_PARA
EOF
        entry_extra_html => <<'EOF',
EOF
    },
    {
        id         => 'How-to-Play-Strip-Dungeons-and-Dragons',
        tagline    => "“Are you a god?”",
        logo_alt   => "A set of role-playing games dice",
        logo_class => "selina",
        logo_src   => "me/rindolf/images/rpg-dice-set--on-nuc--thumb.webp",
        logo_svg   => '//$SKIP',
        entry_id   => "How-to-Play-Strip-Dungeons-and-Dragons",
        entry_text => "How to Play Strip Dungeons-and-Dragons",
        start_date => DateTime->new( day => 19, month => 10, year => 2024, ),
        href       => "humour/How-to-Play-Strip-Dungeons-and-Dragons/",
        abstract   => <<"EOF",
<p class="abstract">
<a href="\$(ROOT)/humour/bits/facts/Emma-Watson/">Emma Watson</a>,
<a href="https://en.wikipedia.org/wiki/Mr._T">Mr. T</a>,
<a href="https://en.wikipedia.org/wiki/Tiffany_Alvord">Tiffany Alvord</a>,
and Shlomi Fish (= me), are trying to play a striptease version of the
tabletop role-playing game.
</p>

$FAN_FIC_PARA
EOF
        entry_extra_html => <<'EOF',
EOF
    },
    {
        id      => 'He-Damsel-in-Distress-and-a-Distressing-Damsel',
        tagline =>
"“If I cannot have 100% of his time, soul, mind, love, and knowledge…”",
        logo_alt   => "TODO",
        logo_class => "hedamsel",
        logo_src   => "humour/images/captioned-image--moral-gps-600.webp",
        logo_svg   => '//$SKIP',
        entry_id   => "He-Damsel-in-Distress-and-a-Distressing-Damsel",
        entry_text => "He-Damsel-in-Distress and a Distressing Damsel",
        start_date => DateTime->new( day => 18, month => 5, year => 2024, ),
        href       => "humour/He-Damsel-in-Distress-and-a-Distressing-Damsel/",
        abstract   => <<"EOF",
<p class="abstract">
In a parallel universe, Tiffany Alvord’s territorial jealousy of Shlomi Fish (=
me), seemed bound to have a far-reaching effect on the multiverse’s integrity.
But luckily the Foundation For Fantastecha™n Functional Fidelity (= “FFFFF” or
“quintuple-F”) has intervened.
</p>

$FAN_FIC_PARA
EOF
        entry_extra_html => <<'EOF',
EOF
    },
);

my @inactive_Stories = _to_story_objects(
    {
        id      => 'pope_died_on_sunday',
        tagline =>
            "And so starts what appears to be an ordinary week… or not!",
        logo_alt   => "“The Pope Died on Sunday” Logo",
        logo_src   => "humour/Pope/images/pope-logo-small.png",
        logo_svg   => 'humour/Pope/images/pope-logo.svg',
        entry_id   => "pope-died-on-sunday",
        entry_text => "The Pope Died on Sunday",
        start_date => DateTime->new( month => 12, year => 2000, ),
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
        id       => 'blue_rabbit',
        tagline  => "TODO FILL IN",
        logo_alt => "The Blue Rabbit Log Logo",
        logo_src => "humour/Blue-Rabbit-Log/images/blue-rabbit-logo-small.png",
        logo_svg => 'humour/Blue-Rabbit-Log/images/blue-rabbit-logo.svg',
        entry_id => "blue-rabbit",
        entry_text => "The Blue Rabbit Log",
        start_date => DateTime->new( year => 2009, ),
        href       => "humour/Blue-Rabbit-Log/",
        abstract   => <<'EOF',
<p>
Screenplays for an (incomplete) series of crazy comedy films parodying Fantasy
<a href="http://en.wikipedia.org/wiki/Tabletop_role-playing_game">Tabletop
Role-Playing Games</a> (FRPs or RPGs). Join the band of the player characters
called “The Blue Rabbit Adventuring Company”, as they journey in the imaginary
role-playing world, and their struggles and encounters with monsters, the
non-player characters, their players, and… the Game Master! (Muahahahahaha).
</p>

<p>
Included here are the beginning of the screenplay of the first part and some
disorganised ideas for the continuation.
</p>
EOF
    },
    {
        id       => 'the_earth_angel',
        tagline  => "TODO FILL IN",
        logo_alt => "The Earth Angel Logo",
        logo_src =>
            "humour/The-Earth-Angel/images/the-earth-angel-logo-small.png",
        logo_svg   => 'humour/The-Earth-Angel/images/the-earth-angel-logo.svg',
        entry_id   => "the-earth-angel",
        entry_text => "The Earth Angel",
        start_date => DateTime->new( month => 4, year => 2013, ),
        href       => "humour/The-Earth-Angel/",
        abstract   => <<"EOF",
<p>
A novella titled “The Earth Angel” in which a colloquial Black man in 2013 Los
Angeles teaches a copyrights attorney all about life.
</p>

<p>
It seems that I found writing most of this redundant, due to
<a href="\$(ROOT)/humour/Summerschool-at-the-NSA/"><i>Summerschool at the NSA</i></a>
and later <a href="\$(ROOT)/humour/Buffy/A-Few-Good-Slayers/"><i>Buffy: A Few Good Slayers</i></a>,
but I’m keeping what I have written so far of it for posterity in its
preliminary state.
</p>

EOF
    },
    {
        id         => 'road_to_heaven',
        tagline    => "TODO FILL IN",
        logo_alt   => "The Road to Heaven Logo",
        logo_src   => "humour/RoadToHeaven/images/r2h-logo-small.png",
        logo_svg   => 'humour/RoadToHeaven/images/r2h-logo.svg',
        entry_id   => "road_to_heaven",
        entry_text => "The Road to Heaven is Paved with Bad Intentions",
        start_date => DateTime->new( year => 2002, ),
        href       => "humour/RoadToHeaven/",
        abstract   => <<'EOF',
<p>
The story “The Road to Heaven is Paved with Bad Intentions” - a proposed sequel
to <a href="$(ROOT)/humour/TheEnemy/">“The Enemy and How I Helped
to Fight it”</a>. The ex-Member of the Organisation
travels back in time in order to prevent World War II.
</p>
EOF
    },
    {
        id         => 'usr-bin-perl',
        tagline    => "TODO FILL IN",
        logo_alt   => "#!/usr/bin/perl Logo",
        logo_src   => "humour/usr-bin-perl/images/usr-bin-perl-logo-small.png",
        logo_svg   => 'humour/usr-bin-perl/images/usr-bin-perl-logo.svg',
        entry_id   => "usr-bin-perl",
        entry_text => "#!/usr/bin/perl",
        start_date => DateTime->new( year => 2002, ),
        href       => "humour/usr-bin-perl/",
        abstract   => <<'EOF',
<p>
Screenplays for an (incomplete) series of sitcoms about a web-development shop.
</p>

<p>
Included here are the beginning of the screenplay of the first part and some
disorganised ideas for the continuation.
</p>
EOF
    },
    {
        id       => 'cookie_monster__the_slayer',
        tagline  => "Me wanna be “Rosh Gadol” about it.",
        logo_alt => "“Cookie Monster - The Slayer” logo",
        logo_src =>
"humour/Cookie-Monster--The-Slayer/images/cookie_monster__the_slayer.png",
        logo_svg =>
"humour/Cookie-Monster--The-Slayer/images/cookie_monster__the_slayer.svg",
        entry_id   => "cookie-monster--the-slayer",
        entry_text => "Cookie Monster - The Slayer",
        start_date => DateTime->new( day => 14, month => 6, year => 2021, ),
        href       => "humour/Cookie-Monster--The-Slayer/",
        abstract   => <<"EOF",
<p>
A parody of my <a href="\$(ROOT)/humour/Selina-Mandrake/"><i>Selina Mandrake - The Slayer</i></a>,
which is itself a parody of \$(BtVS); starring Cookie Monster and Emma Watson.
Shelved for now given I am wilfully ignorant of baking and cooking in general.
</p>
EOF
    },
);

my @_Stories       = ( @active_Stories, @inactive_Stories );
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
    my ( $self, $args ) = @_;

    return $self->_get_story($args)->tagline;
}

sub _get_tagline_tags
{
    my ( $self, $args ) = @_;

    my $tag_elem  = 'p';
    my $tag_id    = 'tagline';
    my $tag_title = $self->get_tagline($args);
    return [ qq#<${tag_elem} id="$tag_id">#, $tag_title, qq#</${tag_elem}>\n#,
    ];
}

sub _url_to
{
    my $self = shift;

    return $self->fn->get_relative_url( shift, 1 );
}

sub _get_should_skip_abstract_h_tag
{
    my ( $self, $args ) = @_;

    my $abstract = $self->_get_story($args)->should_skip_abstract_h_tag();

    return $abstract;
}

sub _get_abstract_tags
{
    my ( $self, $args ) = @_;

    my $abstract =
           $args->{abstract_text}
        || $self->_get_story($args)->abstract
        || die "No abstract for id=<$args->{id}>";
    return [ $self->_process_html($abstract) ];
}

sub _process_html
{
    my ( $self, $html_code ) = @_;

    $html_code =~
        s#"(?: (?: \$\(ROOT\) / ) | (?: \[\% \s* base_path \s* \%\]))([^"]+?)"#
        q{"} . $self->_url_to($1) . q{"}
    #egx;

    $html_code =~ s#\$\(BtVS\)#$BtVS#g;

    return $html_code;
}

sub _get_logo_tags
{
    my ( $self, $args ) = @_;

    my $o = $self->_get_story($args);

    return [
        sprintf(
            qq#<img id="%s" src="%s" alt="%s" class="story_logo%s"%s/>\n#,
            $o->logo_id,
            escape_html( $self->_url_to( $o->logo_src =~ s/\.png\z/.webp/r ) ),
            $o->logo_alt,
            $o->calc_logo_class,
            (
                $o->logo_title
                ? ( " title=\"" . escape_html( $o->logo_title() ) . "\"" )
                : ''
            ),
        )
    ];
}

sub _get_list_items_tags
{
    my ( $self, $args ) = @_;

    return [ @{ $self->_get_abstract_tags($args) }, ];
}

sub _get_common_top_elems
{
    my ( $self, $args ) = @_;
    my $story = $self->_get_story($args);
    my $ret   = [
        @{ $self->_get_tagline_tags($args) },
        @{ $self->_get_logo_tags($args) },
        sprintf( qq#<section class="abstract%s">\n#, $story->calc_logo_class ),
        sprintf(
            qq#<header><h2%s>Abstract</h2></header>\n#,
            scalar(
                $self->_get_should_skip_abstract_h_tag($args)
                ? ""
                : sprintf( qq# id="%s__abstract"#, $story->id(), )
            ),
        ),
        @{ $self->_get_abstract_tags($args) },
        qq{</section>\n},
    ];
    return $ret;
}

sub _get_story_entry_tags
{
    my ( $self, $args ) = @_;

    my $id                = $args->{id};
    my $paragraph_tagline = $args->{paragraph_tagline};
    my $tag               = $args->{tag};

    my $o = $self->_get_story($args);

    return [
        qq{<article class="story">\n},
        qq{<header>\n},
        @{ $self->_get_logo_tags($args) },
        sprintf(
qq{<%s class="story" id="%s"><a href="%s">%s</a> (<span class="start_date">%s</span>)</%s>\n},
            $tag,
            ( $o->entry_id || ( die "no entry_id for $id" ) ),
            escape_html(
                $self->_url_to( $o->href || ( die "no href for $id" ) )
            ),
            ( $o->entry_text || ( die "no entry_text for $id" ) ),
            ( $o->start_date->year() || ( die "no start_date for $id" ) ),
            $tag,
        ),
        qq{</header>\n},
        (
            $paragraph_tagline
            ? ( qq{<p class="tagline">}
                    . escape_html( $o->tagline() )
                    . qq{</p>} )
            : ()
        ),
        @{ $self->_get_list_items_tags($args) },
        $self->_process_html( $o->entry_extra_html() ),
        qq{</article>\n},
    ];
}

sub _get_all_stories_entries_tags
{
    my ( $self, $args ) = @_;

    return [
        map {
            @{
                $self->_get_story_entry_tags(
                    {
                        id                => $_->id(),
                        paragraph_tagline => $args->{paragraph_tagline},
                        tag               => $args->{tag},
                    }
                )
            }
        } (
            map { $_ ? @inactive_Stories : @active_Stories; }
                @{ $args->{only_inactives} // [ 0, 1 ] }
        )
    ];
}

sub calc_abstract
{
    my $self = shift;

    return join( "", @{ $self->_get_abstract_tags(@_) } );
}

sub calc_logo
{
    my ( $self, $args ) = @_;

    return join( '', @{ $self->_get_logo_tags($args) } );
}

sub calc_common_top_elems
{
    my ( $self, $args ) = @_;

    return join( '', @{ $self->_get_common_top_elems($args) }, );
}

sub calc_all_stories_entries
{
    my ( $self, $args ) = @_;

    if ( not $args->{only_inactives} )
    {
        my $tag = $args->{tag};
        return $self->calc_all_stories_entries(
            { only_inactives => [0], %$args, } )
            . qq#<section><header><$tag><a href="@{[$self->_url_to("humour/stories/inactive/")]}">Inactive Stories</a></$tag></header>#
            . $self->calc_all_stories_entries(
            {
                only_inactives => [1],
                %$args, tag => ( $tag =~ s#(h)([0-9]+)#$1 . ($2 + 1)#er )
            }
            ) . "</section>";
    }
    return join( '', @{ $self->_get_all_stories_entries_tags($args) }, );
}

my %png_stories = (
    map { $_ => 1 }
        qw#
        All-in-an-Atypical-Day-Work
        muppets_show_tni
        queen_padme_tales
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
    my %processed_srcs;

    foreach my $s (@_Stories)
    {
        my $id       = $s->id;
        my $uc_id    = uc($id);
        my $logo_src = $s->logo_src;
        my $logo_svg = $s->logo_svg;

        my $m_id = "${uc_id}__SMALL_LOGO_PNG";
        if ( $logo_src =~ /\.png\z/ )
        {
            push @var_decls, "$m_id := \$(POST_DEST)/$logo_src\n";
        }
        if ( $logo_svg ne '//$SKIP' )
        {
            push @rules,
"\$($m_id): \$(SRC_SRC_DIR)/$logo_svg\n\t\$(call EXPORT_INKSCAPE_PNG)\n"
                ,;

            $deps .= " \$($m_id)";
        }
        else
        {
            if ( not $processed_srcs{$logo_src}++ )
            {
                if ( not exists $png_stories{$id} )
                {
                    push @rules,
"\$($m_id): \$(SRC_SRC_DIR)/$logo_src\n\t\$(call COPY)\n"
                        ,;
                }
                $pngs .= " \$($m_id)";
            }
        }
    }

    path("lib/make/generated/long_stories.mak")->spew_utf8(
        @var_decls,
        "\n",
        @rules,
        "\n",
        "LONG_STORIES__SMALL_LOGO_PNGS := $deps $pngs\n",
"LONG_STORIES__SMALL_LOGO_WEBPS := \$(patsubst %.png,%.webp,\$(filter %.png,\$(LONG_STORIES__SMALL_LOGO_PNGS)))\n",
        "\$(LONG_STORIES__SMALL_LOGO_WEBPS): %.webp: %.png\n",
        "\tgm convert \$< \$\@\n",
"art_slogans_targets: \$(LONG_STORIES__SMALL_LOGO_PNGS) \$(LONG_STORIES__SMALL_LOGO_WEBPS)\n",
    );

    return;
}

1;
