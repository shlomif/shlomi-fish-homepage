#!/usr/bin/perl

use strict;
use warnings;

use Bar;

my $bar = Bar->new();

$bar->assign_name_ext("Shlomi");
$bar->assign_name_ext("Rindolf");
print $bar->get_name(), "\n";
$bar->assign_name_ext("Choo");

print $bar->get_num_times_assigned(), "\n";


