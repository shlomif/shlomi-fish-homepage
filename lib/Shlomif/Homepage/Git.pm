package Shlomif::Homepage::Git;

use strict;
use warnings;

use Moo;

use Carp ();
use Path::Tiny qw/ cwd /;
use Parallel::ForkManager ();

my $cwd            = cwd();
my $upper_dir      = $cwd->parent;
my $git_clones_dir = $upper_dir->child( $cwd->basename . "--clones" );
$git_clones_dir->mkpath;

my $pm = Parallel::ForkManager->new(20);

sub task
{
    my ( $self, $cb ) = @_;
    if ( not $pm->start )
    {
        $cb->();
        $pm->finish;
    }
    return;
}

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

sub sys_task
{
    my ( $self, $args ) = @_;
    if ( -e $args->{pivot_path} )
    {
        return;
    }
    return $self->task( sub { system( @{ $args->{cmd} } ); return; } );
}

sub end
{
    my $self = shift;

    $pm->wait_all_children;

    return;
}

1;

# __END__
# # Below is stub documentation for your module. You'd better edit it!
