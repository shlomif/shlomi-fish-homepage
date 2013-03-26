
# This program prints the numbers 1 to 10.
@numbers = (1 .. 10);
while(scalar(@numbers) > 0)
{
    $i = shift(@numbers);
    print $i, "\n";
}
