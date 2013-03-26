#!/usr/bin/perl -w -I/home/shlomi/apps/test/quadpres/share/quad-pres/perl5

use strict;
use Shlomif::Quad::Pres::CGI;

my $cgi = Shlomif::Quad::Pres::CGI->new();

$cgi->run();

