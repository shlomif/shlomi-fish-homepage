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

    return '../'.repeat(count);
}

function test_nav_menu_generation()
{
    module("NavMenu.Main.ToJQTree");

    test("NavMenu main test", function () {
        expect(2);

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
            '../',
            "relative path 1"
        );
    });
}
