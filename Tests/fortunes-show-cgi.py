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

from webtest import TestApp
sys.path.append('./src/humour/fortunes/')
import fortunes_show  # noqa:E402


class MyTests(unittest.TestCase):
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


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
