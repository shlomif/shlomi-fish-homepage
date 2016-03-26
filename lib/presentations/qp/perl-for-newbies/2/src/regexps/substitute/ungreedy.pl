use strict;
use warnings;

my $string = "<html>Hello</html>You</html>";

my $greedy = $string;
$greedy =~ s/<html>.*<\/html>/REPLACED/;

my $ungreedy = $string;
$ungreedy =~ s/<html>.*?<\/html>/REPLACED/;

print $string, "\n",
    $greedy, "\n",
    $ungreedy, "\n";

