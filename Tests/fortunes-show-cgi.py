#!/usr/bin/env python3
"""

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
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

=cut
"""

import sys
import unittest

import html_unit_test

from webtest import TestApp
sys.path.append('./src/humour/fortunes/')
import fortunes_show  # noqa:E402


class MyTests(html_unit_test.TestCase):
    def test_main(self):
        app = TestApp(fortunes_show.app)
        assert app
        resp = app.get('?id=shlomif-fact-chuck-118')
        assert resp.status_code == 200
        assert ("proven experience" in resp.text)

    def test_not_exist_id(self):
        app = TestApp(fortunes_show.app)
        assert app
        resp = app.get('?id=NotExiSTTTTTTttttt', expect_errors=True)
        assert resp.status_code == 404
        assert ("The fortune ID NotExiSTTTTTTttttt is not recog" in resp.text)

    def test_meta_desc_tag(self):
        app = TestApp(fortunes_show.app)
        assert app
        resp = app.get('?id=i-thought-using-loops-was-cheating')
        assert resp.status_code == 200
        doc = self.doc({
            'type': 'text',
            'fn': 'test_meta_desc_tag',
            'text': resp.text.encode('utf8'),
        })
        doc.has_one(
            "//html/head/meta[@name='description' " +
            "and contains(@content, 'recorded')]")
        doc.has_one(
            "descendant::table[@class='info']"
        )
        doc.has_one(
            "descendant::time[contains(@datetime, '2020-08-27')]"
        )
        doc.has_one(
            "descendant::time[contains(text(), '27-August-2020')]"
        )
        doc.has_one(
            "descendant::title[contains(text(), '[possible satire]')]"
        )

    def test_raw_mode(self):
        app = TestApp(fortunes_show.app)
        assert app
        resp = app.get('?id=i-thought-using-loops-was-cheating&mode=raw')
        assert resp.status_code == 200
        doc = self.doc({
            'type': 'text',
            'fn': 'test_raw_mode',
            'text': resp.text.encode('utf8'),
        }, filetype='html')
        doc.has_one(
            "//html/body/div[@class='fortune']/blockquote/" +
            "p[contains(text(), 'thought that programming')]"
        )
        doc.has_one(
            "//html/body/div[@class='fortune']/blockquote/" +
            "p[contains(text(), 'thought that programming')]"
        )
        doc.has_none(
            "//table[@class='info']"
        )


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
