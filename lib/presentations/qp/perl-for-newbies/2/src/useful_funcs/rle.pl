use strict;
use warnings;

my $default_input_string = "2-5,3-9,1-2,8-1,4-7,5-9,20-3,16-9";

my $input_string = shift || $default_input_string;

# RLE stands for Run-Length Encoding
my @rle_components = split(/,/, $input_string);
my @expanded_sequence = (map
    {
        my ($what, $times) = split(/-/, $_);
        (($what) x $times);
    }
    @rle_components
    );

print join(",", @expanded_sequence), "\n";
