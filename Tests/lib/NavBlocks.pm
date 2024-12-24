package NavBlocks;

use strict;
use warnings;
use utf8;
use Carp ();

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

my $Emma_Watson_tech_interview = _l(
    inner_html => "Emma Watson Interviewing for a software developer job",
    path       => "humour/bits/Emma-Watson-applying-for-a-software-dev-job/",
);
my $Emma_Watson_visit_to_Gaza = _l(
    inner_html => "Emma Watson visit to Israel and Gaza",
    path       => "humour/bits/Emma-Watson-Visit-to-Israel-and-Gaza/",
);

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
    'Emma_Watson_facts' => _tr(
        title => "“Facts”",
        items => [
            _l(
                inner_html => "Emma Watson Facts",
                path       => "humour/bits/facts/Emma-Watson/",
            ),
        ],
    ),
    'Emma_Watson_tech_job' => _tr(
        title => "Emma Watson Tech Interview",
        items => [ $Emma_Watson_tech_interview, ],
    ),
    'Emma_Watson_visit_to_Gaza' => _tr(
        title => "Emma Watson Visit to Israel &amp; Gaza",
        items => [ $Emma_Watson_visit_to_Gaza, ],
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
                inner_html =>
                    "It’s not a Fooware - It’s an Operating System",
                path =>
                    "humour/bits/It-s-not-a-Fooware-It-s-an-Operating-System/",
            ),
            $Emma_Watson_tech_interview,
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
                inner_html => "Larry Wall Facts",
                path       => "humour/bits/facts/Larry-Wall/",
            ),
            _l(
                inner_html => "“Knuth is not God”",
                path       => "humour/bits/facts/Knuth/",
            ),
            _l( inner_html => "NSA Facts", path => "humour/bits/facts/NSA/", ),
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
    'muppets_harry_potter' => _tr(
        title => "The Muppet Show - The Next Incarnation",
        items => [
            _fp( path => "humour/Muppets-Show-TNI/Harry-Potter.html", ),
            _github(
                url =>
'http://github.com/shlomif/The-Muppets-Show--The-New-Incarnation',
            ),
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
            _github( url => 'http://github.com/shlomif/Selina-Mandrake', ),
        ],
    ),
    'star_trek_wtld' => _tr(
        title => "Star Trek: “We, the Living Dead”",
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
    'the_enemy' => _tr(
        title => "The Enemy",
        items => [
            _fp( path => "humour/TheEnemy/", ),
            _ontext( path => "humour/TheEnemy/The-Enemy-English-v7.html", ),
            _github( url => 'https://github.com/shlomif/the-enemy', ),
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
            id         => 'buffy_nav_block',
            text_title => 'dummy',
            tr_s       => [
                _master_tr( title => q{Buffy Fanfiction}, ),
                _subdiv_tr( title => q{Screenplays}, ),
                _get_tr('star_trek_wtld'),
                _get_tr('selina_mandrake'),
                _get_tr('summer_nsa'),
                _get_tr('buffy_few_good'),
                _subdiv_tr( title => q{Factoids}, ),
                _get_tr('buffy_facts'),
            ],
        },
    ),
    'harry_potter' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'harry_potter_nav_block',
            text_title => 'dummy',
            tr_s       => [
                _master_tr( title => q{Harry Potter/Emma Watson Fanfiction}, ),
                _subdiv_tr( title => q{Screenplays}, ),
                _get_tr('selina_mandrake'),
                _get_tr('buffy_few_good'),
                _get_tr('muppets_harry_potter'),
                _get_tr('Emma_Watson_tech_job'),
                _get_tr('Emma_Watson_visit_to_Gaza'),
                _subdiv_tr( title => q{Factoids}, ),
                _get_tr('Emma_Watson_facts'),
            ],
        },
    ),
    'foss' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'foss_nav_block',
            text_title => 'dummy',
            tr_s       => [
                _master_tr( title => q{Open Source/Perl/etc. Fanfiction}, ),
                _subdiv_tr( title => q{Screenplays}, ),
                _get_tr('hhfg'),
                _subdiv_tr( title => q{Factoids}, ),
                _get_tr('foss_facts'),
                _subdiv_tr( title => q{Bits}, ),
                _get_tr('foss_bits'),
            ],
        },
    ),
    'politics' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'politics_nav_block',
            text_title => 'dummy',
            tr_s       => [
                _master_tr( title => q{Political Essays and Fiction}, ),
                _subdiv_tr( title => q{Middle East Politics}, ),
                _get_tr('the_enemy'),
                _get_tr('define_zionism'),
                _get_tr('Emma_Watson_visit_to_Gaza'),
                _subdiv_tr( title => q{#SummerNSA} ),
                _get_tr('summer_nsa'),
                _get_tr('SummerNSA_effort'),
            ],
        },
    ),
    'star_trek' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'star_trek_nav_block',
            text_title => 'dummy',
            tr_s       => [
                _master_tr( title => q{Star Trek Fanfiction}, ),
                _subdiv_tr( title => q{Screenplays}, ),
                _get_tr('star_trek_wtld'),
                _get_tr('selina_mandrake'),
            ],
        },
    ),
    'xkcd' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'xkcd_nav_block',
            text_title => 'dummy',
            tr_s       => [
                _master_tr( title => q{Summer Glau/xkcd Fanfiction}, ),
                _subdiv_tr( title => q{Screenplays}, ),
                _get_tr('summer_nsa'),
                _subdiv_tr( title => q{Factoids}, ),
                _get_tr('xkcd_facts'),
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

1;
