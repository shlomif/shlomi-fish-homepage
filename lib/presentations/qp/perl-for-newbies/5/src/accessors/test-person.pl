#!/usr/bin/perl

use strict;
use warnings;

use Person;

my $shlomif =
    Person->new(
        {
            first_name => "Shlomi",
            last_name => "Fish",
            age => 32,
        }
    );

$shlomif->greet();
$shlomif->increment_age();

print "Happy Birhday, Shlomi, your age is now ", $shlomif->get_age(), ".\n";

my $newton =
    Person->new(
        {
            first_name => "Isaac",
            last_name => "Newton",
            age => 366,
        }
    );

$newton->greet();
print "Newton would have been ", $newton->get_age(),
    " years old today if he had been alive.\n"
    ;

