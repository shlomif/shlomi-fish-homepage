
use strict;
use warnings;

my ($line, @parts);

my $user_name = shift;

open I, "<", "/etc/passwd";
while ($line = <I>)
{
    @parts = split(/:/, $line);
    if ($parts[0] eq $user_name)
    {
        print $user_name . "'s user ID is " . $parts[2] . "\n";
        exit(0);
    }    
}
close(I);

print $user_name . "'s user ID was not found!\n";
exit(-1);
