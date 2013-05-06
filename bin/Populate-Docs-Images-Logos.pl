#!/usr/bin/perl

use strict;
use warnings;

use Carp ();

use Parallel::ForkManager;

use IO::All;

my $base_dir = "$ENV{HOME}/Docs/Images/Logos";

my $global_username = $ENV{LOGNAME} || $ENV{USER} || getpwuid($<);

sub _github_clone
{
    my $args = shift;

    my $gh_username = $args->{'username'};
    my $repo = $args->{'repo'};
    my $target = $args->{'target'};
    my $type = $args->{type} || 'github_git';

    my $url;

    if ($type eq 'github_git')
    {
        if ($ENV{GITHUB_USERS} =~ m/,\Q$gh_username\E,/)
        {
            $url = "git\@github.com:${gh_username}/${repo}.git";
        }
        else
        {
            $url = "https://github.com/$gh_username/$repo.git";
        }
    }
    elsif ($type eq 'bitbucket_hg')
    {
    }
    else
    {
        Carp::confess("Unknown type '$type'");
    }

    system('git', 'clone', $url, (defined($target) ? ($target) : ()));

    return;
}

sub _github_shlomif_clone
{
    my ($args) = @_;

    return _github_clone({ username => 'shlomif', %$args,});
}

my $pm = Parallel::ForkManager->new(20);

my $logos =
[
    {
        b => 'Back-to-my-Homepage/git',
        repo_base => 'Shlomi-Fish-Back-to-my-Homepage-Logo',
        type => 'github_git',
    },
    {
        b => 'human-hacking-field-guide-logo',
        repo_base => 'human-hacking-field-guide-graphics',
        type => 'bitbucket_hg',
    },
    {
        b => 'Summerschool-at-the-NSA/SummerNSA-logo',
        repo_base => 'Summerschool-at-the-NSA-logo',
        type => 'github_git',
    },
    {
        b => 'The-One-With-The-Fountainhead-TOWTF-Logo/git',
        repo_base => 'The-One-with-the-Fountainhead-Logo',
        type => 'github_git',
    },
];

foreach my $l (@$logos)
{
    my $b =$l->{b}
        or die "b not specified";
    my $repo_base = $l->{repo_base}
        or die "repo_base not specified.";
    my $type = $l->{type}
        or dei "type not specified.";

    my $pid;
    if (! ($pid = $pm->start))
    {
        my $d = "$base_dir/$b";

        if (! -d $d)
        {
            my $d_obj = io->dir($d);
            my $above = $d_obj->dirname;
            $above->mkpath();

            _github_shlomif_clone(
                {
                    repo => $repo_base,
                    target => $d,
                    type => $type,
                }
            );
        }
        $pm->finish;
    }
}

