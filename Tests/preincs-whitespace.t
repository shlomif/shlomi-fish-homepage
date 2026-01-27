#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use 5.014;

use Test::More tests => 1;

use Test::Differences (qw( eq_or_diff ));
use lib './lib';
use HTML::Latemp::Local::Paths ();

my $PRE_DEST = HTML::Latemp::Local::Paths->new->t2_pre_dest;

open my $LISTER, "-|", "git", "ls-files", "src";
my $bad_results = [];
while ( my $fn = <$LISTER> )
{
    chomp $fn;
    if ( my ($mfn) = ( $fn =~ m{\Asrc/(\S+\.x?html)\.tt2\z}ms ) )
    {
        my $destfn = "$PRE_DEST/$mfn";
        if ( not -f $destfn )
        {
            die "$destfn does not exist!";
        }
        open my $destfh, "<", $destfn;
        binmode $destfh;
        my $content = "";
        read $destfh, $content, 10;
        if ( $content !~ m#\A<\?xml#ms )
        {
            push @$bad_results,
                +{
                basefn            => $mfn,
                fn                => $fn,
                content           => $content,
                pre_incs_filename => $destfn,
                };
        }
        close($destfh);
    }
}

TODO:
{
    local $TODO = "there are still problem pages";

    # TEST
    eq_or_diff(
        [ map { $_->{fn} } @{$bad_results} ],
        [], "Leading whitespace in pre-incs",
    );
    my $LAST = $ENV{'L'};
    if ( $LAST =~ /\A[0-9]+\z/ms )
    {
        if ( @{$bad_results} )
        {
            system( "gvim", "-p",
                [ map { $_->{fn} } @{$bad_results}[ -$LAST .. -1 ] ],
            );
        }
    }
}
