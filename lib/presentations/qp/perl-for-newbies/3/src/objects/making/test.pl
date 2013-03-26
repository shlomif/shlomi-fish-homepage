#!/usr/bin/perl

use strict;
use warnings;

use Foo;

my $foo = Foo->new("MyFoo", 500);

print $foo->{'name'}, "\n";

