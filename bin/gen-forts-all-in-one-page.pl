#!/usr/bin/env perl

use strict;
use warnings;
use Shlomif::Homepage::FortuneCollections ();

my $filename          = shift(@ARGV);
my $fortune_colls_obj = Shlomif::Homepage::FortuneCollections->new;

$fortune_colls_obj->write_epub_and_all_in_one($filename);

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

=cut
