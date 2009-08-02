#!/usr/bin/perl

use strict;
use warnings;

use Foo;

my $foo = Foo->new("MyFoo", 500);

print $foo->get_name(), "\n";

$foo->assign_name("Shlomi Fish");

print $foo->get_name(), "\n";

