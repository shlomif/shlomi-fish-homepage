package Contents;

use strict;

my $contents =
{
    'title' => "The Cathedral and the Bazaar Series",
    'subs' =>
    [
        {
            'url' => "who_is_esr.html",
            'title' => "Who is Eric S. Raymond",
        },
        {
            'url' => "catb",
            'title' => "The Cathedral and the Bazaar",
            'subs' =>
            [
                {
                    'url' => "two_ways.html",
                    'title' => "Two Ways of Managing a Project",
                },
                {
                    'url' => "how_to_start.html",
                    'title' => "How to start a Bazaar-style Project",
                },
                {
                    'url' => "users.html",
                    'title' => "The Users and how to Treat them",
                },
                {
                    'url' => "release_early_release_often.html",
                    'title' => "Release Early, Release Often",
                },
                {
                    'url' => "ideas_from_users.html",
                    'title' => "Getting Ideas from Users",
                },
                {
                    'url' => "category_killer.html",
                    'title' => "Fetchmail Becomes a Category Killer",
                },
                {
                    'url' => "overcoming_brooks_law.html",
                    'title' => "Overcoming Brooks' Law",
                },
                {
                    'url' => "final_notes.html",
                    'title' => "Final Notes about CatB",
                },
            ],
        },
        {
            'url' => "homesteading",
            'title' => "Homesteading the Noosphere",
            'subs' =>
            [
                {
                    'url' => "gift_culture.html",
                    'title' => "The Hacker Community as a Gift Culture",
                },
                {
                    'url' => "lack_of_project_niches.html",
                    'title' => "The Lack of Project Niches",
                },
                {
                    'url' => "lockean_property_theory.html",
                    'title' => "The Lockean Property Theory",
                },
                {
                    'url' => "application_to_projects.html",
                    'title' => "Application to Projects",
                },
                {
                    'url' => "egolessness.html",
                    'title' => "Ego-lessness in the Hackers Community",
                },
                {
                    'url' => "rewards_and_motivation.html",
                    'title' => "Rewards and Motivation",
                },
            ],
        },
        {
            'url' => "magic-cauldron",
            'title' => "The Magic Cauldron",
            'subs' =>
            [
                {
                    'url' => "the_magic.html",
                    'title' => "The Magic of the Open-Source World",
                },
                {
                    'url' => "use_value_and_sale_value.html",
                    'title' => "Use Value and Sale Value",
                },
                {
                    'url' => "inverse_commons.html",
                    'title' => "The Inverse Commons Model",
                },
                {
                    'url' => "case_studies",
                    'title' => "Case Studies",
                    'subs' =>
                    [
                        {
                            'url' => "apache.html",
                            'title' => "Apache : Cost Sharing",
                        },
                        {
                            'url' => "zope.html",
                            'title' => "Zope : Give Away a Recipe, Open a Restaurant",
                        },
                        {
                            'url' => "doom.html",
                            'title' => "Doom : Becoming Open-Source at the Right Time",
                        },
                    ],
                },
                {
                    'url' => "business.html",
                    'title' => "Business and Open-Source",
                },
            ],
        },
        {
            'url' => "take.html",
            'title' => "My Title",
        },
    ],
    'images' =>
    [
        "style.css",
    ],
};

sub get_contents
{
    return $contents;
}

1;
