package Shlomif::Homepage::Git;

use strict;
use warnings;

use Moo;

has default_user => (
    is       => 'ro',
    required => 1,
);

use Carp            ();
use Path::Tiny      qw/ cwd path /;
use IO::Async::Loop ();
use Future::Utils   qw/ fmap_void /;

my $cwd            = cwd();
my $upper_dir      = $cwd->parent;
my $cwd_bn         = $cwd->basename;
my $git_clones_dir = $upper_dir->child( $cwd_bn . "--clones" );
$git_clones_dir->mkpath;

has _tasks => (
    is      => 'rw',
    default => sub {
        return [];
    },

    # other attributes
);

sub add_task
{
    my ( $self, $task ) = @_;
    if ( !$task )
    {
        return;
    }
    push @{ $self->_tasks() }, $task;
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

    my $clone_into =
        path( $args->{clone_into} // $git_clones_dir )->child($repo);
    my $link = "$into_dir/$repo";

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

sub github_default_user_clone
{
    my ( $self, $into_dir, $repo, $inside ) = @_;

    if ($inside)
    {
        my $link       = $git_clones_dir->child($repo);
        my $clone_into = "$into_dir/$repo";

        # die $clone_into;
        warn "[link=$link clone_into=$clone_into]";
        if ( not -e $link )
        {
            warn "[not exist;link=$link clone_into=$clone_into]";
            if ( not -e $clone_into )
            {
                symlink( "../$cwd_bn/$clone_into", $link );
                warn "[not exist clone_into;link=$link clone_into=$clone_into]";
                return $self->github_clone(
                    {
                        clone_into => $into_dir,
                        username   => $self->default_user(),
                        into_dir   => $clone_into,
                        repo       => $repo,
                    }
                );
            }
            return;
        }
        return;
    }

    return $self->github_clone(
        {
            username => $self->default_user(),
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
    my ( $self, $d, $bn, $inside ) = @_;
    return
        if -e "$d/$bn";
    return $self->add_task(
        scalar( $self->github_default_user_clone( $d, $bn, $inside, ) ) );
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

    my $_tasks = $self->_tasks;
    $self->_tasks( [] );
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
    foreach => ($_tasks);
    return $f->get();
}

1;

# __END__
# # Below is stub documentation for your module. You'd better edit it!
