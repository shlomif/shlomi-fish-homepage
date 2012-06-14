#!/usr/bin/perl

open my $in, "<", "./src/intro.html";
my $text = join("",<$in>);
close(I);

$text =~
