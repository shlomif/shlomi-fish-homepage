#!/usr/bin/env perl

use strict;
use warnings;

use Carp ();
use Parallel::ForkManager;
use Path::Tiny qw/ path /;

my $base_dir = "$ENV{HOME}/Docs/Images/Logos";

my $global_username = $ENV{LOGNAME} || $ENV{USER} || getpwuid($<);

sub _github_clone
{
    my $args = shift;

    my $gh_username = $args->{'username'};
    my $repo        = $args->{'repo'};
    my $target      = $args->{'target'};
    my $type        = $args->{type} || 'github_git';

    my $url;

    my $cmd;

    if ( $type eq 'github_git' )
    {
        $cmd = 'git';
        if ( $ENV{GITHUB_USERS} =~ m/,\Q$gh_username\E,/ )
        {
            $url = "git\@github.com:${gh_username}/${repo}.git";
        }
        else
        {
            $url = "https://github.com/$gh_username/$repo.git";
        }
    }
    elsif ( $type eq 'bitbucket_hg' )
    {
        Carp::confess("bitbucket_hg is going away!");
        $cmd = 'hg';
        if ( $ENV{BITBUCKET_USERS} =~ m/,\Q$gh_username\E,/ )
        {
            $url = "ssh://hg\@bitbucket.org/$gh_username/$repo";
        }
        else
        {
            $url = "https://bitbucket.org/$gh_username/$repo";
        }
    }
    else
    {
        Carp::confess("Unknown type '$type'");
    }

    system( $cmd, 'clone', $url, ( defined($target) ? ($target) : () ) );

    return;
}

sub _github_shlomif_clone
{
    my ($args) = @_;

    return _github_clone( { username => 'shlomif', %$args, } );
}

my $pm = Parallel::ForkManager->new(20);

my $logos = [
    {
        b         => 'Back-to-my-Homepage/git',
        repo_base => 'Shlomi-Fish-Back-to-my-Homepage-Logo',
        type      => 'github_git',
    },
    {
        b         => 'human-hacking-field-guide-logo',
        repo_base => 'human-hacking-field-guide-graphics',
        type      => 'github_git',
    },
    {
        b         => 'Summerschool-at-the-NSA/SummerNSA-logo',
        repo_base => 'Summerschool-at-the-NSA-logo',
        type      => 'github_git',
    },
    {
        b         => 'The-One-With-The-Fountainhead-TOWTF-Logo/git',
        repo_base => 'The-One-with-the-Fountainhead-Logo',
        type      => 'github_git',
    },
];

foreach my $l (@$logos)
{
    my $b = $l->{b}
        or die "b not specified";
    my $repo_base = $l->{repo_base}
        or die "repo_base not specified.";
    my $type = $l->{type}
        or die "type not specified.";

    my $pid;
    if ( !( $pid = $pm->start ) )
    {
        my $d = "$base_dir/$b";

        if ( !-d $d )
        {
            path($base_dir)->mkpath;

            _github_shlomif_clone(
                {
                    repo   => $repo_base,
                    target => $d,
                    type   => $type,
                }
            );
        }
        $pm->finish;
    }
}

$pm->wait_all_children;
