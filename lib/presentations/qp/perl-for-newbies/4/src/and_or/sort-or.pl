#!/usr/bin/perl

use strict;
use warnings;


my @array =
(
    { 'first' => "Amanda", 'last' => "Smith", },
    { 'first' => "Jane", 'last' => "Arden",},
    { 'first' => "Tony", 'last' => "Hoffer", },
    { 'first' => "Shlomi", 'last' => "Fish", },
    { 'first' => "Chip", 'last' => "Fish", },
    { 'first' => "John", 'last' => "Smith", },
    { 'first' => "Peter", 'last' => "Torry", },
    { 'first' => "Michael", 'last' => "Hoffer", },
    { 'first' => "Ben", 'last' => "Smith", },
);

my @sorted_array =
    (sort
        {
            ($a->{'last'} cmp $b->{'last'}) ||
            ($a->{'first'} cmp $b->{'first'})
        }
        @array
    );

foreach my $record (@sorted_array)
{
    print $record->{'last'} . ", " . $record->{'first'} . "\n";
}

