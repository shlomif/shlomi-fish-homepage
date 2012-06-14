#!/usr/bin/perl

use strict;
use warnings;

use Test::Count::Filter;
use Getopt::Long;

my $filetype = "perl";
GetOptions('ft=s' => \$filetype);

my %params =
(
    'lisp' =>
    {
        assert_prefix_regex => qr{; TEST},
        plan_prefix_regex => qr{\(plan\s+},
    },
    'c' =>
    {
        assert_prefix_regex => qr{/[/\*]\s+TEST},
        plan_prefix_regex => qr{\s*plan_tests\s*\(\s*},
    },
);

my %aliases =
(
    'arc' => "lisp",
    'scheme' => "lisp",
    'cpp' => "c",
);

$filetype = exists($aliases{$filetype}) ? $aliases{$filetype} : $filetype;
my $ft_params = exists($params{$filetype}) ? $params{$filetype} : +{};

my $filter =
    Test::Count::Filter->new(
        {
            %{$ft_params},
        }
    );

$filter->process();
