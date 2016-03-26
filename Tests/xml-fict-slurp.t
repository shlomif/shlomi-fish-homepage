#!/usr/bin/perl

use strict;
use warnings;

use lib './Tests/lib';
use lib './lib';

use Test::Differences (qw(eq_or_diff));
use Test::More tests => 1;
use Data::Dumper;
use String::ShellQuote;
use File::Spec;
use File::Temp qw( tempdir );
use Test::Trap qw( trap $trap :flow:stderr(systemsafe):stdout(systemsafe):warn );

use Shlomif::XmlFictionSlurp;

{
    trap
    {
        Shlomif::XmlFictionSlurp->my_slurp(
            +{
                fn => 'Tests/data/fict1.xml',
                index_id => 'fiction_text_index',
            }
        );
    };

    # TEST
    eq_or_diff (
        $trap->stdout(),
        <<'EOF',

    <div xml:lang="en-UK" class="article" xml:space="preserve">
      <div class="titlepage" xml:space="preserve">
        <div xml:space="preserve">
          <div xml:space="preserve">
            <h3 id="fiction_text_index" class="title" xml:space="preserve"><a xml:space="preserve" shape="rect"/>David vs. Goliath - Part I</h3>
          </div>
        </div>
        <hr />
      </div>
      <div class="section" xml:space="preserve">
        <div class="titlepage" xml:space="preserve">
          <div xml:space="preserve">
            <div xml:space="preserve">
              <h4 id="top" class="title" xml:space="preserve"><a xml:space="preserve" shape="rect"/>The Top Section</h4>
            </div>
          </div>
        </div>
        <p xml:space="preserve">King <a class="link" href="http://en.wikipedia.org/wiki/David" xml:space="preserve" shape="rect">David</a> and Goliath were standing by each other.
</p>
        <p xml:space="preserve">David said unto Goliath: “I will shoot you. I <span class="bold" xml:space="preserve"><strong xml:space="preserve">swear</strong></span> I will”
</p>
        <div class="section" xml:space="preserve">
          <div class="titlepage" xml:space="preserve">
            <div xml:space="preserve">
              <div xml:space="preserve">
                <h5 id="goliath" class="title" xml:space="preserve"><a xml:space="preserve" shape="rect"/>Goliath's Response</h5>
              </div>
            </div>
          </div>
          <p xml:space="preserve">Goliath was not amused.
</p>
          <p xml:space="preserve">He said to David: “Oh, really. <span class="emphasis" xml:space="preserve"><em xml:space="preserve">David</em></span>, the red-headed!”.
</p>
        </div>
      </div>
    </div>
EOF
        "->my_slurp()",
    );
}

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2008 Shlomi Fish

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

