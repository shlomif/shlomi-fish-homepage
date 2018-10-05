package HTML::Latemp::GenWmlHSects;

use strict;
use warnings;

use Moo;
use Path::Tiny qw/ path /;
use File::Update qw/ write_on_change /;

sub run
{
    write_on_change(
        path("lib/Inc/h_sections.wml"),
        \(
            join "\n",
            map {
                my $n = $_;

                # my $tag = "wml_toc_h$n";
                my $tag = "h$n";
                <<"EOF"
<define-tag h${n}_section endtag="required" whitespace="delete">

<set-var h_tag="$tag"  />
<set-var h_class="h$n" />
<preserve _wml_id_h$n id href title />
<set-var %attributes />

<:

0 and die qq|
%attributes

<get-var h_tag />

<get-var id />

ENDU
|
:>

<set-var _wml_id_h$n=<get-var id /> />
<section class="<get-var h_class />">

<header><$tag id="<get-var _wml_id_h$n />">
<when <get-var href />>
<a href="<get-var href />"><get-var title /></a>
</when>
<when <not <get-var href /> />>
<get-var title />
</when>
</$tag>
</header>

%body

</section>

<restore _wml_id_h$n id href title />

</define-tag>
EOF
            } 1 .. 6
        )
    );
    return;
}

1;
__END__

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
