package Shlomif::Homepage::Git;

use strict;
use warnings;

use Moo;

use Carp ();
use Path::Tiny qw/ cwd /;
use IO::Async       ();
use IO::Async::Loop ();
use Future::Utils qw/ fmap_void /;

my $cwd            = cwd();
my $upper_dir      = $cwd->parent;
my $git_clones_dir = $upper_dir->child( $cwd->basename . "--clones" );
$git_clones_dir->mkpath;

my @tasks;

sub add_task
{
    my ( $self, $task ) = @_;
    if ( !$task )
    {
        return;
    }
    push @tasks, $task;
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

    if ( !-e $link )
    {
        symlink( $clone_into, $link );
    }
    if ( !-e $clone_into )
    {
        print "@cmd\n";
        return \@cmd;
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
    return $self->add_task( [ @{ $args->{cmd} } ] );
}

sub git_task
{
    my ( $self, $d, $bn ) = @_;
    return
        if -e "$d/$bn";
    return $self->add_task( scalar( $self->github_shlomif_clone( $d, $bn ) ) );
}

sub calc_git_task_cb
{
    my $self = shift;

    return sub { return $self->git_task(@_); };
}

sub git_in_checkout_task
{
    my ( $self, $args ) = @_;

    my $bn           = $args->{pivot_bn};
    my $repo         = $args->{repo};
    my $user         = $args->{user};
    my $base_dirname = $args->{base_dirname};
    my $branch       = $args->{branch} // '';
    if ($branch)
    {
        $branch = "-b $branch";
    }

    return $self->sys_task(
        {
            pivot_path => "$base_dirname/$repo/$bn",
            cmd        => [
qq#cd $base_dirname && git clone $branch https://github.com/$user/$repo#,
            ],
        }
    );
}

sub end
{
    my $self = shift;
    my $loop = IO::Async::Loop->new;

    my $f = fmap_void
    {
        my $task = shift;
        if ( ref $task eq 'ARRAY' )
        {
            return $loop->run_process( command => $task );
        }
        $task->();
        return Future->done();
    }
    foreach => ( \@tasks );
    $f->get();

    @tasks = ();
    return;
}

1;

# __END__
# # Below is stub documentation for your module. You'd better edit it!
