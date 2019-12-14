use strict;
use warnings;

=begin removed
    my $nav_bar = HTML::Widgets::NavMenu->new(
        'path_info'    => $fn2,
        'current_host' => $LATEMP_SERVER,
        MyNavData::get_params(),
        'ul_classes'     => [],
        'no_leading_dot' => 1,
    );

    my $rendered_results = $nav_bar->render();
    my $nav_links_obj = $rendered_results->{nav_links_obj};
            my $nav_links = $rendered_results->{nav_links};
            my $nav_links_renderer = MyNavLinks->new(
                'nav_links'     => $nav_links,
                'nav_links_obj' => $nav_links_obj,
                'root'          => $base_path,
            );
            my $with_accesskey = '';
            my @params;
            if ( $with_accesskey ne "" )
            {
                push @params, ( 'with_accesskey' => $with_accesskey );
            }
            my $text = $nav_links_renderer->get_total_html(@params);
=cut
