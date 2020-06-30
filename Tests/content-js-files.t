#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 2;
use lib './lib';
use HTML::Latemp::Local::Paths::Test ();

my $obj = HTML::Latemp::Local::Paths::Test->new;

# TEST
$obj->_check_size("js/main_all.js");

# TEST
$obj->_check_size("js/jquery.expander.min.js");

__END__

=head1 COPYRIGHT & LICENSE

Copyright 2019 by Shlomi Fish

This program is distributed under the MIT / Expat License:
L<http://www.opensource.org/licenses/mit-license.php>

=cut
