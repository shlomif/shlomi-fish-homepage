#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 2;
use Path::Tiny qw/ path /;
use lib './lib';
use HTML::Latemp::Local::Paths;

my $T2_POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

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

{
    my $content =
        path("$T2_POST_DEST/prog-evolution/shlomif-at-cortext.html")
        ->slurp_utf8;

    # TEST
    ok(
        scalar(
            index( $content,
q{<a href="#how_i_started">How I started Working for Cortext</a>}
                ) >= 0
                and index(
                $content,
                q{<h2 id="how_i_started">How I started Working for Cortext</h2>}
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
