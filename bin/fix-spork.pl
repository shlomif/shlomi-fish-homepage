#! /usr/bin/env perl
#
# Short description for fix-spork.pl
#
# Author shlomif <shlomif@cpan.org>
# Version 0.1
# Copyright (C) 2018 shlomif <shlomif@cpan.org>
# Modified On 2018-04-22 16:27
# Created  2018-04-22 16:27
#
use strict;
use warnings;

use Path::Tiny qw/ path /;

my @fns = @ARGV;

foreach my $fn (@fns)
{
    my $fh = path($fn);

    $fh->edit_utf8(
        sub {
s%<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml11.dtd">%<!DOCTYPE html>%gms;
s%<meta name="Content-Type" content="text/html; charset=[^"]+" />%<meta charset="utf-8"/>%gms;

            s%<a accesskey='\S+'\s+href="">([^<]+)</a>%<strong>$1</strong>%gms;
            s%<style type="text/css">%<style>%gms;
            s%<script type="text/javascript"%<script%gms;
        }
    );

    $fh->edit_lines_utf8(
        sub {

            $_ = '' if m%\Q<link rel="stylesheet" type="text/css" href="" />\E%;
            s/(<table)/$1 summary="Navigation aids" /g;
            s/[\t ]+(\n?)\z/$1/;
        }
    );
}

foreach my $I (@fns)
{
    system(qq#tidy -quiet -asxhtml -o "$I".new "$I" ; mv -f "$I".new "$I"#);
}

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
