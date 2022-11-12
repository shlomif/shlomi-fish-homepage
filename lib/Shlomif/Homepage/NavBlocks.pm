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

my $Emma_Watson_tech_interview = _l(
    inner_html => "Emma Watson Interviewing for a software developer job",
    path       => "humour/bits/Emma-Watson-applying-for-a-software-dev-job/",
);
my $Emma_Watson_visit_to_Gaza = _l(
    inner_html => "Emma Watson visit to Israel and Gaza",
    path       => "humour/bits/Emma-Watson-Visit-to-Israel-and-Gaza/",
);

my $muppets_github =
    _github(
    url => 'http://github.com/shlomif/The-Muppets-Show--The-New-Incarnation', );

sub _gen__queen_padme_tales__tr
{
    my $self  = shift;
    my $args  = shift;
    my $regex = $args->{path_regex};

    return _tr(
        title => "Queen Padmé Tales",
        items => [
            _fp( path => "humour/Queen-Padme-Tales/", ),
            (
                grep { $_->path() =~ $regex } _l(
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
            ),
            _github( url => 'https://github.com/shlomif/Queen-Padme-Tales', ),
        ],
    );
}

sub _gen__the_10th_muse__tr
{
    my $self  = shift;
    my $args  = shift;
    my $regex = $args->{path_regex};

    return _tr(
        title => "The 10th Muse",
        items => [
            _fp( path => "humour/The-10th-Muse/", ),
            (
                grep { $_->path() =~ $regex } (
                    _l(
                        inner_html => "Athena Gets Laid",
                        path       =>
"humour/The-10th-Muse/The-10th-Muse--Athena-Gets-Laid.html",
                    ),
                    _l(
                        inner_html => "Trojan War Reenactment",
                        path       =>
"humour/The-10th-Muse/The-10th-Muse--Trojan-War-Reenactment.html",
                    ),
                )
            ),
            _github(
                url => 'https://github.com/shlomif/Queen-Padme-Tales',
            ),
        ],
    );
}

sub _gen__who_will_ride_princess_celestia__tr
{
    my $self  = shift;
    my $args  = shift;
    my $regex = $args->{path_regex};

    return _tr(
        title => "Who will ride Princess Celestia next?",
        items => [
            _fp( path => "humour/bits/Who-will-ride-Princess-Celestia/", ),
            ( grep { $_->path() =~ $regex } () ),
            _github(
                url => 'https://github.com/shlomif/shlomi-fish-homepage',
            ),
        ],
    );
}

sub _commercial_fanfic_initiative__mission_stmt
{
    my ($explicit) = @_;

    return _tr(
        title => (
            $explicit
            ? "The Commercial Fan-fiction Initiative"
            : "Mission Statement"
        ),
        items => [
            _l(
                inner_html => "Document",
                path => "philosophy/culture/case-for-commercial-fan-fiction/",
            ),
            _github(
                url =>
'https://github.com/shlomif/shlomi-fish-homepage/blob/master/src/philosophy/culture/case-for-commercial-fan-fiction/index.xhtml.tt2',
            ),
        ],
    );
}

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
    'card_games_bits' => _tr(
        title => "Ultra-short stories",
        items => [
            _l(
                inner_html => "Freecell Solver™ Enterprise Edition",
                path       => "humour/bits/Freecell-Solver-Enterprise-Edition/",
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
                inner_html => "Who will ride Princess Celestia next?",
                path       => "humour/bits/Who-will-ride-Princess-Celestia/",
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
    'card_games_essays' => _tr(
        title => "Essays",
        items => [
            _l(
                inner_html =>
                    "“What Makes Software High Quality?” - Revision 2",
                path => "philosophy/computers/high-quality-software/rev2/",
            ),
            _l(
                inner_html => "Optimising Code for Speed",
                path       => "philosophy/computers/optimizing-code-for-speed/",
            ),
            _l(
                inner_html => "FOSS Licences Wars (Revision 2)",
                path       =>
                    "philosophy/computers/open-source/foss-licences-wars/rev2/",
            ),
        ],
    ),
    'chuck_norris_essays' => _tr(
        title => "Essays",
        items => [
            _l(
                inner_html => "Putting All Cards on the Table (2013)",
                path       =>
"philosophy/philosophy/putting-all-cards-on-the-table-2013/",
            ),
            _l(
                inner_html => "Putting Cards on the Table (2019-*)",
                path       =>
"philosophy/philosophy/putting-cards-on-the-table-2019-2020/",
            ),
        ],
    ),
    'chuck_norris_facts' => _tr(
        title => "“Facts”",
        items => [
            _l(
                inner_html => "Chuck Norris Facts",
                path       => "humour/bits/facts/Chuck-Norris/",
            ),
            _l(
                inner_html => "Summer Glau Facts",
                path       => "humour/bits/facts/Summer-Glau/",
            ),
        ],
    ),
    'foss_bits' => _tr(
        title => "Ultra-short stories",
        items => [
            _l(
                inner_html =>
"Ways to do it According to the Programming Languages of the World",
                path => "humour/ways_to_do_it.html",
            ),
            _l(
                inner_html => "GPL Not Compatible with Itself",
                path       => "humour/bits/GPL-is-not-Compatible-with-Itself/",
            ),
            _l(
                inner_html => "RMS Lint",
                path       => "humour/bits/RMS-Lint/",
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
            _l(
                inner_html => "I'm the Real Tim Toady",
                path       => "humour/bits/Im-The-Real-Tim-Toady/",
            ),
            _l(
                inner_html => "“Can I SCO Now?”",
                path       => "humour/bits/Can-I-SCO-Now/",
            ),
            _l(
                inner_html => "Freecell Solver™ Enterprise Edition",
                path       => "humour/bits/Freecell-Solver-Enterprise-Edition/",
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
                inner_html => "Announcing New Versions of the GPL",
                path       => "humour/bits/New-versions-of-the-GPL/",
            ),
            $Emma_Watson_tech_interview,
            _l(
                inner_html => "“HTML 6”, the new version of the Web",
                path       => "humour/bits/HTML-6/",
            ),
            _l(
                inner_html =>
                    "The Atom text editor edits a 2,000,001 bytes file",
                path => "humour/bits/Atom-Text-Editor-edits-2_000_001-bytes/",
            ),
            _l(
                inner_html => "Announcing Python 4",
                path       => "humour/bits/Python4-Announcement/",
            ),
        ],
    ),
    'foss_essays' => _tr(
        title => "Essays",
        items => [
            _l(
                inner_html => "Open Source, Free Software, and Other Beasts",
                path       => "philosophy/foss-other-beasts/",
            ),
            _l(
                inner_html => "How to start contributing to FOSS",
                path       =>
"philosophy/computers/open-source/how-to-start-contributing/tos-document.html",
            ),
            _l(
                inner_html => "FOSS Licences Wars (Revision 2)",
                path       =>
                    "philosophy/computers/open-source/foss-licences-wars/rev2/",
            ),
            _l(
                inner_html => "Why I Do Not Trust non-FOSS",
                path => "philosophy/computers/open-source/not-trust-non-FOSS/",
            ),
            _l(
                inner_html =>
                    "“What Makes Software High Quality?” - Revision 2",
                path => "philosophy/computers/high-quality-software/rev2/",
            ),
            _l(
                inner_html => "Optimising Code for Speed",
                path       => "philosophy/computers/optimizing-code-for-speed/",
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
            _l(
                inner_html => "NSA Facts",
                path       => "humour/bits/facts/NSA/",
            ),
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
    'muppets_tiffany_alvord' => _tr(
        title => "Muppets Fanfiction",
        items => [
            _l(
                inner_html => "Tiffany Alvord on The Muppets",
                path       => "humour/Muppets-Show-TNI/Tiffany-Alvord.html",
            ),
            $muppets_github,
        ],
    ),
    'queen_padme_tales' => __PACKAGE__->_gen__queen_padme_tales__tr(
        {
            path_regex => qr/./ms,
        }
    ),
    'queen_padme_tales__emwatson' => __PACKAGE__->_gen__queen_padme_tales__tr(
        {
            path_regex => qr#(?:teaser|Take-It-Over)#ms,
        }
    ),
    'queen_padme_tales__natalie_portman' =>
        __PACKAGE__->_gen__queen_padme_tales__tr(
        {
            path_regex => qr#(?:teaser|vs-the-Klingon-Warriors)#ms,
        }
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
    'software_dirs' => _tr(
        title => "Software Directories",
        items => [
            _l(
                path       => "open-source/portability-libs/",
                inner_html => "Portability Libraries",
            ),
            _l(
                path       => "open-source/resources/software-tools/",
                inner_html => "Software Building and Management Tools",
            ),
            _l(
                path       => "open-source/resources/editors-and-IDEs/",
                inner_html => "Editors and IDEs",
            ),
            _l(
                path       => "open-source/resources/numerical-software/",
                inner_html => "Numerical Software",
            ),
            _l(
                path       => "open-source/resources/text-processing-tools/",
                inner_html => "Text Processing Tools",
            ),
            _l(
                path       => "open-source/resources/networking-clients/",
                inner_html => "Networking Clients",
            ),
            _l(
                path       => "open-source/resources/multimedia-programs/",
                inner_html => "List of Multimedia Applications",
            ),
            _l(
                path       => "open-source/resources/graphics-programs/",
                inner_html => "List of Computer Graphics Applications",
            ),
            _l(
                path       => "open-source/resources/databases-list/",
                inner_html => "List of Database Implementations",
            ),
            _l(
                path => "open-source/resources/software-quality-enhancement/",
                inner_html => "List of Software quality-enhancement tools",
            ),
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
            _l(
                inner_html => "Image Macros",
                path => "humour/So-Who-The-Hell-Is-Qoheleth/image-macros/",
            ),
            _github(
                url => 'https://github.com/shlomif/So-Who-the-Hell-Is-Qoheleth',
            ),
        ],
    ),
    'terminator_liberation' => _tr(
        title =>
"Terminator: Liberation - Starring Arnold Schwarzenegger &amp; Emma Watson",
        items => [
            _fp( path => "humour/Terminator/Liberation/", ),
            _ontext(
                path => "humour/Terminator/Liberation/ongoing-text.html",
            ),
            _l(
                inner_html => "Proposed Cast",
                path       => "humour/Terminator/Liberation/cast.html",
            ),
            _l(
                inner_html => "Image Macros",
                path       => "humour/Terminator/Liberation/image-macros/",
            ),
            _github(
                url => 'https://github.com/shlomif/Terminator-Liberation',
            ),
        ],
    ),
    'the_10th_muse__wil_wheaton' => __PACKAGE__->_gen__the_10th_muse__tr(
        {
            path_regex => qr#(?:Athena-Gets-Laid | Trojan )#imsx,
        }
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
            _github(
                url => 'https://github.com/shlomif/TOW-Fountainhead',
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
    'taylor_swift_essays' => _tr(
        title => "Essays",
        items => [
            _l(
                inner_html =>
                    "Why Openly Bipolar People Should Not Be Medicated",
                path =>
"philosophy/psychology/why-openly-bipolar-people-should-not-be-medicated/",
            ),
            _l(
                inner_html =>
                    "Why I will continue to write my real person fan fiction",
                path => "philosophy/culture/my-real-person-fan-fiction/",
            ),
            _l(
                inner_html => "Putting Cards on the Table (2019-*)",
                path       =>
"philosophy/philosophy/putting-cards-on-the-table-2019-2020/",
            ),
        ],
    ),
    'taylor_swift_facts' => _tr(
        title => "“Facts”",
        items => [
            _l(
                inner_html => "Taylor Swift Facts",
                path       => "humour/bits/facts/Taylor-Swift/",
            ),
        ],
    ),
    'who_will_ride_princess_celestia' =>
        __PACKAGE__->_gen__who_will_ride_princess_celestia__tr(
        {
            path_regex => qr/./ms,
        }
        ),
    'xkcd_facts' => _tr(
        title => "“Facts”",
        items => [
            _l(
                inner_html => "Summer Glau Facts",
                path       => "humour/bits/facts/Summer-Glau/",
            ),
            _l(
                inner_html => "NSA Facts",
                path       => "humour/bits/facts/NSA/"
            ),
        ],
    ),
    'commercial_fanfic_initiative__mission_stmt' =>
        scalar( _commercial_fanfic_initiative__mission_stmt(0) ),
    'commercial_fanfic_initiative__mission_stmt__w_explicit_title' =>
        scalar( _commercial_fanfic_initiative__mission_stmt(1) ),
    'foss_fortunes' => _tr(
        title => "Fortune Cookies (Quotes)",
        items => [
            _l(
                inner_html => "Main Page",
                path       => "humour/fortunes/",
            ),
            _l(
                inner_html => "##programming",
                path       => "humour/fortunes/sharp-programming.html",
            ),
            _l(
                inner_html => "#perl",
                path       => "humour/fortunes/sharp-perl.html",
            ),
            _l(
                inner_html => "Joel on Software",
                path       => "humour/fortunes/joel-on-software.html",
            ),
            _l(
                inner_html => "Paul Graham",
                path       => "humour/fortunes/paul-graham.html",
            ),
            _l(
                inner_html => "Subversion folklore",
                path       => "humour/fortunes/subversion.html",
            ),
            _l(
                inner_html => "Israeli FOSS folklore",
                path       => "humour/fortunes/tinic.html",
            ),
            _github(
                url =>
"https://github.com/shlomif/shlomi-fish-homepage/tree/master/src/humour/fortunes",
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

sub _tr_s
{
    return ( map { _get_tr($_) } @_ );
}

sub _master_tr
{
    return Shlomif::Homepage::NavBlocks::Master_Tr->new( {@_}, );
}

sub _subdiv_tr
{
    return Shlomif::Homepage::NavBlocks::Subdiv_Tr->new( {@_}, );
}

my $Essays_TR      = _subdiv_tr( title => q{Essays}, );
my $Factoids_TR    = _subdiv_tr( title => q{Factoids}, );
my $Screenplays_TR = _subdiv_tr( title => q{Screenplays}, );

my %table_blocks = (
    'buffy' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'buffy_nav_block',
            text_title => "Buffy",
            tr_s       => [
                _master_tr(
                    title =>
q{<a href="https://en.wikipedia.org/wiki/Buffy_the_Vampire_Slayer"><i>Buffy</i></a> Fanfiction},
                ),
                $Screenplays_TR,
                _tr_s(
                    qw( star_trek_wtld selina_mandrake summer_nsa buffy_few_good queen_padme_tales ),
                ),
                $Factoids_TR,
                _get_tr('buffy_facts'),
            ],
        },
    ),
    'card_games' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'card_games_nav_block',
            text_title => "Card Games ( e.g: Freecell ) - referencing works",
            tr_s       => [
                _master_tr(
                    title =>
                        q{Card Games ( e.g: Freecell ) - referencing works},
                ),

                # do { Carp::confess("freecell TODO"); },
                $Essays_TR,
                _tr_s( qw( card_games_essays ), ),
                _subdiv_tr( title => q{Bits}, ),
                _get_tr('card_games_bits'),
            ],
        },
    ),
    'chuck_norris' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'chuck_norris_nav_block',
            text_title => "Chuck Norris Fanfiction and Essays",
            tr_s       => [
                _master_tr(
                    title => q{Chuck Norris Fanfiction and Essays},
                ),
                $Factoids_TR,
                _get_tr('chuck_norris_facts'),
                $Screenplays_TR,
                _tr_s( 'muppets_grammar_nazis', 'buffy_few_good', ),
                $Essays_TR,
                _get_tr('chuck_norris_essays'),
                _get_tr(
'commercial_fanfic_initiative__mission_stmt__w_explicit_title'
                ),
            ],
        }
    ),
    'friends_tv' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'friends_tv_nav_block',
            text_title => "Friends (Television Series)",
            tr_s       => [
                _master_tr(
                    title =>
q{<a href="https://en.wikipedia.org/wiki/Friends"><i>Friends</i></a> Fanfiction},
                ),
                $Screenplays_TR,
                _tr_s( qw( tow_fountainhead hhfg qoheleth ), ),
            ],
        },
    ),
    'harry_potter' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'harry_potter_nav_block',
            text_title => "Harry Potter / Emma Watson Fanfiction",
            tr_s       => [
                _master_tr(
                    title =>
q{<a href="https://en.wikipedia.org/wiki/Wizarding_World">Harry Potter</a> / <a href="https://en.wikipedia.org/wiki/Emma_Watson">Emma Watson</a> Fanfiction},
                ),
                $Screenplays_TR,
                _tr_s(
                    qw( selina_mandrake buffy_few_good muppets_harry_potter terminator_liberation queen_padme_tales__emwatson Emma_Watson_tech_job Emma_Watson_visit_to_Gaza ),
                ),
                $Factoids_TR,
                _get_tr('Emma_Watson_facts'),
                $Essays_TR,
                _get_tr(
'commercial_fanfic_initiative__mission_stmt__w_explicit_title'
                ),
            ],
        },
    ),
    'foss' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'foss_nav_block',
            text_title => "Free & Open Source Software (FOSS)",
            tr_s       => [
                _master_tr(
                    title =>
q{Open Source / <a href="https://perl-begin.org/">Perl</a> / etc. Fanfiction and Essays},
                ),
                _subdiv_tr( title => q{Stories and Screenplays}, ),
                _tr_s( qw( hhfg star_trek_wtld ), ),
                $Factoids_TR,
                _get_tr('foss_facts'),
                _subdiv_tr( title => q{Bits}, ),
                _get_tr('foss_bits'),
                _subdiv_tr( title => q{Quotes}, ),
                _get_tr('foss_fortunes'),
                $Essays_TR,
                _get_tr('foss_essays'),
            ],
        },
    ),
    'politics' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'politics_nav_block',
            text_title => "Politics",
            tr_s       => [
                _master_tr( title => q{Political Essays and Fiction}, ),
                _subdiv_tr( title => q{Middle East Politics}, ),
                _tr_s(
                    qw( the_enemy define_zionism Emma_Watson_visit_to_Gaza ),
                ),
                _subdiv_tr( title => q{#SummerNSA} ),
                _tr_s( qw( summer_nsa SummerNSA_effort ), ),
            ],
        },
    ),
    'star_trek' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'star_trek_nav_block',
            text_title => "Star Trek Fanfiction",
            tr_s       => [
                _master_tr(
                    title =>
q{<a href="https://en.wikipedia.org/wiki/Star_Trek"><i>Star Trek</i></a> Fanfiction},
                ),
                $Screenplays_TR,
                _tr_s(
                    qw( star_trek_wtld selina_mandrake queen_padme_tales ),
                ),
            ],
        },
    ),
    'taylor_swift' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'taylor_swift_nav_block',
            text_title => "Taylor Swift",
            tr_s       => [
                _master_tr(
                    title =>
q{<a href="https://en.wikipedia.org/wiki/Taylor_Swift">Taylor Swift</a>-referencing Fanfiction and Essays},
                ),
                $Essays_TR,
                _get_tr('taylor_swift_essays'),
                $Factoids_TR,
                _get_tr('taylor_swift_facts'),
            ],
        }
    ),
    'xkcd' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'xkcd_nav_block',
            text_title => "Summer Glau/xkcd Fanfiction",
            tr_s       => [
                _master_tr(
                    title =>
q{<a href="https://en.wikipedia.org/wiki/Summer_Glau">Summer Glau</a> / <a href="https://www.explainxkcd.com/"><i>xkcd</i></a> Fanfiction},
                ),
                _subdiv_tr( title => q{#SummerNSA} ),
                _tr_s( qw( summer_nsa SummerNSA_effort ), ),
                _subdiv_tr( title => q{Other Screenplays}, ),
                _get_tr('muppets_grammar_nazis'),
                $Factoids_TR,
                _get_tr('xkcd_facts'),
            ],
        }
    ),
    'mlp_fim' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'mlp_fim_nav_block',
            text_title => "My Little Pony (FiM) Fanfiction",
            tr_s       => [
                _master_tr(
                    title =>
q{<a href="https://en.wikipedia.org/wiki/My_Little_Pony:_Friendship_Is_Magic"><i>My Little Pony</i></a> Fanfiction},
                ),
                $Screenplays_TR,
                _tr_s(
                    qw( terminator_liberation queen_padme_tales
                        who_will_ride_princess_celestia
                    ),
                ),
            ],
        },
    ),
    'self_ref' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'self_ref_nav_block',
            text_title =>
                "Self-Reference/Gödel, Escher, Bach/Last Action Hero",
            tr_s => [
                _master_tr(
                    title =>
q{<a href="https://www.shlomifish.org/philosophy/culture/multiverse-cosmology/#self-ref">Self-Reference</a> / <a href="https://en.wikipedia.org/wiki/G%C3%B6del,_Escher,_Bach"><i>Gödel, Escher, Bach</i></a> / <a href="https://en.wikipedia.org/wiki/Last_Action_Hero"><i>Last Action Hero</i></a>},
                ),
                $Screenplays_TR,
                _tr_s(
                    qw( buffy_few_good terminator_liberation queen_padme_tales ),
                ),
            ],
        },
    ),
    'software_resources' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'software_resources_nav_block',
            text_title => "Software Resources",
            tr_s       => [
                _master_tr(
                    title => "Software Resources",
                ),
                _subdiv_tr( title => q{Directories}, ),
                _get_tr('software_dirs'),
            ],
        },
    ),
    'commercial_fanfic_initiative' =>
        Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'commercial_fanfic_initiative_nav_block',
            text_title => "The Commercial Fan-fiction Initiative",
            tr_s       => [
                _master_tr(
                    title => q{The Commercial Fan-fiction Initiative},
                ),
                $Essays_TR,
                _get_tr('commercial_fanfic_initiative__mission_stmt'),
                _tr(
                    title => "[Precursor]",
                    items => [
                        _l(
                            inner_html =>
"Why I will continue to write my real person fan fiction",
                            path =>
"philosophy/culture/my-real-person-fan-fiction/",
                        ),
                    ],
                ),
                $Screenplays_TR,
                _tr_s( qw( terminator_liberation queen_padme_tales ), ),
            ],
        },
        ),
    'natalie_portman' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'natalie_portman_nav_block',
            text_title => "Natalie Portman Fanfiction",
            tr_s       => [
                _master_tr(
                    title =>
q{<a href="https://en.wikipedia.org/wiki/Natalie_Portman">Natalie Portman</a> Fanfiction},
                ),
                $Screenplays_TR,
                _tr_s(
                    qw(  buffy_few_good queen_padme_tales__natalie_portman ),
                ),
                $Essays_TR,
                _get_tr(
'commercial_fanfic_initiative__mission_stmt__w_explicit_title'
                ),
            ],
        },
    ),
    'wil_wheaton' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'wil_wheaton_nav_block',
            text_title => "Wil Wheaton Fanfiction",
            tr_s       => [
                _master_tr(
                    title =>
q{<a href="https://wilwheaton.net/">Wil Wheaton</a> Fanfiction},
                ),
                $Screenplays_TR,
                _tr_s( qw( selina_mandrake the_10th_muse__wil_wheaton ), ),
            ],
        },
    ),
    'tiffany_alvord' => Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id         => 'tiffany_alvord_nav_block',
            text_title => "Tiffany Alvord Fanfiction",
            tr_s       => [
                _master_tr(
                    title =>
q{<a href="http://www.tiffanyalvord.com/">Tiffany Alvord</a> Fanfiction},
                ),
                $Screenplays_TR,
                _tr_s(
                    qw( queen_padme_tales the_10th_muse__wil_wheaton muppets_tiffany_alvord ),
                ),
                $Essays_TR,
                _get_tr(
'commercial_fanfic_initiative__mission_stmt__w_explicit_title'
                ),
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

{
    my %by_page_lookup;

    sub _calc_by_page_lookup
    {
        my ( $self, ) = @_;

        foreach my $block ( @{ $self->list_nav_blocks() } )
        {
            foreach my $page (
                @{ $self->get_nav_block($block)->collect_local_links() } )
            {
                die $page if not( '' eq ref($page) );
                push @{ $by_page_lookup{$page} }, $block;
            }
        }
        return;
    }

    sub lookup_page_blocks
    {
        my ( $self, $page ) = @_;

        return $by_page_lookup{$page};
    }

}

__PACKAGE__->_calc_by_page_lookup();

1;
