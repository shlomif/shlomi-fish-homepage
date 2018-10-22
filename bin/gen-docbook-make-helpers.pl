#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use utf8;

use File::Basename qw(dirname basename);
use Path::Tiny qw/ cwd path /;
use Parallel::ForkManager ();
use lib './lib';
use HTML::Latemp::GenWmlHSects           ();
use HTML::Latemp::DocBook::GenMake       ();
use Shlomif::Homepage::GenQuadPresMak    ();
use Shlomif::Homepage::GenScreenplaysMak ();

my $global_username = $ENV{LOGNAME} || $ENV{USER} || getpwuid($<);

my $cwd            = cwd();
my $upper_dir      = dirname($cwd);
my $cwd_basename   = basename($cwd);
my $git_clones_dir = path("$upper_dir/_$cwd_basename--clones");
$git_clones_dir->mkpath;

sub _github_clone
{
    my $args = shift;

    my $type = $args->{'type'} // 'github_git';

    my $gh_username = $args->{'username'};
    my $repo        = $args->{'repo'};
    my $into_dir    = $args->{'into_dir'};

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
    my @cmd = ( @prefix, $url, $clone_into );

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

sub _bitbucket_hg_shlomif_clone
{
    my ( $into_dir, $repo ) = @_;

    return _github_clone(
        {
            type     => 'bitbucket_hg',
            username => 'shlomif',
            into_dir => $into_dir,
            repo     => $repo,
        }
    );
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

my $BLOGS_DIR     = 'lib/blogs';
my $TECH_BLOG     = 'shlomif-tech-diary';
my $back_to_hp    = 'Shlomi-Fish-Back-to-my-Homepage-Logo';
my $VALIDATE_YOUR = 'validate-your-html';
foreach my $repo ( $VALIDATE_YOUR, 'how-to-share-code-online', $TECH_BLOG,
    $back_to_hp, )
{
    _git_task( $BLOGS_DIR, $repo );
}

Shlomif::Homepage::GenScreenplaysMak->new->generate(
    { git_task => \&_git_task } );

sub _calc_fiction_story_makefile_lines
{
    my ( $d, $fiction_docs_basenames ) = @_;

    my $base        = $d->{base};
    my $github_repo = $d->{github_repo};
    my $subdir      = $d->{subdir};

    my $vcs_dir_var = "${base}__VCS_DIR";

    my @ret = ("$vcs_dir_var = \$(FICTION_VCS_BASE_DIR)/$github_repo\n\n");

    foreach my $doc ( @{ $d->{docs} } )
    {
        my $doc_base = $doc->{base};
        my $suf      = $doc->{suf};
        my $type     = $doc->{type};

        my $bsuf = "${base}_${suf}";

        my (
            $src_varname, $from_vcs_varname, $src_suffix,
            $dest_suffix, $dest_dir_var
        );

        if ( $type eq 'fiction-text' )
        {
            push @$fiction_docs_basenames, $doc_base;

            $src_varname      = "${bsuf}_FICTION_XML_SOURCE";
            $src_suffix       = 'fiction-text.txt';
            $from_vcs_varname = "${bsuf}_FICTION_TXT_FROM_VCS";
            $dest_suffix      = 'txt';
            $dest_dir_var     = 'FICTION_XML_TXT_DIR';
        }
        elsif ( $type eq 'docbook5' )
        {
            $src_varname      = "${bsuf}_DOCBOOK5_SOURCE";
            $src_suffix       = 'db5.xml';
            $from_vcs_varname = "${bsuf}_DOCBOOK5_FROM_VCS";
            $dest_suffix      = 'xml';
            $dest_dir_var     = 'DOCBOOK5_XML_DIR';
        }

        push @ret,
"$src_varname = \$($vcs_dir_var)/$subdir/text/$doc_base.$src_suffix\n\n",
            "$from_vcs_varname = \$($dest_dir_var)/$doc_base.$dest_suffix\n\n",
            "\$($from_vcs_varname): \$($src_varname)\n\t\$(call COPY)\n\n";
    }

    return \@ret;
}

{
    my $fiction_data = [
        {
            base        => "EARTH_ANGEL",
            github_repo => "The-Earth-Angel",
            subdir      => "The-Earth-Angel",
            docs        => [
                {
                    base => "The-Earth-Angel-english",
                    type => "fiction-text",
                    suf  => "ENG",
                },
                {
                    base => "The-Earth-Angel-hebrew",
                    type => "fiction-text",
                    suf  => "HEB",
                },
            ],
        },
        {
            base        => "HHFG",
            github_repo => "Human-Hacking-Field-Guide",
            subdir      => "HHFG",
            docs        => [
                {
                    base => "human-hacking-field-guide-v2--english",
                    type => "docbook5",
                    suf  => "ENG",
                },
                {
                    base => "human-hacking-field-guide-v2--hebrew",
                    type => "fiction-text",
                    suf  => "HEB",
                },
            ],
        },
        {
            base        => "POPE",
            github_repo => "The-Pope-Died-on-Sunday",
            subdir      => "Pope",
            docs        => [
                {
                    base => "The-Pope-Died-on-Sunday-english",
                    type => "fiction-text",
                    suf  => "ENG",
                },
                {
                    base => "The-Pope-Died-on-Sunday-hebrew",
                    type => "fiction-text",
                    suf  => "HEB",
                },
            ],
        },
    ];

    my $fiction_vcs_base_dir = 'lib/fiction-xml/from-vcs';

FICT:
    foreach my $d (@$fiction_data)
    {
        my $github_repo = $d->{github_repo};
        my $r           = $github_repo;
        _git_task( $fiction_vcs_base_dir, $r );
    }

    my @fiction_docs_basenames;

    my @o = (
        map {
            @{
                _calc_fiction_story_makefile_lines( $_,
                    \@fiction_docs_basenames )
                }
        } @$fiction_data
    );

    path("lib/make/docbook/sf-fictions.mak")->spew_utf8(
        "FICTION_VCS_BASE_DIR = $fiction_vcs_base_dir\n\n",
        @o,
        (
            "\n\nFICTION_DOCS_FROM_GEN = \\\n",
            ( map { "\t$_ \\\n" } @fiction_docs_basenames ),
            "\n\n"
        ),
    );
}

HTML::Latemp::DocBook::GenMake->new(
    { dest_var => '$(T2_DEST)', post_dest_var => '$(T2_POST_DEST)' } )
    ->generate;
Shlomif::Homepage::GenQuadPresMak->new->generate;
HTML::Latemp::GenWmlHSects->new->run;

$pm->wait_all_children;
