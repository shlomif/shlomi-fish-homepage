#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 2;
use lib './lib';
use HTML::Latemp::Local::Paths ();

my $POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

sub _check_size
{
    my ( $path, $size ) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;

    return cmp_ok( scalar( -s "$POST_DEST/$path" ),
        ">", $size, "$path has size greater than $size" );
}

# TEST
_check_size( "js/main_all.js", 100 );

# TEST
_check_size( "js/jquery.expander.min.js", 40 );

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2019 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

=cut
