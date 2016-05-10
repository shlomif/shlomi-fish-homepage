use strict;
use warnings;

use Test::Perl::Critic;

my @files = `git ls-files`;
chomp@files;
all_critic_ok(grep { /\.(?:pl|pm|t)\z/ and !m#\Alib/presentations# } @files);
