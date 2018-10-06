#!/usr/bin/env perl

use strict;
use warnings;

my $s = do { local $/; <>; };

$s =~ s{\A.*<body>}{}ms;
$s =~ s{</body>.*}{}ms;
$s =~ s{<(/?)h(\d)}{"<".$1."h".($2+1)}ge;

print $s;
