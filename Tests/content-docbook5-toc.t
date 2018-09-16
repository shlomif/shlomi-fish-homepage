#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 1;
use Path::Tiny qw/ path /;
use lib './lib';
use Shlomif::Homepage::Paths;

my $T2_POST_DEST = Shlomif::Homepage::Paths->new->t2_post_dest;

{
    my $content =
        path(
"$T2_POST_DEST/philosophy/philosophy/putting-all-cards-on-the-table-2013/index.xhtml"
    )->slurp_utf8;

    # TEST
    ok(
        scalar(
            index( $content,
q{<a href="#machines_that_can_give_questions">The Machines That Can Give You Questions</a>}
            ) >= 0
        ),
        'Contains a hyperlink.'
    );
}

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

=cut
