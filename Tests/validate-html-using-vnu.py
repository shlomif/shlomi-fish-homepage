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
import re
import unittest

import vnu_validator


class MyTests(vnu_validator.VnuTest):
    def test_main(self):
        dir_ = './dest/post-incs/t2/'

        def _create_cb(s):
            """docstring for _create_cb"""
            _re = re.compile(s, re.X)

            def _cb(path):
                return re.search(_re, path)
            return _cb
        xhtml_ext = '\\.x?html'
        slides_dir = "(?:slides|slides--all-in-one-html)"

        lecture_re = """
        (?:
            (?: HTML-Tutorial/v1/xhtml1/hebrew/
                hebrew-html-tutorial.raw.html
            )
            |
            (?:
                (?:
                    WebMetaLecture/
                        {slides_dir}/examples/frames(?:/dest)?/(?:frames|links){ext}
                )
                            |
                (?:(?:
                    WebMetaLecture
                    )/
                    {slides_dir}/index{ext}
                )
            )
        )""".format(ext=xhtml_ext, slides_dir=slides_dir)
        _skip_cb = _create_cb("""
        (?:
            (?:/t2/index\\.xhtml)
                |
            (?:/t2/lecture/{lecture_re})
                |
            (?: MathJax/.*? )
                |
            (?: MathVentures/.*? )
                |
            (?: humour/aphorisms/twitter-tweets-archive/.*? )
                |
            (?: humour/
                (?: by-others/oded-c/\\S+{ext}
                    |
                Blue-Rabbit-Log/ideas\\.xhtml
                    |
Selina-Mandrake/indiv-nodes/dartagnan-advice-to-kate\\.xhtml
                    |
                TheEnemy/The-Enemy-English-v7\\.raw{ext}
                    |
                TheEnemy/The-Enemy-English-v8\\.raw{ext}
                )
            )
                |
            (?: me/resumes/Shlomi-Fish-Heb.*? )
                |
            (?: philosophy/fan-pages/samantha-smith/samsmith.*? )
                |
            (?: open-source/projects/Park-Lisp/
                park-lisp-informal-spec.raw{ext})
                |
            (?: work/.*? )
        )$
            """.format(ext=xhtml_ext, lecture_re=lecture_re))
        _non_xhtml_cb = _create_cb('jquery-ui')
        return self.vnu_test_dir(
            dir_, _non_xhtml_cb, _skip_cb,
            os.getenv('VNU_CACHE', 'Tests/data/cache/vnu-html-validator.json'))


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
