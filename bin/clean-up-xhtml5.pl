#!/usr/bin/env perl

use strict;
use warnings;

use Path::Tiny   qw/ path /;
use File::Update qw/ modify_on_change /;

foreach my $fn (@ARGV)
{
    modify_on_change(
        path($fn),
        sub {
            my $text = shift;
            my $ret  = 0;
            $ret |= ( $$text =~ s%<style type="text/css">%<style>%g );
            $ret |=
                ( $$text =~
s%(<html)([^>]*)(>)%my ($pre, $in, $post)=($1,$2,$3); if ($in !~ /lang/) { $in =~ s/\s*\z/ xml:lang="en"/;} $pre.$in.$post%egms
                );
            $ret |=
                ( $$text =~
s%\s+(?:bgcolor|color|width|border|cellspacing|cellpadding|valign|align)="[^"]+"%%gms
                );
            $ret |= ( $$text =~ s%<hr\s+size="[^"+]"\s*/>%<hr/>%gms );
            return $ret;
        },
    );
}
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
