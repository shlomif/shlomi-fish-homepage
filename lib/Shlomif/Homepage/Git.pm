package Shlomif::Homepage::Git;

use strict;
use warnings;

use Moo;

use Carp ();
use Path::Tiny qw/ cwd /;

my $cwd            = cwd();
my $upper_dir      = $cwd->parent;
my $git_clones_dir = $upper_dir->child( $cwd->basename . "--clones" );
$git_clones_dir->mkpath;

sub github_clone
{
    my ( $self, $args ) = @_;

    my $type = $args->{'type'} // 'github_git';

    my $gh_username = $args->{'username'};
    my $repo        = $args->{'repo'};
    my $into_dir    = $args->{'into_dir'};

    my $url;

    if ( $type eq 'bitbucket_hg' )
    {
        # $url = qq#https://$gh_username\@bitbucket.org/$gh_username/$repo#;
        Carp::confess("bitbucket_hg is going away!");
    }
    else
    {
        $url = "https://github.com/$gh_username/$repo.git";
    }

    my $clone_into = $git_clones_dir->child($repo);
    my $link       = "$into_dir/$repo";

    my @prefix = ( 'git', 'clone' );
    my @cmd    = ( @prefix, $url, $clone_into );

    if ( !-e $clone_into )
    {
        print "@cmd\n";
        if ( system(@cmd) )
        {
            die "git clone [@cmd] failed!";
        }
    }
    if ( !-e $link )
    {
        symlink( $clone_into, $link );
    }

    return;
}

sub github_shlomif_clone
{
    my ( $self, $into_dir, $repo ) = @_;

    return $self->github_clone(
        {
            username => 'shlomif',
            into_dir => $into_dir,
            repo     => $repo,
        }
    );
}

1;

# __END__
# # Below is stub documentation for your module. You'd better edit it!
