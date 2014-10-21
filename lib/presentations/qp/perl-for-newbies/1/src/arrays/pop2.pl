
# This program prints the numbers from 10 down to 1.
@numbers = (1 .. 10);
while(scalar(@numbers) > 0)
{
    $i = pop(@numbers);
    print $i, "\n";
}
