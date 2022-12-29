package Shlomif::Homepage::SectionMenu;

use strict;
use warnings;
use 5.014;

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
has 'lang'         => ( is => 'ro', isa => 'HashRef',    required => 1, );
has 'nav_menu'     => ( is => 'rw', );
has 'path_info'    => ( is => 'rw', isa => 'Str', required => 1, );

sub _mutate__leading_path
{
    my ( $self, $leading_path, $idx ) = @_;

    if ( $self->path_info =~ m# \A (?:/)? humour/bits/true-stories/#msx )
    {
        my $h = $leading_path->[$idx];

        # die $h->label();
        $h->label("Stories");
        $h->title( undef() );
    }
    else
    {
        # else...
    }
    return;
}

has 'results' => (
    is      => 'ro',
    isa     => 'HashRef',
    lazy    => 1,
    default => sub {
        my $self = shift;
        if ( not $self->nav_menu )
        {
            Carp::confess("nav_menu not specified");
        }
        my $results      = $self->nav_menu->render();
        my $leading_path = $results->{leading_path};
        $self->_mutate__leading_path( $leading_path, 0 );
        return $results;
    },
);
has 'root'     => ( is => 'rw', required => 1, );
has 'sections' => ( is => 'ro', required => 1, );
has 'title'    => ( is => 'rw' );
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

    return $class->generic_get_params($args);
}

sub get_modified_sub_tree
{
    my ( $self, $sect, $args ) = @_;

    if ( ( ref $args ne 'HASH' ) or ( not $args->{lang} ) )
    {
        Carp::confess("lang not specified");
    }

    my $tree_contents =
        +{ $self->get_section_nav_menu_params( $sect, $args ) }
        ->{tree_contents};
    return $tree_contents;

=begin foo

    my $subs = $tree_contents->{subs};

    return { %{ $subs->[0] }, subs => [ @{$subs}[ 1 .. $#$subs ] ], };

=end foo

=cut

}

sub _calc_current_sect
{
    my $self = shift;

    my @s = @{ $self->sections() };
    if ( not grep { $_->{class} =~ /Lect/ } @s )
    {
        die;
    }
    my $ret = sub {
        foreach my $sect (@s)
        {
            my $regexp = $sect->{'regex'};
            if ( ( $regexp eq "" ) || ( $self->path_info() =~ /$regexp/ ) )
            {
                return $sect;
            }
        }
        return;
        }
        ->();
    {
        my @s = @{ $self->sections() };
        if ( not grep { $_->{class} =~ /Lect/ } @s )
        {
            die;
        }
    }

    return $ret;
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
        my @params = $self->get_section_nav_menu_params(
            $current_sect->{class},
            { lang => +{ ar => 1, en => 1, he => 1, }, },
        );

        # $DB::single = 1;
        $self->nav_menu(
            HTML::Widgets::NavMenu->new(
                coords_stop  => 1,
                'path_info'  => $self->path_info(),
                current_host => $self->current_host(),
                @params,
                'ul_classes'     => [ "nm_main", ],
                'no_leading_dot' => 1,
            )
        );
        if ($::nav_menu_test)
        {
            my $nav_menu     = $self->nav_menu();
            my $results      = $nav_menu->render();
            my $leading_path = $results->{leading_path};
            if ( $leading_path->[0]->host_url ne
                ( $::nav_menu_test == 1 ? "humour/" : "lecture/" ) )
            {
                $DB::single = 1;
                my $results2 = $nav_menu->render();
                die;
            }
        }
        if (0)
        {
            say Data::Dumper->new(
                [
                    # \@params,
                    # $self->nav_menu(),

                    $self->nav_menu()->render()->{leading_path},
                ]
            )->Dump();
        }
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
        $self->_mutate__leading_path( \@main_leading_path, 1 );
        my @local_path = @{ $self->results()->{'leading_path'} };
        if ($::nav_menu_test)
        {
            $DB::single = 1;
        }

        my $url = $main_leading_path[-1]->host_url();
        while ( @local_path
            && ( $local_path[0]->host_url() ne $url ) )
        {
            shift(@local_path);
        }
        shift(@local_path);

        return [ @main_leading_path, @local_path ];
    }
}

1;
