package Shlomif::Homepage::SectionMenu;

use strict;
use warnings;

package Shlomif::Homepage::SectionMenu::NavLinks;

use parent 'HTML::Latemp::NavLinks::GenHtml::ArrowImages';

sub get_image_base
{
    return 'sect-arr-';
}

package Shlomif::Homepage::SectionMenu;

use MooX (qw( late ));

use HTML::Widgets::NavMenu ();

has 'bottom_code'  => ( is => 'rw', isa => 'Maybe[Str]', required => 1, );
has 'current_host' => ( is => 'rw', isa => 'Str',        required => 1, );
has 'empty'        => ( is => 'rw', isa => 'Bool',       default  => 0, );
has 'lang'         => ( is => 'ro', isa => 'Str',        required => 1, );
has 'nav_menu'     => ( is => 'rw', );
has 'path_info'    => ( is => 'rw', isa => 'Str', required => 1, );
has 'results'      => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub { return shift->nav_menu->render(); }
);
has 'root'          => ( is => 'rw', required => 1, );
has 'sections'      => ( is => 'rw', required => 1, );
has 'title'         => ( is => 'rw' );
has '_current_sect' => (
    is      => 'ro',
    isa     => 'Maybe[HashRef]',
    lazy    => 1,
    default => sub { return shift->_calc_current_sect(); },
);

sub get_section_nav_menu_params
{
    my ( undef, $class, $args ) = @_;

    if ( ( ref $args ne 'HASH' ) or ( not $args->{lang} ) )
    {
        Carp::confess("lang not specified");
    }

    return $class->get_params($args);
}

sub get_modified_sub_tree
{
    my ( $self, $sect, $args ) = @_;

    if ( ( ref $args ne 'HASH' ) or ( not $args->{lang} ) )
    {
        Carp::confess("lang not specified");
    }

    my $subs =
        +{ $self->get_section_nav_menu_params( $sect, $args ) }
        ->{tree_contents}->{subs};

    return { %{ $subs->[0] }, subs => [ @{$subs}[ 1 .. $#$subs ] ], };
}

sub _calc_current_sect
{
    my $self = shift;

    foreach my $sect ( @{ $self->sections() } )
    {
        my $regexp = $sect->{'regex'};
        if ( ( $regexp eq "" ) || ( $self->path_info() =~ /$regexp/ ) )
        {
            return $sect;
        }
    }

    return;
}

sub BUILD
{
    my $self = shift;

    my $current_sect = $self->_current_sect();

    if ( !defined($current_sect) )
    {
        $self->empty(1);
    }
    else
    {
        $self->nav_menu(
            HTML::Widgets::NavMenu->new(
                'path_info'  => $self->path_info(),
                current_host => $self->current_host(),
                $self->get_section_nav_menu_params(
                    $current_sect->{class},
                    { lang => $self->lang(), },
                ),
                'ul_classes'     => [ "nm_main", ],
                'no_leading_dot' => 1,
            )
        );
        $self->title( $current_sect->{'title'} );
    }

    return;
}

sub get_nav_links
{
    my $self = shift;

    return Shlomif::Homepage::SectionMenu::NavLinks->new(
        ext           => '.svg',
        nav_links     => $self->results()->{nav_links},
        nav_links_obj => $self->results()->{nav_links_obj},
        root          => $self->root(),
    )->get_total_html();
}

sub get_html
{
    my $self = shift;
    if ( $self->empty() )
    {
        return "";
    }
    else
    {
        return
qq{<p class="invisible"><a href="#aft_sub_menu">Skip the sub-menu.</a></p>\n}
            . qq{<div class="sub_menu">\n}
            . qq{<h2>}
            . $self->title()
            . qq{</h2>\n}
            . $self->get_nav_links()
            . qq{<button id="toggle_sect_menu" class="toggle_sect_menu off" title="Show or Hide the Section Navigation Menu">Show</button>\n}
            . qq{<div id="sect_menu_wrapper" class="novis">\n}
            . join( "\n", @{ $self->results()->{html} } )
            . qq{\n</div>\n}
            . qq{\n</div>\n}
            . ( defined( $self->bottom_code() ) ? $self->bottom_code() : "" )
            . qq{\n<div id="aft_sub_menu"></div>\n};
    }
}

sub total_leading_path
{
    my $self = shift;
    my $args = shift;

    my @main_leading_path = @{ $args->{main_leading_path} };

    if ( $self->empty )
    {
        return ( \@main_leading_path );
    }
    else
    {
        my @local_path = @{ $self->results()->{'leading_path'} };

        my $url = $main_leading_path[-1]->direct_url();
        while ( @local_path
            && ( $local_path[0]->direct_url() ne $url ) )
        {
            shift(@local_path);
        }
        shift(@local_path);

        return [ @main_leading_path, @local_path ];
    }
}

1;
