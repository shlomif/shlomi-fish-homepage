package NavDataRender;

use strict;
use warnings;

use utf8;

use HTML::Widgets::NavMenu::EscapeHtml qw(escape_html);

use MyNavData                              ();
use MyNavData::Hosts                       ();
use HTML::Widgets::NavMenu::JQueryTreeView ();

use URI::Escape qw(uri_escape);
use MyNavLinks;

sub nav_data_render
{
    my ( $class, $args ) = @_;

    my $filename = $args->{filename};
    my $host     = $args->{host};
    my $ROOT     = $args->{ROOT};

    $filename =~ s!index\.html$!!;
    $filename = "/$filename";

    my $shlomif_main_expanded_nav_bar =
        HTML::Widgets::NavMenu::JQueryTreeView->new(
        'path_info'    => $filename,
        'current_host' => $host,
        MyNavData->generic_get_params( { fully_expanded => 1 } ),
        'ul_classes'     => [ "navbarmain", ("navbarnested") x 10 ],
        'no_leading_dot' => 1,
        );

    my $rendered_results = $shlomif_main_expanded_nav_bar->render();

    my $shlomif_nav_links = $rendered_results->{nav_links};

    my $shlomif_nav_links_obj = $rendered_results->{nav_links_obj};

    my $shlomif_nav_links_renderer = MyNavLinks->new(
        'nav_links'     => $shlomif_nav_links,
        'nav_links_obj' => $shlomif_nav_links_obj,
        'root'          => "$ROOT",
    );

    return +{
        nav_links_renderer            => $shlomif_nav_links_renderer,
        shlomif_main_expanded_nav_bar => $shlomif_main_expanded_nav_bar,
    };
}

sub get_breadcrumbs_trail_unconditionally
{
    my ( $class, $args ) = @_;

    my $total_leading_path = $args->{total_leading_path};

    my $render_leading_path_component = sub {
        my $component  = shift;
        my $title      = $component->title();
        my $title_attr = defined($title) ? " title=\"$title\"" : "";
        return
              "<a href=\""
            . escape_html( $component->direct_url() )
            . "\"$title_attr>"
            . $component->label() . "</a>";
    };
    return join( " → ",
        ( map { $render_leading_path_component->($_) } @$total_leading_path ) );
}

sub get_html_head_nav_links
{
    my ( $class, $args ) = @_;

    my $nav_links_obj = $args->{nav_links_obj};

    my @keys = ( sort { $a cmp $b } keys(%$nav_links_obj) );
    my @ret;
    foreach my $key (@keys)
    {
        my $val   = $nav_links_obj->{$key};
        my $url   = escape_html( $val->direct_url() );
        my $title = $val->title() || '';

        if ( not( $key eq 'top' || $key eq 'up' ) )
        {
            push @ret, qq{<link rel="$key" href="$url" title="$title" />\n};
        }
    }

    return join '', @ret;
}

my $hosts = MyNavData::Hosts::get_hosts();

sub calc_page_url
{
    my ($class) = @_;

    return $hosts->{ $::nav_bar->current_host() }->{'base_url'}
        . $::nav_bar->path_info();
}

sub calc_esc_page_url
{
    my ($class) = @_;

    return escape_html( uri_escape( $class->calc_page_url() ) );
}

1;
