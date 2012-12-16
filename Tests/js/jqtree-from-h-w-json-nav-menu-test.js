"use strict";
/*
 * Tests for the jQtree generation routines.
 * Copyright by Shlomi Fish, 2012.
 * */

// Taken from http://stackoverflow.com/questions/202605/repeat-string-javascript
if (!String.prototype.repeat) {
String.prototype.repeat = function(count) {
    if (count < 1) return '';
    var result = '', pattern = this.valueOf();
    while (count > 0) {
        if (count & 1) result += pattern;
        count >>= 1, pattern += pattern;
    };
    return result;
};
}

function get_base_relative_path (args) {
    var base = args.base;
    var current = args.current;

    var rel_path = current.substring(base.length);

    var count = (rel_path.match(/\//g)||[]).length;

    /*
    if (rel_path.match(/[^\/]$/))
    {
        count++;
    }*/

    return ('./' + ('../'.repeat(count)));
}

function get_relative_path (args) {
    return get_base_relative_path(args) + args.to;
}

function test_nav_menu_generation()
{
    module("NavMenu.Main.ToJQTree");

    test("NavMenu main test", function () {
        expect(7);

        // TEST
        ok (true, "True is, well, true.");

        // TEST
        equal (
            get_base_relative_path(
                {
                    base: 'http://www.shlomifish.org/',
                    current: 'http://www.shlomifish.org/humour/',
                }
            ),
            './../',
            "relative path 1"
        );

        // TEST
        equal (
            get_base_relative_path(
                {
                    base: 'http://www.shlomifish.org/',
                    current: 'http://www.shlomifish.org/humour.html',
                }
            ),
            './',
            "relative path 2"
        );

        // TEST
        equal (
            get_base_relative_path(
                {
                    base: 'http://www.shlomifish.org/',
                    current: 'http://www.shlomifish.org/sod/foobar/',
                }
            ),
            './../../',
            "relative path 3"
        );

        // TEST
        equal (
            get_base_relative_path(
                {
                    base: 'http://www.shlomifish.org/',
                    current: 'http://www.shlomifish.org/sod/foobar/l.html',
                }
            ),
            './../../',
            "relative path with trailing .html page"
        );

        // TEST
        equal (
            get_relative_path(
                {
                    base: 'http://www.shlomifish.org/',
                    current: 'http://www.shlomifish.org/humour/',
                    to: 'me/intros/writers/'
                }
            ),
            './../me/intros/writers/'
        );

        // TEST
        equal (
            get_relative_path(
                {
                    base: 'http://www.shlomifish.org/',
                    current: 'http://www.shlomifish.org/humour/foo.html',
                    to: 'me/intros/writers/'
                }
            ),
            './../me/intros/writers/'
        );
    });
}
