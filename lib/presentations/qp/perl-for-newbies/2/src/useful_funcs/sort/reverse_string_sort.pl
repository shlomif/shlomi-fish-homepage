use strict;
use warnings;

my @input = (
    "Hello World!",
    "You is all I need.",
    "To be or not to be",
    "There's more than one way to do it.",
    "Absolutely Fabulous",
    "Ci vis pacem, para belum",
    "Give me liberty or give me death.",
    "Linux - Because software problems should not cost money",
);

# Do a case-insensitive sort
my @sorted = (sort { lc($b) cmp lc($a); } @input);

print join("\n", @sorted), "\n";
