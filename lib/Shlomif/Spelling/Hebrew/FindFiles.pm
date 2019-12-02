package Shlomif::Spelling::Hebrew::FindFiles;

use strict;
use warnings;

use MooX qw/late/;
use List::MoreUtils qw/any/;

use HTML::Spelling::Site::Finder ();
use lib './lib';
use HTML::Latemp::Local::Paths ();

my $SRC_POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

my @prunes = ( qr#^\Q$SRC_POST_DEST\E/MANIFEST\.html$#, );

sub list_htmls
{
    my ($self) = @_;

    return HTML::Spelling::Site::Finder->new(
        {
            root_dir => $SRC_POST_DEST,
            prune_cb => sub {
                my ($path) = @_;

                # warn $path if 1;
                return (
                           ( -f $path and $path !~ /heb|lecture/i )
                        or ( any { $path =~ $_ } @prunes )
                );
            },
        }
    )->list_all_htmls;
}

1;
