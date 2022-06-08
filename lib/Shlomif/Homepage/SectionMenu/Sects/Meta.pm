package Shlomif::Homepage::SectionMenu::Sects::Meta;

use strict;
use warnings;
use 5.014;
use parent 'Shlomif::Homepage::SectionMenu::BaseSectionClass';
use utf8;
use Carp qw/ cluck confess /;

use MyNavData::Hosts ();

my $_section_navmenu_tree_contents = {
    host        => "t2",
    text        => "Meta Info",
    title       => "Site Meta Information Section Menu",
    show_always => 1,
    expand      => { re => "^meta/", },
    url         => "meta/",
    subs        => [
        {
            text  => "FAQ",
            title => "Frequently Asked Questions",
            url   => "meta/FAQ/",
        },
        {
            text => "How to help",
            url  => "meta/how-to-help/",
            subs => [
                {
                    text => "Donate",
                    url  => "meta/donate/",
                },
                {
                    text => "Site’s Sources",
                    url  => "meta/site-source/",
                },
            ],
        },
        {
            text => "Navigation Blocks",
            url  => "meta/nav-blocks/blocks/",
        },
        {
            text  => "Copyrights Terms",
            title => "Copyright Terms of my site",
            url   => "meta/copyrights/",
        },
        {
            text => "Privacy Policy",
            url  => "meta/privacy-policy/",
        },
        {
            text => "Linking Policy",
            url  => "meta/linking-policy/",
        },
        {
            text => "Anti-Spam Policy",
            url  => "meta/anti-spam-policy/",
        },
        {
            text => "In the Event of My Death",
            url  => "meta/in-the-event-of-my-death/",
        },
        {
            text => "About our Hosting Provider",
            url  => "meta/hosting/",
        },
        {
            text => "Photos of Myself",
            url  => "meta/self-photos/",
        },
        {
            text  => "Old Site Snapshots (Nostalgia)",
            url   => "meta/old-site-snapshots/",
            title => "The site as it looked like many years ago.",
        },
    ],
};

my $section_navmenu_tree_contents_by_lang =
    __PACKAGE__->_calc_lang_trees_hash($_section_navmenu_tree_contents);

sub get_params
{
    my ( $self, $args ) = @_;

    my $lang = $args->{lang}
        or confess("lang was not specified.");

    my @keys = sort keys %$lang;
    if ( @keys == 1 )
    {
        $lang = shift @keys;
    }
    else
    {
        $lang = 'en';
    }
    my $tree_contents = $section_navmenu_tree_contents_by_lang->{$lang};
    if (0)    # ( $lang ne 'en' )
    {
        cluck "lang=$lang";
        say Data::Dumper->new( [ $tree_contents, ] )->Dump();
    }
    return (
        hosts         => scalar( MyNavData::Hosts::get_hosts() ),
        tree_contents => $tree_contents,
    );
}

1;
