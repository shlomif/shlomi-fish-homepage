#!/usr/bin/env perl

use strict;
use warnings;

use utf8;

use Test::More tests => 11;
use Test::Differences (qw(eq_or_diff));

use lib './Tests/lib';
use lib './lib';

use NavDataRender                            ();
use Shlomif::Homepage::NavBlocks::Renderer   ();
use Shlomif::Homepage::NavBlocks             ();
use Shlomif::Homepage::NavBlocks::TableBlock ();
use Shlomif::Homepage::RelUrl (qw/ _set_url _url_obj /);
use NavBlocks ();

sub _fn
{
    my $fn = shift;

    _set_url($fn);

    return "/$fn";
}

{

    my $nav_bar = HTML::Widgets::NavMenu->new(
        coords_stop  => 1,
        path_info    => _fn("philosophy/the-eternal-jew/"),
        current_host => 't2',
        MyNavData::get_params(),
        'no_leading_dot' => 1,
    );

    my $r = Shlomif::Homepage::NavBlocks::Renderer->new(
        {
            host     => 't2',
            nav_menu => $nav_bar,
        }
    );
    $r->fn( _url_obj() );

    {
        my $link = Shlomif::Homepage::NavBlocks::LocalLink->new(
            {
                inner_html => "Ongoing Text",
                path       => "humour/Selina-Mandrake/ongoing-text.html",
            },
        );

        # TEST
        eq_or_diff(
            $r->render( { obj => $link } ),
q{<li><p><a href="../../humour/Selina-Mandrake/ongoing-text.html">Ongoing Text</a></p></li>},
            "Render Local Link.",
        );
    }

    {
        my $link = Shlomif::Homepage::NavBlocks::GitHubLink->new(
            {
                url => 'http://github.com/shlomif/Selina-Mandrake',
            },
        );

        # TEST
        eq_or_diff(
            $r->render( { obj => $link } ),
q{<li><p><a class="ext github" href="http://github.com/shlomif/Selina-Mandrake">GitHub Repo</a></p></li>},
            "Render GitHub Link.",
        );
    }

    {
        my $link = Shlomif::Homepage::NavBlocks::LocalLink->new(
            {
                inner_html => "The Eternal Jew",
                path       => "philosophy/the-eternal-jew/",
            },
        );

        # TEST
        eq_or_diff(
            $r->render( { obj => $link } ),
            q{<li><p><strong class="current">The Eternal Jew</strong></p></li>},
            "Render current link.",
        );
    }
}

{
    my $nav_bar = HTML::Widgets::NavMenu->new(
        coords_stop  => 1,
        path_info    => _fn("humour/Selina-Mandrake/"),
        current_host => 't2',
        MyNavData::get_params(),
        'no_leading_dot' => 1,
    );

    my $r = Shlomif::Homepage::NavBlocks::Renderer->new(
        {
            host     => 't2',
            nav_menu => $nav_bar,
        }
    );
    $r->fn( _url_obj() );

    {
        my @links = (
            Shlomif::Homepage::NavBlocks::LocalLink->new(
                {
                    inner_html => "Front Page",
                    path       => "humour/Selina-Mandrake/",
                },
            ),
            Shlomif::Homepage::NavBlocks::LocalLink->new(
                {
                    inner_html => "Ongoing Text",
                    path       => "humour/Selina-Mandrake/ongoing-text.html",
                },
            ),
            Shlomif::Homepage::NavBlocks::LocalLink->new(
                {
                    inner_html => "Proposed Cast",
                    path       => "humour/Selina-Mandrake/cast.html",
                },
            ),
            Shlomif::Homepage::NavBlocks::GitHubLink->new(
                {
                    url => 'http://github.com/shlomif/Selina-Mandrake',
                },
            ),
        );

        my $tr = Shlomif::Homepage::NavBlocks::Tr->new(
            {
                title => "Selina Mandrake - The Slayer",
                items => \@links,
            },
        );

        # TEST
        eq_or_diff(
            $tr->collect_local_links(),
            [
                "humour/Selina-Mandrake/",
                "humour/Selina-Mandrake/ongoing-text.html",
                "humour/Selina-Mandrake/cast.html",
            ],
        );

        # TEST
        eq_or_diff(
            $r->render( { obj => $tr } ),
            <<'EOF',
<tr>
<td><b>Selina Mandrake - The Slayer</b></td>
<td>
<ul>
<li><p><strong class="current">Front Page</strong></p></li>
<li><p><a href="ongoing-text.html">Ongoing Text</a></p></li>
<li><p><a href="cast.html">Proposed Cast</a></p></li>
<li><p><a class="ext github" href="http://github.com/shlomif/Selina-Mandrake">GitHub Repo</a></p></li>
</ul>
</td>
</tr>
EOF
            "Render Tr",
        );
    }
}

{
    my $nav_bar = HTML::Widgets::NavMenu->new(
        coords_stop  => 1,
        path_info    => _fn("humour/Selina-Mandrake/"),
        current_host => 't2',
        MyNavData::get_params(),
        'no_leading_dot' => 1,
    );

    my $r = Shlomif::Homepage::NavBlocks::Renderer->new(
        {
            host     => 't2',
            nav_menu => $nav_bar,
        }
    );
    $r->fn( _url_obj() );

    {
        my $subdiv_tr = Shlomif::Homepage::NavBlocks::Subdiv_Tr->new(
            {
                title => "Screenplays",
            },
        );

        # TEST
        eq_or_diff( $subdiv_tr->collect_local_links(), [], );

        # TEST
        eq_or_diff(
            $r->render( { obj => $subdiv_tr } ),
            <<'EOF',
<tr class="subdiv">
<th colspan="2">Screenplays</th>
</tr>
EOF
            "Render Subdiv_Tr",
        );
    }

    {
        my $table = Shlomif::Homepage::NavBlocks::TableBlock->new(
            {
                id         => "harry_potter_nav_block",
                text_title => 'dummy',
                title      => "Harry Potter/Emma Watson Fanfiction",
                tr_s       => [],
            },
        );
        my $master_tr = Shlomif::Homepage::NavBlocks::Master_Tr->new(
            {
                title => "Harry Potter/Emma Watson Fanfiction",
            },
        );

        # TEST
        eq_or_diff( $master_tr->collect_local_links(), [], );

        # TEST
        eq_or_diff(
            $r->render( { obj => $master_tr, table => $table, } ),
            <<'EOF',
<tr class="main_title">
<th colspan="2">Harry Potter/Emma Watson Fanfiction <a class="to_block" href="../../meta/nav-blocks/blocks/#harry_potter_nav_block">Link</a></th>
</tr>
EOF
            "Render Master_Tr",
        );
    }
}

# TEST:$ext=2;
foreach my $ext ( '', 'index.xhtml', )
{
    my $nav_bar = HTML::Widgets::NavMenu->new(
        coords_stop  => 1,
        path_info    => _fn("humour/Selina-Mandrake/$ext"),
        current_host => 't2',
        MyNavData::get_params(),
        'no_leading_dot' => 1,
    );

    my $r = Shlomif::Homepage::NavBlocks::Renderer->new(
        {
            host     => 't2',
            nav_menu => $nav_bar,
        }
    );
    $r->fn( _url_obj() );

    my $block = NavBlocks->new->get_nav_block('buffy');

    # TEST*$ext
    eq_or_diff(
        [ $r->render( { obj => $block } ), ], [ <<'EOF', ],
<table id="buffy_nav_block">
<tr class="main_title">
<th colspan="2">Buffy Fanfiction <a class="to_block" href="../../meta/nav-blocks/blocks/#buffy_nav_block">Link</a></th>
</tr>

<tr class="subdiv">
<th colspan="2">Screenplays</th>
</tr>

<tr>
<td><b>Star Trek: We, the Living Dead</b></td>
<td>
<ul>
<li><p><a href="../Star-Trek/We-the-Living-Dead/">Front Page</a></p></li>
<li><p><a href="../Star-Trek/We-the-Living-Dead/ongoing-text.html">Ongoing Text</a></p></li>
<li><p><a class="ext github" href="http://github.com/shlomif/Star-Trek--We-the-Living-Dead">GitHub Repo</a></p></li>
</ul>
</td>
</tr>

<tr>
<td><b>Selina Mandrake - The Slayer</b></td>
<td>
<ul>
<li><p><strong class="current">Front Page</strong></p></li>
<li><p><a href="ongoing-text.html">Ongoing Text</a></p></li>
<li><p><a href="cast.html">Proposed Cast</a></p></li>
<li><p><a class="ext github" href="http://github.com/shlomif/Selina-Mandrake">GitHub Repo</a></p></li>
</ul>
</td>
</tr>

<tr>
<td><b>Summerschool at the NSA</b></td>
<td>
<ul>
<li><p><a href="../Summerschool-at-the-NSA/">Front Page</a></p></li>
<li><p><a href="../Summerschool-at-the-NSA/ongoing-text.html">Ongoing Text</a></p></li>
<li><p><a href="../Summerschool-at-the-NSA/cast.html">Proposed Cast</a></p></li>
<li><p><a class="ext github" href="http://github.com/shlomif/Summerschool-at-the-NSA">GitHub Repo</a></p></li>
<li><p><a class="ext facebook" href="http://www.facebook.com/SummerNSA">Facebook Page</a></p></li>
</ul>
</td>
</tr>

<tr>
<td><b>Buffy: A Few Good Slayers</b></td>
<td>
<ul>
<li><p><a href="../Buffy/A-Few-Good-Slayers/">Front Page</a></p></li>
<li><p><a href="../Buffy/A-Few-Good-Slayers/ongoing-text.html">Ongoing Text</a></p></li>
<li><p><a class="ext github" href="http://github.com/shlomif/Buffy-a-Few-Good-Slayers">GitHub Repo</a></p></li>
</ul>
</td>
</tr>

<tr class="subdiv">
<th colspan="2">Factoids</th>
</tr>

<tr>
<td><b>“Facts”</b></td>
<td>
<ul>
<li><p><a href="../bits/facts/Buffy/">Buffy Facts</a></p></li>
</ul>
</td>
</tr>

</table>
EOF
        "Render a block.",
    );
}

{
    my $foss_bits = Shlomif::Homepage::NavBlocks::_get_tr('foss_bits');
    use Shlomif::Homepage::SectionMenu::Sects::Humour ();
    my %t =
        Shlomif::Homepage::SectionMenu::Sects::Humour->get_params(
        { lang => { 'en' => 1, } } );
    my $t = $t{tree_contents};
    ($t) = ( grep { $_->{url} eq 'humour/bits/' } @{ $t->{subs} } );
    my %i;
    while ( my ( $i, $rec ) = each( @{ $t->{'subs'} } ) )
    {
        $i{ $rec->{url} } = $i;
    }
    my $pos    = 1;
    my $x      = $foss_bits->items;
    my $lookup = sub {
        return $i{ $x->[ $pos + shift ]->path() } // ( die "foo" );
    };
    my $path = sub {
        return $x->[ $pos + shift ]->path() // ( die "pathfoo" );
    };
    while ( $pos < @$x )
    {
        my $verdict = ( $lookup->(-1) < $lookup->(0) );
        if ( not $verdict )
        {
            die "bar == " . $path->(0);
        }
    }
    continue
    {
        ++$pos;
    }
}
