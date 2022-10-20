#!/usr/bin/env python3

import datetime
import html
import os.path
import random
import re
import sqlite3
import sys

# We're using random later.
random.seed()

# The Directory containing the script.
script_dirname = os.path.dirname(os.path.abspath(__file__))
sys.path.append(script_dirname)
from bottle import Bottle, abort, redirect, request, response, \
    run, template  # noqa: E402

DB_BASE_NAME = "fortunes-shlomif-lookup.sqlite3"

full_db_path = script_dirname + "/" + DB_BASE_NAME

dbh = sqlite3.connect(full_db_path)
cur = dbh.cursor()

NL = "\015\012"

app = Bottle()


def _my_fullpath():
    return re.sub('/+$', '', request.fullpath)


def _list_all_string_ids():
    """docstring for _list_all_string_ids"""
    cur.execute(
        'SELECT str_id FROM fortune_cookies ORDER BY str_id',
    )
    strings = cur.fetchall()
    strings = [s for (s,) in strings]
    return strings


def _emit_error(title, body):
    abort(404,
          '''<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>%(title)s</title>
<meta charset="utf-8" />
</head>
<body>
%(body)s
</body>
</html>''' % {'title': title, 'body': body})


def _show_all():
    cur.execute(
        '''SELECT f.str_id, f.text, f.info_text, f.title,
        c.str_id, c.title, f.desc, f.date
FROM fortune_cookies AS f, fortune_collections AS c
WHERE (collection_id = c.id)
ORDER BY c.str_id''', )
    while True:
        data = cur.fetchone()
        if data:
            texts = {
                raw_mode: _display_fortune_from_data(
                    *([raw_mode] + list(data))
                ) for raw_mode in (False, True)
            }
            yield data, texts
        else:
            return


def _show_by_str_id(raw_mode, str_id):
    if not str_id:
        return _emit_error(
            title='ID parameter not specified',
            body='''<h1>Error! Must specify ID parameter</h1>
<p>
The ID parameter must be specified.
</p>''')

    cur.execute(
        '''SELECT f.text, f.info_text, f.title, c.str_id, c.title, f.desc, f.date
FROM fortune_cookies AS f, fortune_collections AS c
WHERE ((f.str_id = ?) AND (f.collection_id = c.id))''', (str_id,))
    data = cur.fetchone()
    if data:
        return _display_fortune_from_data(*([raw_mode, str_id] + list(data)))
    else:
        return _emit_error(
            title='URL not found',
            body='''<h1>URL not found</h1>

<p>
The fortune ID %s is not recognised.
If you've reached this URL and think it should
be defined please contact <a href="mailto:shlomif@shlomifish.org">Shlomi
Fish (the Webmaster)</a> and let him know of this problem.
</p>''' % (html.escape(str_id, True)))


@app.route(['/'])
def main():
    response.content_type = 'application/xhtml+xml; charset=utf-8'
    mode = request.query.mode or 'str_id'

    if mode == "random":
        return _pick_random()
    elif mode == "str_id":
        str_id = request.query.id
        return _show_by_str_id(raw_mode=False, str_id=str_id)
    elif mode == "raw":
        str_id = request.query.id
        return _show_by_str_id(raw_mode=True, str_id=str_id)
    else:
        return _invalid_mode(mode)


def _invalid_mode(mode):
    mode_esc = html.escape(mode, True)

    _emit_error(
        title='Error! Invalid mode "%s"' % (mode_esc),
        body='''<h1>Error! Invalid mode "%s".</h1>
<p>
Only valid modes are <code>random</code> and <code>str_id</code>
(where <code>str_id</code> is the default).
</p>''' % (mode_esc))


def _pick_random():
    cur.execute('SELECT MAX(id) FROM fortune_cookies')
    max_id = cur.fetchone()

    if not max_id:
        _emit_error(
            title="Query failed",
            body='''<h1>Query failed</h1>

<p>
Report this problem to the webmaster.
</p>''')
        return

    cur.execute(
        'SELECT str_id FROM fortune_cookies WHERE id = ?',
        (str(random.randint(1, int(max_id[0]))),)
    )

    str_id = cur.fetchone()

    if not str_id:
        _emit_error(
            title='Unknown fortune ID',
            body='''<h1>lookup_str_id_from_id query failed</h1>
<p>
Report this problem to the webmaster.
</p>''')
        return

    # str_id must not contain any strange HTML/URI/etc. characters
    # If it does - then we suck.
    redirect(_my_fullpath() + "?id=" + str_id[0])


MOBILE_DEVICES_COMPAT_CODE = \
    '<meta name="viewport" content="width' + \
    '=device-width, initial-scale=1.0" />\n'


NON_RAW_TEMPLATE = \
    '''<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>{{title}}</title>
<link rel="stylesheet" href="{{base_dir}}/fort_total.css" media="screen" />
<meta charset="utf-8" />
<meta name="description" content="{{description}}" />
''' + \
    MOBILE_DEVICES_COMPAT_CODE + \
    '''<script src="{{base_dir}}/js/fortunes_show.js"></script>
</head>
<body>
<ul id="nav">
<li><a href="/">Shlomi Fish's Homepage</a></li>
<li><a href="./">Fortune Cookies Page</a></li>
<li><a href="{{col_str_id}}.html">{{col_title}}</a></li>
<li><a href="{{col_str_id}}.html#{{str_id}}">Fortune Cookie</a></li>
</ul>
<ul id="random">
<li><a accesskey="r" href="{{fullpath}}?mode=random">Random Fortune</a></li>
</ul>
<ul id="publish_time">
<li>Published at <time datetime="{{date}}">{{human_date}}</time></li>
</ul>
<h1>{{title}}</h1>
<div class="fortunes_list">
<div class="fortune">
{{!html_text}}
{{!html_info_text}}
</div>
</div>
</body>
</html>'''

RAW_TEMPLATE = \
                    '''<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>{{title}}</title>
<meta charset="utf-8" />
<meta name="description" content="{{description}}" />
</head>
<body>
<div class="fortune">
{{!html_text}}
</div>
</body>
</html>'''


def _display_fortune_from_data(
        raw_mode, str_id, html_text, html_info_text, html_title, col_str_id,
        col_title, description, date):
    title = html_title + " - Fortune"
    base_dir = '../..'
    m = re.search("\\A(([0-9]+)-([0-9]+)-([0-9]+))", date)
    assert m

    def gi(idx):
        return int(m.group(idx))
    d = datetime.date(year=gi(2), month=(gi(3)), day=(gi(4)))
    human_date = m.group(1)
    human_date = d.strftime("%d-%B-%Y")

    return template(
        (RAW_TEMPLATE if raw_mode else NON_RAW_TEMPLATE),
        base_dir=base_dir,
        col_str_id=col_str_id,
        col_title=col_title,
        date=date,
        description=html.escape(description, True),
        fullpath=_my_fullpath(),
        html_info_text=html_info_text,
        html_text=html_text,
        human_date=human_date,
        str_id=str_id,
        title=title
    )


if __name__ == "__main__":
    run(app, server='cgi')

'''

=head1 NAME

fortune_show.cgi - a Perl 5 , CGI.pm and L<DBD::SQLite> script to display
a fortune cookie.

=head1 COPYRIGHT & LICENSE

Copyright 2011 by Shlomi Fish.

This program is distributed under the MIT (Expat) License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

'''
