#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 1;

use Test::Differences (qw( eq_or_diff ));

use File::Find::Object;

my $tree = File::Find::Object->new({}, '.');

my %results;
while (my $r = $tree->next_obj())
{
    if ($r->is_dir())
    {
        my $files = $tree->get_current_node_files_list();

        my %found;
        my %positives;
        foreach my $fn (@$files)
        {
            my $lc = lc$fn;
            if (++$found{$lc} > 1)
            {
                push @{$positives{$lc}}, $fn;
            }
        }

        if (%positives)
        {
            $results{$r->path()} = \%positives;
        }
    }
}

# TEST
eq_or_diff(
    (\%results),
    {},
    "No results were found."
);
