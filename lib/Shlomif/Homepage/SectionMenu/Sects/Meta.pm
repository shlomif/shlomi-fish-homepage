package Shlomif::Homepage::SectionMenu::Sects::Meta;

use strict;
use warnings;

use utf8;

use MyNavData;

my $meta_tree_contents =
{
    host => "t2",
    text => "Site Meta Information Section Menu",
    title => "Site Meta Information Section Menu",
    show_always => 1,
    subs =>
    [
        {
            text => "Meta Info",
            url => "meta/",
        },
        {
            text => "FAQ",
            title => "Frequently Asked Questions",
            url => "meta/FAQ/",
        },
        {
            text => "How to help",
            url => "meta/how-to-help/",
            subs =>
            [
                {
                    text => "Donate",
                    url => "meta/donate/",
                },
                {
                    text => "Site’s Sources",
                    url => "meta/site-source/",
                },
            ],
        },
        {
            text => "Copyrights Terms",
            title => "Copyright Terms of my site",
            url => "meta/copyrights/",
        },
        {
            text => "Privacy Policy",
            url => "meta/privacy-policy/",
        },
        {
            text => "Linking Policy",
            url => "meta/linking-policy/",
        },
        {
            text => "Anti-Spam Policy",
            url => "meta/anti-spam-policy/",
        },
        {
            text => "About our Hosting Provider",
            url => "meta/hosting/",
        },
    ],
};

sub get_params
{
    return
        (
            hosts => MyNavData::get_hosts(),
            tree_contents => $meta_tree_contents,
        );
}

1;

