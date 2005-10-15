package Shlomif::Homepage::SectionMenu;

use strict;
use warnings;

use base 'HTML::Widgets::NavMenu::Object';
use base 'Class::Accessor';

use HTML::Widgets::NavMenu;

__PACKAGE__->mk_accessors(qw(
    current_host
    empty
    menu
    nav_menu
    path_info
    results
    sections
    title
));

sub initialize
{
    my $self = shift;
    my (%args) = @_;
    $self->sections($args{'sections'});
    $self->path_info($args{'path_info'});
    $self->empty(0);
    $self->current_host($args{current_host});

    my $current_sect;
    SECTION_LOOP: foreach my $sect (@{$self->sections()})
    {
        my $regexp = $sect->{'regex'};
        if (($regexp eq "") || ($self->path_info() =~ /$regexp/))
        {
            $current_sect = $sect;
            last SECTION_LOOP;
        }
    }
    if (!defined($current_sect))
    {
        $self->empty(1);
    }
    else
    {
        my $class_id= $current_sect->{'class'};
        my $class = "Shlomif::Homepage::SectionMenu::Sects::$class_id";
        eval "require $class";
        my $nav_menu = HTML::Widgets::NavMenu->new(
            'path_info' => $self->path_info(),
            current_host => $self->current_host(),
            (eval "${class}::get_params()"),
            'ul_classes' => 
                [ "nm_main", "nm_nested", "nm_subnested", "nm_subsubnested", ],
            );
        my $results = $nav_menu->render();
        $self->nav_menu($nav_menu);
        $self->results($results);
        $self->title($current_sect->{'title'});
    }
}

sub get_html
{
    my $self = shift;
    if ($self->empty())
    {
        return "";
    }
    else
    {
        return qq{<div class="sub_menu">\n} .
            qq{<h2>} . $self->title() . qq{</h2>\n} .
            qq{<a id="toggle_sect_menu" href="javascript:toggle_sect_menu()" class="toggle_sect_menu">Hide</a>\n} .
            qq{<div id="sect_menu_wrapper">\n} .
            join("\n", @{$self->results()->{html}}) .
            qq{\n</div>\n</div>\n};
    }
}

1;


