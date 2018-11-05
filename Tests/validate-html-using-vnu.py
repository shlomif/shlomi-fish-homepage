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

import os
from os.path import join
import tempfile
import hashlib
import json
from urllib.parse import urlparse
from subprocess import Popen, PIPE


class VnuValidate:
    """
    Run the Nu HTML Validator on a directory tree of XHTML5 and HTML5 files.

    :param path the path of the root directory
    :param jar path to the Java .jar of the Nu validator
    :param non_xhtml_cb A callback that accepts a path and returns whether it
    is not XHTML
    :param skip_cb Return whether a path should be skipped entirely
    """
    def __init__(self, path, jar, non_xhtml_cb, skip_cb, cache_path=None):
        self.path = path
        self.jar = jar
        self.non_xhtml_cb = non_xhtml_cb
        self.skip_cb = skip_cb
        self.cache_path = cache_path

    def _digest(self, content):
        """docstring for _digest"""
        m = hashlib.sha256()
        m.update(content)
        return m.hexdigest()

    def run(self):
        """
        :returns boolean for sucess or failure.
        """
        t = tempfile.TemporaryDirectory()
        # t = VnuValidate(0, 0, 0, 0)
        # t.name = "/tmp/zjzj"
        try:
            if self.cache_path:
                whitelist = json.load(
                    open(self.cache_path, 'rb'))['vnu_valid']['cache']
        except FileNotFoundError:
            whitelist = {'html': {}, 'xhtml': {}}
        which = {}
        greylist = {'html': {}, 'xhtml': {}}

        def _mytrim(s):
            return re.sub('^(?:\\./)?', '', s)

        for dirpath, _, fns in os.walk(self.path):
            dn = _mytrim(join(t.name, _mytrim(dirpath)))
            os.makedirs(dn)
            for fn in fns:
                path = _mytrim(join(dirpath, fn))
                # print(path)
                if self.skip_cb(path):
                    continue
                html = re.match(r'.*\.html?$', fn)

                def _content():
                    return open(path, 'rb').read()
                out_fn = None
                if re.match('.*\\.xhtml$', fn) or (
                        html and not self.non_xhtml_cb(path)):
                    out_fn = re.sub('\.[^\.]*$', '.xhtml', fn)
                elif html:
                    out_fn = fn

                if out_fn:
                    c = _content()
                    d = self._digest(c)
                    key = 'html' if html else 'xhtml'
                    if d not in whitelist[key]:
                        fn = join(dn, out_fn)
                        # print(dn, out_fn, fn)
                        # import sys
                        # sys.stdout.flush()
                        open(fn, 'wb').write(c)
                        which[fn] = key
                        greylist[key][d] = True

        cmd = ['java', '-jar', self.jar, '--format', 'json', '--Werror',
               '--skip-non-html', t.name]
        print(" ".join(cmd))
        # import sys
        # sys.exit(0)
        with Popen(cmd, stderr=PIPE) as ret:
            ret.wait()
            text = ret.stderr.read()
            # open('foo.json', 'w').write(text.decode('utf-8'))
            data = json.loads(text)
            blacklist = {'html': {}, 'xhtml': {}}
            found = set()
            for msg in data['messages']:
                print(msg)
                url = msg['url']
                fn = urlparse(url).path
                if fn not in found:
                    found.add(fn)
                    d = self._digest(open(fn, 'rb').read())
                    blacklist[which[fn]][d] = True
            for key in ['html', 'xhtml']:
                for k in list(greylist[key].keys()):
                    if k not in blacklist[key]:
                        whitelist[key][k] = True
            if self.cache_path:
                json.dump({'vnu_valid': {'cache': whitelist}},
                          open(self.cache_path, 'w'))
            return len(blacklist['html']) + len(blacklist['xhtml']) == 0


class VnuTest(unittest.TestCase):
    """
    One can find some examples for this here:

    """
    def vnu_test_dir(self, path, non_xhtml_cb, skip_cb, cache_path=None):
        """
        A unit test helper for checking a directory tree.
        :param path the path of the root directory
        :param non_xhtml_cb A callback that accepts a path and returns whether
        it
        :param skip_cb Return whether a path should be skipped entirely

        Uses an environment variable HTML_VALID_VNU_JAR that points to the
        validator .jar (see https://github.com/validator/validator/ ).
        """
        key = 'HTML_VALID_VNU_JAR'
        if key in os.environ:
            self.assertTrue(
                VnuValidate(path, os.environ[key], non_xhtml_cb,
                            skip_cb, cache_path).run(),
                "passed validation")
        else:
            self.assertTrue(True, key + ' not set')


class MyTests(VnuTest):
    def test_main(self):
        dir_ = './dest/post-incs/t2/'
        # dir_ = './dest/post-incs/t2/humour/'

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
                |
            (?: MathJax/.*? )
                |
            (?: MathVentures/.*? )
                |
            (?: humour/
                (?: by-others/oded-c/\S+\.x?html
                    |
                Blue-Rabbit-Log/ideas\.xhtml
                )
            )
                |
            (?: me/resumes/Shlomi-Fish-Heb.*? )
                |
            (?: work/.*? )
        )$
            """)
        _non_xhtml_cb = _create_cb('jquery-ui')
        return self.vnu_test_dir(dir_, _non_xhtml_cb, _skip_cb,
                                 'Tests/data/cache/vnu-html-validator.json')


if __name__ == '__main__':
    from pycotap import TAPTestRunner
    suite = unittest.TestLoader().loadTestsFromTestCase(MyTests)
    TAPTestRunner().run(suite)
