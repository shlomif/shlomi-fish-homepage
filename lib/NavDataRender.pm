package NavDataRender;

use strict;
use warnings;

use utf8;

use MyNavData;
use HTML::Widgets::NavMenu::JQueryTreeView;

use CGI qw();
use MyNavLinks;

use Shlomif::WrapAsUtf8 (qw(_wrap_as_utf8));

sub nav_data_render
{
    my ($class, $args) = @_;

    my $filename = $args->{filename};
    my $host = $args->{host};
    my $ROOT = $args->{ROOT};

    $filename =~ s!index\.html$!!;
    $filename = "/$filename";

    my $shlomif_main_expanded_nav_bar = HTML::Widgets::NavMenu::JQueryTreeView->new(
        'path_info' => $filename,
        'current_host' => $host,
        MyNavData->generic_get_params({ fully_expanded => 1}),
        'ul_classes' => [ "navbarmain", ("navbarnested") x 10 ],
        'no_leading_dot' => 1,
    );

    my $rendered_results = $shlomif_main_expanded_nav_bar->render();

    # use Data::Dumper; die Dumper($rendered_results);
    my $shlomif_nav_links = $rendered_results->{nav_links};

    my $shlomif_nav_links_obj = $rendered_results->{nav_links_obj};

    my $shlomif_nav_links_renderer = MyNavLinks->new(
        'nav_links' => $shlomif_nav_links,
        'nav_links_obj' => $shlomif_nav_links_obj,
        'root' => "$ROOT",
    );

    return
    +{
        nav_links_renderer => $shlomif_nav_links_renderer,
        shlomif_main_expanded_nav_bar => $shlomif_main_expanded_nav_bar,
    };
}

sub render_breadcrumbs_trail_unconditionally
{
    my ($class, $args) = @_;

    my $total_leading_path = $args->{total_leading_path};

    my $render_leading_path_component = sub {
        my $component = shift;
        my $title = $component->title();
        my $title_attr = defined($title) ? " title=\"$title\"" : "";
        return "<a href=\"" . CGI::escapeHTML($component->direct_url()) .
            "\"$title_attr>" .
            $component->label() . "</a>";
    };
    {
        _wrap_as_utf8( sub {
            print join(" → ",
                (map
                 { $render_leading_path_component->($_) }
                 @$total_leading_path
                ));
        });
    }
}

1;
