package Shlomif::Homepage::GenSectionNavMenu;

use strict;
use warnings;

use Moo;

use File::Update                           qw/ write_on_change /;
use HTML::Widgets::NavMenu::JQueryTreeView ();
use MyNavData                              ();
use MyNavData::Hosts                       ();
use NavDataRender                          ();
use NavSectMenuRender                      ();
use Path::Tiny                             qw/ path /;

my $hosts         = MyNavData::Hosts::get_hosts();
my $host          = 't2';
my $host_base_url = $hosts->{$host}->{base_url};
my $hostp         = "lib/cache/combined/$host";

my $nav_links_template = <<'EOF';
[% USE HTML %]
[% FOREACH b = buttons %]
[% IF ( NOT( b.dir == 'top' || b.dir == 'up' ) ) %]
[% SET key = b.dir.substr(0, 1) %]
[% IF b.exists %]
<link href="[% HTML.escape(b.link_obj.direct_url()) %]" rel="[% b.dir %]" title="[% b.link_obj.title() %]"/>
[% END %]
[% END %]
[% END %]
EOF

sub process_batch
{
    my ( $self, $batch ) = @_;
    for my $proto_url ( @{$batch} )
    {
        my $url = $proto_url =~ s#(?:\A|/)\Kindex\.x?html\z##r;

        my $filename = "/$url";

        # urlpath.
        my $urlp = path("$hostp/$proto_url");
        $urlp->mkpath;

        # print "start filename=$filename\n";

        my $nav_bar = HTML::Widgets::NavMenu::JQueryTreeView->new(
            coords_stop    => 1,
            'path_info'    => $filename,
            'current_host' => $host,
            MyNavData::get_params(),
            'ul_classes'     => [],
            'no_leading_dot' => 1,
        );
        my $ROOT    = NavDataRender::get_root($url);
        my $results = NavSectMenuRender->init_section_nav_menu(
            {
                filename => $filename,
                host     => $host,
                lang     => +{ ar => 1, en => 1, he => 1, },
                ROOT     => $ROOT,
            }
        );

        my $section_nav_menu = $results->{section_nav_menu};

        my $rendered_results2 = $nav_bar->render();
        my $rendered_results;
        eval { $rendered_results = $section_nav_menu->results() };
        $rendered_results ||= $rendered_results2;

        my $leading_path = $rendered_results2->{leading_path};

        my $nav_results = NavDataRender->nav_data_render(
            {
                filename => $url,
                host     => $host,
                ROOT     => $ROOT,
                lang     => +{ ar => 1, en => 1, he => 1, },
            }
        );

        # warn Dumper({Results => $results,});

        my $shlomif_nav_links_renderer = $nav_results->{nav_links_renderer};

        if (0)
        {
            my $nav_links_obj = $rendered_results->{nav_links_obj};
            $nav_links_obj ||= $rendered_results2->{nav_links_obj};
        }

        my $out = sub {
            my ( $id, $ref ) = @_;

            return write_on_change( $urlp->child($id), $ref );
        };

        $out->( 'sect-navmenu', \( $section_nav_menu->get_html ), );
        $out->(
            'breadcrumbs-trail',
            \(
                NavDataRender->get_breadcrumbs_trail_unconditionally(
                    {
                        total_leading_path =>
                            $section_nav_menu->total_leading_path(
                            {
                                main_leading_path => $leading_path,
                            }
                            ),
                    }
                )
            ),
        );
        $out->(
            'main_nav_menu_html',
            \( join( "\n", @{ $rendered_results->{html} } ) ),
        );
        $out->(
            'html_head_nav_links',
            \(
                $shlomif_nav_links_renderer->_get_nav_buttons_html(
                    nav_links_template => $nav_links_template,
                    sorted             => 1,
                )
            ),
        );

        foreach my $with_accesskey ( '', 1 )
        {
            $out->(
                "shlomif_nav_links_renderer-with_accesskey=$with_accesskey",
                do
                {
                    my @params;
                    if ( $with_accesskey ne "" )
                    {
                        push @params, ( 'with_accesskey' => $with_accesskey );
                    }
                    \(
                        join(
                            '',
                            $shlomif_nav_links_renderer->get_total_html(
                                @params)
                        ) =~ s%<img src="\K\./%%gr
                    );
                },
            );
        }

        if ( $filename eq '/site-map/' )
        {
            $out->(
                'shlomif_main_expanded_nav_bar',
                \(
                    join(
                        '',
                        map { "$_\n" } @{
                            $nav_results->{shlomif_main_expanded_nav_bar}
                                ->gen_site_map()
                        }
                    )
                ),
            );
        }
        if ( $filename eq '/site-map/hebrew/' )
        {
            my $hebrew_nav_results = NavDataRender->nav_data_render(
                {
                    filename => $url,
                    host     => $host,
                    ROOT     => $ROOT,
                    lang     => +{ 'he' => 1, },
                }
            );
            my $html = join(
                '',
                @{
                    $hebrew_nav_results->{shlomif_main_expanded_nav_bar}
                        ->gen_site_map() || ( die "hebrew site map" )
                }
            );

            # die "'$html" if $html !~ m#The-Enemy-Hebrew#;
            $out->( 'shlomif_hebrew_expanded_nav_bar', \($html), );
        }
    }
    return;
}

1;

__END__
