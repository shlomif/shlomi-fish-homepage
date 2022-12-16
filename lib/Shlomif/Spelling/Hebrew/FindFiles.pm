package Shlomif::Spelling::Hebrew::FindFiles;

use strict;
use warnings;

use Moo;
use List::Util 1.34 qw/ any /;

use HTML::Spelling::Site::Finder ();
use lib './lib';
use HTML::Latemp::Local::Paths ();

my $POST_DEST = HTML::Latemp::Local::Paths->new->t2_post_dest;

my @prunes = (
    qr#\A\Q$POST_DEST\E/MANIFEST\.html\z#,
    qr#\A\Q$POST_DEST\E/humour/fortunes/__FORTS-show-cgi#,
);

sub list_htmls
{
    my ($self) = @_;

    return HTML::Spelling::Site::Finder->new(
        {
            root_dir => $POST_DEST,
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
