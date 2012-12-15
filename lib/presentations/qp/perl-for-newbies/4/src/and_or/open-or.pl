#!/usr/bin/perl

use strict;
use warnings;

# Terminate if we cannot open a file.
open O, ">", "/hello.txt" or die "Cannot open file!";

print O "Hello World!\n";

close(O);

