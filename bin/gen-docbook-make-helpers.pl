#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use Carp       ();
use List::Util qw/ uniq /;
use Path::Tiny qw/ path /;
use lib './lib';
use HTML::Latemp::DocBook::GenMake       ();
use Shlomif::Homepage::Git               ();
use Shlomif::Homepage::GenQuadPresMak    ();
use Shlomif::Homepage::GenFictionsMak    ();
use Shlomif::Homepage::GenScreenplaysMak ();

my $git_obj = Shlomif::Homepage::Git->new( { default_user => 'shlomif', } );

my $git_task = $git_obj->calc_git_task_cb();

$git_obj->git_in_checkout_task(
    {
        pivot_bn     => "README.md",
        repo         => "MathJax",
        user         => "mathjax",
        base_dirname => "lib/js",
        branch       => '3.2.2',
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
    uniq(
        (
            map { m#\A([^/]+)# ? ($1) : ( die "wrong captioned-image '$_'" ) }
                path("lib/Shlomif/Homepage/captioned-images.txt")->lines_raw(),
        ),
        'XML-Grammar-Vered',
        'how-to-share-code-online',
        'my-real-person-fan-fiction',
        'putting-cards-2019-2020',
        'shlomif-business-card',
        'shlomif-tech-diary',
        'validate-your-html',
        'why-openly-bipolar-people-should-not-be-medicated',
    )
    )
{
    $git_task->( 'lib/repos', ( ref($repo) eq '' ? $repo : @$repo ) );
}

my $gen_screenplays_ret = Shlomif::Homepage::GenScreenplaysMak->new->generate(
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
my %f;
foreach my $rec ( @{ $gen_screenplays_ret->{generate_file_list_promises} }, )
{
    my ( $var, $bnlist ) = @{ $rec->() };
    foreach my $bn (@$bnlist)
    {
        ++$f{$var}{$bn};
    }
}

path("lib/make/generated/shlomif-screenplays.mak")->append_utf8(
    (
        map {
            my $var = $_;
            my @bn  = sort keys %{ $f{$var} };
            @bn ? "$var := @bn\n" : ""
            }
            sort keys %f
    ),
    ( @{ $gen_screenplays_ret->{addprefixes} }, ),
);
