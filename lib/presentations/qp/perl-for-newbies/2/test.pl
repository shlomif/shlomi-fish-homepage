#!/usr/bin/perl

open I, "<./src/intro.html";
my $text = join("",<I>);
close(I);

$text =~ 
