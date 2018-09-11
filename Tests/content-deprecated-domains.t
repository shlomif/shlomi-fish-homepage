#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 1;
use Test::Differences (qw(eq_or_diff));
use lib './lib';
use Shlomif::Homepage::Paths ();

my $T2_POST_DEST = Shlomif::Homepage::Paths->new->t2_post_dest;

# TEST
eq_or_diff( scalar(`ag -i 'penguin\\.org\\.il' $T2_POST_DEST`),
    '', "No deprecated (hijacked/etc.) domains." );
__END__

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

=cut
