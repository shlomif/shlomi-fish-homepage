#!/usr/bin/perl

use strict;
use warnings;

use Count;

my $bar = Count->new();

$bar->assign_name("Shlomi");
$bar->assign_name("Rindolf");
print $bar->get_name(), "\n";
$bar->assign_name("Choo");


