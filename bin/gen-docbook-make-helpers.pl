#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use utf8;

use Path::Tiny            qw/ cwd path /;
use Parallel::ForkManager ();
use lib './lib';
use HTML::Latemp::GenWmlHSects           ();
use HTML::Latemp::DocBook::GenMake       ();
use Shlomif::Homepage::GenQuadPresMak    ();
use Shlomif::Homepage::GenFictionsMak    ();
use Shlomif::Homepage::GenScreenplaysMak ();

my $global_username = $ENV{LOGNAME} || $ENV{USER} || getpwuid($<);

my $cwd            = cwd();
my $upper_dir      = $cwd->parent;
my $git_clones_dir = $upper_dir->child( $cwd->basename . "--clones" );
$git_clones_dir->mkpath;

sub _github_clone
{
    my $args = shift;

    my $type = $args->{'type'} // 'github_git';

    my $gh_username = $args->{'username'};
    my $repo        = $args->{'repo'};
    my $into_dir    = $args->{'into_dir'};
    my $branch      = $args->{'branch'};

    my @branch_args;
    if ( defined $branch )
    {
        push @branch_args, ( "-b", $branch, );
    }

    my $url;

    if ( $type eq 'bitbucket_hg' )
    {
        $url = qq#https://$gh_username\@bitbucket.org/$gh_username/$repo#;
    }
    else
    {
        $url = "https://github.com/$gh_username/$repo.git";
    }

    my $clone_into = $git_clones_dir->child($repo);
    my $link       = "$into_dir/$repo";

    my @prefix =
        (
        ( $type eq 'bitbucket_hg' ) ? ( 'hg', 'clone' ) : ( 'git', 'clone' ) );
    my @cmd = ( @prefix, @branch_args, $url, $clone_into );

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

sub _github_shlomif_clone
{
    my ( $into_dir, $repo ) = @_;

    return _github_clone(
        {
            username => 'shlomif',
            into_dir => $into_dir,
            repo     => $repo,
        }
    );
}

my $pm = Parallel::ForkManager->new(20);

sub _task(&)
{
    my $cb = shift;
    if ( not $pm->start )
    {
        $cb->();
        $pm->finish;
    }
    return;
}

sub _sys_task
{
    my @x = @_;
    return _task { system(@x); };
}

sub _git_task
{
    my ( $d, $bn ) = @_;
    if ( not -e "$d/$bn" )
    {
        return _task { _github_shlomif_clone( $d, $bn ); };
    }
    return;
}

if ( not -e 'lib/js/MathJax/README.md' )
{
    _sys_task(
'cd lib/js && git clone git://github.com/mathjax/MathJax.git MathJax && cd MathJax && git checkout 2.7.5'
    );
}

if ( not -e 'lib/js/jquery-expander' )
{
    _sys_task(
        'cd lib/js && git clone https://github.com/kswedberg/jquery-expander');
}
if ( not -e 'lib/ebookmaker/README.md' )
{
    # Broken due to the bug in this pull-request:
    #    - https://github.com/setanta/ebookmaker/pull/7
    #
    # I switched to my fork for now.
    #
    # system('cd lib && git clone https://github.com/setanta/ebookmaker.git');
    _sys_task('cd lib && git clone https://github.com/shlomif/ebookmaker');
}

if ( not -e 'lib/c-begin/README.md' )
{
    _sys_task('cd lib && git clone https://github.com/shlomif/c-begin.git');
}

foreach my $repo (
    'Captioned-Image-Every-mighty-Klingon-Warrior',
    'Captioned-Image-Holocaust',
    'Captioned-Image-Nothing-Sexier',
    'Captioned-Image-Princess-Bride-Greek-Philosophers',
    'Captioned-Image-SLP-Pinned-It-On-Me',
    'Captioned-Image-Truly-You-Have',
    'Captioned-Image-Yo-NSA-Publish-or-Perish',
    'Shlomi-Fish-Back-to-my-Homepage-Logo',
    'XML-Grammar-Vered',
    'captioned-image--emma-watson-doesnt-need-a-wand',
    'how-to-share-code-online',
    'my-real-person-fan-fiction',
    'shlomif-tech-diary',
    'validate-your-html',
    'why-openly-bipolar-people-should-not-be-medicated',
    )
{
    _git_task( 'lib/repos', $repo );
}

_github_clone(
    {
        username => 'shlomif',
        repo     => 'putting-cards-2019-2020',
        into_dir => "lib/repos",
        branch   => "last-updated-news-2019",
    }
);
Shlomif::Homepage::GenScreenplaysMak->new->generate(
    { git_task => \&_git_task } );

Shlomif::Homepage::GenFictionsMak->new->generate( { git_task => \&_git_task } );

HTML::Latemp::DocBook::GenMake->new(
    { dest_var => '$(T2_DEST)', post_dest_var => '$(T2_DEST)' } )->generate;
Shlomif::Homepage::GenQuadPresMak->new->generate;
HTML::Latemp::GenWmlHSects->new->run;

$pm->wait_all_children;
