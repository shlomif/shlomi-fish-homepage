#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use utf8;

use Carp ();
use Path::Tiny qw/ path /;
use lib './lib';
use HTML::Latemp::DocBook::GenMake       ();
use Shlomif::Homepage::Git               ();
use Shlomif::Homepage::GenQuadPresMak    ();
use Shlomif::Homepage::GenFictionsMak    ();
use Shlomif::Homepage::GenScreenplaysMak ();

my $git_obj = Shlomif::Homepage::Git->new;

my $git_task = $git_obj->calc_git_task_cb;

$git_obj->sys_task(
    {
        pivot_path => 'lib/js/MathJax/README.md',
        cmd        => [
'cd lib/js && git clone git://github.com/mathjax/MathJax.git MathJax && cd MathJax && git checkout 2.7.5'
        ]
    }
);

$git_obj->sys_task(
    {
        pivot_path => 'lib/js/jquery-expander',
        cmd        => [
'cd lib/js && git clone https://github.com/kswedberg/jquery-expander'
        ]
    }
);

# Broken due to the bug in this pull-request:
#    - https://github.com/setanta/ebookmaker/pull/7
#
# I switched to my fork for now.
#
# system('cd lib && git clone https://github.com/setanta/ebookmaker.git');
$git_obj->sys_task(
    {
        pivot_path => 'lib/ebookmaker/README.md',
        cmd => ['cd lib && git clone https://github.com/shlomif/ebookmaker']
    }
);

$git_obj->sys_task(
    {
        pivot_path => 'lib/c-begin/README.md',
        cmd => ['cd lib && git clone https://github.com/shlomif/c-begin.git']
    }
);

foreach my $repo (
    (
        map { s#/[^/]*$##r }
        path("lib/Shlomif/Homepage/captioned-images.txt")->lines_utf8
    ),
    'Shlomi-Fish-Back-to-my-Homepage-Logo',
    'XML-Grammar-Vered',
    'how-to-share-code-online',
    'my-real-person-fan-fiction',
    'putting-cards-2019-2020',
    'shlomif-business-card',
    'shlomif-tech-diary',
    'validate-your-html',
    'why-openly-bipolar-people-should-not-be-medicated',
    )
{
    $git_task->( 'lib/repos', $repo );
}

Shlomif::Homepage::GenScreenplaysMak->new->generate(
    { git_task => $git_task, } );

Shlomif::Homepage::GenFictionsMak->new->generate( { git_task => $git_task, } );

HTML::Latemp::DocBook::GenMake->new(
    { dest_var => '$(PRE_DEST)', post_dest_var => '$(SRC_POST_DEST)' } )
    ->generate;
Shlomif::Homepage::GenQuadPresMak->new->generate;

$git_obj->end;
