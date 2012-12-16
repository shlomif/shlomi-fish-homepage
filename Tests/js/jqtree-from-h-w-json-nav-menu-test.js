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

if (!Array.prototype.map)
{
  Array.prototype.map = function(fun /*, thisp */)
  {
    "use strict";

    if (this === void 0 || this === null)
      throw new TypeError();

    var t = Object(this);
    var len = t.length >>> 0;
    if (typeof fun !== "function")
      throw new TypeError();

    var res = new Array(len);
    var thisp = arguments[1];
    for (var i = 0; i < len; i++)
    {
      if (i in t)
        res[i] = fun.call(thisp, t[i], i, t);
    }

    return res;
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

// Taken from http://stackoverflow.com/questions/24816/escaping-html-strings-with-jquery
function escape_html (str) {
    // No jQuery, so use string replace.
    return str
        .replace(/&/g, '&amp;')
        .replace(/>/g, '&gt;')
        .replace(/</g, '&lt;')
        .replace(/"/g, '&quot;');
}

function calc_jqtree_data_from_html_w_nav_menu_json (args) {
    var base = args.base;
    var current = args.current;

    var _get_rel = function (href) {
        return get_relative_path(
            {
                base: base,
                current: current,
                to: href,
            }
        );
    };

    // TODO : XSS - cross site scripting.
    var _recurse;

    _recurse = function(sub_tree) {
        if ($.isArray(sub_tree)) {
            return sub_tree.map(_recurse);
        }

        var title_attr = '';

        if ('title' in sub_tree) {
            title_attr = ' title="' + sub_tree['title'] + '"'
        }
        var ret = {
            label: ("<a href=\"" +
                escape_html(_get_rel(sub_tree['url'])) + "\"" + title_attr +
                ">" + sub_tree['text'] + "</a>"
                ),
        };

        if ('subs' in sub_tree) {
            ret.children = _recurse(sub_tree.subs);
        }

        return ret;
    };

    return _recurse(args.input);
}

function test_nav_menu_generation()
{
    module("NavMenu.Main.ToJQTree");

    test("NavMenu main test", function () {
        expect(9);

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

        // TEST
        equal (
            get_relative_path(
                {
                    base: 'http://www.shlomifish.org/',
                    current: 'http://www.shlomifish.org/me/intros/',
                    to: 'humour/TheEnemy/te-heb.html'
                }
            ),
            './../../humour/TheEnemy/te-heb.html'
        );

        {
            // TODO : test for title.
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
                label: '<a href="./../">Shlomi Fish</a>',
                children: [
                {
                    label: '<a href="./../me/">About Myself</a>'
                },
                {
                    label: '<a href="./../humour/" title="Stories and Aphorisms I wrote">Humour</a>'
                }
                ],
            },
            ];

            deepEqual (
                calc_jqtree_data_from_html_w_nav_menu_json(
                    {
                        input: input,
                        base: 'http://www.shlomifish.org/',
                        current: 'http://www.shlomifish.org/humour/'
                    }
                ),
                expected,
                'Basic tree test No. 1'
            );
        }
    });
}
