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
        _skip_cb = _create_cb("""
        (?:
            (?:/t2/index\.xhtml)
                |
            (?:/t2/lecture/
                (?:
                    (?: HTML-Tutorial/v1/xhtml1/hebrew/
                        hebrew-html-tutorial.raw.html
                    )
                    |
                    (?: Pres-Tools/Perl-Point/slide[0-9]+\.htm
                    )
                    |
                (?:
                    (?:Perl/Lightning/Mojolicious/mojolicious-slides\.x?html)
                        |
                    (?:Perl/Newbies/
                        lecture[1-5](?:--all-in-one-html)?/.*?\.x?html
                    )
                        |
                    (?:
                        (?:Perl/
                        (?:
                            (?:Lightning/
                                (?:Opt-Multi-Task-in-PDL|
                                    Test-Run|Too-Many-Ways
                                )
                            )
                                |
                            Graham-Function
                                |
                            Haskell
                        )
                        )
                            |
                        SCM/subversion/for-pythoneers
                            |
                        Vim/beginners
                            |
                        WebMetaLecture
                            |
                        mini/mdda
                    )
                    /(?:slides|slides--all-in-one-html)/.*\.x?html
                )
                )
            )
                |
            (?:/
                (?:MANIFEST|SFresume[a-z_A-Z]*|
                404|
                humour(?:-heb)?|
                no-ie/index|
                no-ie/update-2014-02/index|
                links|old-news|
                shlomif.il.eu.org-questions|
                personal(?:-heb)?|toggle|wonderous|wysiwyt)\\.html
            )
        )$
            """)
        _non_xhtml_cb = _create_cb('jquery-ui|philosophy/by-others/sscce')
        return self.vnu_test_dir(dir_, _non_xhtml_cb, _skip_cb)


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
