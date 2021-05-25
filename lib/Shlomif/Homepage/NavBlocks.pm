package Shlomif::Homepage::NavBlocks;

use strict;
use warnings;
use utf8;

use Moo;

use Shlomif::Homepage::NavBlocks::LocalLink       ();
use Shlomif::Homepage::NavBlocks::GitHubLink      ();
use Shlomif::Homepage::NavBlocks::FacebookLink    ();
use Shlomif::Homepage::NavBlocks::ShlomifWikiLink ();

sub _l
{
    return Shlomif::Homepage::NavBlocks::LocalLink->new( {@_}, );
}

sub _fp
{
    return _l( inner_html => "Front Page", @_ );
}

sub _ontext
{
    return _l( inner_html => "Ongoing Text", @_ );
}

sub _github
{
    return Shlomif::Homepage::NavBlocks::GitHubLink->new( {@_} );
}

sub _sf_wiki
{
    return Shlomif::Homepage::NavBlocks::ShlomifWikiLink->new( {@_} );
}

sub _facebook
{
    return Shlomif::Homepage::NavBlocks::FacebookLink->new( {@_} );
}

use Shlomif::Homepage::NavBlocks::Tr         ();
use Shlomif::Homepage::NavBlocks::Subdiv_Tr  ();
use Shlomif::Homepage::NavBlocks::Master_Tr  ();
use Shlomif::Homepage::NavBlocks::TableBlock ();

sub _tr
{
    return Shlomif::Homepage::NavBlocks::Tr->new( {@_} );
}

my $EmmaWatson_tech_interview = _l(
    inner_html => "Emma Watson Interviewing for a software developer job",
    path       => "humour/bits/Emma-Watson-applying-for-a-software-dev-job/",
);
my $EmmaWatson_visit_to_Gaza = _l(
    inner_html => "Emma Watson visit to Israel and Gaza",
    path       => "humour/bits/Emma-Watson-Visit-to-Israel-and-Gaza/",
);

my $muppets_github =
    _github(
    url => 'http://github.com/shlomif/The-Muppets-Show--The-New-Incarnation', );

my %tr_s = (
    'buffy_facts' => _tr(
        title => "“Facts”",
        items => [
            _l(
                inner_html => "Buffy Facts",
                path       => "humour/bits/facts/Buffy/",
            ),
        ],
    ),
    'buffy_few_good' => _tr(
        title => "Buffy: A Few Good Slayers",
        items => [
            _fp( path => "humour/Buffy/A-Few-Good-Slayers/", ),
            _ontext(
                path => "humour/Buffy/A-Few-Good-Slayers/ongoing-text.html",
            ),
            _github(
                url => 'http://github.com/shlomif/Buffy-a-Few-Good-Slayers',
            ),
        ],
    ),
    'define_zionism' => _tr(
        title => "Define Zionism",
        items => [ _fp( path => "philosophy/politics/define-zionism/", ), ],
    ),
    'EmmaWatson_facts' => _tr(
        title => "“Facts”",
        items => [
            _l(
                inner_html => "Emma Watson Facts",
                path       => "humour/bits/facts/Emma-Watson/",
            ),
        ],
    ),
    'EmmaWatson_tech_job' => _tr(
        title => "EmmaWatson Tech Interview",
        items => [ $EmmaWatson_tech_interview, ],
    ),
    'EmmaWatson_visit_to_Gaza' => _tr(
        title => "EmmaWatson Visit to Israel &amp; Gaza",
        items => [ $EmmaWatson_visit_to_Gaza, ],
    ),
    'foss_bits' => _tr(
        title => "Ultra-short stories",
        items => [
            _l(
                inner_html => "GPL Not Compatible with Itself",
                path       => "humour/bits/GPL-is-not-Compatible-with-Itself/",
            ),
            _l( inner_html => "RMS Lint", path => "humour/bits/RMS-Lint/", ),
            _l(
                inner_html =>
"Ways to do it According to the Programming Languages of the World",
                path => "humour/ways_to_do_it.html",
            ),
            _l(
                inner_html => "Cracka’s Paradise",
                path       => "humour/bits/Crackas-Paradise/",
            ),
            _l(
                inner_html => "“Mastering cat”",
                path       => "humour/bits/Mastering-Cat/",
            ),
            _l(
                inner_html => "Programs Everyone Has Written",
                path => "humour/bits/Programs-Every-Programmer-has-Written/",
            ),
            _l(
                inner_html => "Freecell Solver™ Enterprise Edition",
                path       => "humour/bits/Freecell-Solver-Enterprise-Edition/",
            ),
            _l(
                inner_html => "COBOL — The New Age Programming Language",
                path => "humour/bits/COBOL-the-New-Age-Programming-Language/",
            ),
            _l(
                inner_html => "Copying Ubuntu Bug #1",
                path       => "humour/bits/Copying-Ubuntu-Bug-No-1/",
            ),
            _l(
                inner_html => "Announcing New Versions of the GPL",
                path       => "humour/bits/New-versions-of-the-GPL/",
            ),
            _l(
                inner_html =>
                    "The Atom text editor edits a 2,000,001 bytes file",
                path => "humour/bits/Atom-Text-Editor-edits-2_000_001-bytes/",
            ),
            _l(
                inner_html => "“HTML 6”, the new version of the Web",
                path       => "humour/bits/HTML-6/",
            ),
            _l(
                inner_html =>
                    "It’s not a Fooware - It’s an Operating System",
                path =>
                    "humour/bits/It-s-not-a-Fooware-It-s-an-Operating-System/",
            ),
            $EmmaWatson_tech_interview,
            _l(
                inner_html => "I'm the Real Tim Toady",
                path       => "humour/bits/Im-The-Real-Tim-Toady/",
            ),
            _l(
                inner_html => "“Can I SCO Now?”",
                path       => "humour/bits/Can-I-SCO-Now/",
            ),
            _l(
                inner_html => "Freecell Solver™ Goes Webscale",
                path       => "humour/bits/Freecell-Solver-Goes-Webscale/",
            ),
            _l(
                inner_html =>
                    "Freecell Solver Enterprises™ Acquires Google Inc.",
                path =>
"humour/bits/Freecell-Solver-Enterprises-Acquires-Google-Inc/",
            ),
            _l(
                inner_html => "New Israeli Tech Usergroups",
                path       => "humour/bits/New-Israeli-Tech-Usergroups/",
            ),
            _l(
                inner_html => "GNU Will Integrate GNU Guile into GNU coreutils",
                path       =>
"humour/bits/GNU-Project-Will-Integrate-Guile-into-coreutils/",
            ),
            _l(
                inner_html => "Announcing Python 4",
                path       => "humour/bits/Python4-Announcement/",
            ),
        ],
    ),
    'foss_facts' => _tr(
        title => "“Facts”",
        items => [
            _l(
                inner_html => "Chuck Norris Facts",
                path       => "humour/bits/facts/Chuck-Norris/",
            ),
            _l(
                inner_html => "“Knuth is not God”",
                path       => "humour/bits/facts/Knuth/",
            ),
            _l(
                inner_html => "Larry Wall Facts",
                path       => "humour/bits/facts/Larry-Wall/",
            ),
            _l( inner_html => "NSA Facts", path => "humour/bits/facts/NSA/", ),
            _l(
                inner_html => "Summer Glau Facts",
                path       => "humour/bits/facts/Summer-Glau/",
            ),
            _l(
                inner_html => "Taylor Swift Facts",
                path       => "humour/bits/facts/Taylor-Swift/",
            ),
            _l(
                inner_html => "Windows Update Facts",
                path       => "humour/bits/facts/Windows-Update/",
            ),
            _l(
                inner_html => "XSLT Facts",
                path       => "humour/bits/facts/XSLT/",
            ),
        ],
    ),
    'hhfg' => _tr(
        title => "Human Hacking Field Guide",
        items => [
            _fp( path => "humour/human-hacking/", ),
            _l(
                inner_html => "Conclusions and Reviews",
                path       => "humour/human-hacking/conclusions/",
            ),
            _github(
                url => 'http://github.com/shlomif/Human-Hacking-Field-Guide',
            ),
        ],
    ),
    'muppets_grammar_nazis' => _tr(
        title => "Muppets Fanfiction",
        items => [
            _l(
                inner_html => "Grammar Nazis",
                path       =>
                    "humour/Muppets-Show-TNI/Summer-Glau-and-Chuck-Norris.html",
            ),
            $muppets_github,
        ],
    ),
    'muppets_harry_potter' => _tr(
        title => "Muppets Fanfiction",
        items => [
            _l(
                inner_html => "Harry Potter on Sesame Street",
                path       => "humour/Muppets-Show-TNI/Harry-Potter.html",
            ),
            $muppets_github,
        ],
    ),
    'queen_padme_tales' => _tr(
        title => "Queen Padmé Tales",
        items => [
            _fp( path => "humour/Queen-Padme-Tales/", ),
            _l(
                inner_html => "Teaser",
                path       => "humour/Queen-Padme-Tales/teaser/",
                skip_bold  => 1,
            ),
            _l(
                inner_html => "vs. The Klingon Warriors",
                path       =>
"humour/Queen-Padme-Tales/Queen-Padme-Tales--Queen-Amidala-vs-the-Klingon-Warriors.html",
            ),
            _l(
                inner_html => "Planting Trees",
                path       =>
"humour/Queen-Padme-Tales/Queen-Padme-Tales--Planting-Trees.html",
            ),
            _l(
                inner_html => "Take It Over",
                path       =>
"humour/Queen-Padme-Tales/Queen-Padme-Tales--Take-It-Over.html",
            ),
            _l(
                inner_html => "Nighttime Flight",
                path       =>
"humour/Queen-Padme-Tales/Queen-Padme-Tales--Nighttime-Flight.html",
            ),
            _l(
                inner_html => "The Fifth Sith",
                path       =>
"humour/Queen-Padme-Tales/Queen-Padme-Tales--The-Fifth-Sith.html",
            ),
            _l(
                inner_html => "Proposed Cast",
                path       => "humour/Queen-Padme-Tales/cast.html",
            ),
            _github( url => 'https://github.com/shlomif/Queen-Padme-Tales', ),
        ],
    ),
    'selina_mandrake' => _tr(
        title => "Selina Mandrake - The Slayer",
        items => [
            _fp( path => "humour/Selina-Mandrake/", ),
            _ontext( path => "humour/Selina-Mandrake/ongoing-text.html", ),
            _l(
                inner_html => "Proposed Cast",
                path       => "humour/Selina-Mandrake/cast.html",
            ),
            _l(
                inner_html => "Image Macros",
                path       => "humour/Selina-Mandrake/image-macros/",
            ),
            _github( url => 'http://github.com/shlomif/Selina-Mandrake', ),
        ],
    ),
    'star_trek_wtld' => _tr(
        title => "Star Trek: We, the Living Dead",
        items => [
            _fp( path => "humour/Star-Trek/We-the-Living-Dead/", ),
            _ontext(
                path => "humour/Star-Trek/We-the-Living-Dead/ongoing-text.html",
            ),
            _github(
                url =>
                    'http://github.com/shlomif/Star-Trek--We-the-Living-Dead',
            ),
        ],
    ),
    'SummerNSA_effort' => _tr(
        title => "The “#SummerNSA” Effort",
        items => [
            _fp( path => "philosophy/SummerNSA/", ),
            _l(
                inner_html => "A #SummerNSA’s Reading",
                path       => "philosophy/SummerNSA/A-SummerNSA-Reading/",
            ),
            _l(
                inner_html => "Letter to Summer Glau",
                path       => "philosophy/SummerNSA/Letter-to-SGlau-2014-10/",
            ),
            _sf_wiki( url => 'http://shlomif.wikia.com/wiki/SummerNSA', ),
            _facebook( url => 'http://www.facebook.com/SummerNSA', ),
        ],
    ),
    'summer_nsa' => _tr(
        title => "Summerschool at the NSA",
        items => [
            _fp( path => "humour/Summerschool-at-the-NSA/", ),
            _ontext(
                path => "humour/Summerschool-at-the-NSA/ongoing-text.html",
            ),
            _l(
                inner_html => "Proposed Cast",
                path       => "humour/Summerschool-at-the-NSA/cast.html",
            ),
            _github(
                url => 'http://github.com/shlomif/Summerschool-at-the-NSA',
            ),
            _facebook( url => 'http://www.facebook.com/SummerNSA', ),
        ],
    ),
    'qoheleth' => _tr(
        title => "“So, who the Hell is Qoheleth?”",
        items => [
            _fp( path => "humour/So-Who-The-Hell-Is-Qoheleth/", ),
            _ontext(
                path => "humour/So-Who-The-Hell-Is-Qoheleth/ongoing-text.html",
            ),
            _github(
                url => 'https://github.com/shlomif/So-Who-the-Hell-Is-Qoheleth',
            ),
        ],
    ),
    'terminator_liberation' => _tr(
        title =>
"Terminator: Liberation - Starring Schwarzenegger &amp; Emma Watson",
        items => [
            _fp( path => "humour/Terminator/Liberation/", ),
            _ontext(
                path => "humour/Terminator/Liberation/ongoing-text.html",
            ),
            _l(
                inner_html => "Proposed Cast",
                path       => "humour/Terminator/Liberation/cast.html",
            ),
            _github(
                url => 'https://github.com/shlomif/Terminator-Liberation',
            ),
        ],
    ),
    'tow_fountainhead' => _tr(
        title => "The One with the Fountainhead",
        items => [
            _fp( path => "humour/TOneW-the-Fountainhead/", ),
            _l(
                inner_html => "Part 1",
                path => "humour/TOneW-the-Fountainhead/TOW_Fountainhead_1.html",
            ),
            _l(
                inner_html => "Part 2",
                path => "humour/TOneW-the-Fountainhead/TOW_Fountainhead_2.html",
            ),
        ],
    ),
    'the_enemy' => _tr(
        title => "The Enemy",
        items => [
            _fp( path => "humour/TheEnemy/", ),
            _ontext( path => "humour/TheEnemy/The-Enemy-English-v7.html", ),
            _github( url => 'http://github.com/shlomif/the-enemy', ),
        ],
    ),
    'xkcd_facts' => _tr(
        title => "“Facts”",
        items => [
            _l(
                inner_html => "Summer Glau Facts",
                path       => "humour/bits/facts/Summer-Glau/",
            ),
            _l( inner_html => "NSA Facts", path => "humour/bits/facts/NSA/" ),
        ],
    ),
    'commercial_fanfic_initiative__mission_stmt' => _tr(
        title => "Mission Statement",
        items => [
            _l(
                inner_html => "Screenplay Shortage Reduced Version",
                path       =>
"philosophy/culture/case-for-commercial-fan-fiction/screenplays-shortage-reduced-version.xhtml",
            ),
            _l(
                inner_html => "Document",
                path => "philosophy/culture/case-for-commercial-fan-fiction/",
            ),
            _github(
                url =>
'https://github.com/shlomif/shlomi-fish-homepage/blob/master/src/philosophy/culture/case-for-commercial-fan-fiction/index.xhtml.tt2',
            ),
        ],
    ),
);

sub _get_tr
{
    my ($id) = @_;
    return (
        $tr_s{$id} // do { Carp::confess "Unknown ID $id." }
    );
}

sub _master_tr
{
    return Shlomif::Homepage::NavBlocks::Master_Tr->new( {@_}, );
}

sub _subdiv_tr
{
    return Shlomif::Homepage::NavBlocks::Subdiv_Tr->new( {@_}, );
}

my %table_blocks = (
    'buffy' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id   => 'buffy_nav_block',
            tr_s => [
                _master_tr(
                    title =>
q{<a href="https://en.wikipedia.org/wiki/Buffy_the_Vampire_Slayer"><i>Buffy</i></a> Fanfiction},
                ),
                _subdiv_tr( title => q{Screenplays}, ),
                _get_tr('star_trek_wtld'),
                _get_tr('selina_mandrake'),
                _get_tr('summer_nsa'),
                _get_tr('buffy_few_good'),
                _get_tr('queen_padme_tales'),
                _subdiv_tr( title => q{Factoids}, ),
                _get_tr('buffy_facts'),
            ],
        },
    ),
    'friends_tv' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id   => 'friends_tv_nav_block',
            tr_s => [
                _master_tr(
                    title =>
q{<a href="https://en.wikipedia.org/wiki/Friends"><i>Friends</i></a> Fanfiction},
                ),
                _subdiv_tr( title => q{Screenplays}, ),
                _get_tr('tow_fountainhead'),
                _get_tr('hhfg'),
                _get_tr('qoheleth'),
            ],
        },
    ),
    'harry_potter' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id   => 'harry_potter_nav_block',
            tr_s => [
                _master_tr(
                    title =>
q{<a href="https://en.wikipedia.org/wiki/Wizarding_World">Harry Potter</a> / Emma Watson Fanfiction},
                ),
                _subdiv_tr( title => q{Screenplays}, ),
                _get_tr('selina_mandrake'),
                _get_tr('buffy_few_good'),
                _get_tr('muppets_harry_potter'),
                _get_tr('terminator_liberation'),
                _get_tr('EmmaWatson_tech_job'),
                _get_tr('EmmaWatson_visit_to_Gaza'),
                _subdiv_tr( title => q{Factoids}, ),
                _get_tr('EmmaWatson_facts'),
            ],
        },
    ),
    'foss' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id   => 'foss_nav_block',
            tr_s => [
                _master_tr( title => q{Open Source/Perl/etc. Fanfiction}, ),
                _subdiv_tr( title => q{Stories and Screenplays}, ),
                _get_tr('hhfg'),
                _get_tr('star_trek_wtld'),
                _subdiv_tr( title => q{Factoids}, ),
                _get_tr('foss_facts'),
                _subdiv_tr( title => q{Bits}, ),
                _get_tr('foss_bits'),
            ],
        },
    ),
    'politics' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id   => 'politics_nav_block',
            tr_s => [
                _master_tr( title => q{Political Essays and Fiction}, ),
                _subdiv_tr( title => q{Middle East Politics}, ),
                _get_tr('the_enemy'),
                _get_tr('define_zionism'),
                _get_tr('EmmaWatson_visit_to_Gaza'),
                _subdiv_tr( title => q{#SummerNSA} ),
                _get_tr('summer_nsa'),
                _get_tr('SummerNSA_effort'),
            ],
        },
    ),
    'star_trek' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id   => 'star_trek_nav_block',
            tr_s => [
                _master_tr(
                    title =>
q{<a href="https://en.wikipedia.org/wiki/Star_Trek"><i>Star Trek</i></a> Fanfiction},
                ),
                _subdiv_tr( title => q{Screenplays}, ),
                _get_tr('star_trek_wtld'),
                _get_tr('selina_mandrake'),
                _get_tr('queen_padme_tales'),
            ],
        },
    ),
    'xkcd' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id   => 'xkcd_nav_block',
            tr_s => [
                _master_tr(
                    title =>
q{Summer Glau / <a href="https://www.explainxkcd.com/"><i>xkcd</i></a> Fanfiction},
                ),
                _subdiv_tr( title => q{#SummerNSA} ),
                _get_tr('summer_nsa'),
                _get_tr('SummerNSA_effort'),
                _subdiv_tr( title => q{Other Screenplays}, ),
                _get_tr('muppets_grammar_nazis'),
                _subdiv_tr( title => q{Factoids}, ),
                _get_tr('xkcd_facts'),
            ],
        }
    ),
    'mlp_fim' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id   => 'mlp_fim_nav_block',
            tr_s => [
                _master_tr(
                    title =>
q{<a href="https://en.wikipedia.org/wiki/My_Little_Pony:_Friendship_Is_Magic"><i>My Little Pony</i></a> Fanfiction},
                ),
                _subdiv_tr( title => q{Screenplays}, ),
                _get_tr('terminator_liberation'),
                _get_tr('queen_padme_tales'),
            ],
        },
    ),
    'self_ref' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id   => 'self_ref_nav_block',
            tr_s => [
                _master_tr(
                    title =>
q{Self-Reference / <a href="https://en.wikipedia.org/wiki/G%C3%B6del,_Escher,_Bach"><i>Gödel, Escher, Bach</i></a> / <a href="https://en.wikipedia.org/wiki/Last_Action_Hero"><i>Last Action Hero</i></a>},
                ),
                _subdiv_tr( title => q{Screenplays}, ),
                _get_tr('buffy_few_good'),
                _get_tr('terminator_liberation'),
                _get_tr('queen_padme_tales'),
            ],
        },
    ),
    'commercial_fanfic_initiative' =>
        Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id   => 'commercial_fanfic_initiative_nav_block',
            tr_s => [
                _master_tr( title => q{The Commercial Fanfic Initiative}, ),
                _subdiv_tr( title => q{Essays}, ),
                _get_tr('commercial_fanfic_initiative__mission_stmt'),
                _subdiv_tr( title => q{Screenplays}, ),
                _get_tr('terminator_liberation'),
                _get_tr('queen_padme_tales'),
            ],
        },
        ),
);

sub get_nav_block
{
    my ( $self, $id ) = @_;

    return (
        $table_blocks{$id} // do { Carp::confess "Unknown ID $id." }
    );
}

sub list_nav_blocks
{
    my ( $self, ) = @_;

    return [ sort { $a cmp $b } keys(%table_blocks) ];
}

1;
