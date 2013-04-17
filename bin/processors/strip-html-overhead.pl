#!/usr/bin/perl

use strict;
use warnings;

use IO::All;

my $s = io("-")->slurp();

$s =~ s{\A.*<body>}{}ms;
$s =~ s{</body>.*}{}ms;
$s =~ s{<(/?)h(\d)}{"<".$1."h".($2+1)}ge;

print $s;
