#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 1;
use Path::Tiny qw/ path /;

{
    my $content =
        path("./post-dest/t2/humour/fortunes/sharp-programming.html")
        ->slurp_utf8;

    # TEST
    like(
        $content,
qr{<a href=\r?\n?"https://en.wikipedia.org/wiki/NP-completeness" rel=\r?\n?"nofollow">https://en.wikipedia.org/wiki/NP-completeness</a>},
        'Contains a hyperlink.'
    );
}

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2018 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

=cut
