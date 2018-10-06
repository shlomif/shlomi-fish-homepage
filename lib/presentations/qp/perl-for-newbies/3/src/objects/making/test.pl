#!/usr/bin/env perl

use strict;
use warnings;

use Foo;

my $foo = Foo->new("MyFoo", 500);

print $foo->{'name'}, "\n";
