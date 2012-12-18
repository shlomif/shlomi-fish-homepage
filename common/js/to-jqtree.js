"use strict";
/*
 * jQtree from HTML-Widgets-NavMenu code.
 *
 * Copyright by Shlomi Fish, 2012 under the MIT/X11 Licence.
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
    var rel_path = args.rel_path;

    //var rel_path = current.substring(base.length);

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
    var rel_path = args.rel_path;

    var _get_rel = function (href) {
        return get_relative_path(
            {
                rel_path: rel_path,
                to: href,
            }
        );
    };

    // TODO : XSS - cross site scripting.
    var _recurse;
    var _next_id = 0;

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
            id: (++_next_id),
        };

        if ('subs' in sub_tree) {
            ret.children = _recurse(sub_tree.subs);
        }

        return ret;
    };

    return _recurse(args.input);
}
