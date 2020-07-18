#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

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

$git_obj->git_in_checkout_task(
    {
        pivot_bn     => "README.md",
        repo         => "MathJax",
        user         => "mathjax",
        base_dirname => "lib/js",
        branch       => '3.0.5',
    }
);

$git_obj->git_in_checkout_task(
    {
        pivot_bn     => "readme.md",
        repo         => "jquery-expander",
        user         => "kswedberg",
        base_dirname => "lib/js",
    }
);

# Broken due to the bug in this pull-request:
#    - https://github.com/setanta/ebookmaker/pull/7
#
# I switched to my fork for now.
#
# system('cd lib && git clone https://github.com/setanta/ebookmaker.git');
if (0)
{
    $git_obj->git_in_checkout_task(
        {
            pivot_bn     => "README.md",
            repo         => "ebookmaker",
            user         => "shlomif",
            base_dirname => "lib",
            branch       => "shlomif-conversion-to-floss",
        }
    );
}

$git_obj->git_in_checkout_task(
    {
        pivot_bn     => "hebrew-html-tutorial/hebrew-html-tutorial.xml.tt",
        repo         => "html-tutorial",
        user         => "shlomif",
        base_dirname => "lib/presentations/docbook",
    }
);

$git_obj->git_in_checkout_task(
    {
        pivot_bn     => "README.md",
        repo         => "c-begin",
        user         => "shlomif",
        base_dirname => "lib",
    }
);

foreach my $repo (
    (
        map { s#/[^/]*$##r }
        path("lib/Shlomif/Homepage/captioned-images.txt")->lines_raw(),
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
    {
        dest_var         => '$(PRE_DEST)',
        disable_docbook4 => 1,
        post_dest_var    => '$(POST_DEST)'
    }
)->generate;
Shlomif::Homepage::GenQuadPresMak->new->generate;

$git_obj->end;
