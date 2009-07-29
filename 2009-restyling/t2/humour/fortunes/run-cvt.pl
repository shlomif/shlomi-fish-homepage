#!/usr/bin/perl

use strict;
use warnings;

foreach my $id (qw(
    corollary-of-godwyn
    keeping-an-idea-to-yourself
    apple-a-day
    you-are-banished
    foreign-languages
    in-philosophy-as-in-soft-eng
    he-has-high-degree
girly-men
if-his-programming
hacker-sees-bug
tcl-is-lisp-on-drugs
linus-95-percent-of-programmers
cpp-is-complex
first-phrase
reinvent-the-wheel
not-familiar-with-better
good-student-vs-bad-student
real-programmers-dont-write
jewish-atheists
the-ex-member-about-rashness
second-best-solution
if-it-isnt-in-my-email
bad-thing-about-hardware
larry-wall-facts
ee-studies-in-technion
not-an-actor
trying-to-block-porn
Im-not-straight
almost-worthy
tower-of-babel-and-god-the-dwarf
we-dont-know-his-cellphone
engrew-sentence-1
what-do-you-mean
windows-minus-minus
use-qmail-instead-excerpt-1
rtfm-vs-jatfm
have-to-do-twain
    ))
{
    print "ID = $id\n";
    if (system("perl", "convert-aphorism.pl", $id))
    {
        die "$id failed";
    }
}
