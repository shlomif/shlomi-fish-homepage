package Shlomif::Homepage::SectionMenu::Sects::Me;

use strict;
use warnings;
use 5.014;
use parent 'Shlomif::Homepage::SectionMenu::BaseSectionClass';
use utf8;
use Carp qw/ cluck confess /;

use MyNavData::Hosts ();

my @personal_expand = ( expand => { bool => 1, capt => 0, }, );

my $_section_navmenu_tree_contents = {
    host        => "t2",
    show_always => 1,
    text        => "About Myself",
    url         => "me/",
    @personal_expand,
    subs => [
        {
            text   => "Bio",
            url    => "personal.html",
            title  => "A Short Biography of Myself",
            expand => { re => "^(?:me/|personal/)", },
            subs   => [
                {
                    text  => "Intros",
                    url   => "me/intros/",
                    title => "Introductions of Me to Various Forums",
                    skip  => 1,
                    subs  => [
                        {
                            text  => "MIT Writers",
                            url   => "me/intros/writers/",
                            title => "My Intro to the MIT Writers Mailing List",
                            skip  => 1,
                        },
                    ],
                },
            ],
        },
        {
            text  => "Contact Me",
            url   => "me/contact-me/",
            title => "How to Contact Me",
        },
        {
            text  => "“Rindolf” - my nickname",
            url   => "me/rindolf/",
            title =>
"The history and etymology of “Rindolf”, Shlomi Fish’s Nickname",
            subs => [
                {
                    text =>
                        "“Rindolfism” - my personal, dynamic, philosophy",
                    url   => "me/rindolfism/",
                    title =>
"Shlomi Fish’s Personal, dynamic, open / free / geeky / share / hacky philosophy",
                    skip => 1,
                },
            ],
        },
        {
            text => "My Résumés",
            url  => "me/resumes/",
            subs => [
                {
                    text => "Résumé as a Software Dev",
                    url => "me/resumes/Shlomi-Fish-Resume-as-Software-Dev.html",
                },
                {
                    text => "English Résumé",
                    url  => "SFresume.html",
                    skip => 1,
                },
                {
                    text => "Detailed English Résumé",
                    url  => "SFresume_detailed.html",
                    skip => 1,
                },
                {
                    text => "Résumé as a Writer and Entertainer",
                    url  =>
"me/resumes/Shlomi-Fish-Resume-as-Writer-Entertainer.html",
                },
            ],
        },
        {
            text => "My Business Card",
            url  => "me/business-card/",
        },
        {
            text  => "Personal Ad",
            url   => "me/personal-ad.html",
            title =>
"My Personal Ad: what I’m looking for in a prospective girlfriend and what I can add to the relationship.",
        },
        {
            text  => "My Weblogs",
            url   => "me/blogs/",
            title => "Links to my online journals.",
        },
        {
            text  => "Interviews",
            url   => "me/interviews/",
            title => "Interviews that were conducted with me",
            skip  => 1,
            subs  => [
                {
                    text => "Reddit “Ask Me Anything”",
                    url  => "me/interviews/reddit-AMA/",
                    skip => 1,
                },
            ],
        },
        {
            text  => "Relicensing my Creative Works Portfolio",
            url   => "me/relicensing-my-entire-portfolio-under-cc-by/",
            title =>
"Offer to relicense my whole body of creative works under CC-by if I get enough money",
            skip => 1,
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
