#!/usr/bin/perl

use strict;
use warnings;
use Shlomif::Homepage::FortuneCollections;

my $filename = shift(@ARGV);

Shlomif::Homepage::FortuneCollections->write_fortune_all_in_one_page_to_file(
    $filename);
Shlomif::Homepage::FortuneCollections->write_epub_json(
    'lib/fortunes/xhtmls/book.json');

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

=cut
