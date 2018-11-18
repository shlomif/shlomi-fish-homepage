use strict;
use warnings;

use List::Util qw/ max /;

use Test::Perl::Critic;

use Test::More ();

my @files = `git ls-files`;
chomp @files;
@files =
    grep { !m#\Alib/presentations/qp/perl-for-newbies/# and /\.(?:pl|pm|t)\z/ }
    @files;

sub mtime
{
    return ( stat shift )[9];
}

my $files_mtime = max( map { mtime($_); } @files );
my $TS          = 'Tests/data/cache/perl-critic.timestamp';
if ( all_critic_ok( ( $files_mtime < mtime($TS) ) ? ( $files[0] ) : @files ) )
{
    utime( undef, undef, $TS );
}
