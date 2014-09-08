package Shlomif::Homepage::NavBlocks::Thingy;

use strict;
use warnings;

use MooX (qw( late ));

has 'cache' => (is => 'rw');
has 'is_cached' => (is => 'rw', isa => 'Bool', default => 0);

sub cached_render
{
    my ($self, $promise_cb) = @_;

    if (! $self->is_cached)
    {
        $self->cache(
            scalar ( $promise_cb->() ),
        );
        $self->is_cached(1);
    }

    return $self->cache;
}

package Shlomif::Homepage::NavBlocks::LocalLink;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

extends ('Shlomif::Homepage::NavBlocks::Thingy');

has [qw(
    inner_html
    path
)] => (is => 'ro', isa => 'Str', required => 1);

has 'title' => (is => 'ro', isa => 'Str');

sub collect_local_links
{
    my ($self) = @_;

    return [$self->path];
}

sub render
{
    my ($self, $r) = @_;

    my $normalize = sub {return shift =~ s#/index\.html\z#/#gr};

    if ($normalize->($self->path) eq $normalize->($r->nav_menu->path_info))
    {
        return sprintf(
            q#<li><p><strong class="current">%s</strong></p></li>#,
            $self->inner_html(),
        );
    }
    else
    {
        return sprintf(q#<li><p><a href="%s">%s</a></p></li>#,
            CGI::escapeHTML(
                $r->nav_menu->get_cross_host_rel_url_ref(
                    {
                        host => $r->host,
                        host_url => $self->path,
                        url_type => 'rel',
                        url_is_abs => 0,
                    },
                ),
            ),
            $self->inner_html(),
        );
    }
}

package Shlomif::Homepage::NavBlocks::ExternalLink;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

extends ('Shlomif::Homepage::NavBlocks::Thingy');

has [qw(
    url
)] => (is => 'ro', isa => 'Str', required => 1);

sub collect_local_links
{
    my ($self) = @_;

    return [];
}

package Shlomif::Homepage::NavBlocks::GitHubLink;

use MooX (qw( late ));

extends ('Shlomif::Homepage::NavBlocks::ExternalLink');

sub render
{
    my ($self, $r) = @_;

    return sprintf(q#<li><p><a class="ext github" href="%s">%s</a></p></li>#,
        CGI::escapeHTML(
            $self->url,
        ),
        'GitHub Repo',
    );
}

package Shlomif::Homepage::NavBlocks::FacebookLink;

use MooX (qw( late ));

extends ('Shlomif::Homepage::NavBlocks::ExternalLink');

sub render
{
    my ($self, $r) = @_;

    return sprintf(q#<li><p><a class="ext facebook" href="%s">%s</a></p></li>#,
        CGI::escapeHTML(
            $self->url,
        ),
        'Facebook Page',
    );
}

package Shlomif::Homepage::NavBlocks::Tr;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

extends ('Shlomif::Homepage::NavBlocks::Thingy');

has 'items' => (is => 'ro', isa => 'ArrayRef', required => 1);
has 'title' => (is => 'ro', isa => "Str", required => 1);

sub collect_local_links
{
    my $self = shift;

    return [ map { @{$_->collect_local_links} } @{$self->items}];
}

sub render
{
    my ($self, $r) = @_;

    return join '', map { "$_\n" }
    "<tr>",
    sprintf(qq{<td colspan="2"><b>%s</b></td>}, $self->title),
    "<td>",
    "<ul>",
    (map { $r->render($_) } @{$self->items}),
    "</ul>",
    "</td>",
    "</tr>",
    ;

}

1;

package Shlomif::Homepage::NavBlocks::Title_Tr;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

extends ('Shlomif::Homepage::NavBlocks::Thingy');

has 'title' => (is => 'ro', isa => "Str", required => 1);

sub collect_local_links
{
    my $self = shift;

    return [];
}

sub render
{
    my ($self,$r) = @_;

    return join'', map { "$_\n" }
    sprintf( q{<tr class="%s">}, $self->css_class),
    sprintf(qq{<th colspan="3">%s</th>}, $self->title),
    "</tr>",
    ;
}

1;

package Shlomif::Homepage::NavBlocks::Subdiv_Tr;

use MooX (qw( late ));

extends ('Shlomif::Homepage::NavBlocks::Title_Tr');

has 'css_class' => (is => 'ro', isa => 'Str', default => 'subdiv');

package Shlomif::Homepage::NavBlocks::Master_Tr;

use MooX (qw( late ));

extends ('Shlomif::Homepage::NavBlocks::Title_Tr');

has 'css_class' => (is => 'ro', isa => 'Str', default => 'main_title');

package Shlomif::Homepage::NavBlocks::TableBlock;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

extends ('Shlomif::Homepage::NavBlocks::Thingy');

has 'tr_s' => (is => 'ro', isa => 'ArrayRef', required => 1);
has 'id' => (is => 'ro', isa => "Str", required => 1);

sub collect_local_links
{
    my $self = shift;

    return [ map { @{$_->collect_local_links} } @{$self->tr_s}];
}

sub render
{
    my ($self, $r) = @_;

    return join '', map { "$_\n" }
    sprintf(q{<div class="topical_nav_block" id="%s">}, $self->id),
    "<table>",
    (map { $r->render($_); } @{$self->tr_s}),
    "</table>",
    "</div>",
    ;
}

1;

package Shlomif::Homepage::NavBlocks::Renderer;

use strict;
use warnings;

use utf8;

use Carp ();

use MooX (qw( late ));

use CGI ();

extends ('Exporter');

has 'host' => (is => 'ro', isa => 'Str', required => 1);

has [qw(
    nav_menu
)] => (is => 'ro', required => 1);

sub render
{
    my ($self, $thingy) = @_;

    return $thingy->cached_render(
        sub {
            return $self->_non_cached_render($thingy);
        }
    );
}

sub _non_cached_render
{
    my ($self, $thingy) = @_;

    return $thingy->render($self);
}

package Shlomif::Homepage::NavBlocks;

use strict;
use warnings;

use utf8;

use parent ('Exporter');

our @EXPORT_OK = (qw(
    get_nav_block
));

sub _l
{
    return
        Shlomif::Homepage::NavBlocks::LocalLink->new(
            {
            @_
            },
        );
}

sub _fp
{
    return _l(inner_html => "Front Page", @_);
}

sub _ontext
{
    return _l(inner_html => "Ongoing Text", @_);
}

sub _github
{
    return
        Shlomif::Homepage::NavBlocks::GitHubLink->new(
            { @_ }
        );
}

sub _facebook
{
    return
        Shlomif::Homepage::NavBlocks::FacebookLink->new(
            { @_ }
        );
}

sub _tr
{
    return Shlomif::Homepage::NavBlocks::Tr->new(
        { @_ }
    );
}

my $EmWatson_tech_interview = _l( inner_html => "Emma Watson Interviewing for a software developer job", path => "humour/bits/Emma-Watson-applying-for-a-software-dev-job/",);

my %tr_s =
(
    'buffy_facts' =>
    _tr(
        title => "“Facts”",
        items => [
            _l( inner_html => "Buffy Facts", path => "humour/bits/facts/Buffy/",),
        ],
    ),
    'buffy_few_good' =>
    _tr(
        title => "Buffy: A Few Good Slayers",
        items => [
            _fp(path => "humour/Buffy/A-Few-Good-Slayers/",),
            _ontext( path => "humour/Buffy/A-Few-Good-Slayers/ongoing-text.html",),
            _github( url => 'http://github.com/shlomif/Buffy-a-Few-Good-Slayers',),
        ],
    ),
    'EmWatson_facts' =>
    _tr(
        title => "“Facts”",
        items => [
            _l( inner_html => "Emma Watson Facts", path => "humour/bits/facts/Emma-Watson/",),
        ],
    ),
    'EmWatson_tech_job' =>
    _tr(
        title => "EmWatson Tech Interview",
        items => [
            $EmWatson_tech_interview,
        ],
    ),
    'foss_bits' =>
    _tr(
        title => "Ultra-short stories",
        items => [
            _l( inner_html => "GPL Not Compatible with Itself", path => "humour/bits/GPL-is-not-Compatible-with-Itself/",),
            _l( inner_html => "RMS Lint", path => "humour/bits/RMS-Lint/",),
            _l( inner_html => "Cracka’s Paradise", path => "humour/bits/Crackas-Paradise/",),
            _l( inner_html => "“Mastering cat”", path => "humour/bits/Mastering-Cat/",),
            _l( inner_html => "Programs Everyone Has Written", path => "humour/bits/Programs-Every-Programmer-has-Written/",),
            _l( inner_html => "Freecell Solver™ Enterprise Edition", path => "humour/bits/Freecell-Solver-Enterprise-Edition/",),
            _l( inner_html => "COBOL — The New Age Programming Language", path => "humour/bits/COBOL-the-New-Age-Programming-Language/",),
            _l( inner_html => "Copying Ubuntu Bug #1", path => "humour/bits/Copying-Ubuntu-Bug-No-1/",),
            _l( inner_html => "It’s not a Fooware - It’s an Operating System", path => "humour/bits/It-s-not-a-Fooware-It-s-an-Operating-System/",),
            $EmWatson_tech_interview,
        ],
    ),
    'foss_facts' =>
    _tr(
        title => "“Facts”",
        items => [
            _l( inner_html => "Chuck Norris Facts", path => "humour/bits/facts/Chuck-Norris/",),
            _l( inner_html => "Larry Wall Facts", path => "humour/bits/facts/Larry-Wall/",),
            _l( inner_html => "“Knuth is not God”", path => "humour/bits/facts/Knuth/",),
            _l( inner_html => "NSA Facts", path => "humour/bits/facts/NSA/",),
            _l( inner_html => "XSLT Facts", path => "humour/bits/facts/XSLT/",),
        ],
    ),
    'hhfg' =>
    _tr(
        title => "Human Hacking Field Guide",
        items => [
            _fp( path => "humour/human-hacking/",),
            _l( inner_html => "Conclusions and Reviews", path => "humour/human-hacking/conclusions/",),
            _github( url => 'http://github.com/shlomif/Human-Hacking-Field-Guide',),
        ],
    ),
    'muppets_harry_potter' =>
    _tr(
        title => "The Muppet Show - The Next Incarnation",
        items => [
            _fp( path => "humour/Muppets-Show-TNI/Harry-Potter.html",),
            _github( url => 'http://github.com/shlomif/The-Muppets-Show--The-New-Incarnation',),
        ],
    ),
    'selina_mandrake' =>
    _tr(
        title => "Selina Mandrake - The Slayer",
        items => [
            _fp( path => "humour/Selina-Mandrake/",),
            _ontext( path => "humour/Selina-Mandrake/ongoing-text.html",),
            _l( inner_html => "Proposed Cast", path => "humour/Selina-Mandrake/cast.html",),
            _github( url => 'http://github.com/shlomif/Selina-Mandrake',),
        ],
    ),
    'star_trek_wtld' =>
    _tr(
        title => "Star Trek: We, the Living Dead",
        items => [
            _fp( path => "humour/Star-Trek/We-the-Living-Dead/",),
            _ontext( path => "humour/Star-Trek/We-the-Living-Dead/ongoing-text.html",),
            _github( url => 'http://github.com/shlomif/Star-Trek--We-the-Living-Dead',),
        ],
    ),
    'summer_nsa' =>
    _tr(
        title => "Summerschool at the NSA",
        items => [
            _fp( path => "humour/Summerschool-at-the-NSA/",),
            _ontext( path => "humour/Summerschool-at-the-NSA/ongoing-text.html",),
            _l( inner_html => "Proposed Cast", path => "humour/Summerschool-at-the-NSA/cast.html",),
            _github( url => 'http://github.com/shlomif/Summerschool-at-the-NSA',),
            _facebook( url => 'http://www.facebook.com/SummerNSA',),
        ],
    ),
    'xkcd_facts' =>
    _tr(
        title => "“Facts”",
        items => [
            _l( inner_html => "Summer Glau Facts", path => "humour/bits/facts/Summer-Glau/",),
            _l( inner_html => "NSA Facts", path => "humour/bits/facts/NSA/"),
        ],
    ),
);

sub _get_tr
{
    my ($id) = @_;
    return ($tr_s{$id} // do { Carp::confess "Unknown ID $id." });
}

sub _master_tr
{
    return Shlomif::Homepage::NavBlocks::Master_Tr->new(
        { @_ },
    );
}

sub _subdiv_tr
{
    return Shlomif::Homepage::NavBlocks::Subdiv_Tr->new(
        { @_ },
    );
}

my %table_blocks =
(
    'buffy' =>
    Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id => 'buffy_nav_block',
            tr_s =>
            [
                _master_tr(title => q{Buffy Fanfiction},),
                _subdiv_tr(title => q{Screenplays},),
                _get_tr('star_trek_wtld'),
                _get_tr('selina_mandrake'),
                _get_tr('summer_nsa'),
                _get_tr('buffy_few_good'),
                _subdiv_tr(title => q{Factoids},),
                _get_tr('buffy_facts'),
            ],
        },
    ),
    'harry_potter' =>
    Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id => 'harry_potter_nav_block',
            tr_s =>
            [
                _master_tr(title => q{Harry Potter/Emma Watson Fanfiction},),
                _subdiv_tr(title => q{Screenplays},),
                _get_tr('selina_mandrake'),
                _get_tr('buffy_few_good'),
                _get_tr('muppets_harry_potter'),
                _get_tr('EmWatson_tech_job'),
                _subdiv_tr(title => q{Factoids},),
                _get_tr('EmWatson_facts'),
            ],
        },
    ),
    'foss' =>
    Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id => 'foss_nav_block',
            tr_s =>
            [
                _master_tr(title => q{Open Source/Perl/etc. Fanfiction},),
                _subdiv_tr(title => q{Screenplays},),
                _get_tr('hhfg'),
                _subdiv_tr(title => q{Factoids},),
                _get_tr('foss_facts'),
                _subdiv_tr(title => q{Bits},),
                _get_tr('foss_bits'),
            ],
        },
    ),
    'star_trek' =>
    Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id => 'star_trek_nav_block',
            tr_s =>
            [
                _master_tr(title => q{Star Trek Fanfiction},),
                _subdiv_tr(title => q{Screenplays},),
                _get_tr('star_trek_wtld'),
                _get_tr('selina_mandrake'),
            ],
        },
    ),
    'xkcd' =>
    Shlomif::Homepage::NavBlocks::TableBlock->new(
        {
            id => 'xkcd_nav_block',
            tr_s =>
            [
                _master_tr(title => q{Summer Glau/xkcd Fanfiction},),
                _subdiv_tr(title => q{Screenplays},),
                _get_tr('summer_nsa'),
                _subdiv_tr(title => q{Factoids},),
                _get_tr('xkcd_facts'),
            ],
        },
    ),
);

sub get_nav_block
{
    my ($id) = @_;

    return ($table_blocks{$id} // do { Carp::confess "Unknown ID $id." });
}

1;

