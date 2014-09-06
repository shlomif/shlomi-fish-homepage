package Shlomif::Homepage::NavBlocks::LocalLink;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

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

package Shlomif::Homepage::NavBlocks::ExternalLink;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

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

package Shlomif::Homepage::NavBlocks::FacebookLink;

use MooX (qw( late ));

extends ('Shlomif::Homepage::NavBlocks::ExternalLink');

package Shlomif::Homepage::NavBlocks::Tr;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

has 'items' => (is => 'ro', isa => 'ArrayRef', required => 1);
has 'title' => (is => 'ro', isa => "Str", required => 1);

sub collect_local_links
{
    my $self = shift;

    return [ map { @{$_->collect_local_links} } @{$self->items}];
}

1;

package Shlomif::Homepage::NavBlocks::Title_Tr;

use strict;
use warnings;

use utf8;

use MooX (qw( late ));

has 'title' => (is => 'ro', isa => "Str", required => 1);

sub collect_local_links
{
    my $self = shift;

    return [];
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

    if ($thingy->isa('Shlomif::Homepage::NavBlocks::Tr'))
    {
        return join'',map { "$_\n" }
            "<tr>",
            sprintf(qq{<td colspan="2"><b>%s</b></td>}, $thingy->title),
            "<td>",
            "<ul>",
            (map { $self->render($_) } @{$thingy->items}),
            "</ul>",
            "</td>",
            "</tr>",
            ;
    }
    elsif ($thingy->isa('Shlomif::Homepage::NavBlocks::Title_Tr'))
    {
        return join'',map { "$_\n" }
            sprintf( q{<tr class="%s">}, $thingy->css_class),
            sprintf(qq{<th colspan="3">%s</th>}, $thingy->title),
            "</tr>",
            ;
    }
    elsif ($thingy->isa('Shlomif::Homepage::NavBlocks::LocalLink'))
    {
        my $normalize = sub {return shift =~ s#/index\.html\z#/#gr};

        if ($normalize->($thingy->path) eq $normalize->($self->nav_menu->path_info))
        {
            return sprintf(
                q#<li><p><strong class="current">%s</strong></p></li>#,
                $thingy->inner_html(),
            );
        }
        else
        {
            return sprintf(q#<li><p><a href="%s">%s</a></p></li>#,
                CGI::escapeHTML(
                    $self->nav_menu->get_cross_host_rel_url_ref(
                        {
                            host => $self->host,
                            host_url => $thingy->path,
                            url_type => 'rel',
                            url_is_abs => 0,
                        },
                    ),
                ),
                $thingy->inner_html(),
            );
        }
    }
    elsif ($thingy->isa('Shlomif::Homepage::NavBlocks::GitHubLink'))
    {
        return sprintf(q#<li><p><a class="ext github" href="%s">%s</a></p></li>#,
            CGI::escapeHTML(
                $thingy->url,
            ),
            'GitHub Repo',
        );
    }
    elsif ($thingy->isa('Shlomif::Homepage::NavBlocks::FacebookLink'))
    {
        return sprintf(q#<li><p><a class="ext facebook" href="%s">%s</a></p></li>#,
            CGI::escapeHTML(
                $thingy->url,
            ),
            'Facebook Page',
        );
    }
    else
    {
        Carp::confess('unimplemented');
    }
}

package Shlomif::Homepage::NavBlocks;

use strict;
use warnings;

use utf8;

use parent ('Exporter');

our @EXPORT_OK = (qw(
    _facebook
    _fp
    _get_tr
    _github
    _l
    _ontext
    _tr
    $r
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

1;

