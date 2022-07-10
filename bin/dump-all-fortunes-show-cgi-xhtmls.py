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

import os
import sys
import unittest

import html_unit_test

# from webtest import TestApp
sys.path.append('./src/humour/fortunes/')
import fortunes_show  # noqa:E402


class MyTests(html_unit_test.TestCase):
    def test_meta_desc_tag(self):
        # app = TestApp(fortunes_show.app)
        # assert app
        strings_list = fortunes_show._list_all_string_ids()
        containing_dest_dir = "dest/post-incs/t2/humour/fortunes/"
        dest_dir = containing_dest_dir + "__FORTS-show-cgi-xhtmls"
        os.makedirs(dest_dir, exist_ok=True, )
        maxidlen = max(len(x) for x in strings_list)
        print('maxidlen = ', maxidlen)
        RECORD_LEN = (1 << 7)
        assert maxidlen < RECORD_LEN
        randfn = containing_dest_dir + "__FORTS-show-cgi-ids.dat"
        with open(randfn, 'wb') as f:
            for str_id in strings_list:
                s = str_id + ("\n" * (RECORD_LEN - len(str_id)))
                assert len(s) == RECORD_LEN
                s = s.encode('utf8')
                assert len(s) == RECORD_LEN
                f.write(s)
        for str_id in strings_list:
            # resp = app.get('?id=' + str_id)
            # assert resp.status_code == 200
            # text = resp.text  # .encode('utf8')
            text = fortunes_show._show_by_str_id(raw_mode=False, str_id=str_id)
            assert len(text) > 0
            # print(text)
            fn = dest_dir + "/" + str_id + ".xhtml"
            with open(fn, 'wt') as f:
                f.write(text)


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
