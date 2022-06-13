#!/usr/bin/env perl

use strict;
use warnings;

use YAML::XS      qw/ LoadFile /;
use JSON::MaybeXS qw/ encode_json /;
use Path::Tiny    qw/ path /;
use Getopt::Long  qw/GetOptions/;

my $output_fn;
my $input_fn;

GetOptions( 'o|output=s' => \$output_fn, 'i|input=s' => \$input_fn )
    or die "No options. $!";

if ( !defined $output_fn )
{
    die "output filename is not specified.";
}

if ( !defined $input_fn )
{
    die "No input filename.";
}

my $data = LoadFile($input_fn);
path($output_fn)
    ->spew_utf8(
    JSON::MaybeXS->new( utf8 => 1, canonical => 1 )->encode($data) );

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2017 by Shlomi Fish

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
