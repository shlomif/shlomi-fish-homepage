#!/usr/bin/perl

use strict;
use warnings;

use MyVar;

$MyVar::myvar = "Hello";

MyVar::print_myvar();

$MyVar::myvar = "World";

MyVar::print_myvar();

