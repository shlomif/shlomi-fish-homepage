#!/usr/bin/perl

use strict;
use warnings;

printf "<%10s>\n", "Hello";       # Prints <     Hello>
printf "<%-10s>\n", "Hello";      # Prints <Hello     >
printf "<%3.5s>\n", "Longstring"; # Prints <Longs>
printf "<%.2f>\n", 3.1415926535;  # Prints <3.14>
