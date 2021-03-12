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

my $git_task = $git_obj->calc_git_task_cb();

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

# Replaced with rebookmaker anyway due to a lack of an explicit (and FOSS)
# licence:
#
# https://pypi.org/project/rebookmaker/
#
# Previously broken due to the bug in this pull-request:
#    - https://github.com/setanta/ebookmaker/pull/7
#
# I switched to my fork before the "rebookmaker" rewrite.
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
        repo         => "Star-Wars-opening-crawl-from-1977-Remake",
        branch       => "queen-padme-intro--shlomif",
        user         => "shlomif",
        base_dirname => "lib/repos",
    }
);

$git_obj->git_in_checkout_task(
    {
        pivot_bn     => "README.pod",
        repo         => "shlomif-humour-fortunes-archives-assets",
        branch       => "master",
        user         => "shlomif",
        base_dirname => "lib/repos",
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
    [ 'Shlomi-Fish-Back-to-my-Homepage-Logo', 1 ],
    (
        map { s#/[^/]*$##r }
            path("lib/Shlomif/Homepage/captioned-images.txt")->lines_raw(),
        ),
    'captioned-images--repo',
    'how-to-share-code-online',
    'my-real-person-fan-fiction',
    'putting-cards-2019-2020',
    'shlomif-business-card',
    'shlomif-tech-diary',
    'validate-your-html',
    'why-openly-bipolar-people-should-not-be-medicated',
    'XML-Grammar-Vered',
    )
{
    $git_task->( 'lib/repos', ( ref($repo) eq '' ? $repo : @$repo ) );
}

my $gen_scr_ret = Shlomif::Homepage::GenScreenplaysMak->new->generate(
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

my $future = $git_obj->end();

# $future->await();
path("lib/make/docbook/sf-screenplays.mak")
    ->append_utf8( map { $_->() }
        ( @{ $gen_scr_ret->{generate_file_list_promises} } ) );
