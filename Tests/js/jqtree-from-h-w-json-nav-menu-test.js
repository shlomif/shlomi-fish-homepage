"use strict";
/*
 * Tests for the jQtree generation routines.
 * Copyright by Shlomi Fish, 2012.
 * */

function test_nav_menu_generation()
{
    module("NavMenu.Main.ToJQTree");

    test("NavMenu main test", function () {
        expect(10);

        // TEST
        ok (true, "True is, well, true.");

        // TEST
        equal (
            get_base_relative_path(
                {
                    rel_path: 'humour/',
                }
            ),
            './../',
            "relative path 1"
        );

        // TEST
        equal (
            get_base_relative_path(
                {
                    rel_path: 'humour.html',
                }
            ),
            './',
            "relative path 2"
        );

        // TEST
        equal (
            get_base_relative_path(
                {
                    rel_path: 'sod/foobar/',
                }
            ),
            './../../',
            "relative path 3"
        );

        // TEST
        equal (
            get_base_relative_path(
                {
                    rel_path: 'sod/foobar/l.html',
                }
            ),
            './../../',
            "relative path with trailing .html page"
        );

        // TEST
        equal (
            get_relative_path(
                {
                    rel_path: 'humour/',
                    to: 'me/intros/writers/'
                }
            ),
            './../me/intros/writers/'
        );

        // TEST
        equal (
            get_relative_path(
                {
                    rel_path: 'humour/foo.html',
                    to: 'me/intros/writers/'
                }
            ),
            './../me/intros/writers/'
        );

        // TEST
        equal (
            get_relative_path(
                {
                    rel_path: 'me/intros/',
                    to: 'humour/TheEnemy/te-heb.html'
                }
            ),
            './../../humour/TheEnemy/te-heb.html'
        );

        {
            var input = [
            {
                "text": 'Shlomi Fish',
                "url": "",
                "subs": [
                    {
                        "text": "About Myself",
                        "url": "me/"
                    },
                    {
                        "text": "Humour",
                        "title": "Stories and Aphorisms I wrote",
                        "url": "humour/"
                    }
                ]
            }
            ];

            // TEST
            var expected = [
            {
                id: 1,
                label: '<a href="./../">Shlomi Fish</a>',
                children: [
                {
                    id: 2,
                    label: '<a href="./../me/">About Myself</a>'
                },
                {
                    id: 3,
                    label: '<a href="./../humour/" title="Stories and Aphorisms I wrote">Humour</a>'
                }
                ],
            },
            ];

            deepEqual (
                calc_jqtree_data_from_html_w_nav_menu_json(
                    {
                        input: input,
                        rel_path: 'humour/',
                    }
                ),
                expected,
                'Basic tree test No. 1'
            );
        }

        {
            var input = [
            {
                "text": 'Shlomi Fish',
                "url": "",
                "subs": [
                    {
                        "text": "About Myself",
                        "url": "me/"
                    },
                    {
                        "text": "Humour",
                        "title": "Stories and Aphorisms I wrote",
                        "url": "humour/",
                        "subs": [
                            {
                                "text": "The One With The Fountainhead",
                                "title": "Parody of The Fountainhead",
                                "url": "humour/TOWTF/"
                            },
                            {
                                "text": "HHFG",
                                "title": "The Human Hacking Field Guide",
                                "url": "humour/human-hacking/",
                                "subs": [
                                    {
                                        "text": "Hebrew Translation",
                                        "url": "humour/human-hacking/heb.html"
                                    }
                                ]
                            }
                        ]
                    }
                ]
            }
            ];

            // TEST
            var expected = [
            {
                id: 1,
                label: '<a href="./../../">Shlomi Fish</a>',
                children: [
                {
                    id: 2,
                    label: '<a href="./../../me/">About Myself</a>'
                },
                {
                    id: 3,
                    label: '<a href="./../../humour/" title="Stories and Aphorisms I wrote">Humour</a>',
                    children: [
                        {
                            id: 4,
                            label: '<a href="./../../humour/TOWTF/" title="Parody of The Fountainhead">The One With The Fountainhead</a>',
                        },
                        {
                            id: 5,
                            label: '<a href="./../../humour/human-hacking/" title="The Human Hacking Field Guide">HHFG</a>',
                            children: [
                                {
                                    id: 6,
                                    label: '<a href="./../../humour/human-hacking/heb.html">Hebrew Translation</a>'
                                }
                            ]
                        }
                    ]
                }
                ]
            }
            ];

            deepEqual (
                calc_jqtree_data_from_html_w_nav_menu_json(
                    {
                        input: input,
                        rel_path: 'art/solgans/',
                    }
                ),
                expected,
                'Nested tree test'
            );
        }
    });
}
