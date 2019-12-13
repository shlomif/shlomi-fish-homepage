#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use utf8;

use Carp ();
use Path::Tiny qw/ path /;
use lib './lib';
use HTML::Latemp::GenWmlHSects           ();
use HTML::Latemp::DocBook::GenMake       ();
use Shlomif::Homepage::Git               ();
use Shlomif::Homepage::GenQuadPresMak    ();
use Shlomif::Homepage::GenFictionsMak    ();
use Shlomif::Homepage::GenScreenplaysMak ();

my $global_username = $ENV{LOGNAME} || $ENV{USER} || getpwuid($<);

my $git_obj = Shlomif::Homepage::Git->new;

sub _sys_task
{
    my @x = @_;
    return $git_obj->task( sub { system(@x); return; } );
}

sub _git_task
{
    my ( $d, $bn ) = @_;
    if ( not -e "$d/$bn" )
    {
        return $git_obj->task(
            sub { $git_obj->github_shlomif_clone( $d, $bn ); return; } );
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
    (
        map { s#/[^/]*$##r }
        path("lib/Shlomif/Homepage/captioned-images.txt")->lines_utf8
    ),
    'Shlomi-Fish-Back-to-my-Homepage-Logo',
    'XML-Grammar-Vered',
    'captioned-image--emma-watson-doesnt-need-a-wand',
    'how-to-share-code-online',
    'my-real-person-fan-fiction',
    'putting-cards-2019-2020',
    'shlomif-business-card',
    'shlomif-tech-diary',
    'validate-your-html',
    'why-openly-bipolar-people-should-not-be-medicated',
    )
{
    _git_task( 'lib/repos', $repo );
}

Shlomif::Homepage::GenScreenplaysMak->new->generate(
    { git_task => \&_git_task } );

Shlomif::Homepage::GenFictionsMak->new->generate( { git_task => \&_git_task } );

HTML::Latemp::DocBook::GenMake->new(
    { dest_var => '$(SRC_DEST)', post_dest_var => '$(SRC_POST_DEST)' } )
    ->generate;
Shlomif::Homepage::GenQuadPresMak->new->generate;
HTML::Latemp::GenWmlHSects->new->run;

$git_obj->end;
